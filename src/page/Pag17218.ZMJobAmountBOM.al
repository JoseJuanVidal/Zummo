page 17218 "ZM Job Amount BOM"
{
    Caption = 'Job Amount BOM', Comment = 'ESP=""Importe Lista de Materiales"';
    PageType = List;
    SourceTable = "ZM Job Amount BOM";
    UsageCategory = None;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
            }
        }
    }
}
