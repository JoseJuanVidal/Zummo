page 17403 "ZM WS Movs Fixed Assets"
{
    PageType = Card;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "FA Ledger Entry";
    // SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                Editable = false;
                field("FA Posting Date"; "FA Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("FA No."; "FA No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(FAName; FixedAssets.Description)
                {
                    Caption = 'Fixed Assets Name', comment = 'ESP="Nombre Act. Fijo"';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Depreciation Book Code"; "Depreciation Book Code")
                {
                    ApplicationArea = all;
                }
                field("FA Posting Category"; "FA Posting Category")
                {
                    ApplicationArea = all;
                }
                field("FA Posting Type"; "FA Posting Type")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("G/L Entry No."; "G/L Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gen. Posting Type"; "Gen. Posting Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not FixedAssets.Get(Rec."FA No.") then
            Clear(FixedAssets);
    end;

    var
        FixedAssets: Record "Fixed Asset";

}