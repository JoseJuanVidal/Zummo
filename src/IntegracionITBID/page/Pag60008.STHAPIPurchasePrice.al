page 60008 "STH API Purchase Price"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Purchase Price';
    // EntityCaption = 'STH API Purchase Price';
    // EntitySetCaption = 'STH API Purchase Price';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPurchasePrice';
    EntitySetName = 'sthPurchasePrice';
    ODataKeyFields = "Item No.", "Vendor No.", "Currency Code", "Starting Date", "Minimum Quantity", "Unit of Measure Code", "Variant Code";
    PageType = API;
    SourceTable = "Purchase Price";

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
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
                // field(systemId; Rec.SystemId)
                // {
                //     Caption = 'SystemId';
                // }
                field(ProcessNo; "Process No.")
                {
                    Caption = 'Process No.';
                }
                field(ProcessDescription; "Process Description")
                {
                    Caption = 'Process Description';
                }
            }
        }
    }
}
