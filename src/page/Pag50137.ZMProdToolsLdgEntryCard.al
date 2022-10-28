page 50137 "ZM Prod. Tools Ldg. Entry Card"
{
    Caption = 'Prod. Tools Ledger Entry', Comment = 'ESP="Movs. Utiles producción"';
    PageType = List;
    SourceTable = "ZM Prod. Tools Ledger Entry";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Prod. Tools code"; Rec."Prod. Tools code")
                {
                    ApplicationArea = All;
                }
                field("Prod. Tools Name"; "Prod. Tools Name")
                {
                    ApplicationArea = all;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                }

                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Ref. Certificate"; Rec."Ref. Certificate")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Periodicity; Rec.Periodicity)
                {
                    ApplicationArea = All;
                }
                field("Last date revision"; Rec."Last date revision")
                {
                    ApplicationArea = All;
                }
                field(Resolution; Rec.Resolution)
                {
                    ApplicationArea = All;
                }
            }
        }
    }


}
