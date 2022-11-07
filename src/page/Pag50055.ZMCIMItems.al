page 50055 "ZM CIM Items"
{
    ApplicationArea = All;
    Caption = 'Items Pending', comment = 'ESP="Productos pendientes"';
    ;
    PageType = List;
    SourceTable = "ZM CIM Items temporary";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
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
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = All;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                }
                field(Largo; Rec.Largo)
                {
                    ApplicationArea = All;
                }
                field(Alto; Rec.Alto)
                {
                    ApplicationArea = All;
                }
                field(Ancho; Rec.Ancho)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}
