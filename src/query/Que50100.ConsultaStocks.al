query 50100 "Consulta Stocks"
{
    elements
    {
        dataitem(Warehouse_Entry; "Warehouse Entry")
        {
            filter(FiltroAlmacen; "Location Code")
            {
            }
            filter(FiltroUbicacion; "Bin Code")
            {
            }
            filter(FiltroItemNo; "Item No.")
            {
            }
            filter(FiltroLotNo; "Lot No.")
            {
            }
            filter(FiltroSerialNo; "Serial No.")
            {
            }
            filter(FiltroVariante; "Variant Code")
            {
            }
            filter(FiltroUnidadMedida; "Unit of Measure Code")
            {
            }

            column(SerialNo; "Serial No.")
            {
            }
            column(Almacen; "Location Code")
            {
            }
            column(Ubicacion; "Bin Code")
            {
            }
            column(Lote; "Lot No.")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Variant_Code; "Variant Code")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Cantidad; "Qty. (Base)")
            {
                ColumnFilter = Cantidad = FILTER(<> 0);
                Method = Sum;
            }
            column(Registering_Date; "Registering Date")
            {
            }
            column(Fecha_Fin_Contrato; "Fecha Fin Contrato")
            { }
            column(Comentario; "Comentario")
            { }
            column(Source_Document; "Source Document")
            { }
            column(Source_No_; "Source No.")
            { }
            column(Source_Type; "Source Type")
            { }
            column(Source_Subtype; "Source Subtype")
            { }
            column(Source_Line_No_; "Source Line No.")
            { }
            column(Entry_No_; "Entry No.")
            { }
        }
    }
}

