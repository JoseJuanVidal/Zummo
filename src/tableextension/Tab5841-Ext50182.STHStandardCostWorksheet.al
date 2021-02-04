tableextension 50182 "STH StandardCostWorksheet" extends "Standard Cost Worksheet"  //5841
{
    fields
    {
        Field(50100; LastUnitCost; Decimal)
        {
            Caption = 'Ultimo coste directo', comment = 'ESP="Ultimo coste directo"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Last Direct Cost" where("No." = field("No.")));
        }
    }
}