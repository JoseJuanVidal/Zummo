pageextension 50141 "SalesQuoteSubform" extends "Sales Quote Subform"
{
    layout
    {

        addafter("Line Amount")
        {
            field("Line No."; "Line No.")
            { }
            //231219 S19/01434 Mostar iva en compras y ventas
            field("VAT %"; "VAT %")
            {
                ApplicationArea = All;
            }

            //Mostar iva en compras y ventas
            field("VAT Identifier"; "VAT Identifier")
            {
                ApplicationArea = All;
            }
        }

        addafter("Line Discount %")
        {

            field("DecLine Discount1 %_btc"; "DecLine Discount1 %_btc")
            {
                ApplicationArea = All;
            }

            field("DecLine Discount2 %_btc"; "DecLine Discount2 %_btc")
            {
                ApplicationArea = All;
            }

            field(EnStock; EnStock)
            {
                ApplicationArea = All;
            }
            field(Comprometido; Comprometido)
            {
                ApplicationArea = All;
            }
            field(Disponible; Disponible)
            {
                ApplicationArea = All;
            }
            field("No contemplar planificacion"; "No contemplar planificacion")
            {
                ApplicationArea = all;
            }

        }

        addafter("No.")
        {
            field(txtBloqueado; txtBloqueado)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Blocked', comment = 'ESP="Bloqueado"';
            }
        }
    }
    var
        EnStock: Decimal;
        Comprometido: Decimal;
        Disponible: Decimal;
        txtBloqueado: Text;

    trigger OnAfterGetRecord()
    var
        recItem: Record Item;
        cduSalesEvents: Codeunit SalesEvents;
    begin
        txtBloqueado := '';

        if type = Type::Item then begin
            clear(cduSalesEvents);
            txtBloqueado := cduSalesEvents.GetTipoBloqueoProducto("No.");
        end;

        EnStock := 0;
        Disponible := 0;
        Comprometido := 0;

        IF NOT (Rec.Type = Rec.Type::Item) THEN
            EXIT;

        recItem.Reset();
        recItem.SetRange("No.", "No.");
        recItem.SetRange("Location Filter", "Location Code");
        recItem.SetRange("Variant Filter", "Variant Code");
        //recItem.SetRange("Date Filter", "Starting Date", "Ending Date");
        if not recItem.FindFirst() then
            EXIT;

        recItem.CalcFields(Inventory);
        recItem.CalcFields("Qty. on Purch. Order");
        recItem.CalcFields("Qty. on Prod. Order");
        recItem.CalcFields("Res. Qty. on Inbound Transfer");
        recItem.CalcFields("Qty. on Sales Return");

        recItem.CalcFields("Qty. on Sales Order");
        recItem.CalcFields("Qty. on Component Lines");
        recItem.CalcFields("Res. Qty. on Outbound Transfer");
        recItem.CalcFields("Qty. on Purch. Return");
        recItem.CalcFields("Qty. on Asm. Component");

        EnStock := recItem.Inventory;

        Disponible := (recItem.Inventory + recItem."Qty. on Purch. Order" + recItem."Qty. on Prod. Order" + recItem."Res. Qty. on Inbound Transfer" + recItem."Qty. on Sales Return") -
        (recItem."Qty. on Sales Order" + recItem."Qty. on Asm. Component" + recItem."Qty. on Component Lines" + recItem."Res. Qty. on Outbound Transfer" + recItem."Qty. on Purch. Return");

        Comprometido := (recItem."Qty. on Sales Order" + recItem."Qty. on Asm. Component" + recItem."Qty. on Component Lines" + recItem."Res. Qty. on Outbound Transfer" + recItem."Qty. on Purch. Return");


    end;
}