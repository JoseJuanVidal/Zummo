//051219 S19/01384
pageextension 50139 "ProdBOMWhereUsed" extends "Prod. BOM Where-Used"
{
    layout
    {
        addafter(ShowLevel)
        {

            field(ShowBlocked; ShowBlocked)
            {
                ApplicationArea = all;
                Caption = 'Ocultar Bloqueados', comment = 'ESP="Ocultar Bloqueados"';

                trigger OnValidate()
                begin
                    if ShowBlocked then
                        SetRange(ProductoBloqueado_btc, false)
                    else
                        SetRange(ProductoBloqueado_btc);

                    CurrPage.Update();
                end;
            }
        }
        addafter("Quantity Needed")
        {
            field("Level Code"; "Level Code")
            {
                ApplicationArea = all;
            }
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
    trigger OnOpenPage()
    begin

    end;

    var
        ShowBlocked: Boolean;
}