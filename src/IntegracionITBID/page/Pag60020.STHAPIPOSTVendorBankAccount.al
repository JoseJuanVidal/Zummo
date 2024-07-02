page 60020 "STH API POST VendorBankAccount"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Vendor Bank Account';
    // EntityCaption = 'STH API Vendor Bank Account';
    // EntitySetCaption = 'STH API Vendor Bank Account';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostVendorBankAccount';
    EntitySetName = 'sthPostVendorBankAccount';
    ODataKeyFields = "Vendor No.", Code;
    PageType = API;
    SourceTable = "Vendor Bank Account";
    // Extensible = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(id; Rec.Id)
                // {
                //     Caption = 'Id';
                // }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field("code"; CodeAux)
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(iban; txtIBAN)
                {
                    Caption = 'IBAN';
                }
                field(swiftCode; Rec."SWIFT Code")
                {
                    Caption = 'SWIFT Code';
                }
                field(CCCBankNo; txtCCCNO)
                {
                    Caption = 'CCC Bank No.';
                }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }
    var
        vendorBankAccount: Record "Vendor Bank Account";
        actionHTTP: Text;
        result: Text;
        CodeAux: Code[20];
        txtIBAN: text;
        txtCCCNO: text;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        HttpAction();
        exit(false);
    end;

    local procedure HttpAction()
    var
        myInt: Integer;
    begin
        txtCCCNo := LimpiarCaracteres(txtCCCNo);
        txtIBAN := LimpiarCaracteres(txtIBAN);
        result := 'Failed';
        case actionHTTP of
            'DELETE':

                if vendorBankAccount.Get(Rec."Vendor No.", CodeAux) then begin
                    vendorBankAccount.Delete;
                    result := 'Success';
                end;
            'POST':
                begin
                    if vendorBankAccount.Get(Rec."Vendor No.", CodeAux) then
                        Error('El registro ya existe %1 %2', Rec."Vendor No.", CodeAux);

                    vendorBankAccount.Init();
                    vendorBankAccount."Vendor No." := Rec."Vendor No.";
                    createNoVendorBankAccount();
                    UpdateVendorBank();
                    vendorBankAccount.Insert();
                    Commit();
                    SendEmailChangesVendor(false);
                end;
            'PATCH':
                begin
                    if vendorBankAccount.Get(Rec."Vendor No.", CodeAux) then begin
                        UpdateVendorBank();
                        vendorBankAccount.Modify();
                        Commit();
                        SendEmailChangesVendor(true);
                    end else
                        Error('El registro no existe %1 %2', Rec."Vendor No.", CodeAux);
                end;
        end;
        result := 'Success';
    end;

    local procedure UpdateVendorBank()
    begin
        if Rec.Name <> '' then
            vendorBankAccount.Name := copystr(Rec.Name, 1, MaxStrLen(vendorBankAccount.Name));
        if Rec."SWIFT Code" <> '' then
            vendorBankAccount."SWIFT Code" := copystr(Rec."SWIFT Code", 1, MaxStrLen(vendorBankAccount."SWIFT Code"));
        if txtCCCNo <> '' then
            vendorBankAccount."CCC No." := copystr(txtCCCNo, 1, MaxStrLen(vendorBankAccount."CCC No."));
        if txtIBAN <> '' then
            vendorBankAccount.Validate(IBAN, copystr(txtIBAN, 1, MaxStrLen(vendorBankAccount.IBAN)));

    end;

    local procedure createNoVendorBankAccount()
    var
        vendorBankACC: Record "Vendor Bank Account";
    begin
        if Rec."Code" = '' then begin
            vendorBankACC.Reset();
            vendorBankACC.SetRange("Vendor No.", Rec."Vendor No.");
            if vendorBankACC.FindLast() then begin
                //Incrementar el código
                vendorBankAccount.Code := IncStr(vendorBankACC.Code);
            end else begin
                //Inicializar Code
                vendorBankAccount.Code := '1';
            end;
            Rec.Code := vendorBankAccount.Code;
            CodeAux := Rec.Code;
        end;
    end;

    local procedure LimpiarCaracteres(Valor: text) TrimString: text
    var
        I: Integer;
    begin
        for I := 1 to StrLen(Valor) do begin
            CASE UpperCase(CopyStr(Valor, i, 1)) OF
                'A' .. 'Z', 'a' .. 'z', '0' .. '9':
                    TrimString += UpperCase(copystr(Valor, I, 1));
            end;
        end;
    end;

    local procedure SendEmailChangesVendor(Changes: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Subject: text;
        Body: text;
        SubjectLbl: Label 'Alta Banco proveedor - %1 (%2)';
        SubjectChangesLbl: Label 'Cambio Banco proveedor - %1 (%2)';
    begin
        SalesSetup.Get();
        SMTPMailSetup.Get();
        SMTPMailSetup.TestField("User ID");
        if Changes then
            Subject := StrSubstNo(SubjectChangesLbl, vendorBankAccount."Vendor No.", vendorBankAccount.Code)
        else
            Subject := StrSubstNo(SubjectLbl, vendorBankAccount."Vendor No.", vendorBankAccount.Code);
        Body := EnvioEmailBody(Subject);
        // enviamos el email 
        if SalesSetup.emailVendorBank = '' then
            exit;
        SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", SalesSetup.emailVendorBank, Subject, Body, true);
        SMTPMail.Send();
    end;

    local procedure EnvioEmailBody(Subject: Text) Body: Text
    var
        Companyinfo: Record "Company Information";
        Vendor: Record Vendor;
    begin
        Companyinfo.Get();
        Body := '<p>&nbsp;</p>';
        Body += '<h1 style="color: #5e9ca0;">' + Companyinfo.Name + '</h1>';
        Body += '<h2 style="color: #2e6c80;">' + Subject + '</h2>';
        if Vendor.Get(vendorBankAccount."Vendor No.") then;
        Body += '<p><strong>' + Rec.FieldCaption("Vendor No.") + '</strong>: ' + StrSubstNo('%1 %2', Vendor."No.", Vendor.Name) + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(Name) + '</strong>: ' + vendorBankAccount.Name + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Bank Account No.") + '</strong>: ' + vendorBankAccount."Bank Account No." + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(IBAN) + '</strong>: ' + vendorBankAccount.IBAN + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("SWIFT Code") + '</strong>: ' + vendorBankAccount."SWIFT Code" + '</p>';
    end;
}