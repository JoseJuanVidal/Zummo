query 50010 "Consulta Stocks Almacen"
{
    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            filter(FiltroAlmacen; "Location Code")
            {
            }
            filter(FiltroItemNo; "Item No.")
            {
            }
            // filter(FiltroLotNo; "Lot No.")
            // {
            // }
            filter(FiltroSerialNo; "Serial No.")
            {
            }
            // filter(FiltroVariante; "Variant Code")
            // {
            // }
            // filter(FiltroUnidadMedida; "Unit of Measure Code")
            // {
            // }
            column(Item_No; "Item No.")
            {
            }

            column(SerialNo; "Serial No.")
            {
            }
            column(Almacen; "Location Code")
            {
            }
            // column(Lote; "Lot No.")
            // {
            // }
            column(Open; Open)
            {
                ColumnFilter = Open = const(true);
            }
            // column(Location_Code; "Location Code")
            // {
            // }
            column(Cantidad; "Remaining Quantity")
            {
                ColumnFilter = Cantidad = FILTER(<> 0);
                Method = Sum;
            }

        }
    }
}

