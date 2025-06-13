tableextension 50207 "ZM Production Forecast Entry" extends "Production Forecast Entry"
{
    fields
    {
        field(50100; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation', comment = 'ESP="Plazo entrega (días)"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Lead Time Calculation" where("No." = field("Item No.")));
            Editable = false;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}