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
        field(50005; "Journal Template Name"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Template Name', comment = 'ESP="Nombre libro diario"';
            TableRelation = "Res. Journal Template";
        }

        field(50006; "Journal Batch Name"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Batch Name', comment = 'ESP="Nombre sección diario"';
            TableRelation = "Res. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(50010; "Resource No. Expenses"; code[20])
        {
            Caption = 'Resource No. Expenses', comment = 'ESP="Nª Recurso Gastos"';
            DataClassification = ToBeClassified;
            TableRelation = Resource where(Type = const(Machine));
        }
        field(50011; "Expenses Job Jnl. Template"; code[10])
        {
            Caption = 'Expenses Job Jnl. Template', comment = 'ESP="Nombre libro diario Gastos"';
            DataClassification = ToBeClassified;
            TableRelation = "Job Journal Template";
        }
        field(50012; "Expenses Journal Batch Name"; code[10])
        {
            Caption = 'Expenses Journal Batch Name', comment = 'ESP="Nombre sección diario Gastos"';
            DataClassification = ToBeClassified;
            TableRelation = "Job Journal Batch".Name where("Journal Template Name" = field("Expenses Job Jnl. Template"));
        }
    }
}
