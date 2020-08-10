page 50126 "CopiarCuent"
{
    //Duplicar cuenta contable

    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Copy Account', comment = 'ESP="Copiar Cuenta"';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Name; codigo)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account No.', comment = 'ESP="Nº Cuenta"';
                }

                field(Desc; descripcion)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account Name', comment = 'ESP="Nombre cuente"';
                }
            }
        }
    }

    procedure SetProductoOrigen(pOrigen: Code[20])
    begin
        codigoOrigen := pOrigen;
    end;

    procedure GetDatos(var pNuevaCuenta: code[20]; var pNuevaDescripcion: text[100])
    begin
        pNuevaCuenta := codigo;
        pNuevaDescripcion := descripcion;
    end;

    var
        codigo: code[20];
        descripcion: Text[100];
        codigoOrigen: code[20];
}