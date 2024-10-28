table 17200 "Purchase Requests less 200"
{
    DataClassification = CustomerContent;
    Caption = 'Purchase Requests less 200', comment = 'ESP="Compra menor 200"';
    DrillDownPageId = "Purchase Request less 200 List";
    LookupPageId = "Purchase Request less 200 List";
    Permissions = tabledata "Purch. Inv. Header" = rmid, tabledata "G/L Entry" = rmid;

    fields
    {
        field(1; "No."; code[20])
        {
            Caption = 'Request No.', comment = 'ESP="Nº Solicitud"';
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
            InitValue = 'EUR';
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
        field(102; "G/L Entry"; Integer)
        {
            Caption = 'G/L Entry', comment = 'ESP="Mov. Contabilidad"';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Entry"."Entry No." where("Purch. Request less 200" = field("No.")));
            Editable = false;
        }
        field(107; "No. Series"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series', comment = 'ESP="Nos. serie"';
        }
        field(110; Type; Option)
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
            OptionMembers = " ","G/L Account","Fixed Asset",Item;
            OptionCaption = ' ,G/L Account,Fixed Asset,Item', comment = 'ESP=" ,Cuenta,Activo Fijo,Producto"';
        }
        field(120; "G/L Account No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.', comment = 'ESP="Nº"';
            TableRelation = IF (Type = const("G/L Account")) "G/L Account"
                    where(Blocked = const(false), "Account Type" = const(Posting), "Direct Posting" = const(true), "Income Stmt. Bal. Acc." = filter(<> ''))
            ELSE IF (Type = const("Fixed Asset")) "Fixed Asset"
            ELSE IF (Type = const(Item)) Item where("Purch. Request minor 200" = const(true));
        }
        field(130; "Global Dimension 3 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3), "Value Dimensión Padre" = field("Global Dimension 8 Code"), Blocked = const(false));
        }
        field(140; "Global Dimension 8 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8), Blocked = const(false));
        }
        field(150; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
        }
        field(50000; "Codigo Empleado"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Codigo Empleado', comment = 'ESP="Codigo Empleado"';
            TableRelation = Employee;
            ValidateTableRelation = true;
            Editable = false;

            trigger OnValidate()
            begin
                OnValidate_CodEmpleado();
            end;
        }
        field(50010; "Nombre Empleado"; text[100])
        {
            Caption = 'Nombre Empleado', comment = 'ESP="Nombre Empleado"';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Status)
        { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Vendor Name", Description, "G/L Account No.", Amount) { }
        fieldgroup(Brick; "No.", "Vendor Name", Description, "G/L Account No.", Amount) { }
    }

    var
        PurchasesSetup: Record "Purchases & Payables Setup";
        Vendor: Record Vendor;
        Item: Record Item;
        UserSetup: Record "User Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AutLoginMgt: Codeunit "AUT Login Mgt.";
        lblAction: Label '¿Desea %1 la solicitud %2?', comment = 'ESP="¿Desea %1 la solicitud %2?"';
        lblErrorBlocked: Label 'Vendor %1 is blocked %2.', comment = 'ESP="El provedoor %1 está bloqueado %2."';
        lblMaxAmount: Label 'The amount of the request %1 is greater than the maximum allowed %2.',
            comment = 'ESP="El importe de la solicitud %1 es mayor que el máximo permitido %2."';
        lblConfirm: Label '¿Do you wish to send the Approval of Purchase request %1 for an amount of %2?',
            comment = 'ESP="¿Desea enviar la Aprobación de la solicitud de compra %1 por un importe de %2?"';
        lblSubject: Label 'Solicitud de Compra menor de 200 € %1'
            , comment = 'ESP="Solicitud de Compra menor de 200 € %1"';
        lblTitle: Label '<p><strong>Solicitud de Compra menor de 200&euro;1</strong></p>'
            , comment = 'ESP="<p><strong>Solicitud de Compra menor de 200&euro;</strong></p>"';
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
            PurchasesSetup.GET;
            PurchasesSetup.TESTFIELD("Purchase Request Nos.");
            NoSeriesMgt.InitSeries(PurchasesSetup."Purchase Request Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        if "User Id" = '' then
            "User Id" := UserId;
        if Rec."Posting Date" = 0D then
            Rec."Posting Date" := WorkDate();
        if Rec."Codigo Empleado" = '' then
            Rec.validate("Codigo Empleado", AutLoginMgt.GetEmpleado());
    end;

    trigger OnModify()
    begin
        CheckIsAssigned;
        if Rec.Amount <> xRec.Amount then
            Rec.Status := Rec.Status::" ";
        if Rec."Codigo Empleado" = '' then
            Rec.validate("Codigo Empleado", AutLoginMgt.GetEmpleado());
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
            PurchasesSetup.GET;
            NoSeriesMgt.TestManual(PurchasesSetup."Purchase Request Nos.");
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
        PurchasesSetup.Get();
        if PurchasesSetup."Maximum amount Request" < Rec.Amount then
            Error(lblMaxAmount, Rec.Amount, PurchasesSetup."Maximum amount Request");
    end;

    procedure Approve()
    begin
        // control de si existe ya alguna linea indicada
        if not Confirm(lblAction, false, 'Aprobar', Rec."No.") then
            exit;
        CheckIsAssigned;
        Rec.Status := Rec.Status::Approved;
        Rec.Modify();
        SendEmailNotification();
    end;

    procedure Reject()
    begin
        if not Confirm(lblAction, false, 'Rechazar', Rec."No.") then
            exit;
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
        Rec.TestField(Type);
        Rec.TestField("G/L Account No.");
        Rec.TestField(Description);
        Rec.TestField(Amount);
        case Rec.Type of
            Rec.Type::"G/L Account":
                begin
                    Rec.TestField("Global Dimension 1 Code");
                    Rec.TestField("Global Dimension 3 Code");
                    Rec.TestField("Global Dimension 8 Code");
                end;
        end;
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
        DocAttachment.SetRange("No.", Rec."No.");
        if DocAttachment.FindFirst() then
            repeat
                FilePathName := FileManagement.ServerTempFileName(DocAttachment."File Extension");
                DocAttachment."Document Reference ID".ExportFile(FilePathName);
                cduSmtp.AddAttachment(FilePathName, StrSubstNo('%1.%2', DocAttachment."File Name", DocAttachment."File Extension"));
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
        textoHtml += StrSubstNo(lblUser, Rec."Nombre Empleado");
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
        lblError: Label 'No existen empleados configurados para aprobacion de Solicitudes de compra.\Hable con Administración del sistemaB',
            comment = 'ESP="No existen empleados configurados para aprobacion de Solicitudes de compra.\Hable con Administración del sistema"';
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
        DocAttachment.SetRange("No.", Rec."No.");
        if DocAttachment.FindFirst() then
            repeat
                FilePathName := FileManagement.ServerTempFileName(DocAttachment."File Extension");
                DocAttachment."Document Reference ID".ExportFile(FilePathName);
                cduSmtp.AddAttachment(FilePathName, DocAttachment."File Name");
            Until DocAttachment.next() = 0;

        cduSmtp.Send();
    end;

    procedure AssistEdit(OldPurchaseRequest: Record "Purchase Requests less 200"): Boolean
    var
        PurchaseRequest: Record "Purchase Requests less 200";
    begin
        PurchaseRequest := Rec;
        PurchasesSetup.GET;
        PurchasesSetup.TESTFIELD("Purchase Request Nos.");
        IF NoSeriesMgt.SelectSeries(PurchasesSetup."Purchase Request Nos.", OldPurchaseRequest."No. Series", "No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            Rec := PurchaseRequest;
            EXIT(TRUE);
        END;
    end;

    procedure Navigate_PostedPurchaseRequest()
    var
        PurchaseRequest: Record "Purchase Requests less 200";
        PurchaseRequests: page "Purchase Request less 200 List";
    begin
        // if not PurchaseRequest.IsUserApproval() then
        //     PurchaseRequest.SetRange("User Id", UserId);
        PurchaseRequest.SetRange(Status, PurchaseRequest.Status::Posted);
        PurchaseRequests.SetTableView(PurchaseRequest);
        PurchaseRequests.RunModal();
    end;

    procedure Navigate()
    var
        NavigateForm: page Navigate;
    begin
        NavigateForm.SetDoc(rec."Posting Date", "No.");
        NavigateForm.RUN;
    end;

    local procedure OnValidate_CodEmpleado()
    var
        Employee: Record Employee;
    begin
        "Nombre Empleado" := '';
        if Employee.Get(Rec."Codigo Empleado") then
            "Nombre Empleado" := copystr(Employee.FullName(), 1, MaxStrLen(Rec."Nombre Empleado"));
    end;

    procedure UpdateStatus()
    var
        GLEntry: Record "G/L Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if Rec.Status in [Rec.Status::Posted] then
            exit;
        // buscamos si existe movimiento de contabilidad relacionado
        GLEntry.Reset();
        GLEntry.SetRange("Purch. Request less 200", Rec."No.");
        if GLEntry.FindFirst() then begin
            Rec.Status := Rec.Status::Posted;
            Rec.Invoiced := true;
            Rec.Modify();
        end;
        // miramos el historico de facturas de compras
        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("Purch. Request less 200", Rec."No.");
        if PurchInvHeader.FindFirst() then begin
            Rec.Status := Rec.Status::Posted;
            Rec.Invoiced := true;
            Rec.Modify();
        end;
    end;

    procedure CheckDocumentNo(): code[20]
    var
        GLEntry: Record "G/L Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        // buscamos si existe movimiento de contabilidad relacionado
        GLEntry.Reset();
        GLEntry.SetRange("Purch. Request less 200", Rec."No.");
        if GLEntry.FindFirst() then
            exit(GLEntry."Document No.");
        // miramos el historico de facturas de compras
        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("Purch. Request less 200", Rec."No.");
        if PurchInvHeader.FindFirst() then
            exit(PurchInvHeader."No.");
        exit('');
    end;

    procedure UpdatePurchaseInvoice(PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchRequestsless200: record "Purchase Requests less 200";
        PurchRequestsless200s: page "Purchase Request less 200";
    begin
        PurchInvHeader.TestField("Purch. Request less 200", '');
        PurchRequestsless200.SetRange(Status, PurchRequestsless200.Status::Approved);
        PurchRequestsless200s.SetTableView(PurchRequestsless200);
        PurchRequestsless200s.LookupMode := true;
        if PurchRequestsless200s.RunModal() = Action::LookupOK then begin
            PurchRequestsless200s.GetRecord(PurchRequestsless200);
            PurchRequestsless200.TestField(Status, PurchRequestsless200.Status::Approved);
            PurchRequestsless200.AssingPurchInvoice(PurchInvHeader);
        end
    end;

    procedure AssingPurchInvoice(PurchInvHeader: Record "Purch. Inv. Header")
    var
        myInt: Integer;
    begin
        PurchInvHeader."Purch. Request less 200" := Rec."No.";
        PurchInvHeader.Modify();
        Rec.UpdateStatus();
    end;

    procedure UpdateGLEntry(GLEntry: Record "G/L Entry")
    var
        PurchRequestsless200: record "Purchase Requests less 200";
        PurchRequestsless200s: page "Purchase Request less 200";
    begin
        GLEntry.TestField("Purch. Request less 200", '');
        PurchRequestsless200.SetRange(Status, PurchRequestsless200.Status::Approved);
        PurchRequestsless200s.SetTableView(PurchRequestsless200);
        PurchRequestsless200s.LookupMode := true;
        if PurchRequestsless200s.RunModal() = Action::LookupOK then begin
            PurchRequestsless200s.GetRecord(PurchRequestsless200);
            PurchRequestsless200.TestField(Status, PurchRequestsless200.Status::Approved);
            PurchRequestsless200.AssingGLEntry(GLEntry);
        end
    end;

    procedure AssingGLEntry(GLEntry: Record "G/L Entry")
    var
        myInt: Integer;
    begin
        GLEntry."Purch. Request less 200" := Rec."No.";
        GLEntry.Modify();
        Rec.UpdateStatus();
    end;

}