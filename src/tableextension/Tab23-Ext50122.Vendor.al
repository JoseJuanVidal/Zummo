tableextension 50122 "Vendor" extends Vendor //23
{
    fields
    {
        field(50000; "Purch. Order email"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Purch. Order email', comment = 'ESP="Email pedido compra"';
        }
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
        field(50102; "Transport Methods"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Transport Methods', comment = 'ESP="Método de transporte"';
            TableRelation = "Transport Method";
        }
        field(50105; "Last date ledger Entry"; Date)
        {
            Caption = 'Last Entry', comment = 'ESP="Último movimiento"';
            FieldClass = FlowField;
            CalcFormula = max("Vendor Ledger Entry"."Document Date" where("Vendor No." = field("No."), "Document Type" = filter(Invoice | "Credit Memo")));
        }
        field(50120; "Codigo Anterior"; code[20])
        {
            Caption = 'Codigo Anterior', comment = 'ESP="Codigo Anterior"';
        }
        field(50121; NuevoSEB; Boolean)
        {
            Caption = 'Nuevo SEB', comment = 'ESP="Nuevo SEB"';
        }
    }
}