page 17415 "ZM PL Items temporary card"
{
    ApplicationArea = All;
    Caption = 'Items temporary', Comment = 'ESP="Alta de productos"';
    PageType = card;
    SourceTable = "ZM PL Items temporary";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Applicant)
            {
                Caption = 'Applicant', comment = 'ESP="Solicitante"';
                field(Department; Department)
                {
                    ApplicationArea = all;
                }
                field("Product manager"; "Product manager")
                {
                    ApplicationArea = all;
                }
                field(Reason; Reason)
                {
                    ApplicationArea = all;
                }
                field(Activity; Activity)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Prototype; Prototype)
                {
                    ApplicationArea = all;
                }
            }
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(EnglishDescription; Rec.EnglishDescription)
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("State Creation"; "State Creation")
                {
                    ApplicationArea = all;
                }
                field("Assembly BOM"; Rec."Assembly BOM")
                {
                    ApplicationArea = All;
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Color; Rec.Color)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Alto; Rec.Alto)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Ancho; Rec.Ancho)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Largo; Rec.Largo)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Packaging; Rec.Packaging)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}
