pageextension 50106 "PurchaseOrderSubform" extends "Purchase Order Subform"
{
    layout
    {
        modify("Direct Unit Cost")
        {
            Editable = not EditContract;
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
            field("Contracts No."; "Contracts No.")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;

                trigger OnAssistEdit()
                begin
                    OnAssistEdit_ContractsNo();
                end;

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

            action(DuplicateLine)
            {
                ApplicationArea = All;
                Caption = 'Duplicate line', comment = 'ESP="Duplicar línea"';
                ToolTip = 'Navigate to product lines', comment = 'ESP="Navega a las líneas de producto"';
                Image = CheckDuplicates;

                trigger OnAction()
                begin
                    DuplicateLineAction;
                end;
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
        addafter(OrderTracking)
        {
            action(AssignContract)
            {
                ApplicationArea = all;
                Caption = 'Asignar Contrato', comment = 'ESP="Asignar Contrato"';
                Image = ContractPayment;

                trigger OnAction()
                begin
                    OnAction_AssignContract();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EditContract := (Rec."Contracts No." <> '') and ("Contracts Line No." <> 0);
    end;

    var
        Funciones: Codeunit Funciones;
        EditContract: Boolean;

    local procedure DuplicateLineAction()
    var
        PurchaseLine: Record "Purchase Line";
        lblConfirm: Label '¿Would you like to duplicate the Line %1 quantity %2 ?', comment = 'ESP="¿Desea duplicar la Línea %1 Cantidad %2?"';

    begin
        if not Confirm(lblConfirm, false, Rec.Description, Rec.Quantity) then
            exit;
        PurchaseLine.Init();
        PurchaseLine.TransferFields(Rec);
        PurchaseLine."Line No." := Rec."Line No." + 10;
        PurchaseLine."Quantity Received" := 0;
        PurchaseLine."Quantity Invoiced" := 0;
        PurchaseLine."Qty. Invoiced (Base)" := 0;
        PurchaseLine."Qty. Received (Base)" := 0;
        PurchaseLine.Validate(Quantity, Rec.Quantity);
        PurchaseLine.Insert()
    end;

    local procedure OnAction_AssignContract()
    begin
        Funciones.OnActionAssignContract(Rec, true);
        CurrPage.Update();
    end;

    local procedure OnAssistEdit_ContractsNo()
    var
        ContractsSuppliesHeader: record "ZM Contracts/Supplies Header";
        ContractsSupliesList: page "ZM Contracts Suplies List";
    begin
        if "Contracts No." = '' then
            OnAction_AssignContract()
        else begin
            // lista de contrato asignado
            ContractsSuppliesHeader.SetRange("No.", Rec."Contracts No.");
            ContractsSupliesList.RunModal();
        end;
    end;
}