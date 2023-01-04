page 50010 "Tarifas Precios"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Price";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(ItemDesc; Item.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Nombre producto', comment = 'ESP="Nombre producto"';
                }
                field("Sales Type"; "Sales Type")
                {
                    ApplicationArea = all;
                }
                field("Sales Code"; "Sales Code")
                {
                    ApplicationArea = all;
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Price Includes VAT"; "Price Includes VAT")
                {
                    ApplicationArea = all;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    ApplicationArea = all;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }

                field(ItemBlocked; Item.Blocked)
                {
                    ApplicationArea = all;
                    Caption = 'Bloqueado', comment = 'ESP="Bloqueado"';
                    Editable = false;
                }
                field(ItemBlockedSales; Item."Sales Blocked")
                {
                    ApplicationArea = all;
                    Caption = 'Bloqueado Ventas', comment = 'ESP="Bloqueado Ventas"';
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
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
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