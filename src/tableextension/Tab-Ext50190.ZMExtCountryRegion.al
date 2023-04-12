tableextension 50190 "ZM Ext Country/Region" extends "Country/Region"
{
    fields
    {
        field(17200; "Cuota Objetivo"; Decimal)
        {
            Caption = 'Cuota Objetivo';
            DataClassification = ToBeClassified;
        }
        field(17201; "Pais ABC"; Text[3])
        {
            Caption = 'Pais ABC';
            DataClassification = ToBeClassified;
        }
    }
}
