page 50159 "ZM Bussiness Unit Sales"
{
    Caption = 'Business Unit Sales', comment = 'ESP="Business Unit Sales"';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = all;
                    Caption = 'Filtro Fecha', comment = 'ESP="Filtro Fecha"';
                    trigger OnValidate()
                    begin
                        Fechas.SetFilter("Period Start", DateFilter);
                        DateFilter := Fechas.GetFilter("Period Start");
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Calcular)
            {
                Image = Track;

                trigger OnAction()
                begin
                    Message(DateFilter);
                end;
            }
        }
    }

    var
        Fechas: Record date;
        DateFilter: text;
}