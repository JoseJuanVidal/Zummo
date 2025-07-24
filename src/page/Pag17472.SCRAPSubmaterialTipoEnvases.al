page 17472 "SCRAP Submaterial Tipo Envases"
{
    Caption = 'Submaterial - Tipo de envases', comment = 'ESP="Submaterial - Tipo de envases"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SCRAP SubMaterial Tipo Envases";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SUBMATERIAL; SUBMATERIAL)
                {
                    ApplicationArea = all;
                }
                field("Tipo de Envase"; "Tipo de Envase")
                {
                    ApplicationArea = all;
                }
                field(Rigidez; Rigidez)
                {
                    ApplicationArea = all;
                }
                field(Tarifa; Tarifa)
                {
                    ApplicationArea = all;
                }
                field("Tipo Mercado"; "Tipo Mercado")
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