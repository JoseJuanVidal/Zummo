pageextension 50204 "ZM IT Ext Jobs Setup" extends "Jobs Setup"
{
    layout
    {
        addlast(Content)
        {
            group(Expenses)
            {
                Caption = 'Register expenses', comment = 'ESP="Registro Gastos"';
                field("Expenses Job Jnl. Template"; "Expenses Job Jnl. Template")
                {
                    ApplicationArea = all;
                }
                field("Expenses Journal Batch Name"; "Expenses Journal Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Resource No. Expenses"; "Resource No. Expenses")
                {
                    ApplicationArea = all;
                }
            }
            group("Partes IT")
            {
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = all;
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = all;
                }
                field("url Base"; "url Base")
                {
                    ApplicationArea = All;
                }
                field(user; user)
                {
                    ApplicationArea = all;
                }
                field(token; token)
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }
            }
        }
    }
}
