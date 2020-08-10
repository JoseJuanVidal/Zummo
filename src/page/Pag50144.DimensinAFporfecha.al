page 50144 "Dimensión AF por fecha"
{

    PageType = List;
    SourceTable = DimAFRagoFecha;
    Caption = 'FA Dimension By date', Comment = 'ESP="Dimensión AF por fecha"';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CodDimension; CodDimension)
                {
                    ApplicationArea = All;
                }
                field(FechaInicio; FechaInicio)
                {
                    ApplicationArea = All;
                }
                field(ValorDimension; ValorDimension)
                {
                    ApplicationArea = All;
                }
                field(FechaFin; FechaFin)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
