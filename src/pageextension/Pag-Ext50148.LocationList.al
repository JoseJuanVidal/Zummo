pageextension 50148 "LocationList" extends "Location List"
{
    //111219 S19/01398 Query inventario
    //191219 S19/01425 Ordenación almacenes

    layout
    {
        //191219 S19/01425 Ordenación almacenes
        addafter(Name)
        {
            field(Ordenacion_btc; Ordenacion_btc)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Items with Negative Inventory")
        {
            action(ConsultaInventario)
            {
                Caption = 'Check inventory', comment = 'ESP="Consulta inventario"';
                ToolTip = 'Launch a query that shows the inventory in the warehouse in which we are positioned',
                    comment = 'ESP="Lanza una consulta que muestra el inventario en el almacén en el que estamos posicionados"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = ExtendedDataEntry;
                ApplicationArea = All;

                trigger OnAction()
                var
                    pageConsulta: Page "Consulta de Inventario";
                begin
                    Clear(pageConsulta);
                    pageConsulta.SetAlmacen(Rec.Code);
                    pageConsulta.RunModal();
                end;
            }
           

        }
    }
}