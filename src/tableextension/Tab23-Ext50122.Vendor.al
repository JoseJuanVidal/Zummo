tableextension 50122 "Vendor" extends Vendor //23
{
    fields
    {
        field(50100; CodMotivoBloqueo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Blocking Motives', comment = 'ESP="Motivo Bloqueo"';
            TableRelation = MotivosBloqueo;
        }

        // Clasificación proveedor
        field(50101; ClasProveedor_btc; Enum ClasificacionProveedor)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Classification', comment = 'ESP="Clasificación proveedor"';
        }
    }
}