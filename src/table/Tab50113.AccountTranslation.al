table 50113 "Account Translation"
{
    //171241
    Caption = 'Account Translation', Comment = 'ESP="Traducción Cuentas"';
    DataCaptionFields = "G/L Account No.", "Language Code", Description;
    LookupPageID = "Account Translations";
    DrillDownPageId = "Account Translations";

    fields
    {
        field(1; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.', Comment = 'ESP="Nº cuenta"';
            NotBlank = true;
            TableRelation = "G/L Account";
            ValidateTableRelation = false;  //  se utiliza en otras traducciones
        }
        field(2; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'ESP="Cód. idioma"';
            NotBlank = true;
            TableRelation = Language;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(4; "Description 2"; Text[50])
        {
            Caption = 'Description 2', Comment = 'ESP="Descripción 2"';
        }
    }

    keys
    {
        key(Key1; "G/L Account No.", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}