pageextension 50223 "ZM JOb Card" extends "Job Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Co&mments")
        {
            action(FixedAssets)
            {
                ApplicationArea = all;
                Caption = 'Fixed Assets', comment = 'ESP="Activos Fijos"';
                Image = FixedAssets;
                Promoted = true;
                PromotedCategory = Category7;
                RunObject = page "Fixed Asset List";
                RunPageLink = "Global Dimension 2 Code" = field("No.");
            }
        }
    }

    var
        myInt: Integer;
}