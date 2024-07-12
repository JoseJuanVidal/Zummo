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
                field(PostCode; PostCode) { }
                field(city; varCity)
                {
                    Caption = 'City';
                }
                field(County; varCounty) { }
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
        OldVendor: Record "Vendor";
        varCity: text[30];
        varCounty: text[30];
        PostCode: code[20];
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
                    Rec.Validate("Post Code", PostCode);
                    Rec.Validate(City, varCity);
                    Rec.Validate(County, varCounty);
                    Rec."Approval Status" := Rec."Approval Status"::Aproval;
                    createNoVendor();
                    AddVendorPostingGroup();
                    addContact();
                    addPreferredBankAccount();
                    vendor.Insert();
                    Commit();
                    SendEmailChangesVendor(false);
                end;
            'PATCH':
                begin
                    if vendor.Get(Rec."No.") then begin
                        OldVendor := vendor;
                        vendor.TransferFields(Rec);
                        Rec.Validate("Post Code", PostCode);
                        Rec.Validate(City, varCity);
                        Rec.Validate(County, varCounty);
                        Rec."Approval Status" := Rec."Approval Status"::Aproval;
                        AddVendorPostingGroup();
                        addContact();
                        addPreferredBankAccount();
                        vendor.Modify();
                        Commit();
                        SendEmailChangesVendor(true);
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

    local procedure SendEmailChangesVendor(Changes: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Subject: text;
        Body: text;
        SubjectNewLbl: Label 'Alta proveedor - %1 (%2)';
        SubjectChangesLbl: Label 'Cambio proveedor - %1 (%2)';
    begin
        SalesSetup.Get();
        SMTPMailSetup.Get();
        SMTPMailSetup.TestField("User ID");
        if Changes then
            Subject := StrSubstNo(SubjectChangesLbl, Vendor."No.", Vendor.Name)
        else
            Subject := StrSubstNo(SubjectNewLbl, Vendor."No.", Vendor.Name);

        Body := EnvioEmailBody(Subject);
        // enviamos el email 
        if SalesSetup.emailVendor = '' then
            exit;
        SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", SalesSetup.emailVendor, Subject, Body, true);
        SMTPMail.Send();
    end;

    local procedure EnvioEmailBody(Subject: text) Body: Text
    var
        Companyinfo: Record "Company Information";
    begin
        Companyinfo.Get();
        Body := '<p>&nbsp;</p>';
        Body += '<h1 style="color: #5e9ca0;">' + Companyinfo.Name + '</h1>';
        Body += '<h2 style="color: #2e6c80;">' + Subject + '</h2>';
        Body += '<p><strong>' + Rec.FieldCaption("Name 2") + '</strong>: ' + Vendor.Name + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Search Name") + '</strong>: ' + Vendor."Name 2" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("VAT Registration No.") + '</strong>: ' + Vendor."VAT Registration No." + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(Address) + '</strong>: ' + Vendor.Address + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Address 2") + '</strong>: ' + Vendor."Address 2" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Post Code") + '</strong>: ' + Vendor."Post Code" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(City) + '</strong>: ' + Vendor.City + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(County) + '</strong>: ' + Vendor.County + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Country/Region Code") + '</strong>: ' + Vendor."Country/Region Code" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Primary Contact No.") + '</strong>: ' + format(Rec."Primary Contact No.") + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("E-Mail") + '</strong>: ' + Rec."E-Mail" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Home Page") + '</strong>: ' + Rec."Home Page" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Phone No.") + '</strong>: ' + Rec."Phone No." + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Fax No.") + '</strong>: ' + Rec."Fax No." + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(ClasProveedor_btc) + '</strong>: ' + format(Vendor.ClasProveedor_btc) + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Currency Code") + '</strong>: ' + Vendor."Currency Code" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Language Code") + '</strong>: ' + Vendor."Language Code" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Vendor Posting Group") + '</strong>: ' + Vendor."Vendor Posting Group" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Payment Method Code") + '</strong>: ' + Vendor."Payment Method Code" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Payment Terms Code") + '</strong>: ' + Vendor."Payment Terms Code" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Preferred Bank Account Code") + '</strong>: ' + Vendor."Preferred Bank Account Code" + '</p>';
    end;
}
