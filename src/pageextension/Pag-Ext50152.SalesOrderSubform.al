pageextension 50152 "SalesOrderSubform" extends "Sales Order Subform"
{

    layout
    {
        addafter("Line Amount")
        {
            //231219 S19/01434 Mostar iva en compras y ventas
            field("VAT %"; "VAT %")
            {
                ApplicationArea = All;
            }

            //231219 S19/01434 Mostar iva en compras y ventas
            field("VAT Identifier"; "VAT Identifier")
            {
                ApplicationArea = All;
            }
        }

        addafter("Unit Price")
        {
            field("DecLine Discount1 %_btc"; "DecLine Discount1 %_btc")
            {
                ApplicationArea = all;
            }
            field("DecLine Discount2 %_btc"; "DecLine Discount2 %_btc")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Tariff No_btc"; "Tariff No_btc")
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

        //INICIO FJAB 121219 S19/01403 Fechas pedido venta
        modify("Shipment Date")
        {
            Visible = true;
        }

        modify("Requested Delivery Date")
        {
            Visible = true;
        }

        modify("Promised Delivery Date")
        {
            Visible = true;
        }

        addafter("Shipment Date")
        {
            field(FechaAlta_btc; FechaAlta_btc)
            {
                ApplicationArea = all;
            }
        }
        //FIN FJAB 121219 S19/01403 Fechas pedido venta

        modify("Line Discount %")
        {
            Enabled = false;
            //Editable = false;
            //Visible = false;
        }

        addafter(Description)
        {
            field(TieneComentarios_btc; TieneComentarios_btc)
            {
                ApplicationArea = all;
            }
        }

        addafter("Line Amount")
        {
            //111219 S19/01395 Motivos retraso
            field(MotivoRetraso_btc; MotivoRetraso_btc)
            {
                ApplicationArea = All;
            }

            //111219 S19/01395 Motivos retraso
            field(TextoMotivoRetraso_btc; TextoMotivoRetraso_btc)
            {
                ApplicationArea = all;
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

        }
    }


    // 161219 S19/01406 Abrir ficha producto 
    actions
    {
        addbefore("Reservation Entries")
        {
            action(GoToFichaProd)
            {
                ApplicationArea = All;
                Caption = 'Item Card', comment = 'ESP="Ficha producto"';
                ToolTip = 'Navigates to item card', comment = 'ESP="Navega a la ficha del producto"';
                Image = Item;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("No.");
            }
        }
        addafter(Reserve)
        {
            action(CalcItemCost)
            {
                Caption = 'Act. Coste Unitario', comment = 'ESP="Act. Coste Unitario"';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    Rec.GetUnitCost();
                    Rec.Modify();
                end;
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