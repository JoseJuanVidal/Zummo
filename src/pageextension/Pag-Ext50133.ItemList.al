pageextension 50133 "ItemList" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field(Ordenacion_btc; Ordenacion_btc)
            {
                ApplicationArea = All;
                BlankZero = true;
            }
            field(STHQuantityWhse; STHQuantityWhse)
            {
                ApplicationArea = all;
                ToolTip = 'Qty. en Stockkeeping Unit', Comment = 'ESP="Cantidad en contenido de almacén"';
                Visible = false;
            }
            field("Safety Stock Quantity"; "Safety Stock Quantity")
            {
                ApplicationArea = all;
            }
            // Validar productos
            field(ValidadoContabiliad_btc; ValidadoContabiliad_btc)
            {
                ApplicationArea = All;
            }
            field(selClasVtas_btc; selClasVtas_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(desClasVtas_btc; desClasVtas_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(selFamilia_btc; selFamilia_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(desFamilia_btc; desFamilia_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(selGama_btc; selGama_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            Field(desGama_btc; desGama_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            Field(selLineaEconomica_btc; selLineaEconomica_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            Field(desLineaEconomica_btc; desLineaEconomica_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("Co&mments")
        {
            Promoted = true;
            PromotedCategory = Category4;
        }
    }
    var
        WarehouseEntry: Record "Warehouse Entry";
        ValueEntry: Record "Value Entry";
}