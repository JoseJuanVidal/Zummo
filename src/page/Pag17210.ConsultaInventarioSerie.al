page 17210 "Consulta Inventario/Serie"
{
    Caption = 'Consulta de Inventario(Nº Serie)', comment = 'ESP="Consulta de inventario (Nº Serie)"';
    PageType = List;
    SourceTable = "Warehouse Entry";
    SourceTableTemporary = true;
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    Permissions = tabledata 7312 = rmid;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(ItemDesc1_btc; ItemDesc1_btc)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(ItemDesc2_btc; ItemDesc2_btc)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bin Code"; "Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Familia; recItem.desFamilia_btc)
                {
                    ApplicationArea = All;
                    Caption = 'Familia', Comment = 'ESP="Familia"';
                    Editable = false;
                }
                field("Reference No."; "Reference No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Cliente', comment = 'ESP="Cliente"';
                }
                field(NomCliente; NomCliente)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Nombre Cliente', comment = 'ESP="Nombre Cliente"';
                }
                field(NomAreaManager; NomAreaManager)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Area Manager', comment = 'ESP="Area Manager"';
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Registering Date"; "Registering Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Unitcost; recItem."Unit Cost")
                {
                    Caption = 'Unit cost', comment = 'ESP="Coste unitario"';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 2;
                }
                field("Source Document"; "Source Document")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Fecha_Fin_Contrato; "Fecha Fin Contrato")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        UpdateWhseEntry;
                    end;

                }
                field("Comentarios"; "Comentario")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        UpdateWhseEntry;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(MovAlmacen)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = New;
                Image = BinLedger;
                Caption = 'Warehouse entry', comment = 'ESP="Movs. Almacén"';
                ToolTip = 'It shows the list of warehouse entries associated with that Product, Serial No., Lot No. ...',
                    comment = 'ESP="Muestra la lista de movimientos de almacén asociados a ese Producto, Nº serie, Nº Lote..."';

                trigger OnAction()
                var
                    recWhseEntries: Record "Warehouse Entry";
                begin
                    recWhseEntries.Reset();
                    recWhseEntries.SetRange("Item No.", "Item No.");
                    recWhseEntries.SetRange("Lot No.", "Lot No.");
                    recWhseEntries.SetRange("Serial No.", "Serial No.");
                    recWhseEntries.SetRange("Location Code", "Location Code");
                    recWhseEntries.SetRange("Bin Code", "Bin Code");

                    page.RunModal(Page::"Warehouse Entries", recWhseEntries);
                end;
            }

            action(MovProducto)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = New;
                Image = ItemLedger;
                Caption = 'Item ledger entry', comment = 'ESP="Movs. Producto"';
                ToolTip = 'It shows the list of item ledger entries associated with that Product, Serial No., Lot No. ...',
                    comment = 'ESP="Muestra la lista de movimientos de producto asociados a ese Producto, Nº serie, Nº Lote..."';

                trigger OnAction()
                var
                    recItemLedgEntry: Record "Item Ledger Entry";
                begin
                    recItemLedgEntry.Reset();
                    recItemLedgEntry.SetRange("Item No.", "Item No.");
                    recItemLedgEntry.SetRange("Lot No.", "Lot No.");
                    recItemLedgEntry.SetRange("Serial No.", "Serial No.");
                    recItemLedgEntry.SetRange("Location Code", "Location Code");

                    Page.RunModal(Page::"Item Ledger Entries", recItemLedgEntry);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF NOT recItem.GET("Item No.") THEN CLEAR(recItem);
        recItem.CalcFields(desFamilia_btc);

        // obtenemos campo de descripción familia
        //familia := Funciones.GetExtensionFieldValuetext(recItem.RecordId, 50021, true);   // Desc Familia  021        

        NomCliente := '';
        NomAreaManager := '';
        if Customer.Get("Reference No.") then begin
            NomCliente := Customer.Name;
            NomAreaManager := Customer.AreaManager_btc;
        end;
    end;

    trigger OnOpenPage()
    begin
        SetPageData();
    end;

    var
        WhseEntry: Record "Warehouse Entry";
        Customer: Record Customer;
        LotInventory: Query "Consulta Stocks";
        Funciones: Codeunit Funciones;
        TransferReceiptHeader: Record "Transfer Receipt Header";
        Cont: Integer;
        recItem: Record "Item";
        globalAlmacen: Code[20];
        globalUbicacion: Code[20];
        globalProducto: Code[20];
        globalSerie: Code[20];
        CodCliente: code[20];
        NomCliente: text;
        NomAreaManager: text;
        Ventana: Dialog;
        msgVentana: Label 'Almacén:#1###########\Producto #2##############';

    local procedure SetPageData()
    begin
        if globalAlmacen <> '' then
            LotInventory.SetFilter(LotInventory.FiltroAlmacen, globalAlmacen);
        if globalUbicacion <> '' then
            LotInventory.SetFilter(LotInventory.FiltroUbicacion, globalUbicacion);
        if globalProducto <> '' then
            LotInventory.SetFilter(LotInventory.FiltroItemNo, globalProducto);
        if globalSerie <> '' then
            LotInventory.SetFilter(LotInventory.FiltroSerialNo, globalSerie);

        LotInventory.OPEN;
        WHILE LotInventory.READ DO BEGIN
            Cont += 1;
            "Entry No." := Cont;  //LotInventory.Entry_No_;
            "Item No." := LotInventory.Item_No;
            "Serial No." := LotInventory.SerialNo;
            "Variant Code" := LotInventory.Variant_Code;
            "Lot No." := LotInventory.Lote;
            "Location Code" := LotInventory.Almacen;
            "Bin Code" := LotInventory.Ubicacion;
            Quantity := LotInventory.Cantidad;
            // buscamos el movimiento
            WhseEntry.SetRange("Item No.", LotInventory.Item_No);
            WhseEntry.SetRange("Serial No.", LotInventory.SerialNo);
            WhseEntry.SetRange("Variant Code", LotInventory.Variant_Code);
            WhseEntry.SetRange("Lot No.", LotInventory.Lote);
            WhseEntry.SetRange("Location Code", LotInventory.Almacen);
            WhseEntry.SetRange("Bin Code", LotInventory.Ubicacion);
            if not WhseEntry.FindSet() then
                clear(WhseEntry);
            "Registering Date" := WhseEntry."Registering Date";
            "Fecha Fin Contrato" := WhseEntry."Fecha Fin Contrato";
            "Comentario" := WhseEntry.Comentario;
            "Source Document" := WhseEntry."Source Document";
            "Source No." := WhseEntry."Source No.";
            "Source Type" := WhseEntry."Source Type";
            "Source Subtype" := WhseEntry."Source Subtype";
            "Source Line No." := WhseEntry."Source Line No.";
            // Cod. Cliente que esta en la cabecera de recepcion  
            CodCliente := '';
            case "Source Type" of
                5741:
                    begin
                        TransferReceiptHeader.SetRange("Transfer Order No.", "Source No.");
                        if TransferReceiptHeader.FindSet() then
                            CodCliente := Funciones.GetExtensionFieldValuetext(TransferReceiptHeader.RecordId, 50600, false);   // Desc Familia  021        
                    end;
            end;
            "Reference No." := CodCliente;
            IF Quantity <> 0 THEN
                INSERT();
        END;

        FINDFIRST();
    end;

    procedure SetAlmacen(pAlmacen: Code[20])
    begin
        globalAlmacen := pAlmacen;
    end;

    procedure SetUbicacion(pUbicacion: Code[20])
    begin
        globalUbicacion := pUbicacion;
    end;

    procedure SetProducto(pProducto: Code[20])
    begin
        globalProducto := pProducto;
    end;

    procedure SetSerie(pSerie: Code[20])
    begin
        globalSerie := pSerie;
    end;

    local procedure UpdateWhseEntry()
    begin
        WhseEntry.SetRange("Item No.", "Item No.");
        WhseEntry.SetRange("Serial No.", "Serial No.");
        WhseEntry.SetRange("Variant Code", "Variant Code");
        WhseEntry.SetRange("Lot No.", "Lot No.");
        WhseEntry.SetRange("Location Code", "Location Code");
        WhseEntry.SetRange("Bin Code", "Bin Code");
        if WhseEntry.FindSet() then begin
            WhseEntry."Fecha Fin Contrato" := "Fecha Fin Contrato";
            WhseEntry.Comentario := Comentario;
            WhseEntry.Modify();
        end
    end;
}
