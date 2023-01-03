enum 50109 "ZM Task Production Bom change"
{
    Extensible = true;

    value(0; Change)
    {
        Caption = 'Change data', comment = 'ESP="Cambiar datos"';
    }
    value(1; Add)
    {
        Caption = 'Add Item', comment = 'ESP="Añadir producto"';
    }
    value(2; Replace)
    {
        Caption = 'Replace producto', comment = 'ESP="Sustituir producto"';
    }
    value(3; Delete)
    {
        Caption = 'Delete Item', comment = 'ESP="Eliminar producto"';
    }
}