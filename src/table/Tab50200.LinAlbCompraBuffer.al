table 50200 "LinAlbCompraBuffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; NumAlbaran; code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Receipt No.', comment = 'ESP="Nº Albarán"';
        }

        field(2; NumLinea; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Line No.', comment = 'ESP="Nº Línea"';
        }

        field(3; NumProducto; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Item No.', comment = 'ESP="Nº Producto"';
        }

        field(4; DescProducto; Text[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }

        field(5; Cantidad; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Print Quantity', comment = 'ESP="Cantidad Imprimir"';
        }

        field(6; NumMovimiento; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(7; NumPedido; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(8; FechaRegistro; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; NumAlbaran, NumLinea)
        {
            Clustered = true;
        }
    }
}