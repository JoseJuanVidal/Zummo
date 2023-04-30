tableextension 50191 "ZM IT Ext Jobs Setup" extends "Jobs Setup"
{
    fields
    {
        field(50000; "url Base"; Text[100])
        {
            Caption = 'url Base';
            DataClassification = ToBeClassified;
        }
        field(50001; user; Text[50])
        {
            Caption = 'user';
            DataClassification = ToBeClassified;
        }
        field(50002; token; Text[250])
        {
            Caption = 'token';
            DataClassification = ToBeClassified;
        }
    }
}
