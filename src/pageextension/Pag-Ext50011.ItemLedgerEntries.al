pageextension 50011 "ItemLedgerEntries" extends "Item Ledger Entries"
{
    //Cantidad pendiente en mov producto

    layout
    {
        modify("Order No.")
        {
            Visible = true;
        }
        modify("Order Line No.")
        {
            Visible = true;
        }
        addafter("Entry Type")
        {
            field(ItemType; ItemType)
            {
                Editable = false;
            }
        }
        addafter("Document No.")
        {
            field("External Document No."; "External Document No.") { }
        }
        addafter("Reserved Quantity")
        {
            field(CantDisp; cantidadDisponible)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Available Quantity', comment = 'ESP="Cantidad disponible"';
                DecimalPlaces = 0 : 5;
            }
            field("Item Category Code"; "Item Category Code")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field(Desc2_btc; Desc2_btc)
            {
                ApplicationArea = All;
            }

            field(CodCliente_btc; CodCliente_btc)
            {
                ApplicationArea = All;
            }
            field(NombreCliente_btc; NombreCliente_btc)
            {
                ApplicationArea = All;
            }
            field("Source Type"; "Source Type")
            {
                ApplicationArea = all;
            }
            field("Source No."; "Source No.")
            {
                ApplicationArea = all;
            }
            field(VendorName; VendorName)
            {
                ApplicationArea = all;
                Caption = 'Vendor Name', comment = 'ESP="Nombre proveedor"';
                Editable = false;
            }
        }
        addbefore("Entry No.")
        {
            field(OrderNo; OrderNo)
            {
                ApplicationArea = all;
                Caption = 'Parent Order No.', comment = 'ESP="Nº Pedido ensamblado"';
                Editable = false;
            }
            field(ItemParentNo; ItemParentNo)
            {
                ApplicationArea = all;
                Caption = 'Parent Item No.', comment = 'ESP="Cód. producto ensamblado"';
                Editable = false;
            }
            field(OrderLineNo; OrderLineNo)
            {
                ApplicationArea = all;
                Caption = 'Parent Order Line No.', comment = 'ESP="Nº Línea Pedido ensamblado"';
                Editable = false;
            }
            field(CodEmpleado; CodEmpleado)
            {
                ApplicationArea = all;
                Caption = 'Cód. Empleado', comment = 'ESP="Cód. Empleado"';
            }
            field(IdUsuario; IdUsuario)
            {
                ApplicationArea = all;
                Caption = 'User Id.', comment = 'Id Uusario';
            }
        }
    }
    actions
    {
        addfirst(Reporting)
        {
            action("Imprimir Etiqueta")
            {
                ApplicationArea = all;
                Caption = 'Imprimir Etiqueta', comment = 'ESP="Imprimir Etiqueta"';
                ToolTip = 'Imprimir etiqueta', comment = 'ESP="Imprimir etiqueta"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = PrintReport;

                trigger OnAction()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    Selection: Integer;
                begin
                    Selection := STRMENU('1.-Expedición,2.-Embalaje,3.-Materia Prima,4.-Prod.Terminado', 1);
                    // Message(Format(Selection));
                    ItemLedgerEntry.Reset();
                    IF Selection > 0 THEN begin

                        ItemLedgerEntry.SetRange("Entry No.", Rec."Entry No.");
                        if ItemLedgerEntry.FindFirst() then
                            case Selection of
                                1:
                                    Report.Run(Report::EtiquetaDeExpedicion, false, false, ItemLedgerEntry);
                                2:
                                    Report.Run(Report::EtiquetaEmbalaje, false, false, ItemLedgerEntry);
                                3:
                                    Report.Run(Report::EtiquetaMateriaPrima, false, false, ItemLedgerEntry);
                                4:
                                    Report.Run(Report::EtiquetaProductoTerminado, false, false, ItemLedgerEntry);

                            end;


                    end;
                end;

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin
        // inicializamos variables ensamblado
        OrderNo := '';
        OrderLineNo := 0;
        ItemParentNo := '';

        CalcFields("Reserved Quantity");
        cantidadDisponible := "Remaining Quantity" - "Reserved Quantity";
        if Item.Get("Item No.") then;
        case "Entry Type" of
            "Entry Type"::Purchase:
                begin
                    if Vendor.Get(Rec."Source No.") then
                        VendorName := Vendor.Name;
                end;
            "Entry Type"::"Assembly Output", "Entry Type"::"Assembly Consumption":
                begin
                    // buscamos si es salida de ensamblado el pedido original
                    AssembleToOrderLink.reset;
                    AssembleToOrderLink.SetRange("Document Type", AssembleToOrderLink."Document Type"::"Sales Shipment");
                    AssembleToOrderLink.SetRange("Assembly Document No.", Rec."Document No.");
                    IF AssembleToOrderLink.FindSet() THEN begin
                        OrderNo := AssembleToOrderLink."Order No.";
                        OrderLineNo := AssembleToOrderLink."Order Line No.";
                        SalesShipmentLine.Reset();
                        if SalesShipmentLine.Get(AssembleToOrderLink."Document No.", AssembleToOrderLink."Document Line No.") then begin
                            ItemParentNo := SalesShipmentLine."No.";
                        end;
                    end;
                end;
            else
                VendorName := '';
        end;

        // 

        // obtener campo de la otra extension
        CodEmpleado := Funciones.GetExtensionFieldValuetext(Rec.RecordId, 50500, false);  // 50500  Cód. empleado
        ValueEntry.Reset();
        ValueEntry.SetRange("Item Ledger Entry No.", rec."Entry No.");
        if not ValueEntry.FindSet() then
            clear(ValueEntry);
        IdUsuario := ValueEntry."User ID";

    end;

    var
        Item: Record Item;
        SalesShipmentLine: Record "Sales Shipment Line";
        AssembleToOrderLink: Record "Posted Assemble-to-Order Link";
        WarehouseEntry: Record "Warehouse Entry";
        ValueEntry: Record "Value Entry";
        Funciones: Codeunit Funciones;
        cantidadDisponible: Decimal;
        CantidadAlmacen: Decimal;
        VendorName: Text;
        OrderNo: Code[20];
        ItemParentNo: code[20];
        OrderLineNo: Integer;
        CodEmpleado: text;
        IdUsuario: code[50];

}