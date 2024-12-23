pageextension 50007 "PostedPurchaseInvoice" extends "Posted Purchase Invoice"
{
    //Guardar Nº asiento y Nº documento

    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Purch. Request less 200"; "Purch. Request less 200")
            {
                ApplicationArea = all;
            }
            field(NumAsiento_btc; NumAsiento_btc)
            {
                ApplicationArea = All;
            }
        }
        addlast(Content)
        {
            group(Plastic)
            {
                Caption = 'Normativa Plástico', comment = 'ESP="Normativa Plástico"';

                field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Plastic Date Declaration"; "Plastic Date Declaration")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        addafter(Vendor)
        {
            action(PurchRequestless200)
            {
                ApplicationArea = all;
                Caption = 'Purch. Request less 200', comment = 'ESP="Seleccionar Compra Menor 200 €"';
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    PurchRequestless200: record "Purchase Requests less 200";
                begin
                    PurchRequestless200.UpdatePurchaseInvoice(Rec);
                    CurrPage.Update();
                end;

            }
        }
    }

}