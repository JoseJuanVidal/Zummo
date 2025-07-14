page 17402 "ZM Fixed Assets Products"
{
    Caption = 'Fixed Assets Products', comment = 'ESP="Productos de Activos Fijos"';
    PageType = List;
    // ApplicationArea = all;
    UsageCategory = None;
    SourceTable = "ZM Fixed Assets Products";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FA No."; "FA No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("FA Name"; "FA Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        Item: Record Item;
                    begin
                        Item.SetFilter("No.", '%1', Rec."Item No." + '*');
                        page.RunModal(0, Item);
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Dependent; Dependent)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }
}