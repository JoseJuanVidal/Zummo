page 50135 "ZM Item Where Used detail"
{
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Where-Used Line";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field("Parent Item No."; "Parent Item No.")
                {
                    ApplicationArea = all;
                    Caption = 'Cód. Producto', comment = 'ESP="Cód. Producto""';
                }
                field("Description Parent"; "Description Parent")
                {
                    ApplicationArea = all;
                    Caption = 'Descripción', comment = 'ESP="Descripción""';
                }
                field("Parent Blocked"; "Parent Blocked")
                {
                    ApplicationArea = all;
                    Caption = 'Bloqueado', comment = 'ESP="Bloqueado""';
                }
                field("Production BOM No."; "Production BOM No.")
                {
                    ApplicationArea = all;
                    Caption = 'L.M. Producción', comment = 'ESP="L.M. Producción"';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Quantity Needed"; "Quantity Needed")
                {
                    ApplicationArea = all;
                }
                field(ProductoBloqueado_btc; ProductoBloqueado_btc)
                {
                    ApplicationArea = all;
                }
                field("Level Code"; "Level Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        Item: Record Item;
        FuncionesFabricacion: Codeunit FuncionesFabricacion;

    trigger OnOpenPage()
    begin
        Item.Reset();
        Item.SetRange(Blocked, false);
        Item.SetFilter("Production BOM No.", '<>%1', '');
        FuncionesFabricacion.BuildWhereUsedFromItem(Item, Rec, true);
    end;

    trigger OnAfterGetRecord()
    begin
        if Item.Get(Rec."Item No.") then;
    end;

}