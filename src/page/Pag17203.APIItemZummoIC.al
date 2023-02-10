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
                field(UnitPrice; UnitPrice) { ApplicationArea = all; }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UnitPrice := 0;
        CalcSalesPrice();
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        SalesPrice: Record "Sales Price" temporary;
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        UnitPrice: Decimal;

    local procedure CalcSalesPrice()
    begin
        SalesReceivablesSetup.Get;
        if Customer.Get(SalesReceivablesSetup."Customer Quote IC") then begin

            PriceCalcMgt.FindSalesPrice(SalesPrice, SalesReceivablesSetup."Customer Quote IC", '', Customer."Customer Price Group", '', Rec."No.", '',
                    Rec."Base Unit of Measure", Customer."Currency Code", WorkDate(), false);

            IF SalesPrice.FindSet() THEN
                REPEAT
                    IF (UnitPrice = 0) OR (UnitPrice > SalesPrice."Unit Price") then
                        UnitPrice := SalesPrice."Unit Price";
                UNTIL SalesPrice.NEXT = 0;

        end;
    end;
}