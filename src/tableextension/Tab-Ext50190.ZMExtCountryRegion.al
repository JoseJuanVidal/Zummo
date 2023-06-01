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
        field(50100; "ID RAES"; Text[100])
        {
            Caption = 'ID RAES';
            DataClassification = ToBeClassified;
        }
        field(50101; "ID PILAS"; Text[100])
        {
            Caption = 'ID PILAS';
            DataClassification = ToBeClassified;
        }
    }
}
