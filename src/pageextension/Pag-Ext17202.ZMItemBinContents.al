pageextension 17202 "ZM Item Bin Contents" extends "Item Bin Contents"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            action(ConsultaInventarioSerie)
            {
                Caption = 'Ubicaciones Nº Serie', comment = 'ESP="Ubicaciones Nº Serie"';
                ToolTip = 'Lanza una consulta que muestra el inventario del producto, con almacenes, ubicación y numero de serie.',
                    comment = 'ESP="Lanza una consulta que muestra el inventario del producto, con almacenes, ubicación y numero de serie."';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ExtendedDataEntry;
                ApplicationArea = All;

                trigger OnAction()
                var
                    pageConsulta: Page "Consulta Inventario/Serie";
                begin
                    Clear(pageConsulta);
                    pageConsulta.SetProducto(Rec."Item No.");
                    pageConsulta.RunModal();
                end;
            }
        }
    }

    var
        myInt: Integer;
}