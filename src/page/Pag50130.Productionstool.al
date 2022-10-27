page 50130 "Productions tool"
{
    ApplicationArea = All;
    Caption = 'Productions tool', Comment = 'ESP="Utiles producción"';
    PageType = Card;
    SourceTable = "ZM Productión Tools";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }
                field("Last date revision"; Rec."Last date revision")
                {
                    ApplicationArea = All;
                }
                field(Periodicity; Rec.Periodicity)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Resolution; Rec.Resolution)
                {
                    ApplicationArea = All;
                }
                group(Observations)
                {
                    Caption = 'Observations', comment = 'ESP="Observaciones"';

                    field(Obs; Obs)
                    {
                        ShowCaption = false;
                        MultiLine = true;
                    }
                }
            }

        }
    }
}
