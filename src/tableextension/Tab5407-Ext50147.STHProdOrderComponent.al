tableextension 50147 "STHProdOrderComponent" extends "Prod. Order Component" //5407
{
    fields
    {
        field(50001; "Item No. production"; code[20])
        {
            Caption = 'Item No. production', comment = 'ESP="Nº producto a producir"';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Item No." where(Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }
        field(50002; "Item Name production"; text[100])
        {
            Caption = 'Item Name production', comment = 'ESP="Descripción producto a producir"';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line".Description where(Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }

        field(50003; "Starting Datet production"; Date)
        {
            Caption = 'Starting Dateproduction', comment = 'ESP="Fecha inicial producto a producir"';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Starting Date" where(Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }
        field(50004; "Quantity production"; Decimal)
        {
            Caption = 'Quantity production', comment = 'ESP="Cantidad producto a producir"';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line".Quantity where(Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }
        field(50005; "Remaining Quantity production"; Decimal)
        {
            Caption = 'Remaining Quantity production', comment = 'ESP="Cantidad pendiente producto a producir"';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Remaining Quantity" where(Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }

    }
}