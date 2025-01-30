pageextension 50191 "FixedAssetCard" extends "Fixed Asset Card"
{
    layout
    {
        addafter(Acquired)
        {
            field("Status Use"; "Status Use")
            {
                ApplicationArea = all;
            }
            field("Previous AF changes"; "Previous AF changes")
            {
                ApplicationArea = all;
            }
            field("Item No."; "Item No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addbefore(Details)
        {
            Action(DimPorFecha)
            {
                ApplicationArea = All;
                Image = MapDimensions;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Caption = 'Dimensions by Date', comment = 'ESP="Dimensiones por Fecha"';
                ToolTip = 'Allows you to configure the dimensions by date of each fixed asset', comment = 'ESP="Permite configurar las dimensiones por fecha de cada activo fijo"';
                RunObject = Page "Dimensión AF por fecha";
                RunPageLink = CodActivo = field("No.");
            }

            action(ActualizarDimensiones)
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Update Dimensions', comment = 'ESP="Actualiza dimensiones"';
                ToolTip = 'Update the dimensions of the fixed asset according to the dimensions by dates set', comment = 'ESP="Actualiza las dimensiones del activo fijo según las dimensiones por fechas configuradas"';

                trigger OnAction()
                var
                    recDimFecha: Record DimAFRagoFecha;
                    recActivoFijo: Record "Fixed Asset";
                begin
                    Clear(recDimFecha);

                    recActivoFijo.Reset();
                    recActivoFijo.SetRange("No.", "No.");
                    if recActivoFijo.FindFirst() then
                        recDimFecha.CambiaDimensiones(Today(), recActivoFijo);
                end;
            }
        }
    }
}