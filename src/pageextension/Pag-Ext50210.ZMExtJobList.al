pageextension 50210 "ZM Ext Job List" extends "Job List"
{
    layout
    {
        addafter(Status)
        {
            field(Cancelled; Cancelled)
            {
                ApplicationArea = all;
            }
            field("Ending Date"; "Ending Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Machine; Machine)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Typology; Typology)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Criticality; Criticality)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Laboratory; Laboratory)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Country/Region code"; "Country/Region code")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
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
                PromotedCategory = Category5;
                RunObject = page "Fixed Asset List";
                RunPageLink = "Global Dimension 2 Code" = field("No.");
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter(Status, '<>%1', Rec.Status::Completed);
    end;

}