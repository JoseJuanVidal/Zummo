//101219 S19/01393 Clasificación proveedor
enum 50103 "ClasificacionProveedor"
{
    Extensible = true;

    value(0; Ninguno)
    {
        Caption = ' ', comment = 'ESP=" "';
    }

    value(1; Embalaje)
    {
        Caption = 'Packaging', comment = 'ESP="Embalaje"';
    }

    value(10; Estampacion)
    {
        Caption = 'Stamping', comment = 'ESP="Estampación"';
    }

    value(11; Vestuario_Epis)
    {
        Caption = 'Clothing/EPIS', comment = 'ESP="Vestuario/EPIS"';
    }

    value(12; Transportes)
    {
        Caption = 'Transportation', comment = 'ESP="Transportes"';
    }

    value(13; Medios)
    {
        Caption = 'Media', comment = 'ESP="Medios"';
    }

    value(14; Servicios)
    {
        Caption = 'Services', comment = 'ESP="Servicios"';
    }

    value(15; Varilla)
    {
        Caption = 'Dipstick', comment = 'ESP="Varilla"';
    }

    value(16; Instalaciones)
    {
        Caption = 'Installations', comment = 'ESP="Instalaciones"';
    }

    value(2; Tornilleria)
    {
        Caption = 'Screws', comment = 'ESP="Tornillería"';
    }

    value(3; Caucho)
    {
        Caption = 'Rubber', comment = 'ESP="Caucho"';
    }

    value(4; Plastico)
    {
        Caption = 'Plastic', comment = 'ESP="Plástico"';
    }

    value(5; Imprenta_Publicidad)
    {
        Caption = 'Printing/Advertising', comment = 'ESP="Imprenta/Publicidad"';
    }

    value(6; Electronica)
    {
        Caption = 'Electronic', comment = 'ESP="Electrónica"';
    }

    value(7; Otros)
    {
        Caption = 'Others', comment = 'ESP="Otros"';
    }

    value(8; Mecanizado)
    {
        Caption = 'Machining', comment = 'ESP="Mecanizado"';
    }

    value(9; Motor_Reduct)
    {
        Caption = 'Engine/Reduct', comment = 'ESP="Motor/Reduct"';
    }

    value(17; Proveedor_Sat)
    {
        Caption = 'SAT Provider', comment = 'ESP="Proveedor SAT"';
    }
}