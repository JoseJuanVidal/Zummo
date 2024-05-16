table 17200 "Purchase Requests less 200"
{
    DataClassification = CustomerContent;
    Caption = 'Purchase Requests less 200', comment = 'ESP="Compra menor 200"';
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
            Caption = 'Amount Excluding VAT', comment = 'ESP="Importe SIN IVA"';

            trigger OnValidate()
            begin
                OnValidate_Amount();
            end;
        }
        field(55; "Currency Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Code', comment = 'ESP="Cód. Divisa"';
            TableRelation = Currency;
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
        field(81; "Invoiced"; Boolean)
        {
            Caption = 'Invoice No.', comment = 'ESP="Nº Factura"';
            FieldClass = FlowField;
            CalcFormula = exist("Purch. Inv. Header" where("Purch. Request less 200" = field("No.")));
            Editable = false;
        }
        field(90; Comment; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Comment', comment = 'ESP="Comentarios"';
        }
        field(100; "Purchase Invoice"; code[20])
        {
            Caption = 'Purchase Invoice Related', comment = 'ESP="Factura Compra relacionada"';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."No." where("Purch. Request less 200" = field("No.")));
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
        fieldgroup(DropDown; "No.", "Vendor Name", Description, Amount) { }
        fieldgroup(Brick; "No.", "Vendor Name", Description, Amount) { }
    }

    var
        PurchSetup: Record "Purchases & Payables Setup";
        Vendor: Record Vendor;
        Item: Record Item;
        UserSetup: Record "User Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        lblErrorBlocked: Label 'Vendor %1 is blocked %2.', comment = 'ESP="El provedoor %1 está bloqueado %2."';
        lblMaxAmount: Label 'The amount of the request %1 is greater than the maximum allowed %2.',
            comment = 'ESP="El importe de la solicitud %1 es mayor que el máximo permitido %2."';
        lblConfirm: Label '¿Do you wish to send the Approval of Purchase request %1 for an amount of %2?',
            comment = 'ESP="¿Desea enviar la Aprobación de la solicitud de compra %1 por un importe de %2?"';
        lblSubject: Label 'Solicitud de Compra menor de 200 € %1'
            , comment = 'ESP="Solicitud de Compra menor de 200 € %1"';
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
        lblStatus: Label '<p><strong>Estados:</strong> %1</p>'
            , Comment = 'ESP="<p><strong>Estado:</strong> %1;</p>"';
        lblComments: Label '<p><strong>Commentarios:</strong></p>'
            , Comment = 'ESP="<p><strong>Comentario:</strong></p>"';

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
        CheckIsAssigned;
        if Rec.Amount <> xRec.Amount then
            Rec.Status := Rec.Status::" ";
    end;

    trigger OnDelete()
    begin
        // controlamos que no este invoiced
        Rec.CalcFields(Invoiced);
        Rec.TestField(Invoiced, false);
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
        CheckIsAssigned;
        Rec.Status := Rec.Status::Approved;
        Rec.Modify();
        SendEmailNotification();
    end;

    procedure Reject()
    begin
        CheckIsAssigned;
        Rec.Status := Rec.Status::Reject;
        Rec.Modify();
        SendEmailNotification();
    end;

    procedure TestApproved()
    var
        myInt: Integer;
    begin
        Rec.TestField(Status, Rec.Status::Approved);
    end;

    local procedure CheckIsAssigned()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        lblError: Label 'la factura %1 tiene la solicituda asignada', comment = 'ESP="la factura %1 tiene la solicituda asignada"';
    begin
        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("Purch. Request less 200", Rec."No.");
        if PurchInvHeader.FindFirst() then
            Error(lblError, PurchInvHeader."No.");
    end;

    procedure SendApproval()
    var
        myInt: Integer;
    begin
        // comprobamos si ya se ha enviado, o se vuelve a enviar
        // Rec.TestField("Vendor No.");
        Rec.TestField(Description);
        Rec.TestField(Amount);
        if not Confirm(lblConfirm, false, Rec."No.", Rec.Amount) then
            exit;
        SendEmailApproval;

        Message('Enviado');
    end;

    procedure SendEmailApproval()
    var
        DocAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
        SMTPSetup: Record "SMTP Mail Setup";
        cduSmtp: Codeunit "SMTP Mail";
        txtAsunto: Text;
        Recipients: text;
        textoHtml: Text;
        FilePathName: text;
    begin
        textoHtml := GetHTLMResumen();
        Recipients := GetRecipientsEmailRequest();
        txtAsunto := StrSubstNo(lblSubject, Rec."No.");
        SMTPSetup.Get();
        Clear(cduSmtp);
        cduSmtp.CreateMessage(CompanyName, SMTPSetup."User ID", Recipients, txtAsunto, textoHtml, TRUE);
        DocAttachment.Reset();
        DocAttachment.SetRange("Table ID", 17200);
        if DocAttachment.FindFirst() then
            repeat
                FilePathName := FileManagement.ServerTempFileName(DocAttachment."File Extension");
                DocAttachment."Document Reference ID".ExportFile(FilePathName);
                cduSmtp.AddAttachment(FilePathName, DocAttachment."File Name");
            Until DocAttachment.next() = 0;

        cduSmtp.Send();

        //cambiamos el estado pendiente, para saber que se ha enviado la aprobacion
        Rec.Status := Rec.Status::Pending;
        Rec.Modify();
    end;

    local procedure GetHTLMResumen() textoHtml: Text;
    var
        ListText: list of [text];
        i: Integer;
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
        textoHtml += StrSubstNo(lblStatus, Rec.Status);
        textoHtml += lblComments;
        Rec.GetListComment(ListText);
        for i := 1 to ListText.Count do
            textoHtml += '<p>        ' + ListText.Get(i) + '</p>';
        textoHtml += '<p>&nbsp;</p>';
    end;

    local procedure GetRecipientsEmailRequest() Recipients: text;
    var
        Employee: Record Employee;
        lblError: Label 'No existen emplados configurados para aprobacion de Solicitudes de compra.\Hable con Administración del sistemaB',
            comment = 'ESP="No existen emplados configurados para aprobacion de Solicitudes de compra.\Hable con Administración del sistema"';
    begin
        UserSetup.Reset();
        UserSetup.SetRange("Approvals Purch. Request", true);
        if UserSetup.FindFirst() then
            repeat
                Employee.SetRange("Approval User Id", UserSetup."User ID");
                if Employee.FindFirst() then
                    repeat
                        if Employee."Company E-Mail" <> '' then begin
                            if Recipients <> '' then
                                Recipients += ';';
                            Recipients += Employee."Company E-Mail";
                        end;
                    Until Employee.next() = 0;
            Until UserSetup.next() = 0;

        if Recipients = '' then
            Error(lblError);
    end;

    procedure IsUserApproval(): Boolean
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Approvals Purch. Request" then
                exit(True);
        end;
    end;

    procedure GetComment() Coments: TextBuilder
    var
        StreamIn: InStream;
        TextLine: text;
    begin
        rec.CalcFields(Comment);
        Rec.Comment.CreateInStream(StreamIn);
        while not (StreamIn.EOS) do begin
            StreamIn.ReadText(TextLine);
            Coments.AppendLine(TextLine);
        end;
    end;

    procedure GetListComment(var Coments: List of [text])
    var
        StreamIn: InStream;
        TextLine: text;
    begin
        rec.CalcFields(Comment);
        Rec.Comment.CreateInStream(StreamIn);
        while not (StreamIn.EOS) do begin
            StreamIn.ReadText(TextLine);
            Coments.add(TextLine);
        end;
    end;

    procedure SetComment(Comments: Text)
    var
        OutS: OutStream;
    begin
        Clear(Rec.Comment);
        Rec.Comment.CreateOutStream(OutS);
        OutS.WriteText(Comments);

        if not Rec.Insert() then
            Rec.Modify();
    end;

    local procedure SendEmailNotification()
    var
        PurchasesSetup: Record "Purchases & Payables Setup";
        DocAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
        SMTPSetup: Record "SMTP Mail Setup";
        cduSmtp: Codeunit "SMTP Mail";
        txtAsunto: Text;
        Recipients: text;
        textoHtml: Text;
        FilePathName: text;
    begin
        textoHtml := GetHTLMResumen();
        PurchasesSetup.Get();
        PurchasesSetup.TestField("Email reply lower 200");
        Recipients := PurchasesSetup."Email reply lower 200";
        txtAsunto := StrSubstNo(lblSubject, Rec."No.");
        SMTPSetup.Get();
        Clear(cduSmtp);
        cduSmtp.CreateMessage(CompanyName, SMTPSetup."User ID", Recipients, txtAsunto, textoHtml, TRUE);
        DocAttachment.Reset();
        DocAttachment.SetRange("Table ID", 17200);
        if DocAttachment.FindFirst() then
            repeat
                FilePathName := FileManagement.ServerTempFileName(DocAttachment."File Extension");
                DocAttachment."Document Reference ID".ExportFile(FilePathName);
                cduSmtp.AddAttachment(FilePathName, DocAttachment."File Name");
            Until DocAttachment.next() = 0;

        cduSmtp.Send();

        //cambiamos el estado pendiente, para saber que se ha enviado la aprobacion
        Rec.Status := Rec.Status::Pending;
        Rec.Modify();
    end;
}