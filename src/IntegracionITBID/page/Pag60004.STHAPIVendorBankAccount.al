page 60004 "STH API Vendor Bank Account"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Vendor Bank Account';
    // EntityCaption = 'STH API Vendor Bank Account';
    // EntitySetCaption = 'STH API Vendor Bank Account';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthVendorBankAccount';
    EntitySetName = 'sthVendorBankAccount';
    ODataKeyFields = "Vendor No.", Code;
    PageType = API;
    SourceTable = "Vendor Bank Account";
    // Extensible = false;

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
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(iban; Rec.IBAN)
                {
                    Caption = 'IBAN';
                }
                field(swiftCode; Rec."SWIFT Code")
                {
                    Caption = 'SWIFT Code';
                }
                field(CCCBankNo; Rec."CCC No.")
                {
                    Caption = 'CCC Bank No.';
                }
            }
        }
    }
}
