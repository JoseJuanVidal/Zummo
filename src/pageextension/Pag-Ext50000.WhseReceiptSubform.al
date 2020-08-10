pageextension 50000 "WhseReceiptSubform" extends "Whse. Receipt Subform"
{
    //Nuevos campos recepción almacén

    layout
    {
        addafter("Qty. Outstanding")
        {
            field(Precio; globalPrecio)
            {
                Editable = false;
                ApplicationArea = all;
                Caption = 'Unit Cost', comment = 'ESP="Coste Unitario"';
            }

            field(Descuento; globalDescuento)
            {
                Editable = false;
                ApplicationArea = all;
                Caption = 'Line Discount Amount', comment = 'ESP="Importe dto. Línea"';
            }

            field(ImporteLinea; globalImporteLinea)
            {
                Editable = false;
                ApplicationArea = all;
                Caption = 'Line Amount', comment = 'ESP="Importe línea"';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recPurchLine: Record "Purchase Line";
    begin
        globalPrecio := 0;
        globalDescuento := 0;
        globalImporteLinea := 0;

        if recPurchLine.get("Source Subtype", "Source No.", "Source Line No.") then begin
            globalPrecio := recPurchLine."Unit Cost";
            globalDescuento := recPurchLine."Line Discount Amount";
            globalImporteLinea := recPurchLine."Line Amount";
        end;
    end;

    var
        globalPrecio: Decimal;
        globalDescuento: Decimal;
        globalImporteLinea: Decimal;
}