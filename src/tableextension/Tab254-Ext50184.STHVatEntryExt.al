tableextension 50184 "STH Vat Entry Ext" extends "vat Entry" //254
{
    fields
    {
        field(50001; "EU Country/Region Code"; Code[10])
        {
            FieldClass = FlowField;
            Caption = 'EU Cód. Pais', comment = 'ESP="EU Cód. Pais"';
            CalcFormula = lookup("Country/Region"."EU Country/Region Code" where(Code = field("Country/Region Code")));
            Editable = false;
        }
    }

    var
        myInt: Integer;
}