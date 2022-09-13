pageextension 50075 "STH Posted Sales Cr. Memo Subf" extends "Posted Sales Cr. Memo Subform"
{
    actions
    {
        addafter(DocAttach)
        {
            action(CalcItemCost)
            {
                Caption = 'Act. Coste Unitario', comment = 'ESP="Act. Coste Unitario"';
                ApplicationArea = all;
                Image = Cost;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                begin
                    funciones.SalesCRMemoLineUpdatecost(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }
}
