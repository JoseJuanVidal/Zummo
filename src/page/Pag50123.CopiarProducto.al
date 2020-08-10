page 50123 "CopiarProducto"
{
    //Copiar producto

    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Item Copy', comment = 'ESP="Copiar producto"';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(producto; codProducto)
                {
                    ApplicationArea = All;
                    Caption = 'New Item Code', comment = 'ESP="Nuevo Cód. Producto"';

                    trigger OnAssistEdit()
                    var
                        InvtSetup: Record "Inventory Setup";
                        recItem: Record Item;
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                    begin
                        InvtSetup.GET();
                        recItem.Init();

                        InvtSetup.TESTFIELD("Item Nos.");
                        IF NoSeriesMgt.SelectSeries(InvtSetup."Item Nos.", recItem."No. Series", recItem."No. Series") THEN
                            NoSeriesMgt.SetSeries(codProducto);
                    end;
                }

                field(descripcion; descProducto)
                {
                    ApplicationArea = All;
                    Caption = 'New Description', comment = 'ESP="Nueva descripción"';
                }

                field(crearLista; crearListaMateriales)
                {
                    ApplicationArea = All;
                    Caption = 'Create materials list', comment = 'ESP="Crear lista materiales"';
                }
            }
        }
    }

    procedure SetProductoOrigen(pCodProducto: Code[20])
    begin
        productoOrigen := pCodProducto;
    end;

    procedure GetDatos(var pNuevoCodProducto: code[20]; var pNuevaDescripcion: text[100]; var pCrearLista: Boolean)
    begin
        pNuevoCodProducto := codProducto;
        pNuevaDescripcion := descProducto;
        pCrearLista := crearListaMateriales;
    end;

    var
        codProducto: code[20];
        descProducto: Text[100];
        crearListaMateriales: Boolean;
        productoOrigen: code[20];
}