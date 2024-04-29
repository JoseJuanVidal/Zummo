pageextension 50152 "SalesOrderSubform" extends "Sales Order Subform"
{

    layout
    {
        modify("No.")
        {
            StyleExpr = txtStyleExprUnitPrice;

            trigger OnAfterValidate()
            begin
                GetSalesPrices();
                CurrPage.Update();
            end;
        }
        modify("Unit Price")
        {
            StyleExpr = txtStyleExprUnitPrice;
            Enabled = Not ExistSalesPrice;
            Editable = Not ExistSalesPrice;
        }
        modify("Line Amount")
        {
            Enabled = Not ExistSalesPrice;
            Editable = Not ExistSalesPrice;
        }
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
            field(DtoPendingApproval; DtoPendingApproval)
            {
                ApplicationArea = all;
            }
        }

        addafter("Unit Price")
        {
            field("DecLine Discount1 %_btc"; "DecLine Discount1 %_btc")
            {
                ApplicationArea = all;
                Style = Unfavorable;
                StyleExpr = DtoPendingApproval;

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("DecLine Discount2 %_btc"; "DecLine Discount2 %_btc")
            {
                ApplicationArea = all;
                Style = Unfavorable;
                StyleExpr = DtoPendingApproval;

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field(DiscountApprovalStatus; DiscountApprovalStatus)
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
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
                StyleExpr = StyleExpBloqueado;
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
            Style = Unfavorable;
            StyleExpr = DtoPendingApproval;
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
            field(PricesApprovalStatus; PricesApprovalStatus)
            {
                ApplicationArea = all;
            }
            field(Promociones; Promociones)
            {
                ApplicationArea = all;
            }
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
                Editable = false;
            }
            field(Comprometido; Comprometido)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(Disponible; Disponible)
            {
                ApplicationArea = All;
                Editable = false;
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
        addafter(ExplodeBOM_Functions)
        {
            action(ExplodeProdBOM)
            {
                ApplicationArea = all;
                Caption = 'Desplegar Componentes', comment = 'ESP="Desplegar Componentes"';

                trigger OnAction()
                begin
                    Action_ExplodeProdBOM();
                end;
            }
        }
    }

    var
        Funciones: Codeunit SalesEvents;
        ExistSalesPrice: Boolean;
        EnStock: Decimal;
        Comprometido: Decimal;
        Disponible: Decimal;
        txtBloqueado: Text;
        StyleExpBloqueado: Text;
        txtStyleExprUnitPrice: text;
        DtoPendingApproval: Boolean;

    trigger OnAfterGetRecord()
    var
        recItem: Record Item;
        cduSalesEvents: Codeunit SalesEvents;
    begin
        txtBloqueado := '';
        txtStyleExprUnitPrice := '';
        StyleExpBloqueado := '';

        if type = Type::Item then begin
            clear(cduSalesEvents);
            txtBloqueado := cduSalesEvents.GetTipoBloqueoProducto("No.", StyleExpBloqueado);
        end;

        if Rec.SinPrecioTarifa then
            txtStyleExprUnitPrice := 'Unfavorable';

        EnStock := 0;
        Disponible := 0;
        Comprometido := 0;


        // ponemos en rojo el descuento
        DtoPendingApproval := Rec.DiscountApprovalStatus in [Rec.DiscountApprovalStatus::Pending, Rec.DiscountApprovalStatus::Reject];


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

    trigger OnAfterGetCurrRecord()
    begin
        // miramos si tienes precios y bloqueamos precio
        GetSalesPrices();

    end;

    local procedure Action_ExplodeProdBOM()
    begin
        Funciones.Action_ExplodeProdBOM(Rec);
    end;

    local procedure GetSalesPrices()
    begin
        ExistSalesPrice := false;
        if not (Rec.Type in [Rec.Type::Item]) then
            exit;
        ExistSalesPrice := Funciones.CheckSalesPriceItemNo(Rec);
    end;
}