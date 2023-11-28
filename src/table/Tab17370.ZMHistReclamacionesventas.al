table 17370 "ZM Hist. Reclamaciones ventas"
{
    DataClassification = CustomerContent;
    Caption = 'Hist. Reclamaciones ventas', comment = 'ESP="Hist. Reclamaciones ventas"';
    DrillDownPageId = "Hist. Reclamaciones ventas";
    LookupPageId = "Hist. Reclamaciones ventas";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.', comment = 'ESP=Nº Movimiento"';
            AutoIncrement = true;
        }
        field(2; Type; Option)
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
            OptionMembers = Ventas,"Pedidos Servicio";
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.', comment = 'ESP="Nº Documento"';
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', comment = 'ESP="Nº Linea"';
            Editable = false;
        }
        field(5; "Serial No."; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.', comment = 'ESP="Nº serie"';
        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha Registro"';
        }
        field(7; "Item No."; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. producto"';

        }
        field(8; "Cod. Categoria"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Cod. Categoria', comment = 'ESP="Cód. Categoria"';
        }
        field(9; "Familia"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Familia', comment = 'ESP="Familia"';
        }
        field(10; "Customer No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.', comment = 'ESP="Cód. Cliente"';
        }
        field(11; "Country"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country', comment = 'ESP="País"';
        }
        field(12; "Grupo Clientes"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Grupo Clientes', comment = 'ESP="Grupo Clientes"';
        }
        field(15; "Sales Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Venta', comment = 'ESP="Fecha Venta"';
        }
        field(20; "Fallo localizado"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Fallo localizado', comment = 'ESP="Fallo localizado"';
        }
        field(21; "Incidencia"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Incidencia', comment = 'ESP="Incidencia"';
        }
        field(22; "Cantidad Ventas"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cantidad Ventas', comment = 'ESP="Cantidad Ventas"';
        }
        field(23; "Tipo Reclamaciones"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Tipo Reclamaciones', comment = 'ESP="Tipo Reclamaciones"';
        }
        field(24; "Fallo"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Fallo', comment = 'ESP="Fallo"';
        }

        field(25; "ALERTA CLD"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'ALERTA CLD', comment = 'ESP="ALERTA CLD"';
        }
        field(26; "Clasif Ventas"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cód. Clasif Ventas', comment = 'ESP="Cód. Clasif Ventas"';
        }
        field(27; "Des Clasif Ventas"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Clasif Ventas', comment = 'ESP="Clasif Ventas"';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.", "Serial No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        Item: Record Item;

    procedure CreateHistReclamaciones(InitDate: Date)
    var
        Item: Record Item;
        Customer: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesInvoiceLine: Record "Sales Invoice Line";
        ServiceHeader: Record "Service Header";
        ServiceItem: Record "Service Item";
        ServiceItemLine: Record "Service Item Line";
        ServiceOrderType: Record "Service Order Type";
        SalesDate: date;
        Window: Dialog;
    begin
        // buscamos los movimientos de ventas y abonos de tipo productos y ensamblados
        Window.Open('Nº Mov: #1###############\Tipo: #2#####################\Producto: #3#############################\Fecha: #4##############');
        ItemLedgerEntry.Reset();
        if InitDate <> 0D then
            ItemLedgerEntry.SetFilter("Posting Date", '%1..', InitDate);
        ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::Sale, ItemLedgerEntry."Entry Type"::"Assembly Consumption");
        if ItemLedgerEntry.FindFirst() then
            repeat
                Window.Update(1, ItemLedgerEntry."Entry No.");
                Window.Update(2, ItemLedgerEntry."Entry Type");
                Window.Update(3, ItemLedgerEntry."Item No.");
                Window.Update(4, ItemLedgerEntry."Posting Date");
                if Item.Get(ItemLedgerEntry."Item No.") and not item.IsAssemblyItem() then begin
                    item.CalcFields(desFamilia_btc);
                    if Customer.Get(ItemLedgerEntry."Source No.") then;

                    AddHistReclamacionesventas(ItemLedgerEntry, Item, Customer)

                end;
            Until ItemLedgerEntry.next() = 0;
        // ahora buscamos los abonos de ensamblado que son tipo ajustes positivos
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::"Positive Adjmt.");
        if ItemLedgerEntry.FindFirst() then
            repeat
                Window.Update(1, ItemLedgerEntry."Entry No.");
                Window.Update(2, ItemLedgerEntry."Entry Type");
                Window.Update(3, ItemLedgerEntry."Item No.");
                Window.Update(4, ItemLedgerEntry."Posting Date");
                if Item.Get(ItemLedgerEntry."Item No.") and not item.IsAssemblyItem() then begin
                    item.CalcFields(desFamilia_btc);
                    if Customer.Get(ItemLedgerEntry."Source No.") then;

                    if copystr(ItemLedgerEntry."Document No.", 1, 4) = 'PENS' then
                        AddHistReclamacionesventas(ItemLedgerEntry, Item, Customer)

                end;
            Until ItemLedgerEntry.next() = 0;
        // recorremos las lineas de servicio para añadir los fallos o reclamaciones
        ServiceHeader.Reset();
        ServiceHeader.SetRange("Document Type", ServiceHeader."Document Type"::Order);
        ServiceHeader.SetFilter("Posting Date", '%1..', InitDate);
        if ServiceHeader.FindFirst() then
            repeat
                if ServiceOrderType.Get(ServiceHeader."Service Order Type") and (ServiceOrderType."Exportar BI Reclamaciones") then begin
                    ServiceItemLine.Reset();
                    ServiceItemLine.SetRange("Document Type", ServiceHeader."Document Type");
                    ServiceItemLine.SetRange("Document No.", ServiceHeader."No.");
                    if ServiceItemLine.FindFirst() then begin
                        //repeat
                        if Item.Get(ServiceItemLine."Item No.") and not item.IsAssemblyItem() then begin
                            if ServiceItem.Get(ServiceItemLine."Service Item No.") then
                                SalesDate := ServiceItem."Sales Date"
                            else
                                SalesDate := GetFechaSalesOrderServiceHeader(ServiceHeader);

                            AddHistReclamacionesventasService(ServiceHeader, ServiceItemLine, Item, ServiceItem."Serial No.", SalesDate);
                        end;
                        // Until ServiceItemLine.next() = 0;
                    end;
                end;
            Until ServiceHeader.next() = 0;

    end;

    local procedure GetFechaSalesOrderServiceHeader(ServiceHeader: Record "Service Header"): Date
    var
        Funciones: Codeunit Funciones;
    begin
        exit(Funciones.GetExtensionFieldValueDate(ServiceHeader.RecordId, 50607, false));
    end;

    local procedure AddHistReclamacionesventas(ItemLedgerEntry: Record "Item Ledger Entry"; Item: Record Item; Customer: Record Customer)
    var
        HistReclamacionesventas: Record "ZM Hist. Reclamaciones ventas";
    begin
        HistReclamacionesventas.Reset();
        HistReclamacionesventas.SetRange("Document No.", ItemLedgerEntry."Document No.");
        HistReclamacionesventas.SetRange("Line No.", ItemLedgerEntry."Document Line No.");
        if ItemLedgerEntry."Serial No." <> '' then
            HistReclamacionesventas.SetRange("Serial No.", ItemLedgerEntry."Serial No.");
        if not HistReclamacionesventas.FindFirst() then begin
            HistReclamacionesventas.Init();
            HistReclamacionesventas.Type := HistReclamacionesventas.Type::Ventas;
            HistReclamacionesventas."Document No." := ItemLedgerEntry."Document No.";
            HistReclamacionesventas."Line No." := ItemLedgerEntry."Document Line No.";
            HistReclamacionesventas."Serial No." := ItemLedgerEntry."Serial No.";
            HistReclamacionesventas."Posting Date" := ItemLedgerEntry."Posting Date";
            HistReclamacionesventas."Item No." := ItemLedgerEntry."Item No.";
            HistReclamacionesventas."Cod. Categoria" := Item."Item Category Code";
            HistReclamacionesventas.Familia := Item.desFamilia_btc;
            HistReclamacionesventas."Customer No." := ItemLedgerEntry."Source No.";
            HistReclamacionesventas.Country := ItemLedgerEntry."Country/Region Code";
            HistReclamacionesventas."Grupo Clientes" := Customer.GrupoCliente_btc;
            HistReclamacionesventas."Cantidad Ventas" := -ItemLedgerEntry.Quantity;
            HistReclamacionesventas."Clasif Ventas" := item.selClasVtas_btc;
            Item.CalcFields(DesClasVtas_btc);
            HistReclamacionesventas."Des Clasif Ventas" := Item.desClasVtas_btc;
            HistReclamacionesventas.Insert(true)
        end;
    end;

    local procedure AddHistReclamacionesventasService(ServiceHeader: Record "Service Header"; ServiceItemLine: Record "Service Item Line"; Item: Record Item;
        SerialNo: code[50]; SalesDate: date)
    var
        Customer: Record Customer;
        HistReclamacionesventas: Record "ZM Hist. Reclamaciones ventas";
    begin
        HistReclamacionesventas.Reset();
        HistReclamacionesventas.SetRange("Document No.", ServiceItemLine."Document No.");
        HistReclamacionesventas.SetRange("Line No.", ServiceItemLine."Line No.");
        if SerialNo <> '' then
            HistReclamacionesventas.SetRange("Serial No.", SerialNo);
        if not HistReclamacionesventas.FindFirst() then begin
            if Customer.Get(ServiceHeader."Customer No.") then;
            HistReclamacionesventas.Init();
            HistReclamacionesventas.Type := HistReclamacionesventas.Type::"Pedidos Servicio";
            HistReclamacionesventas."Document No." := ServiceItemLine."Document No.";
            HistReclamacionesventas."Line No." := ServiceItemLine."Line No.";
            HistReclamacionesventas."Serial No." := SerialNo;
            HistReclamacionesventas."Sales Date" := SalesDate;
            HistReclamacionesventas."Posting Date" := ServiceHeader."Order Date";
            HistReclamacionesventas."Item No." := ServiceItemLine."Item No.";
            HistReclamacionesventas."Cod. Categoria" := Item."Item Category Code";
            HistReclamacionesventas.Familia := Item.desFamilia_btc;
            HistReclamacionesventas."Customer No." := ServiceHeader."Customer No.";
            HistReclamacionesventas.Country := ServiceHeader."Ship-to Country/Region Code";
            HistReclamacionesventas."Grupo Clientes" := Customer.GrupoCliente_btc;
            HistReclamacionesventas."Fallo localizado" := ServiceItemLine."Fallo localizado";
            HistReclamacionesventas."Fallo" := ServiceItemLine."Fallo";
            HistReclamacionesventas."Tipo Reclamaciones" := ServiceHeader."Service Order Type";
            HistReclamacionesventas.Insert(true)
        end;
    end;
}