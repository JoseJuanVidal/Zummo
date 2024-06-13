page 60018 "STH API POST Vendor"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Vendor';
    // EntityCaption = 'STH API Vendor';
    // EntitySetCaption = 'STH API Vendor';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostVendor';
    EntitySetName = 'sthPostVendor';
    ODataKeyFields = "No.";
    PageType = API;
    SourceTable = Vendor;
    // Extensible = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(Name2; Rec."Name 2")
                {
                    Caption = 'Name';
                }
                field(SearchName; "Search Name") { }
                field(VATRegistrationNo; "VAT Registration No.") { }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(Address2; "Address 2")
                { }
                field(PostCode; "Post Code") { }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(County; County) { }
                field(CountryRegionCode; "Country/Region Code") { }
                field(contactNo; contactNo) { }
                // field(contactNo; Rec."Primary Contact No.") { }
                // field(contact; contactNew)
                // {
                //     Caption = 'Contact';
                // }
                field(EMail; "E-Mail") { }
                field(HomePage; "Home Page") { }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(faxNo; Rec."Fax No.")
                {
                    Caption = 'Fax No.';
                }
                field(ClasProveedor; ClasProveedor_btc)
                {
                    Caption = 'Clasificación proveedor';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(languageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
                }
                field(VendorPostingGroup; "Vendor Posting Group")
                {
                    Caption = 'Vendor Posting Group';
                }
                field(paymentMethodCode; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                }
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code';
                }
                field(preferredBankAccountCode; preferredBankAccountCode) { }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }

    var
        vendor: Record "Vendor";
        actionHTTP: Text;
        result: Text;
        // contactNew: Text;
        contactNo: Code[20];
        // ContBusRel: Record "Contact Business Relation";
        preferredBankAccountCode: Code[20];


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if vendor.Get(Rec."No.") then begin
                        vendor.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    if vendor.Get(Rec."No.") then
                        Error('El registro ya existe %1', Rec."No.");

                    vendor.Init();
                    createNoVendor();
                    vendor.TransferFields(Rec);
                    createNoVendor();
                    AddVendorPostingGroup();
                    addContact();
                    addPreferredBankAccount();
                    vendor.Insert();
                end;
            'PATCH':
                begin
                    if vendor.Get(Rec."No.") then begin
                        vendor.TransferFields(Rec);
                        AddVendorPostingGroup();
                        addContact();
                        addPreferredBankAccount();
                        vendor.Modify();
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;

    local procedure AddVendorPostingGroup()
    var
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        if VendorPostingGroup.get(vendor."Vendor Posting Group") then begin
            if VendorPostingGroup."Gen. Business Posting Group" <> '' then
                vendor.Validate("Gen. Bus. Posting Group", VendorPostingGroup."Gen. Business Posting Group");
        end
    end;

    local procedure addContact()
    var
        contacto: Record Contact;
    begin
        if contacto.Get(contactNo) then begin
            Vendor.Validate("Primary Contact No.", contactNo);
        end else
            Vendor."Primary Contact No." := contactNo;
    end;

    local procedure addPreferredBankAccount()
    begin
        Vendor."Preferred Bank Account Code" := preferredBankAccountCode;
    end;

    local procedure createNoVendor()

    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            PurchSetup.Get();
            PurchSetup.TestField("Vendor Nos.");
            // NoSeriesMgt.InitSeries(PurchSetup."Vendor Nos.", '', 0D, vendor."No.", vendor."No. Series");
            vendor."No." := NoSeriesMgt.GetNextNo(PurchSetup."Vendor Nos.", 0D, true);
            Rec."No." := vendor."No.";
        end;
    end;
}
