page 50146 "Selección Etiquetas"
{

    PageType = List;
    SourceTable = LinAlbCompraBuffer;
    Caption = 'Selección Etiquetas';
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(NumProducto; NumProducto)
                {
                    ApplicationArea = All;
                }
                field(DescProducto; DescProducto)
                {
                    ApplicationArea = All;
                }
                field(Cantidad; Cantidad)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FindFirst() then;
    end;

    procedure GetDatos(var pMovsImprimir: List of [Integer])
    var
        i: Integer;
        cantEntera: Integer;
    begin
        if FindSet() then
            repeat
                cantEntera := Cantidad div 1;

                for i := 1 to cantEntera do
                    pMovsImprimir.Add(NumMovimiento);
            until Next() = 0;
    end;

    procedure SetData(var pTabla: Record LinAlbCompraBuffer temporary)
    var
        myInt: Integer;
    begin
        pTabla.Reset();
        if pTabla.FindSet() then
            repeat
                Rec := pTabla;
                Insert();
            until pTabla.Next() = 0;
    end;
}
