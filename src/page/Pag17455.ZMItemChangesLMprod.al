page 17455 "ZM Item Changes L.M. prod."
{
    Caption = 'Confirm Changes in L.M. Production', Comment = 'ESP="Confirmar Cambios en L.M. Producción"';
    PageType = List;
    SourceTable = "Item Changes L.M. production";
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }

                field("Action"; Rec."Action")
                {
                    ApplicationArea = All;
                }
                field("Original Quantity"; Rec."Original Quantity")
                {
                    ApplicationArea = All;
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = All;
                }
                field("New Item No."; Rec."New Item No.")
                {
                    ApplicationArea = All;
                }
                field("New Item Description"; Rec."New Item Description")
                {
                    ApplicationArea = All;
                }
                field("New Action"; Rec."New Action")
                {
                    ApplicationArea = All;
                }
                field("New Quantity"; Rec."New Quantity")
                {
                    ApplicationArea = All;
                }
                field("New Unit of measure"; Rec."New Unit of measure")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}
