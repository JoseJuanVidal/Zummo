pageextension 50041 "PostedSalesInvoiceSubform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group") { }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group") { }
        }
        addlast(Control1)
        {
            field("Inv. Discount Amount"; "Inv. Discount Amount")
            {
                ApplicationArea = all;
            }
        }
    }
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
                    funciones.SalesInvoiceLineUpdatecost(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }
}