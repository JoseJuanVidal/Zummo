table 17200 "Purchase Requests less 200"
{
    DataClassification = CustomerContent;
    Caption = 'Purchase Requests less 200', comment = 'ESP="Solicitudes de Compra menos 200"';
    DrillDownPageId = "Purchase Request less 200";
    LookupPageId = "Purchase Request less 200";

    fields
    {
        field(1; "No."; code[20])
        {
            Caption = 'No.', comment = 'ESP="Nº"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnValidate_No();
            end;
        }
        field(10; "Vendor No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.', comment = 'ESP="Nº proveedor"';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                OnValidate_VendorNo();
            end;
        }
        field(11; "Vendor Name"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name', comment = 'ESP="Nombre"';
        }
        field(12; "Vendor Name 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name 2', comment = 'ESP="Nombre 2"';
        }
        field(20; "Description"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(30; Quantity; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quanity', comment = 'ESP="Cantidad"';
            DecimalPlaces = 2 : 5;

            trigger OnValidate()
            begin
                OnValidate_CalculateAmount();
            end;
        }
        field(40; "Unit Price"; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price', comment = 'ESP="Precio Unitario"';
            DecimalPlaces = 2 : 5;

            trigger OnValidate()
            begin
                OnValidate_CalculateAmount();
            end;
        }
        field(50; Amount; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount', comment = 'ESP="Importe"';

            trigger OnValidate()
            begin
                OnValidate_Amount();
            end;
        }
        field(60; "Posting Date"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha Registro"';
        }
        field(70; "User Id"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User Id', comment = 'ESP="Usuario"';
            Editable = false;
        }
        field(80; Status; Enum "Status Approval")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', comment = 'ESP="Estado"';
            Editable = false;
        }
        field(107; "No. Series"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series', comment = 'ESP="Nos. serie"';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        PurchSetup: Record "Purchases & Payables Setup";
        Vendor: Record Vendor;
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        lblErrorBlocked: Label 'Vendor %1 is blocked %2.', comment = 'ESP="El provedoor %1 está bloqueado %2."';
        lblMaxAmount: Label 'The amount of the request %1 is greater than the maximum allowed %2.',
            comment = 'ESP="El importe de la solicitud %1 es mayor que el máximo permitido %2."';
        lblConfirm: Label '¿Do you wish to send the Approval of Purchase request %1 for an amount of %2?',
            comment = 'ESP="¿Desea enviar la Aprobación de la solicitud de compra %1 por un importe de %2?"';
        lblSubject: Label 'Solicitud de Compra mas de 200 € %1'
            , comment = 'ESP="Solicitud de Compra mas de 200 € %1"';
        lblTitle: Label '<p><strong>Solicitud de Compra mas de 200&euro; %1</strong></p>'
            , comment = 'ESP="<p><strong>Solicitud de Compra mas de 200&euro; %1</strong></p>"';
        lblUser: Label '<p><strong>Usuario:</strong> %1</p>'
            , comment = 'ESP="<p><strong>Usuario:</strong> %1</p>"';
        lblDate: Label '<p><strong>Fecha:</strong> %1</p>'
            , comment = 'ESP="<p"><strong>Fecha:</strong> %1</p>"';
        lblRequest: Label '<p><strong>N&ordm; Solicitud:</strong> %1</p>'
            , comment = 'ESP="<p><strong>N&ordm; Solicitud:</strong> %1</p>"';
        lblVendorNo: Label '<p><strong>C&oacute;d. Proveedor:</strong> %1</p>'
            , comment = 'ESP="<p><strong>C&oacute;d. Proveedor:</strong> %1</p>"';
        lblVendorName: Label '<p><strong>Nombre:</strong> %1</p>'
            , comment = 'ESP="<p><strong>Nombre:</strong> %1</p>"';
        lblVendorName2: Label '<p>        %1</p>'
            , comment = 'ESP="<p>        %1</p>"';
        lblDescription: Label '<p><strong>Descripci&oacute;n:</strong> %1</p>'
            , comment = 'ESP="<p><strong>Descripci&oacute;n:</strong> %1</p>"';
        lblAmount: Label '<p><strong>Importe:</strong> %1 &euro;</p>'
            , Comment = 'ESP="<p><strong>Importe:</strong> %1 &euro;</p>"';

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            PurchSetup.GET;
            PurchSetup.TESTFIELD("Purchase Request Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."Purchase Request Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        if "User Id" = '' then
            "User Id" := UserId;
        if Rec."Posting Date" = 0D then
            Rec."Posting Date" := WorkDate();
    end;

    trigger OnModify()
    begin
        if Rec.Amount <> xRec.Amount then
            Rec.Status := Rec.Status::" ";
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    local procedure OnValidate_No()
    begin
        IF "No." <> xRec."No." THEN BEGIN
            PurchSetup.GET;
            NoSeriesMgt.TestManual(PurchSetup."Vendor Nos.");
            "No. Series" := '';
        END;
    end;

    local procedure OnValidate_VendorNo()
    begin
        TestApproved();
        Vendor.Reset();
        Vendor.Get(Rec."Vendor No.");
        if Vendor.Blocked in [Vendor.Blocked::All] then
            Error(lblErrorBlocked, Rec."Vendor No.", Vendor.Blocked);
        // actualizamos datos
        Rec."Vendor Name" := Vendor.Name;
        Rec."Vendor Name 2" := Vendor."Name 2";
    end;

    local procedure OnValidate_CalculateAmount()
    begin
        Rec.Amount := Rec.Quantity * Rec."Unit Price";
        TestMaximumAmount();
    end;

    local procedure OnValidate_Amount()
    begin
        if Rec.Quantity = 0 then
            Rec."Unit Price" := 0
        else
            Rec."Unit Price" := Rec.Amount / Rec.Quantity;
        TestMaximumAmount();
    end;

    local procedure TestMaximumAmount()
    begin
        PurchSetup.Get();
        if PurchSetup."Maximum amount Request" < Rec.Amount then
            Error(lblMaxAmount, Rec.Amount, PurchSetup."Maximum amount Request");
    end;

    procedure Approve()
    begin
        // control de si existe ya alguna linea indicada

        Rec.Status := Rec.Status::Approved;
    end;

    procedure Reject()
    begin
        Rec.Status := Rec.Status::Reject;
    end;

    procedure TestApproved()
    var
        myInt: Integer;
    begin
        Rec.TestField(Status, Rec.Status::Approved);
    end;

    procedure SendApproval()
    var
        myInt: Integer;
    begin
        // comprobamos si ya se ha enviado, o se vuelve a enviar
        Rec.TestField("Vendor No.");
        Rec.TestField(Description);
        Rec.TestField(Amount);
        if not Confirm(lblConfirm, false, Rec."No.", Rec.Amount) then
            exit;
        SendEnvioEmailApproval;

        Message('Enviado');
    end;

    local procedure SendEnvioEmailApproval()
    var
        SMTPSetup: Record "SMTP Mail Setup";
        cduSmtp: Codeunit "SMTP Mail";
        txtAsunto: Text;
        textoHtml: Text;
    begin
        textoHtml := GetHTLMResumen();
        txtAsunto := StrSubstNo(lblSubject, Rec."No.");
        SMTPSetup.Get();
        Clear(cduSmtp);
        cduSmtp.CreateMessage(CompanyName, SMTPSetup."User ID", 'jvidal@zummo.es', txtAsunto, textoHtml, TRUE);
        cduSmtp.Send();

        //cambiamos el estado pendiente, para saber que se ha enviado la aprobacion
        Rec.Status := Rec.Status::Pending;
        Rec.Modify();
    end;

    local procedure GetHTLMResumen() textoHtml: Text;
    begin
        textoHtml := lblTitle;
        textoHtml += StrSubstNo(lblUser, UserId);
        textoHtml += StrSubstNo(lblDate, WorkDate());
        textoHtml += StrSubstNo(lblRequest, Rec."No.");
        textoHtml += StrSubstNo(lblVendorNo, Rec."Vendor No.");
        textoHtml += StrSubstNo(lblVendorName, Rec."Vendor Name");
        textoHtml += StrSubstNo(lblVendorName2, Rec."Vendor Name 2");
        textoHtml += StrSubstNo(lblDescription, Rec.Description);
        textoHtml += StrSubstNo(lblAmount, Rec.Amount);
        textoHtml += '<p>&nbsp;</p>';
    end;

    local procedure GetRecipientsEmailRequest()
    var
        Employee: Record Employee;
    begin
        // Employee."Approval User Id"
    end;
}