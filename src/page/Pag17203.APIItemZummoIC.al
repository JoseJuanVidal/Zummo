page 17203 "API Item Zummo IC"
{
    PageType = List;
    SourceTable = Item;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.") { ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; }
                field(Blocked; Blocked) { ApplicationArea = all; }
                field("Sales Blocked"; "Sales Blocked") { ApplicationArea = all; }
                field("Block Reason"; "Block Reason") { ApplicationArea = all; }
                field("Item Category Code"; "Item Category Code") { ApplicationArea = all; }
                field(Familia; selFamilia_btc) { ApplicationArea = all; }
                field(desFamilia_btc; desFamilia_btc) { ApplicationArea = all; }
                field(ClasVtas_btc; selClasVtas_btc) { ApplicationArea = all; }
                field(desClasVtas_btc; desClasVtas_btc) { ApplicationArea = all; }
                field(selGama_btc; selGama_btc) { ApplicationArea = all; }
                field(desGama_btc; desGama_btc) { ApplicationArea = all; }
                field(selLineaEconomica_btc; selLineaEconomica_btc) { ApplicationArea = all; }
                field(desLineaEconomica_btc; desLineaEconomica_btc) { ApplicationArea = all; }
            }
        }
    }
}