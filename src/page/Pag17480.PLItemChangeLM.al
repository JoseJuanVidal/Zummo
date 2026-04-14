page 17480 "PL Item Change LM"
{
    Caption = 'Sustitución en Lista Materiales', comment = 'ESP="Sustitución en Lista Materiales"';
    PageType = ListPart;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "PL Item Change LM";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Request No."; "Request No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Action; Action)
                {
                    ApplicationArea = all;
                }
                field("Quantity per"; "Quantity per")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}