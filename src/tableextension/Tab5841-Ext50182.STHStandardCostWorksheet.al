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
        Field(50101; Blocked; Boolean)
        {
            Caption = 'Bloqueado', comment = 'ESP="Bloqueado"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Blocked where("No." = field("No.")));
            Editable = false;
        }
        Field(50102; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost', comment = 'ESP="Coste unitario"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Unit Cost" where("No." = field("No.")));
        }
        Field(50103; "Costing Method"; Option)
        {
            OptionMembers = FIFO,LIFO,Specific,Average,Standard;
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard', comment = 'ESP="FIFO,LIFO,Especial,Medio,Estándar"';
            Caption = 'Costing Method', comment = 'ESP="Valoración existencias"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Costing Method" where("No." = field("No.")));
        }
    }
}