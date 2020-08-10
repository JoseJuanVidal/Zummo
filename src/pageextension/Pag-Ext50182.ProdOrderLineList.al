pageextension 50182 "ProdOrderLineList" extends "Prod. Order Line List"
{

    procedure GetResult(VAR SalesLine: Record "Prod. Order Line")
    begin
        CurrPage.SETSELECTIONFILTER(SalesLine);
    end;
}