page 50120 "Historico Contratos_zum"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "MultiRRHH Lineas_zum";
    SourceTableView = SORTING(tabla, CodigoRRHH);
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

                  }
                field("Cod. Contrato Laboral"; "Cod. Contrato Laboral")
                {

                 }
                field("Contrato Laboral"; "Contrato Laboral")
                {
                    Editable = false;
             }
                field("Fecha Baja"; "Fecha Baja")
                {

                }
                field("Cod. motivo terminación"; "Cod. motivo terminación")
                {

                }
                field("Motivo terminación"; "Motivo terminación")
                {
                    Editable = false;
                }
                field(Empresa; Empresa)
                {
                }
            }
        }
    }

    actions
    {
    }
}

