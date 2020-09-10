page 50134 "Historico Categorias_zum"
{
    AutoSplitKey = true;
    PageType = Listpart;
    SourceTable = "MultiRRHH Lineas_zum";
    SourceTableView =
                      WHERE(tabla = CONST("Historico Categoria"));
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha Alta"; "Fecha Alta")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Cod. Categoria"; "Cod. Categoria")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Fecha Baja"; "Fecha Baja")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field(Motivo; Motivo)
                {

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

