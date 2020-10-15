page 50008 "Account Translations"
{
    //171241
    Caption = 'Account Translations', comment = 'Traducción cuenta';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Account Translation";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}