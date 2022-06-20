pageextension 50106 "PurchaseOrderSubform" extends "Purchase Order Subform"
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

            field(FechaRechazo_btc; FechaRechazo_btc)
            {
                ApplicationArea = All;
            }

            field(TextoRechazo; TextoRechazo)
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Unit Cost")
        {
            field(StandarCost; StandarCost)
            {
                ApplicationArea = all;
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

        addafter(SelectMultiItems)
        {
            action(SeleccionarArticulosProveedor)
            {
                ApplicationArea = All;
                Caption = 'SeleccionarArticulosProveedor', comment = 'ESP="SeleccionarArticulosProveedor"';
                ToolTip = 'SeleccionarArticulosProveedor', comment = 'ESP="SeleccionarArticulosProveedor"';
                Image = Select;
                trigger OnAction()
                var
                    Item: Record Item;
                    ItemListPage: Page "Item List";
                    NewPurchLine: Record "Purchase Line";
                    PurchaseHeader: Record "Purchase Header";
                    PurchLine: Record "Purchase Line";
                    SelectionFilter: text;
                begin
                    PurchaseHeader.SetRange("No.", NewPurchLine."Document No.");
                    PurchaseHeader.FindFirst();
                    Item.SETRANGE(Blocked, FALSE);
                    Item.SetRange("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                    ItemListPage.SETTABLEVIEW(Item);
                    ItemListPage.LOOKUPMODE(TRUE);
                    IF ItemListPage.RUNMODAL = ACTION::LookupOK THEN begin
                        SelectionFilter := ItemListPage.GetSelectionFilter;
                        NewPurchLine.COPY(Rec);
                        PurchLine.SETRANGE("Document Type", NewPurchLine."Document Type");
                        PurchLine.SETRANGE("Document No.", NewPurchLine."Document No.");
                        IF PurchLine.FINDLAST THEN
                            NewPurchLine."Line No." := PurchLine."Line No."
                        ELSE
                            NewPurchLine."Line No." := 0;
                        Item.SETFILTER("No.", SelectionFilter);
                        IF Item.FINDSET THEN
                            REPEAT
                                PurchLine.INIT;
                                PurchLine."Line No." += 10000;
                                PurchLine.VALIDATE(Type, Type::Item);
                                PurchLine.VALIDATE("No.", Item."No.");
                                PurchLine.INSERT(TRUE);
                            UNTIL Item.NEXT = 0;

                    end;
                end;
            }
        }
    }
}