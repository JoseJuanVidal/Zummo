tableextension 50138 "UserSetup" extends "User Setup"  // 91
{
    // Validar productos

    fields
    {
        field(50100; PermiteValidarProcutos_bc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allows to validate items', comment = 'ESP="Permite validar productos"';
        }
        field(50101; ImprimirPedVentaComentarios; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Imp. Ped. Venta mostrar comentarios', comment = 'ESP="Imp. Ped. Venta mostrar comentarios"';
        }
        field(50102; "Permite cambiar MMPP"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Permite cambiar MMPP', comment = 'ESP="Permite cambiar MMPP"';
        }
        field(50103; "Permite exportacion costes BOM"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Permite exportacion costes BOM', comment = 'ESP="Permite exportacion costes BOM"';
        }
    }
}