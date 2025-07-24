page 17473 "SCRAP Item - Tipo de Envases"
{
    Caption = 'Tipo de Envase producto', comment = 'ESP="Tipo de Envase producto"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SCRAP Item - Tipo de Envase";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field(SUBMATERIAL; SUBMATERIAL)
                {
                    ApplicationArea = all;
                }
                field("Tipo de Envase"; "Tipo de Envase")
                {
                    ApplicationArea = all;
                }
                field(Flexible; Flexible)
                {
                    ApplicationArea = all;
                }
                field(Tarifa; Tarifa)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}