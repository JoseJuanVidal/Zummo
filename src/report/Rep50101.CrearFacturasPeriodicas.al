report 50101 "CrearFacturasPeriodicas"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Create period invoices (process)', comment = 'ESP="Crear facturas periódicas (proceso)"';

    dataset
    {
        dataitem("Standard Customer Sales Code"; "Standard Customer Sales Code")
        {
            RequestFilterFields = "Customer No.", Code;

            trigger OnPreDataItem()
            begin
                // La validez se comprueba contra la fecha de la cuota (OnAfterGetRecord), no contra WorkDate,
                // para que si la cola no se ejecuta algún día se facturen igualmente las cuotas pendientes
                SetRange(Blocked, false);
                SetFilter(ProximaFechaFactura_btc, '<>%1&<=%2', 0D, WorkDate());
                SetRange(Active, true);
            end;

            trigger OnAfterGetRecord()
            begin
                if not CuotaPendiente("Standard Customer Sales Code") then
                    CurrReport.Skip();

                // Cliente bloqueado: no se factura y se informa en el resumen de líneas no facturadas
                if Customer.Get("Standard Customer Sales Code"."Customer No.") then
                    if Customer.Blocked in [Customer.Blocked::All, Customer.Blocked::Invoice] then begin
                        AddLineaNoFacturada("Standard Customer Sales Code", StrSubstNo('Cliente bloqueado (%1)', Customer.Blocked));
                        CurrReport.Skip();
                    end;

                tmpStandarCustomerSales.Init();
                tmpStandarCustomerSales.TransferFields("Standard Customer Sales Code");
                tmpStandarCustomerSales.Insert();
                SetLlamadaDesdeReport(true);
                // La última fecha es la de la cuota facturada, para que la siguiente no se desplace si la cola se retrasa
                validate(UltimaFechaFactura_btc, ProximaFechaFactura_btc);
                Modify();

                CreateSalesInvoice(WorkDate(), WorkDate());

            end;
        }
    }

    trigger OnPostReport()
    begin
        Commit();
        SendEmail();
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        recSMTPSetup: Record "SMTP Mail Setup";

        Customer: Record Customer;
        tmpStandarCustomerSales: record "Standard Customer Sales Code" temporary;
        cduSmtp: Codeunit "SMTP Mail";
        LineasNoFacturadas: List of [Text];

    local procedure CuotaPendiente(StandardSalesCustomer: Record "Standard Customer Sales Code"): Boolean
    begin
        with StandardSalesCustomer do begin
            if ("Valid From Date" <> 0D) and (ProximaFechaFactura_btc < "Valid From Date") then begin
                AddLineaNoFacturada(StandardSalesCustomer, StrSubstNo('Próxima fecha factura anterior a la fecha inicio validez %1', "Valid From Date"));
                exit(false);
            end;

            if ("Valid To date" <> 0D) and (ProximaFechaFactura_btc > "Valid To date") then begin
                // Contrato terminado con normalidad (ya se facturó alguna cuota): no se avisa
                if UltimaFechaFactura_btc = 0D then
                    AddLineaNoFacturada(StandardSalesCustomer, StrSubstNo('Contrato vencido (fecha fin validez %1) sin ninguna cuota facturada', "Valid To date"));
                exit(false);
            end;

            if (UltimaFechaFactura_btc <> 0D) and (ProximaFechaFactura_btc <= UltimaFechaFactura_btc) then begin
                AddLineaNoFacturada(StandardSalesCustomer, StrSubstNo('Cuota ya facturada (última fecha factura %1)', UltimaFechaFactura_btc));
                exit(false);
            end;
        end;
        exit(true);
    end;

    local procedure AddLineaNoFacturada(StandardSalesCustomer: Record "Standard Customer Sales Code"; Motivo: Text)
    var
        Linea: Text;
    begin
        StandardSalesCustomer.CalcFields("Customer Name");
        Linea := '<tr style="height: 15px;">';
        Linea += '<td style="width: 80.75px; height: 10px;text-align: right;">' + StandardSalesCustomer."Customer No." + '</td>';
        Linea += '<td style="width: 80.75px; height: 10px;text-align: right;">' + StandardSalesCustomer."Customer Name" + '</td>';
        Linea += '<td style="width: 80.75px; height: 10px;text-align: right;">' + StandardSalesCustomer.Code + '</td>';
        Linea += '<td style="width: 80.75px; height: 10px;text-align: right;">' + StandardSalesCustomer.Description + '</td>';
        Linea += '<td style="width: 80.75px; height: 10px;text-align: right;">' + format(StandardSalesCustomer.ProximaFechaFactura_btc) + '</td>';
        Linea += '<td style="width: 80.75px; height: 10px;text-align: left;">' + Motivo + '</td>';
        Linea += '</tr>';
        LineasNoFacturadas.Add(Linea);
    end;

    local procedure SendEmail()
    var
        body: text;
        Destino: text;
        Linea: Text;
    begin
        recSMTPSetup.Get();
        SalesSetup.Get();
        if (tmpStandarCustomerSales.Count = 0) and (LineasNoFacturadas.Count = 0) then
            exit;
        if SalesSetup."Recipient Mail Invoice Summary" = '' then
            Destino := 'pedidos@zummo.es;jvidal@zummo.es'
        else
            Destino := SalesSetup."Recipient Mail Invoice Summary";
        Body := '<p>&nbsp;</p>';
        Body += '<h1 style="color: #5e9ca0;">' + CompanyName + '</h1>';
        Body += '<h2 style="color: #2e6c80;">Facturación Ventas periódicas</h2>';
        Body += '<h2 style="color: #2e6c80;">L&iacute;neas:</h2>';
        Body += '<table class="editorDemoTable" style="width: 980px; height: 18px;">';
        Body += '<thead>';
        Body += '<tr style="height: 15px;">';
        Body += '<td style="width: 115.141px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption("Customer No.") + '</strong></td>';
        Body += '<td style="width: 277.078px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption("Customer Name") + '</strong></td>';
        Body += '<td style="width: 80.75px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption(Code) + '</strong></td>';
        Body += '<td style="width: 277.25px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption(Description) + '</strong></td>';
        Body += '<td style="width: 57.25px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption(Periodicidad_btc) + '</strong></td>';
        Body += '<td style="width: 43.9688px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption(ProximaFechaFactura_btc) + '</strong>.&nbsp;</td>';
        Body += '<td style="width: 43.9688px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption("Amount Lines") + '</strong>.&nbsp;</td>';
        Body += '</tr>';
        Body += '</thead>';
        Body += '<tbody>';
        if tmpStandarCustomerSales.FindFirst() then
            repeat
                tmpStandarCustomerSales.CalcFields("Amount Lines", "Customer Name");
                Body += '<tr style="height: 15px;">';
                Body += '<td style="width: 80.75px; height: 10px;text-align: right;">' + tmpStandarCustomerSales."Customer No." + '</td>';
                Body += '<td style="width: 80.75px; height: 10px;text-align: right;">' + tmpStandarCustomerSales."Customer Name" + '</td>';
                Body += '<td style="width: 80.75px; height: 10px;text-align: right;">' + tmpStandarCustomerSales.Code + '</td>';
                Body += '<td style="width: 80.75px; height: 10px;text-align: right;">' + tmpStandarCustomerSales.Description + '</td>';
                Body += '<td style="width: 80.75px; height: 10px;text-align: right;">' + format(tmpStandarCustomerSales.Periodicidad_btc) + '</td>';
                Body += '<td style="width: 80.75px; height: 10px;text-align: right;">' + format(tmpStandarCustomerSales.ProximaFechaFactura_btc) + '</td>';
                Body += '<td style="width: 80.75px; height: 10px;text-align: right;">' + format(tmpStandarCustomerSales."Amount Lines") + '</td>';
                Body += '<tr>';
            Until tmpStandarCustomerSales.next() = 0;
        Body += '</tbody>';
        Body += '</table>';
        if LineasNoFacturadas.Count > 0 then begin
            Body += '<h2 style="color: #2e6c80;">L&iacute;neas no facturadas:</h2>';
            Body += '<table class="editorDemoTable" style="width: 980px; height: 18px;">';
            Body += '<thead>';
            Body += '<tr style="height: 15px;">';
            Body += '<td style="width: 115.141px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption("Customer No.") + '</strong></td>';
            Body += '<td style="width: 277.078px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption("Customer Name") + '</strong></td>';
            Body += '<td style="width: 80.75px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption(Code) + '</strong></td>';
            Body += '<td style="width: 277.25px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption(Description) + '</strong></td>';
            Body += '<td style="width: 43.9688px; height: 18px;"><strong>' + tmpStandarCustomerSales.FieldCaption(ProximaFechaFactura_btc) + '</strong></td>';
            Body += '<td style="width: 277.25px; height: 18px;"><strong>Motivo</strong></td>';
            Body += '</tr>';
            Body += '</thead>';
            Body += '<tbody>';
            foreach Linea in LineasNoFacturadas do
                Body += Linea;
            Body += '</tbody>';
            Body += '</table>';
        end;
        Body += '<p><strong>&nbsp;</strong></p>';
        recSMTPSetup.Get();
        recSMTPSetup.TestField("SMTP Server");
        recSMTPSetup.TestField("User ID");
        Clear(cduSmtp);
        cduSmtp.CreateMessage(CompanyName(), recSMTPSetup."User ID", Destino, StrSubstNo('Creación Facturación peridica %1', WorkDate()), body, TRUE); //pDireccion, pAsunto, pCuerpo, TRUE);
        // filePathPurchaseHeader := GetDocAttachment(PurchLinesRequest."Document No.", FileName);
        // if filePathPurchaseHeader <> '' then
        //     if Exists(filePathPurchaseHeader) then
        //         cduSmtp.AddAttachment(filePathPurchaseHeader, FileName);
        cduSmtp.Send();
    end;
}