page 50137 "ZM Prod. Tools Ldg. Entry Card"
{
    Caption = 'Prod. Tools Ledger Entry', Comment = 'ESP="Movs. Utiles producción"';
    PageType = Card;
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

                    trigger OnValidate()
                    begin
                        ValidateProdTools;
                    end;
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

                    trigger OnValidate()
                    begin
                        ValidateVendor();
                    end;
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

    var
        Vendor: Record Vendor;
        ProdTools: Record "ZM Productión Tools";

    local procedure ValidateProdTools()
    begin
        Rec."Prod. Tools Name" := '';
        if ProdTools.Get(Rec."Prod. Tools code") then begin
            Rec."Prod. Tools Name" := ProdTools.Description;
            Rec.Periodicity := ProdTools.Periodicity;
        end;
        CurrPage.Update();
    end;

    local procedure ValidateVendor()
    begin
        Rec."Vendor Name" := '';
        if Vendor.Get(Rec."Vendor No.") then begin
            Rec."Vendor Name" := Vendor.Name;
        end;
        CurrPage.Update();
    end;
}
