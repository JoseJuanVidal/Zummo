tableextension 50017 "ZMFixedAsset" extends "Fixed Asset"
{
    fields
    {
        field(50000; "Date Ini. Amort"; Date)
        {
            Caption = 'Date Ini. Amort', comment = 'ESP="Fecha inicio amortización"';
            FieldClass = FlowField;
            CalcFormula = lookup("FA Depreciation Book"."Depreciation Starting Date" where("FA No." = field("No.")));
            Editable = false;
        }
        field(50001; "Date Fin. Amort"; Date)
        {
            Caption = 'Date Fin. Amort', comment = 'ESP="Fecha final amortización"';
            FieldClass = FlowField;
            CalcFormula = lookup("FA Depreciation Book"."Depreciation Ending Date" where("FA No." = field("No.")));
            Editable = false;
        }
    }
}
