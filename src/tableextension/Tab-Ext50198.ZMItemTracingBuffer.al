tableextension 50198 "ZM Item Tracing Buffer" extends "Item Tracing Buffer"
{
    fields
    {
        field(50100; "Country Region/Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country/Region Code', comment = 'ESP="Cód. país/región"';
            TableRelation = "Country/Region";
        }
        field(50101; "Country/Region Name"; text[50])
        {
            Caption = 'EU Country/Region Code', comment = 'ESP="Cód. país/región EU"';
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region".name where(Code = field("Country Region/Code")));
        }
        field(50102; "EU Country/Region Code"; code[10])
        {
            Caption = 'EU Country/Region Code', comment = 'ESP="Cód. país/región EU"';
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region"."EU Country/Region Code" where(Code = field("Country Region/Code")));
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