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
        txtCCCNo := LimpiarCaracteres(txtCCCNo);
        txtIBAN := LimpiarCaracteres(txtIBAN);
        result := 'Failed';
        case actionHTTP of
            'DELETE':

                if vendorBankAccount.Get(Rec."Vendor No.", Rec.Code) then begin
                    vendorBankAccount.Delete;
                    result := 'Success';
                end;
            'POST':
                begin
                    if vendorBankAccount.Get(Rec."Vendor No.", Rec.Code) then
                        Error('El registro ya existe %º', Rec.Code);

                    vendorBankAccount.Init();
                    vendorBankAccount.TransferFields(Rec);
                    vendorBankAccount."CCC No." := copystr(txtCCCNo, 1, MaxStrLen(vendorBankAccount."CCC No."));
                    vendorBankAccount.Validate(IBAN, copystr(txtIBAN, 1, MaxStrLen(vendorBankAccount.IBAN)));
                    createNoVendorBankAccount();
                    vendorBankAccount.Insert();
                    Commit();
                    SendEmailChangesVendor(false);
                end;
            'PATCH':
                begin
                    if vendorBankAccount.Get(Rec."Vendor No.", Rec.Code) then begin
                        vendorBankAccount.TransferFields(Rec);
                        vendorBankAccount."CCC No." := copystr(txtCCCNo, 1, MaxStrLen(vendorBankAccount."CCC No."));
                        vendorBankAccount.Validate(IBAN, copystr(txtIBAN, 1, MaxStrLen(vendorBankAccount.IBAN)));
                        vendorBankAccount.Modify();
                        Commit();
                        SendEmailChangesVendor(true);
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;

    local procedure createNoVendorBankAccount()
    var
        vendorBankACC: Record "Vendor Bank Account";
    begin
        if "Code" = '' then begin
            vendorBankACC.Reset();
            vendorBankACC.SetRange("Vendor No.", Rec."Vendor No.");
            if vendorBankACC.FindLast() then begin
                //Incrementar el código
                vendorBankAccount.Code := IncStr(vendorBankACC.Code);
            end else begin
                //Inicializar Code
                vendorBankAccount.Code := '1';
            end;
            CodeAux := vendorBankAccount.Code;
        end;
    end;

    local procedure LimpiarCaracteres(Valor: text) TrimString: text
    var
        I: Integer;
    begin
        for I := 1 to StrLen(Valor) do begin
            if copystr(Valor, I, 1) in [' ', '!', '"', '·', '$', '%', '&', '/', '-', '+', '*', '¿', '?', '=', ')', '()'] then
                TrimString += copystr(Valor, I, 1);
        end;
    end;

    local procedure SendEmailChangesVendor(Changes: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Subject: text;
        Body: text;
        SubjectLbl: Label 'Alta/Cambio Banco proveedor - %1 (%2)';
    begin
        SalesSetup.Get();
        SMTPMailSetup.Get();
        SMTPMailSetup.TestField("User ID");
        Subject := StrSubstNo(SubjectLbl, vendorBankAccount."Vendor No.", vendorBankAccount.Code);
        Body := EnvioEmailBody;
        // enviamos el email 
        if SalesSetup.emailVendorBank = '' then
            exit;
        SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", SalesSetup.emailVendorBank, Subject, Body, true);
        SMTPMail.Send();
    end;

    local procedure EnvioEmailBody() Body: Text
    var
        Companyinfo: Record "Company Information";
        Vendor: Record Vendor;
    begin
        Companyinfo.Get();
        Body := '<p>&nbsp;</p>';
        Body += '<h1 style="color: #5e9ca0;">' + Companyinfo.Name + '</h1>';
        Body += '<h2 style="color: #2e6c80;">Alta/Cambio Banco proveedor: ' + strsubstno('%1 %2', vendorBankAccount."Vendor No.", vendorBankAccount.Code) + '</h2>';
        if Vendor.Get(vendorBankAccount."Vendor No.") then;
        Body += '<p><strong>' + Rec.FieldCaption("Vendor No.") + '</strong>: ' + StrSubstNo('%1 %2', Vendor."No.", Vendor.Name) + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(Name) + '</strong>: ' + vendorBankAccount.Name + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Bank Account No.") + '</strong>: ' + vendorBankAccount."Bank Account No." + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(IBAN) + '</strong>: ' + vendorBankAccount.IBAN + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("SWIFT Code") + '</strong>: ' + vendorBankAccount."SWIFT Code" + '</p>';
    end;
}