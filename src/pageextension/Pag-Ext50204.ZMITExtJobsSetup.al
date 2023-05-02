pageextension 50204 "ZM IT Ext Jobs Setup" extends "Jobs Setup"
{
    layout
    {
        addlast(Content)
        {
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
