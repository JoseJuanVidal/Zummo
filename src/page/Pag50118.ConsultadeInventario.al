page 50118 "Consulta de Inventario"

{
    PageType = List;
    SourceTable = "Warehouse Entry";
    SourceTableTemporary = true;
    UsageCategory = Administration;
    ApplicationArea = all;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    Caption = 'Consulta Inventario';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }

                field(ItemDesc1_btc; ItemDesc1_btc)
                {
                    ApplicationArea = All;
                }

                field(ItemDesc2_btc; ItemDesc2_btc)
                {
                    ApplicationArea = All;
                }

                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; "Serial No.")
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
                field("Registering Date"; "Registering Date")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
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
    end;

    trigger OnOpenPage()
    begin
        SetPageData();
    end;

    var
        LotInventory: Query "Consulta Stocks"; 


        Cont: Integer;
        recItem: Record "Item";
        globalAlmacen: Code[20];
        globalUbicacion: Code[20];

        globalProducto: Code[20];
        globalSerie: Code[20];

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
            "Entry No." := Cont;
            "Item No." := LotInventory.Item_No;
            "Serial No." := LotInventory.SerialNo;
            "Variant Code" := LotInventory.Variant_Code;
            "Lot No." := LotInventory.Lote;
            "Location Code" := LotInventory.Almacen;
            "Bin Code" := LotInventory.Ubicacion;
            Quantity := LotInventory.Cantidad;
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
}
