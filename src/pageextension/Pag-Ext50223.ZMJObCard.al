pageextension 50223 "ZM JOb Card" extends "Job Card"
{
    layout
    {
        addafter(Status)
        {
            field(Cancelled; Cancelled)
            {
                ApplicationArea = all;
            }
            field("Percentage progress"; "Percentage progress")
            {
                ApplicationArea = all;
            }
        }
        addlast(Content)
        {
            group(Clasification)
            {
                Caption = 'Clasification', comment = 'ESP="Clasificación"';
                field(Machine; Machine)
                {
                    ApplicationArea = all;
                }
                field(Typology; Typology)
                {
                    ApplicationArea = all;
                }
                field(Criticality; Criticality)
                {
                    ApplicationArea = all;
                }
                field(Laboratory; Laboratory)
                {
                    ApplicationArea = all;
                }
                field("Country/Region code"; "Country/Region code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        addafter("Co&mments")
        {
            action(AmountBOM)
            {
                ApplicationArea = all;
                Caption = 'Amount BOM', comment = 'ESP="Importe lista materiales"';
                Image = ExchProdBOMItem;
                Promoted = true;
                PromotedCategory = Category7;
                RunObject = page "ZM Job Amount BOM";
                RunPageLink = "Job No." = field("No.");
            }
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