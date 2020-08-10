tableextension 50172 "WarehouseBasicCue" extends "Warehouse Basic Cue"  // 9050
{
    fields
    {
        field(50100; "Exp. Purch. Orders Until Today 2"; Integer)
        {
            Editable = false;
            Caption = 'Exp. Purch. Orders Until Today', comment = 'ESP="Pedidos de compra esperados hasta hoy"';
            FieldClass = FlowField;
            CalcFormula = count ("Purchase Header" where(
                "Document Type" = FILTER(Order),
                Status = FILTER(Released),
                "Expected Receipt Date" = FIELD("Date Filter"),
                "Location Code" = FIELD("Location Filter"),
                "Completely Received" = const(false)
                )
            );
        }
    }
}