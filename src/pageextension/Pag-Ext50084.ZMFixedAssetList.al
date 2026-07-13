pageextension 50084 "ZMFixed Asset List" extends "Fixed Asset List"
{
    layout
    {
        addlast(Control1)
        {
            field("Date Ini. Amort"; "Date Ini. Amort")
            {
                ApplicationArea = all;
            }
            field("Date Fin. Amort"; "Date Fin. Amort")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
            field(Active; "Status Use")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Previous AF changes"; "Previous AF changes")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Item Nos."; "Item Nos.")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Dependent Item Nos."; "Dependent Item Nos.")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Serial No."; "Serial No.")
            {
                ApplicationArea = all;
            }
            field("Contract No."; "Contract No.")
            { ApplicationArea = all; }
        }
    }
    actions
    {
        addbefore("Main&tenance Ledger Entries")
        {
            action(Items)
            {
                ApplicationArea = all;
                Caption = 'Items', comment = 'ESP="Productos"';
                Image = ItemLines;
                RunObject = page "ZM Fixed Assets Products";
                RunPageLink = "FA No." = field("No.");

            }
            action(AnalysisLdgFixedAssets)
            {
                ApplicationArea = all;
                Caption = 'Analysis Ldg. Fixed Assets', comment = 'ESP="Análisis Act Fijos"';
                Image = FixedAssetLedger;

                trigger OnAction()
                var
                    AnalysisLdgFixedAssets: page "ZM Analysis Ldg. Fixed Assets";
                begin
                    AnalysisLdgFixedAssets.SetFixedAsset(Rec."No.");
                    AnalysisLdgFixedAssets.RunModal();
                end;

            }
        }
    }
}
