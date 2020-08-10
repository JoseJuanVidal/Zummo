page 50101 "MatarRestosCompras"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Line";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Navigate', Comment = 'ESP="Nuevo,Procesar,Informe,Navegar"';

    SourceTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending)
        WHERE(
            "Document Type" = CONST(Order),
            "Outstanding Quantity" = FILTER(<> 0),
            Type = filter(<> " ")
        );

    Caption = 'Kill purchase orders remains', comment = 'ESP="Matar restos pedidos compra"';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }

                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }

                field(txtNombreProveedor; txtNombreProveedor)
                {
                    Caption = 'Vendor Name', comment = 'ESP="Nombre Proveedor"';
                    ApplicationArea = All;
                }

                field(Type; Type)
                {
                    ApplicationArea = All;
                }

                field("No."; "No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Description)
                {
                    ApplicationArea = All;
                }

                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }

                field("Bin Code"; "Bin Code")
                {
                    ApplicationArea = All;
                }

                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }

                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }

                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                    ApplicationArea = All;
                }

                field("Qty. to Receive"; "Qty. to Receive")
                {
                    ApplicationArea = All;
                }

                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = All;
                }

                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MatarResto)
            {
                ApplicationArea = All;
                Image = FaultDefault;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Kill rest', comment = 'ESP="Matar resto"';
                ToolTip = 'Change the original quantity of the order line so that it does not appear as pending',
                    comment = 'ESP="Cambia la cantidad original de la línea del pedido para que no aparezca como pendiente"';

                trigger OnAction();
                var
                    recPurchHeader: record "Purchase Header";
                    ReleasePurchDoc: Codeunit "Release Purchase Document";
                    lbConfirmQst: Label 'Are you sure you want to kill the rest?',
                        comment = 'ESP="¿Está seguro/a de que desea matar el resto?"';
                    lbErrorCantidadErr: Label 'If the quantity received is greater than the original quantity, you must do this process from the shipment',
                        comment = 'ESP="Si la cantidad recibida es mayor a la cantidad original, debe hacer este proceso desde el envío"';
                    lbConfirmLinRecepcionQst: Label 'There are warehouse receipt lines associated with this line item. Do you want to delete the receipt lines?',
                        comment = 'ESP="Existen líneas de recepción de almacén asociadas a esta línea de pedido ¿Desea borrar las líneas de recepción?"';
                    lbErrorCancelarErr: Label 'Process canceled, no warehouse receipt line has been deleted or any quantity has been killed in the purchase order.',
                        comment = 'ESP="Proceso cancelado, no se ha borrado ninguna línea de recepción de almacén ni se ha matado ninguna cantidad en el pedido de compra."';
                begin
                    if not Confirm(lbConfirmQst) then
                        exit;

                    if "Quantity Received" > Quantity then
                        Error(lbErrorCantidadErr);

                    if GetExisteLinRecepcion() then
                        if not Confirm(lbConfirmLinRecepcionQst) then
                            error(lbErrorCancelarErr)
                        else
                            BorrarLinRecepcionAlmacen();

                    recPurchHeader.Reset();
                    recPurchHeader.SetRange("Document Type", "Document Type");
                    recPurchHeader.SetRange("No.", "Document No.");
                    recPurchHeader.FindFirst();

                    Rec.PermitirMatarResto := true;

                    if recPurchHeader.Status = recPurchHeader.Status::Open then begin
                        Validate(Quantity, "Quantity Received");
                        if Modify() then;
                    end else begin
                        clear(ReleasePurchDoc);
                        ReleasePurchDoc.PerformManualReopen(recPurchHeader);

                        Validate(Quantity, "Quantity Received");
                        if Modify() then;

                        clear(ReleasePurchDoc);
                        ReleasePurchDoc.PerformManualRelease(recPurchHeader);
                    end;

                    Rec.PermitirMatarResto := false;
                end;
            }
        }

        area(Navigation)
        {
            action(MostrarDocOrigen)
            {
                ApplicationArea = All;
                Image = Document;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                Caption = 'Show order', comment = 'ESP="Mostrar pedido"';
                ToolTip = 'Show original purchase order', comment = 'ESP="Muestra el pedido de compra original"';
                RunObject = Page "Purchase Order";
                RunPageLink = "Document Type" = field("Document Type"), "No." = field("Document No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterGroup(2);

        setrange("Document Type", "Document Type"::Order);
        SetFilter("Outstanding Quantity", '<>%1', 0);
        SetFilter(Type, '<>%1', Type::" ");
        SetFilter("Quantity Received", '<>%1', 0);

        FilterGroup(0);
    end;

    trigger OnAfterGetRecord()
    var
        recVendor: Record Vendor;
    begin
        txtNombreProveedor := '';

        if recVendor.get("Buy-from Vendor No.") then
            txtNombreProveedor := recVendor.Name;
    end;

    local procedure BorrarLinRecepcionAlmacen()
    var
        recWhseReceiptLine: Record "Warehouse Receipt Line";
        recWhseReceiptHeader: Record "Warehouse Receipt Header";
        recWhseReceiptLineAux: Record "Warehouse Receipt Line";
        intLineaBorrar: Integer;
    begin
        recWhseReceiptLine.Reset();
        recWhseReceiptLine.SetRange("Source Type", 39);
        recWhseReceiptLine.SetRange("Source Subtype", recWhseReceiptLine."Source Subtype"::"1");
        recWhseReceiptLine.SetRange("Source No.", "Document No.");
        recWhseReceiptLine.SetRange("Source Line No.", "Line No.");
        if recWhseReceiptLine.FindFirst() then begin
            intLineaBorrar := recWhseReceiptLine."Line No.";

            recWhseReceiptHeader.Get(recWhseReceiptLine."No.");

            recWhseReceiptLine.Delete();

            recWhseReceiptLineAux.Reset();
            recWhseReceiptLineAux.SetRange("No.", recWhseReceiptHeader."No.");
            recWhseReceiptLineAux.SetFilter("Line No.", '<>%1', intLineaBorrar);
            if not recWhseReceiptLineAux.FindFirst() then begin
                recWhseReceiptHeader.DeleteRelatedLines(false);
                recWhseReceiptHeader.Delete();
            end;
        end;
    end;

    local procedure GetExisteLinRecepcion(): Boolean
    var
        recWhseReceiptLine: Record "Warehouse Receipt Line";
    begin
        recWhseReceiptLine.Reset();
        recWhseReceiptLine.SetRange("Source Type", 39);
        recWhseReceiptLine.SetRange("Source Subtype", recWhseReceiptLine."Source Subtype"::"1");
        recWhseReceiptLine.SetRange("Source No.", "Document No.");
        recWhseReceiptLine.SetRange("Source Line No.", "Line No.");
        if recWhseReceiptLine.FindFirst() then
            exit(true);

        exit(false);
    end;

    var
        txtNombreProveedor: Text;
}