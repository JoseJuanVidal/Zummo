page 50104 "CapacidadCentrosTrabajo"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = CapCentrotrabajo;
    Caption = 'Capacity list by work center', comment = 'ESP="Lista Capacidad por centro trabajo"';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(CodCentro; CodCentro)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CalcFields(NombreCentro);
                    end;
                }

                field(NombreCentro; NombreCentro)
                {
                    ApplicationArea = All;
                }

                field(CodProducto; CodProducto)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CalcFields(DescProducto);
                    end;
                }

                field(DescProducto; DescProducto)
                {
                    ApplicationArea = All;
                }

                field(NumOrdenesFab; NumOrdenesFab)
                {
                    ApplicationArea = all;
                }

                field(NumPersonas; NumPersonas)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}