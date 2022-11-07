page 50131 "ZM Prod. Tools Ledger Entry"
{
    Caption = 'ZM Prod. Tools Ledger Entry';
    PageType = List;
    SourceTable = "ZM Prod. Tools Ledger Entry";
    UsageCategory = None;
    CardPageId = "ZM Prod. Tools Ldg. Entry Card";

    layout
    {
        area(content)
        {
            repeater(General)
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
                field("Next date revision"; "Next date revision")
                {
                    ApplicationArea = all;
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

        area(FactBoxes)
        {
            part("Attached Documents"; "ZM Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments', Comment = 'ESP="Doc. Adjuntos"';
                SubPageLink = "Table ID" = CONST(50153), "No." = FIELD("Prod. Tools code"), "Line No." = field("Entry No.");
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage."Attached Documents".Page.SetTableNo(50153, Rec."Prod. Tools code", rec."Entry No.");
        CurrPage."Attached Documents".Page.SetProdToolsLdgEntry_RecordRef(Rec);
    end;
}
