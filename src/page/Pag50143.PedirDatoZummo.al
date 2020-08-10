page 50143 "PedirDatoZummo"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Pedir dato', comment = 'ESP="Pedir dato"';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General', comment = 'ESP="General"';

                field(varDato; varDato)
                {
                    ApplicationArea = All;
                    Caption = 'Dato', comment = 'ESP="Dato"';
                }

            }
        }
    }

    procedure SetDato(var Dato: Code[20])
    begin
        varDato := Dato;
    end;

    procedure GetDato(): Code[20]
    begin
        Exit(varDato);
    end;

    var
        varDato: Code[20];
        estadoOrden: Option Simulada,Planificada,"Planif. en firme",Lanzada,Terminada;
}