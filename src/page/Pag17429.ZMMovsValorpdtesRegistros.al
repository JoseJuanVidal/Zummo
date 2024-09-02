page 17429 "ZM Movs. Valor pdtes Registros"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            group(Filtros)
            {
                field(FechaIni; FechaIni)
                {
                    ApplicationArea = All;
                    Caption = 'Fecha Inicial', comment = 'ESP="Fecha Inicial"';
                }
                field(FechaFin; FechaFin)
                {
                    ApplicationArea = all;
                    Caption = 'Fecha Final', comment = 'ESP="Fecha Final"';
                }
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = all;
                    Caption = 'Fecha Registro', comment = 'ESP="Fecha Registro"';
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
        PostingDate: Date;
        FechaIni: Date;
        FechaFin: Date;
}