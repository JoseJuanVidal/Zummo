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
                SetFilter("Valid From Date", '%1|<=%2', 0D, WorkDate());
                SetFilter("Valid To date", '%1|>=%2', 0D, WorkDate());
                SetRange(Blocked, false);
                SetFilter(ProximaFechaFactura_btc, '<=%1', WorkDate());
                SetRange(Active, true);
            end;

            trigger OnAfterGetRecord()
            begin
                tmpStandarCustomerSales.Init();
                tmpStandarCustomerSales.TransferFields("Standard Customer Sales Code");
                tmpStandarCustomerSales.Insert();
                SetLlamadaDesdeReport(true);
                validate(UltimaFechaFactura_btc, WorkDate());
                Modify();

                CreateSalesInvoice(WorkDate(), WorkDate());


            end;
        }
    }

    trigger OnPostReport()
    begin
        SendEmail();
    end;

    var
        tmpStandarCustomerSales: record "Standard Customer Sales Code" temporary;

    local procedure SendEmail()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        recSMTPSetup: Record "SMTP Mail Setup";
        cduSmtp: Codeunit "SMTP Mail";
        body: text;
        Destino: text;
    begin
        recSMTPSetup.Get();
        SalesSetup.Get();
        if tmpStandarCustomerSales.Count = 0 then
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