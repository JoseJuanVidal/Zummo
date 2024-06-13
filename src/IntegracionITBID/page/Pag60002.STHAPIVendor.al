page 60002 "STH API Vendor"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Vendor';
    // EntityCaption = 'STH API Vendor';
    // EntitySetCaption = 'STH API Vendor';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthVendor';
    EntitySetName = 'sthVendor';
    ODataKeyFields = "No.";
    PageType = API;
    SourceTable = Vendor;
    // Extensible = false;

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
                field(contactNo; Rec."Primary Contact No.") { }
                field(contact; Rec.Contact)
                {
                    Caption = 'Contact';
                }
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
                field(preferredBankAccountCode; Rec."Preferred Bank Account Code") { }
            }
        }
    }
}
