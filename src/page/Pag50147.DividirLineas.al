page 50147 "DividirLineas"
{
    PageType = Card;
    Caption = 'Divide Line', comment = 'ESP="Dividir línea"';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(globalCantidad; globalCantidad)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity', comment = 'ESP="Cantidad"';
                }
            }
        }
    }

    procedure SetCantidad(pCantidad: Decimal)
    begin
        globalCantidad := pCantidad;
    end;

    procedure GetCantidad(): Decimal
    begin
        exit(globalCantidad);
    end;

    var
        globalCantidad: Decimal;
}