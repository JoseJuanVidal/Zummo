page 60003 "STH API Item"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Item';
    // EntityCaption = 'STH API Item';
    // EntitySetCaption = 'STH API Item';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthItem';
    EntitySetName = 'sthItem';
    ODataKeyFields = "No.";
    PageType = API;
    SourceTable = Item;
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
                field(inventory; Rec.Inventory)
                {
                    Caption = 'Inventory';
                }
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(type; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(priceIncludesVAT; Rec."Price Includes VAT")
                {
                    Caption = 'Price Includes VAT';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
            }
        }
    }
}
