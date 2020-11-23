pageextension 50052 "STHDefSalesPriceWorksheet" extends "Sales Price Worksheet"
{
    layout
    {
        addlast(Control1)
        {
            field(ItemBlocked; Item.Blocked)
            {
                ApplicationArea = all;
                Caption = 'Bloqueado', comment = 'ESP="Bloqueado"';
                Editable = false;
            }
            field(ItemBlockedSales; Item."Sales Blocked")
            {
                ApplicationArea = all;
                Caption = 'Bloqueado Ventas', comment = 'Bloqueado Ventas';
                Editable = false;
            }
            field(ItemClasVtas; Item.desClasVtas_btc)
            {
                ApplicationArea = all;
                Caption = 'Clasificación Ventas', comment = 'ESP="Clasificación Ventas"';
                Editable = false;
            }
            field(ItemFamilia; Item.desFamilia_btc)
            {
                ApplicationArea = all;
                Caption = 'Familia', comment = 'ESP="Familia"';
                Editable = false;
            }
            field(ItemGamma; Item.desGama_btc)
            {
                ApplicationArea = all;
                Caption = 'Gama', comment = 'ESP="Gama"';
                Editable = false;
            }
            field(ItemLineaEco; Item.desLineaEconomica_btc)
            {
                ApplicationArea = all;
                Caption = 'Línea Económica', comment = 'ESP="Línea Económica"';
                Editable = false;
            }
            field(ItemCategory; Item."Item Category Code")
            {
                ApplicationArea = all;
                Caption = 'Categoria producto', comment = 'ESP="Categoria producto"';
                Editable = false;
            }
            field(ItemCostingMethod; Item."Costing Method")
            {
                ApplicationArea = all;
                Caption = 'Valoración Existencias', comment = 'ESP="Valoración Existencias"';
                Editable = false;
            }
            field(ItemUnitCost; Item."Unit Cost")
            {
                ApplicationArea = all;
                Caption = 'Coste Unitario', comment = 'ESP="Coste Unitario"';
                Editable = false;
            }
            field(ItemStandardCost; Item."Standard Cost")
            {
                ApplicationArea = all;
                Caption = 'Coste Estandar', comment = 'ESP="Coste Estandar"';
                Editable = false;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }


    trigger OnAfterGetRecord()
    begin
        if Item.Get("Item No.") then;
        ItemCalcFields;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Item.Get("Item No.") then;
        ItemCalcFields;
    end;

    var
        Item: Record Item;

    local procedure ItemCalcFields()
    begin
        Item.CalcFields(desClasVtas_btc, desFamilia_btc, desGama_btc, desLineaEconomica_btc)

    end;
}