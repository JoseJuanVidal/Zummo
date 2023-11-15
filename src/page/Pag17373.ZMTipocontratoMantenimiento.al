page 17373 "ZM Tipo contrato Mantenimiento"
{
    PageType = List;
    Caption = 'Tipo contrato mantenimiento', comment = 'ESP="Tipo contrato mantenimiento"';
    UsageCategory = None;
    SourceTable = "ZM Tipo contrato Mantenimiento";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(duration; duration)
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
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}