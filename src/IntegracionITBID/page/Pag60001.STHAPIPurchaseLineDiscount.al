page 60001 "STH API Purchase Line Discount"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Purchase Line Discount';
    // EntityCaption = 'STH API Purchase Line Discount';
    // EntitySetCaption = 'STH API Purchase Line Discount';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPurchaseLineDiscount';
    EntitySetName = 'sthPurchaseLineDiscount';
    ODataKeyFields = "Item No.", "Vendor No.", "Currency Code", "Minimum Quantity", "Unit of Measure Code", "Variant Code", "Starting Date";
    PageType = API;
    SourceTable = "Purchase Line Discount";
    // Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(systemId; Rec.SystemId)
                // {
                //     Caption = 'SystemId';
                // }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(lineDiscount; Rec."Line Discount %")
                {
                    Caption = 'Line Discount %';
                }
                field(minimumQuantity; Rec."Minimum Quantity")
                {
                    Caption = 'Minimum Quantity';
                }
                field(endingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
            }
        }
    }
}
