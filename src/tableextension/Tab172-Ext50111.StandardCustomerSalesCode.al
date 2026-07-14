tableextension 50111 "StandardCustomerSalesCode" extends "Standard Customer Sales Code"  //172
{
    fields
    {
        field(50000; Active; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active', comment = 'ESP="Activo"';
        }

        field(50100; Periodicidad_btc; DateFormula)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Period', comment = 'ESP="Periodicidad"';

            trigger OnValidate()
            begin
                if format(Periodicidad_btc) = '' then
                    exit;

                CalculaProximaFechaFactura();
            end;
        }

        field(50101; ProximaFechaFactura_btc; Date)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Next invoice date', comment = 'ESP="Próxima fecha factura"';

            trigger OnValidate()
            var
                lbErrorFechaErr: Label 'The next invoice date cannot be less than the initial date', comment = 'ESP="La fecha de próxima factura no puede ser menor a la fecha inicial"';
                lbErrorFechaMayorErr: Label 'The next invoice date cannot be greater than the final date', Comment = 'ESP="La fecha de próxima factura no puede ser mayor a la fecha final"';
                lbErrorFechaMenorUltimaFechaErr: Label 'The next invoice date cannot be less than the last invoice date', comment = 'ESP="La fecha de próxima factura no puede ser menor a la fecha última factura"';
            begin
                if (ProximaFechaFactura_btc <> 0D) and (ProximaFechaFactura_btc < "Valid From Date") and ("Valid From Date" <> 0D) then
                    error(lbErrorFechaErr);


                if (ProximaFechaFactura_btc <> 0D) and (ProximaFechaFactura_btc > "Valid To date") and ("Valid To date" <> 0D) then
                    if not globalBoolDesdeReport then  // Si el cálculo viene desde el proceso que genera facturas no doy error, se deja la fecha fin como estaba
                        error(lbErrorFechaMayorErr)
                    else
                        ProximaFechaFactura_btc := xRec.ProximaFechaFactura_btc;

                if (ProximaFechaFactura_btc <> 0D) and (UltimaFechaFactura_btc <> 0D) and (ProximaFechaFactura_btc < UltimaFechaFactura_btc) then
                    error(lbErrorFechaMenorUltimaFechaErr);
            end;
        }

        field(50102; UltimaFechaFactura_btc; Date)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Last invoice date', comment = 'ESP="Última fecha factura"';

            trigger OnValidate()
            begin
                if (UltimaFechaFactura_btc <> 0D) and (UltimaFechaFactura_btc <> xRec.UltimaFechaFactura_btc) then
                    CalculaProximaFechaFactura();
            end;
        }
        field(50110; "Customer Name"; text[100])
        {
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup(customer.Name where("No." = field("Customer No.")));
            Editable = false;
        }
        field(50120; "Amount Lines"; Decimal)
        {
            Caption = 'Amount', comment = 'ESP="Importe Líneas"';
            FieldClass = FlowField;
            CalcFormula = sum("Standard Sales Line".Precio_btc where("Standard Sales Code" = field(Code)));
            Editable = false;
        }
        field(50130; "Contract Services"; code[20])
        {
            Caption = 'Nº contrato servicio', comment = 'ESP="Nº contrato servicio"';
            DataClassification = CustomerContent;
            TableRelation = "Service Contract Header"."Contract No." where("Customer No." = field("Customer No."));
        }
    }

    procedure CalculaProximaFechaFactura()
    begin
        if format(Periodicidad_btc) = '' then
            exit;

        if UltimaFechaFactura_btc <> 0D then
            Validate(ProximaFechaFactura_btc, CalcDate(Periodicidad_btc, DMY2Date(Date2DMY("Valid From Date", 1), Date2DMY(WorkDate(), 2), Date2DMY(WorkDate(), 3))))   // UltimaFechaFactura_btc cambiamos para que aunque se facture en otra fecha, sea un desplazamiento exacto
        else
            if "Valid From Date" <> 0D then
                validate(ProximaFechaFactura_btc, CalcDate(Periodicidad_btc, "Valid From Date"))
            else
                validate(ProximaFechaFactura_btc, CalcDate(Periodicidad_btc, WorkDate()));
    end;

    procedure SetLlamadaDesdeReport(pBool: Boolean)
    begin
        globalBoolDesdeReport := pBool;
    end;

    var
        globalBoolDesdeReport: Boolean;

    procedure ExportExcel(var StandardCustomerSales: record "Standard Customer Sales Code")
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.CreateNewBook('Ventas Periodicas');
        HeaderExcelBuffer(ExcelBuffer, StandardCustomerSales.GetFilters());
        if StandardCustomerSales.FindFirst() then
            repeat
                LineExcelBuffer(ExcelBuffer, StandardCustomerSales);
            Until StandardCustomerSales.next() = 0;
        ExcelBuffer.WriteSheet('Cliente - Ventas periodicas', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.DownloadAndOpenExcel;
    end;

    local procedure HeaderExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; TextoFiltro: text)
    var
        StandardSalesLine: record "Standard Sales Line";
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Informe tarifas de Proveedor - precios', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Filtro:', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(TextoFiltro, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(Rec.FieldCaption("Customer No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption("Customer Name"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption(Code), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption(Description), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption("Valid From Date"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption("Valid to Date"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption(Periodicidad_btc), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption(UltimaFechaFactura_btc), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption(ProximaFechaFactura_btc), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Rec.FieldCaption("Amount Lines"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StandardSalesLine.FieldCaption(Type), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StandardSalesLine.FieldCaption("No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StandardSalesLine.FieldCaption(Description), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StandardSalesLine.FieldCaption(Quantity), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StandardSalesLine.FieldCaption(Precio_btc), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

    local procedure LineExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; StandardCustomerSales: Record "Standard Customer Sales Code")
    var
        StandardSalesLine: record "Standard Sales Line";
    begin
        StandardCustomerSales.CalcFields("Amount Lines");
        StandardSalesLine.Reset();
        StandardSalesLine.SetRange("Standard Sales Code", StandardCustomerSales.code);
        if StandardSalesLine.FindFirst() then
            repeat
                ExcelBuffer.AddColumn(StandardCustomerSales."Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StandardCustomerSales."Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StandardCustomerSales.Code, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StandardCustomerSales.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StandardCustomerSales."Valid From Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(StandardCustomerSales."Valid to Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(StandardCustomerSales.Periodicidad_btc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StandardCustomerSales.UltimaFechaFactura_btc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(StandardCustomerSales.ProximaFechaFactura_btc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(StandardCustomerSales."Amount Lines", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(StandardSalesLine.Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StandardSalesLine."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StandardSalesLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StandardSalesLine.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(StandardSalesLine.Precio_btc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.NewRow();
                StandardCustomerSales."Amount Lines" := 0;
            Until StandardSalesLine.next() = 0;

    end;
}