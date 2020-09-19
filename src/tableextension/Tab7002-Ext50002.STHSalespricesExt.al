tableextension 50002 "STH Sales prices Ext" extends "Sales price"  //7002
{
    fields
    {
        field(50000; "STH Vigente"; Boolean)
        {
            Caption = 'Vigente', comment = 'ESP="Vigente"';
            FieldClass = FlowField;
            CalcFormula = exist ("Sales Price" where("Item No." = field("Item No."), "Sales Type" = field("Sales Type"), "Sales Code" = field("Sales Code"),
            "Starting Date" = field("Starting Date"), "Currency Code" = field("Currency Code"), "Variant Code" = field("Variant Code"),
            "Unit of Measure Code" = field("Unit of Measure Code"), "Minimum Quantity" = field("Minimum Quantity")));
        }
        field(50002; "Date Filter"; date)
        {
            Caption = 'Date Filter', comment = 'ESP="Filtro Fecha"';
            FieldClass = FlowFilter;
        }
    }
}