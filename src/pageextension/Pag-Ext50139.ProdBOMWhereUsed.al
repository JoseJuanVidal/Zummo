//051219 S19/01384
pageextension 50139 "ProdBOMWhereUsed" extends "Prod. BOM Where-Used"
{
    layout
    {
        addafter(ShowLevel)
        {
            field(HideBlocked; HideBlocked)
            {
                ApplicationArea = all;
                Caption = 'Hide Bocked', comment = 'ESP="Ocultar Bloqueados"';

                trigger OnValidate()
                begin
                    if HideBlocked then
                        SetRange(ProductoBloqueado_btc, false)
                    else
                        SetRange(ProductoBloqueado_btc);
                    CurrPage.Update();
                end;
            }
        }
        addafter("Quantity Needed")
        {
            field(ProductoBloqueado_btc; ProductoBloqueado_btc)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action(Product)
            {
                ApplicationArea = all;
                Caption = 'Item', comment = 'ESP="Producto"';
                Image = Item;
                Promoted = true;
                PromotedCategory = Category12;

                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
            }
        }
    }
    var
        HideBlocked: Boolean;
}