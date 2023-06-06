page 17418 "ZM CONSULTIA Producto-Proyecto"
{
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "ZM CONSULTIA Producto-Proyecto";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(CodigoProducto; CodigoProducto)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = all;
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

    var
        myInt: Integer;
}