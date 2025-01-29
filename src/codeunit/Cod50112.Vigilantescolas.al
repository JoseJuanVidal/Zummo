codeunit 50112 "Vigilantes colas"
{
    // clientes
    // ofertas aux
    // lineas ofertas aux
    // productos

    // Report	88205	GBS Resumen envios email SII
    // Report	88204	GBS Enviar documentos SII
    // Report	88201	GBS Procesar Movs. IVA SII
    // Codeunit	50503	Cron_AddonAUT	Cron_EnvioMailAprobacion	
    // Codeunit	50110	CU_Cron	Enviar facturación	
    // Codeunit	50110	CU_Cron	Aviso próximos vencimientos	
    // Codeunit	50110	CU_Cron	CargaMovsContaPresup
    // Codeunit	50110	CU_Cron	Limpia seguimientos    
    // Report	50101	Crear facturas periódicas (proceso)
    // Report	795	Valorar stock - movs. producto


    // ============== CRM 
    // Codeunit	5339	Integration Synch. Job Runner	CLIENTECORPORATIVO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	TERMINOS.PAGO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CURRENCY: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTAS-LIN: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTASSALESLIN: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CANAL: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	AREAMANAGER: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	PAISES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	FORMAS.PAGO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CLIENTES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	ACTIVIDADCLIENTE: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	PROVINCIAS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	TARIFAS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	DELEGADOS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	GRUPOCLIENTE: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTASSALES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	MERCADOS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTAS: trabajo de sincronización de Dynamics 365 for Sales.



    trigger OnRun()
    begin
        CheckJobQueueEntry;

        testCRMConnection;
    end;

    var
        myInt: Integer;

    local procedure CheckJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        isactive: Boolean;
    begin
        if JobQueueEntry.findset() then
            repeat
                isactive := false;
                // Limpiamos los trabajos de ERROR del CRM - customer - Contact link
                // id 5351 - CRM Customer-Contact Link - ERROR
                if (JobQueueEntry."Object ID to Run" = 5351) and (JobQueueEntry.Description = 'Enlace de contacto con el cliente.') and
                   (JobQueueEntry.Status in [JobQueueEntry.Status::Error]) then
                    JobQueueEntry.Delete();
                case JobQueueEntry."Object Type to Run" of
                    JobQueueEntry."Object Type to Run"::Codeunit:
                        begin
                            if JobQueueEntry."Object ID to Run" = 5339 then begin
                                case JobQueueEntry.Description of
                                    'CLIENTES: trabajo de sincronización de Dynamics 365 for Sales.',
                                    'OFERTASSALES: trabajo de sincronización de Dynamics 365 for Sales.',
                                    'OFERTASSALESLIN: trabajo de sincronización de Dynamics 365 for Sales.':
                                        begin
                                            if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                                JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                        end;
                                end;
                            end;

                            case JobQueueEntry."Object ID to Run" of
                                50503, 50110:
                                    begin
                                        if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                    end;
                            end;
                        end;
                    JobQueueEntry."Object Type to Run"::Report:
                        begin
                            case JobQueueEntry."Object ID to Run" of
                                88205, 88204, 88201, 50101, 795:
                                    begin
                                        if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                    end;
                            end;
                        end;
                end;

            Until JobQueueEntry.next() = 0;
    end;

    local procedure testCRMConnection()
    var
        CRMConnectionSetup: record "CRM Connection Setup";
    begin
        CRMConnectionSetup.get();
        if not CRMConnectionSetup.IsEnabled() then
            CRMConnectionSetup.Validate("Is Enabled", true);
    end;


    procedure ExportMovsProductos()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Item: Record Item;
        Vendor: Record Vendor;
        ItemLedgerEntry: Record "Item Ledger Entry";
        SourceNo: code[20];
        SourceDescription: text;
        DocumentNo: code[20];
        Quantity: Decimal;
        LastCost: Decimal;
        LastDate: Date;
        DateFilter: Text;
        Window: Dialog;
    begin
        DateFilter := StrSubstNo('%1..%2', CalcDate('<-CY>', WorkDate()), CalcDate('<CY>', WorkDate()));
        ExcelBuffer.DeleteAll();
        ExcelBuffer.CreateNewBook('Movs. Productos - Análisis Compras Año');
        Window.Open('Producto: #1###########################\Fecha #2############');
        Item.SetRange(Type, Item.Type::Inventory);
        ExportMovsProductos_Cabecera(ExcelBuffer, Item, DateFilter);
        if Item.FindFirst() then
            repeat
                Window.Update(1, Item."No.");
                SourceNo := '';
                SourceDescription := '';
                DocumentNo := '';
                Quantity := 0;
                LastCost := 0;
                LastDate := 0D;
                case Item."Replenishment System" of
                    Item."Replenishment System"::Purchase:
                        begin
                            ItemLedgerEntry.Reset();
                            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
                            ItemLedgerEntry.SetRange("Item No.", Item."No.");
                            if DateFilter <> '' then
                                ItemLedgerEntry.SetFilter("Posting Date", DateFilter);
                            if ItemLedgerEntry.FindFirst() then begin
                                repeat
                                    Window.Update(2, ItemLedgerEntry."Posting Date");
                                    ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                                    SourceNo := ItemLedgerEntry."Source No.";
                                    if Vendor.Get(SourceNo) then
                                        SourceDescription := Vendor.Name;
                                    DocumentNo := ItemLedgerEntry."Document No.";
                                    Quantity += ItemLedgerEntry.Quantity;
                                    LastCost := ItemLedgerEntry.GetUnitCostLCY();
                                    LastDate := ItemLedgerEntry."Posting Date";
                                Until ItemLedgerEntry.next() = 0;
                                ExportMovsProductos_lines(ExcelBuffer, Item, SourceNo, SourceDescription, DocumentNo, Quantity, LastCost, LastDate);
                            end;
                        end;
                    Item."Replenishment System"::"Prod. Order":
                        begin
                            if CopyStr(Item."No.", 1, 2) = 'SM' then begin
                                ItemLedgerEntry.Reset();
                                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
                                ItemLedgerEntry.SetRange("Item No.", Item."No.");
                                if DateFilter <> '' then
                                    ItemLedgerEntry.SetFilter("Posting Date", DateFilter);
                                if ItemLedgerEntry.FindFirst() then begin
                                    repeat
                                        Window.Update(2, ItemLedgerEntry."Posting Date");
                                        ItemLedgerEntry.CalcFields(NombreCliente_btc);
                                        SourceNo := ItemLedgerEntry."Source No.";
                                        SourceDescription := ItemLedgerEntry.NombreCliente_btc;
                                        DocumentNo := ItemLedgerEntry."Document No.";
                                        Quantity += ItemLedgerEntry.Quantity;
                                        LastCost := ItemLedgerEntry.GetUnitCostLCY();
                                        LastDate := ItemLedgerEntry."Posting Date";
                                    Until ItemLedgerEntry.next() = 0;
                                    ExportMovsProductos_lines(ExcelBuffer, Item, SourceNo, SourceDescription, DocumentNo, Quantity, LastCost, LastDate);
                                end;
                            end

                        end;
                end;
            Until Item.next() = 0;
        ExcelBuffer.WriteSheet('Mov Producto', COMPANYNAME, USERID);

        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Movs Productos');
        ExcelBuffer.OpenExcel();

    end;

    local procedure ExportMovsProductos_lines(var
                                                  ExcelBuffer: Record "Excel Buffer";
                                                  Item: Record Item;
                                                  SourceNo: code[20];
                                                  SourceDescription: text;
                                                  DocumentNo: code[20];
                                                  Quantity: Decimal;
                                                  LastCost: Decimal;
                                                  LastDate: Date)
    var

    begin
        Item.CalcFields("Desc. Purch. SubCategory");
        ExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item."Desc. Purch. SubCategory", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(LastCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(LastDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(DocumentNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SourceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SourceDescription, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
    end;

    local procedure ExportMovsProductos_Cabecera(var ExcelBuffer: Record "Excel Buffer"; var Item: Record Item; DateFilter: Text)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ExcelBuffer.AddColumn(StrSubstNo('%1', ItemLedgerEntry.TableCaption), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(StrSubstNo('Filtro productos %1', Item.GetFilters), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(StrSubstNo('Filtro Fecha %1', DateFilter), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(StrSubstNo('%1', CompanyName), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;

        ExcelBuffer.AddColumn(ItemLedgerEntry.FIELDCAPTION("Item No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemLedgerEntry.FIELDCAPTION(Description), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemLedgerEntry.FIELDCAPTION("Item Category Code"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Quantity Year', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Monthly Estimation', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Last purchase price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Last purchase date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Order num', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Suplier code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Suplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
    end;


}



