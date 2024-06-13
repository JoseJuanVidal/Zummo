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
                end;
            'PATCH':
                begin
                    if vendorBankAccount.Get(Rec."Vendor No.", Rec.Code) then begin
                        vendorBankAccount.TransferFields(Rec);
                        vendorBankAccount."CCC No." := copystr(txtCCCNo, 1, MaxStrLen(vendorBankAccount."CCC No."));
                        vendorBankAccount.Validate(IBAN, copystr(txtIBAN, 1, MaxStrLen(vendorBankAccount.IBAN)));
                        vendorBankAccount.Modify();
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
}