codeunit 50110 "CU_Cron"
{
    TableNo = 472;
    Permissions = TableData "Sales Invoice Header" = RIMD, tabledata "Sales Header" = RIMD, tabledata "Sales Line" = RIMD, tabledata "Sales Cr.MeMO Header" = RIMD
    , tabledata "Email Item" = RIMD, tabledata "LogMailManagement" = RIMD, tabledata "LogEnvioEmailsClientes" = RIMD, tabledata "Service Password" = RIMD;

    var
        MovsContaPresup: Record "STH Movs Conta-Presup";
        ResultEnvioMailTxt: Text;
        TotalExcelBuffer: Record "Excel Buffer" temporary;
        Ejecucioncola: Boolean;

    trigger OnRun()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        TextosAuxiliares: Record TextosAuxiliares;
        Param: Text;
        lbNoParametroErr: Label 'Unknown parameter', comment = 'ESP="Parámetro Desconocido"';
        Fecha: date;
    begin
        if (StrPos("Parameter String", ';')) > 0 then begin
            Param := CopyStr("Parameter String", 1, (StrPos("Parameter String", ';') - 1));

            case Param of
                'FechaOferta':
                    CambiaFechasOferta();
                'AvisoVenc':
                    AvisosVencimientos();
                //JJV 28/4 quitamos que quite reservas
                'LimpiaSeguimiento':
                    LimpiarSeguimientos();
                'EnviarFacturacion':
                    EnvioMasivoMail();
                'DimensAF':
                    CambiaDimensionesAF();
                'AvisosFrasVencidas':
                    AvisosFacturasVencidas();
                'CalculateVtoAseguradora':
                    CalculateVtoAseguradora();
                'CargaMovsContaPresup':
                    MovsContaPresup.CargarDatos();
                'AvisosFrasVencidasAreaManager':
                    begin
                        SalesSetup.Get();
                        if SalesSetup."Ult. Envío Fact. Vencidas" <> 0D then
                            Fecha := CalcDate(SalesSetup."Envío email Fact. Vencidas", SalesSetup."Ult. Envío Fact. Vencidas");
                        if Fecha < TODAY then begin
                            Ejecucioncola := true;
                            AvisosFacturasVencidasTodosAreaManager(TextosAuxiliares);
                            SalesSetup."Ult. Envío Fact. Vencidas" := Today;
                            SalesSetup.Modify();
                        end;
                    end;

                else
                    error(lbNoParametroErr);

            end; //case
        end;
    end;

    local procedure CambiaDimensionesAF()
    var
        recActivoFijo: Record "Fixed Asset";
        recDimAFFechas: Record DimAFRagoFecha;
    begin
        recActivoFijo.Reset();
        if recActivoFijo.FindSet() then
            repeat
                clear(recDimAFFechas);
                recDimAFFechas.CambiaDimensiones(Today(), recActivoFijo);
            until recActivoFijo.Next() = 0;
    end;

    local procedure LimpiarSeguimientos()
    var
        recReservEntry: Record "Reservation Entry";
        recReservEntry2: Record "Reservation Entry";
    begin
        recReservEntry.Reset();
        recReservEntry.SetFilter("Reservation Status", '<>%1', recReservEntry."Reservation Status"::Reservation);
        recReservEntry.SetFilter("Source Type", '<>%1', 5741);
        if recReservEntry.FindFirst() then
            recReservEntry.DeleteAll();
        Commit();
        recReservEntry.Reset();
        recReservEntry.SetFilter("Reservation Status", '<>%1', recReservEntry."Reservation Status"::Reservation);
        recReservEntry.SetRange("Source Type", 5741);
        recReservEntry.SetRange("Item Tracking", recReservEntry."Item Tracking"::None);
        if recReservEntry.FindFirst() then
            recReservEntry.DeleteAll();
        Commit();
        recReservEntry.Reset();
        recReservEntry.SetRange("Reservation Status", recReservEntry."Reservation Status"::Reservation);
        //recReservEntry.SetRange("Item Tracking", recReservEntry."Item Tracking"::None);
        recReservEntry.SetRange(Positive, false);
        if recReservEntry.FindSet() then
            repeat
                recReservEntry2.SetRange(Positive, true);
                recReservEntry2.SetRange("Entry No.", recReservEntry."Entry No.");
                if not recReservEntry2.FindFirst() then begin
                    recReservEntry.Delete();
                    Commit();
                end;
            until recReservEntry.Next() = 0;
        recReservEntry.Reset();
        recReservEntry.SetRange("Reservation Status", recReservEntry."Reservation Status"::Reservation);
        //recReservEntry.SetRange("Item Tracking", recReservEntry."Item Tracking"::None);
        recReservEntry.SetRange(Positive, true);
        if recReservEntry.FindSet() then
            repeat
                recReservEntry2.SetRange(Positive, false);
                recReservEntry2.SetRange("Entry No.", recReservEntry."Entry No.");
                if not recReservEntry2.FindFirst() then begin
                    recReservEntry.Delete();
                    Commit();
                end;
            until recReservEntry.Next() = 0;
    end;

    local procedure CambiaFechasOferta()
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        cduSalesEvents: Codeunit SalesEvents;
        fechaEnvio: Date;
    begin
        recSalesHeader.Reset();
        recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Quote);
        recSalesHeader.SetFilter(NumDias_btc, '<>%1', 0);
        if recSalesHeader.FindSet() then
            repeat
                fechaEnvio := cduSalesEvents.GetResFechaLaborables(recSalesHeader.NumDias_btc, WorkDate());

                recSalesHeader."Shipment Date" := fechaEnvio;
                recSalesHeader.Modify();

                recSalesLine.Reset();
                recSalesLine.SetRange("Document Type", recSalesHeader."Document Type");
                recSalesLine.SetRange("Document No.", recSalesHeader."No.");
                if recSalesLine.FindFirst() then
                    recSalesLine.modifyall("Shipment Date", fechaEnvio);
            until recSalesHeader.Next() = 0;
    end;

    procedure EnvioPersonalizado(RecordVariant: Variant)
    var
        RecRef: RecordRef;
        RecHcoFVTA: Record "Sales Invoice Header";
        RecHcoAVTA: Record "Sales Cr.Memo Header";
        TmpEmail: Record "Email Item" temporary;
        TmpBlob: Record TempBlob;
        RecCustomer: Record Customer;
        PostedDocNo: code[20];
        FechaReg: date;
        TablaNo: Integer;
    begin
        RecRef.GetTable(RecordVariant);
        case RecRef.Number() of
            DATABASE::"Sales Invoice Header":
                begin
                    RecRef.SetTable(RecHcoFVTA);
                    RecCustomer.GET(RecHcoFVTA."Bill-to Customer No.");
                    PostedDocNo := RecHcoFVTA."No.";
                    FechaReg := RecHcoFVTA."Posting Date";
                    TablaNo := DATABASE::"Sales Invoice Header";
                end;
            DATABASE::"Sales Cr.Memo Header":
                begin
                    RecRef.SetTable(RecHcoAVTA);
                    RecCustomer.GET(RecHcoAVTA."Bill-to Customer No.");
                    PostedDocNo := RecHcoAVTA."No.";
                    FechaReg := RecHcoFVTA."Posting Date";
                    TablaNo := DATABASE::"Sales Cr.Memo Header";
                end;
        end;
        with TmpEmail do begin
            "Send to" := RecCustomer.CorreoFactElec_btc;
            GenerarCuerpoCorreo(TmpBlob);
            Body := TmpBlob.Blob;
            "Attachment File Path" := CopyStr(ObtenerRutaFichAdjuntoPersonalizado(FechaReg, PostedDocNo, TablaNo), 1, 250);
            "Attachment Name" := PostedDocNo + '.pdf';
            "Plaintext Formatted" := true;
            "Message Type" := "Message Type"::"Custom Message";
            Send(false);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 9520, 'OnBeforeSentViaSMTP', '', false, false)]
    local procedure MarcarHcos(VAR TempEmailItem: Record "Email Item" temporary)
    var
        RecHcoFVTA: Record "Sales Invoice Header";
        RecHcoABVTA: Record "Sales Cr.Memo Header";
        PostedDocNo: Code[20];
        RecCustomer: Record Customer;
    begin

        PostedDocNo := CopyStr(TempEmailItem."Attachment Name", 1, StrPos(TempEmailItem."Attachment Name", '.pdf') - 1);

        if not RecHcoFVTA.get(PostedDocNo) and not RecHcoABVTA.get(PostedDocNo) then
            exit;

        if RecHcoFVTA.get(PostedDocNo) then begin
            RecHcoFVTA.CorreoEnviado_btc := true;
            RecCustomer.get(RecHcoFVTA."Bill-to Customer No.");
            if RecCustomer.PermiteEnvioMail_btc then
                RecHcoFVTA.FacturacionElec_btc := true;
            RecHcoFVTA.Modify();
        end;

        if RecHcoABVTA.get(PostedDocNo) then begin
            RecHcoABVTA.CorreoEnviado_btc := true;
            RecCustomer.get(RecHcoFVTA."Bill-to Customer No.");
            if RecCustomer.PermiteEnvioMail_btc then
                RecHcoFVTA.FacturacionElec_btc := true;
            RecHcoABVTA.Modify();
        end;

    end;


    local procedure ObtenerRutaFichAdjuntoPersonalizado(Fecha: date; NoDoc: code[20]; TablaNo: Integer): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        recCabHcoAbVta: Record "Sales Cr.Memo Header";
        recCustomer: Record Customer;
        reportFactura: Report FacturaNacionalMaquinas;
        reportAbVtaReg: Report AbonoVentaRegistrado;
        reportBrasil: Report FacturaRegBrasil;
        FileMgt: Codeunit "File Management";
        RutaServidor: Text;

    begin
        Clear(FileMgt);
        RutaServidor := FileMgt.ServerTempFileName('pdf');
        case TablaNo of
            DATABASE::"Sales Cr.Memo Header":
                begin
                    Clear(reportAbVtaReg);
                    recCabHcoAbVta.Reset();
                    recCabHcoAbVta.SetRange("No.", NoDoc);
                    recCabHcoAbVta.FindFirst();
                    reportAbVtaReg.SetTableView(recCabHcoAbVta);
                    reportAbVtaReg.SaveAsPdf(RutaServidor);
                end;
            DATABASE::"Sales Invoice Header":
                begin
                    SalesInvoiceHeader.Reset();
                    SalesInvoiceHeader.SetRange("No.", NoDoc);
                    SalesInvoiceHeader.FindFirst();
                    recCustomer.get(SalesInvoiceHeader."Bill-to Customer No.");
                    case recCustomer.TipoFormarto_btc of
                        recCustomer.TipoFormarto_btc::Brasil:
                            begin
                                clear(reportBrasil);
                                reportBrasil.SetTableView(SalesInvoiceHeader);
                                reportBrasil.SaveAsPdf(RutaServidor);
                            end;
                        recCustomer.TipoFormarto_btc::"Exportación":
                            begin
                                clear(reportFactura);
                                reportFactura.EsExportacion();
                                reportFactura.SetTableView(SalesInvoiceHeader);
                                reportFactura.SaveAsPdf(RutaServidor);
                            end;
                        recCustomer.TipoFormarto_btc::Lidl:
                            begin
                                clear(reportFactura);
                                reportFactura.EsLidl();
                                ;
                                reportFactura.SetTableView(SalesInvoiceHeader);
                                reportFactura.SaveAsPdf(RutaServidor);
                            end;
                        recCustomer.TipoFormarto_btc::Nacional:
                            begin
                                clear(reportFactura);
                                reportFactura.EsNacional();
                                reportFactura.SetTableView(SalesInvoiceHeader);
                                reportFactura.SaveAsPdf(RutaServidor);
                            end;
                        else begin
                                clear(reportFactura);
                                reportFactura.EsNacional();
                                reportFactura.SetTableView(SalesInvoiceHeader);
                                reportFactura.SaveAsPdf(RutaServidor);
                            end;
                    end;
                end;
        end;
        exit(RutaServidor);
    end;

    [EventSubscriber(ObjectType::Table, 77, 'OnBeforeGetCustEmailAddress', '', false, false)]
    local procedure RellenarDireccionEnvio(BillToCustomerNo: Code[20]; VAR ToAddress: Text; ReportUsage: Option; VAR IsHandled: Boolean)
    var
        RecCustomer: Record Customer;
    begin
        if not RecCustomer.get(BillToCustomerNo) then
            exit;
        if RecCustomer.CorreoFactElec_btc <> '' then begin
            ToAddress := RecCustomer.CorreoFactElec_btc;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeSendEmail', '', true, true)]
    local procedure OnBeforeSendemail(VAR TempEmailItem: Record "Email Item" temporary; VAR IsFromPostedDoc: Boolean; VAR PostedDocNo: Code[20]; VAR HideDialog: Boolean; VAR ReportUsage: Integer)
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recHcoFVTA: Record "Sales Invoice Header";
        recHcoABVTA: Record "Sales Cr.Memo Header";
        recCustomer: Record Customer;
        EmailCuerpo: Record TempBlob temporary;
        FechaReg: Date;
    begin
        if not IsFromPostedDoc then
            exit;

        if not recHcoFVTA.Get(PostedDocNo) and not recHcoABVTA.Get(PostedDocNo) then
            exit;
        recSalesSetup.Get();
        if not recCustomer.Get(recHcoABVTA."Bill-to Customer No.") and not recCustomer.get(recHcoFVTA."Bill-to Customer No.") then
            exit;
        if recHcoABVTA."Posting Date" <> 0D then
            FechaReg := recHcoABVTA."Posting Date";
        if recHcoFVTA."Posting Date" <> 0D then
            FechaReg := recHcoFVTA."Posting Date";

        if (recCustomer.CorreoFactElec_btc <> '') and (StrLen(recCustomer.CorreoFactElec_btc) <= MaxStrLen(TempEmailItem."Send to")) then
            TempEmailItem."Send to" := copystr(recCustomer.CorreoFactElec_btc, 1, MaxStrlen(tempemailitem."Send To"));

        GenerarCuerpoCorreo(EmailCuerpo);
        TempEmailItem.Body := EmailCuerpo.Blob;
        TempEmailItem."Plaintext Formatted" := true;
        TempEmailItem."Message Type" := TempEmailItem."Message Type"::"Custom Message";
        TempEmailItem."Body File Path" := CopyStr(ObtenerRutaFichAdjunto(FechaReg, PostedDocNo), 1, 250);
        TempEmailItem."Attachment Name" := PostedDocNo + '.pdf';

        if TempEmailItem.Modify() then;
    end;

    local procedure GenerarCuerpoCorreo(var CuerpoBlob: Record TempBlob)
    var
        cuerpoStream: OutStream;
        LF: Char;
        CR: Char;
    begin
        LF := 10;
        CR := 13;
        CuerpoBlob.Init();
        CuerpoBlob.Blob.CreateOutStream(cuerpoStream, TextEncoding::UTF8);
        cuerpoStream.WriteText('Estimado cliente,' + Format(CR) + FORMAT(LF) + Format(CR) + FORMAT(LF));
        cuerpoStream.WriteText('Remitimos factura del pedido solicitado.' + Format(CR) + FORMAT(LF) + Format(CR) + FORMAT(LF));
        cuerpoStream.WriteText('El presente envío sustituye íntegramente lo efectuado tradicionalmente a través de servicio postal.' + Format(CR) + FORMAT(LF) + Format(CR) + FORMAT(LF));
        cuerpoStream.WriteText('La factura electrónica es, desde un punto de vista de contenido, totalmente equivalente a una factura'
                               + ' en papel.  Es por lo tanto su responsabilidad proceder a la relativa impresión y archivo. La factura está en formato PDF y podrán visualizar e imprimir el adjunto con Acrobat Reader.' + Format(CR) + FORMAT(LF) + Format(CR) + FORMAT(LF)
                );
        cuerpoStream.WriteText('Aprovechamos para agradecerle su confianza,' + Format(CR) + FORMAT(LF) + Format(CR) + FORMAT(LF));
        cuerpoStream.WriteText('Reciban un cordial saludo.' + Format(CR) + FORMAT(LF) + Format(CR) + FORMAT(LF));
    end;

    [EventSubscriber(ObjectType::Table, 77, 'OnAfterSendEmailDirectly', '', false, false)]
    local procedure CambiarEstadoHcoFactVenta(ReportUsage: Integer; RecordVariant: Variant; VAR AllEmailsWereSuccessful: Boolean)
    var
        RecHistAlbVta: Record "Sales Cr.Memo Header";
        RecHistAlbVtaAux: Record "Sales Cr.Memo Header";
        RecHistFactVta: Record "Sales Invoice Header";
        RecHistFactVtaAux: Record "Sales Invoice Header";
        RecCustomer: Record Customer;
        recLogEnvio: Record LogEnvioEmailsClientes;
        RecRef: RecordRef;
    begin
        if not AllEmailsWereSuccessful then
            exit;
        RecRef.GETTABLE(RecordVariant);
        case RecRef.NUMBER() of
            DATABASE::"Sales Invoice Header":
                begin
                    RecRef.SetTable(RecHistFactVta);
                    if RecCustomer.get(RecHistFactVta."Bill-to Customer No.") then;
                    RecHistFactVtaAux.get(RecHistFactVta."No.");
                    RecHistFactVtaAux.CorreoEnviado_btc := true;
                    RecHistFactVtaAux.modify();
                    if recLogEnvio.get(RecHistFactVta."Posting Date", RecHistFactVta."No.") then begin
                        recLogEnvio.Enviado_btc := true;
                        recLogEnvio.FechaEnvio_btc := WorkDate();
                        recLogEnvio.Modify();

                    end else begin
                        recLogEnvio.Init();
                        recLogEnvio.FechaDocumento_btc := RecHistFactVta."Posting Date";
                        recLogEnvio.CodCliente_btc := RecHistFactVta."No.";
                        recLogEnvio.Tipo := recLogEnvio.Tipo::Factura;
                        recLogEnvio.NoDoc_btc := RecHistFactVta."No.";
                        recCustomer.Get(RecHistFactVta."Bill-to Customer No.");
                        recLogEnvio.DireccionEmail_btc := recCustomer.CorreoFactElec_btc;
                        recLogEnvio.NombreCliente_btc := recCustomer.Name;
                        recLogEnvio.clienteFact_btc := recCustomer."No.";
                        recLogEnvio.NoDoc_btc := RecHistFactVta."No.";
                        recLogEnvio.Enviado_btc := true;
                        recLogEnvio.FechaEnvio_btc := WorkDate();
                        recLogEnvio.Insert();
                    end;
                end;
            DATABASE::"Sales Cr.Memo Header":
                begin
                    RecRef.SetTable(RecHistAlbVta);
                    if RecCustomer.get(RecHistAlbVta."Bill-to Customer No.") then;
                    RecHistAlbVtaAux.get(RecHistAlbVta."No.");
                    RecHistAlbVtaAux.CorreoEnviado_btc := true;
                    RecHistAlbVtaAux.modify();
                    if recLogEnvio.get(RecHistAlbVta."Posting Date", RecHistAlbVta."No.") then begin
                        recLogEnvio.Enviado_btc := true;
                        recLogEnvio.FechaEnvio_btc := WorkDate();
                        recLogEnvio.Modify();
                    end else begin
                        recLogEnvio.Init();
                        recLogEnvio.FechaDocumento_btc := RecHistAlbVta."Posting Date";
                        recLogEnvio.CodCliente_btc := RecHistAlbVta."No.";
                        recLogEnvio.Tipo := recLogEnvio.Tipo::Abono;
                        recLogEnvio.NoDoc_btc := RecHistAlbVta."No.";
                        recCustomer.Get(RecHistAlbVta."Bill-to Customer No.");
                        recLogEnvio.DireccionEmail_btc := recCustomer.CorreoFactElec_btc;
                        recLogEnvio.NombreCliente_btc := recCustomer.Name;
                        recLogEnvio.clienteFact_btc := recCustomer."No.";
                        recLogEnvio.NoDoc_btc := RecHistAlbVta."No.";
                        recLogEnvio.Enviado_btc := true;
                        recLogEnvio.FechaEnvio_btc := WorkDate();
                        recLogEnvio.Insert();

                    end;
                end;
        end;
    end;

    local procedure EnvioMasivoMail()
    var
        recCabHcoFactVta: Record "Sales Invoice Header";
        recCabHcoAbVta: Record "Sales Cr.Memo Header";
        recCustomer: Record Customer;
        recLogEnvio: Record LogEnvioEmailsClientes;
        cduMailManagement: Codeunit "Mail Management";

    begin
        recCabHcoFactVta.Reset();
        recCabHcoFactVta.SetRange(FacturacionElec_btc, true);
        recCabHcoFactVta.SetRange(CorreoEnviado_btc, false);
        if recCabHcoFactVta.FindSet() then
            repeat
                //Para no romper mucho la tabla recLogEnvio y no chocar con Fran, pondremos como campo CodCliente nuesto nº doc
                if not recLogEnvio.Get(recCabHcoFactVta."Posting Date", recCabHcoFactVta."No.") then begin
                    recLogEnvio.Init();
                    recLogEnvio.FechaDocumento_btc := recCabHcoFactVta."Posting Date";
                    recLogEnvio.CodCliente_btc := recCabHcoFactVta."No.";
                    recLogEnvio.Tipo := recLogEnvio.Tipo::Factura;
                    recLogEnvio.NoDoc_btc := recCabHcoFactVta."No.";
                    recCustomer.Get(recCabHcoFactVta."Bill-to Customer No.");
                    recLogEnvio.DireccionEmail_btc := recCustomer.CorreoFactElec_btc;

                    if recLogEnvio.DireccionEmail_btc = '' then begin
                        recLogEnvio.TieneError_btc := true;
                        recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email configurada', recCustomer."No.");
                    end;

                    clear(cduMailManagement);
                    if not cduMailManagement.CheckValidEmailAddress(recLogEnvio.DireccionEmail_btc) then begin
                        recLogEnvio.TieneError_btc := true;
                        recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email válida', recCustomer."No.");
                    end;

                    recLogEnvio.NombreCliente_btc := recCustomer.Name;
                    recLogEnvio.clienteFact_btc := recCustomer."No.";
                    recLogEnvio.Insert();
                end;

            until recCabHcoFactVta.Next() = 0;

        recCabHcoAbVta.Reset();
        recCabHcoAbVta.SetRange(FacturacionElec_btc, true);
        recCabHcoAbVta.SetRange(CorreoEnviado_btc, false);
        if recCabHcoAbVta.FindSet() then
            repeat
                if not recLogEnvio.Get(recCabHcoAbVta."Posting Date", recCabHcoAbVta."No.") then begin
                    recLogEnvio.Init();
                    recLogEnvio.FechaDocumento_btc := recCabHcoAbVta."Posting Date";
                    recLogEnvio.CodCliente_btc := recCabHcoAbVta."No.";
                    recLogEnvio.Tipo := recLogEnvio.Tipo::Abono;
                    recLogEnvio.NoDoc_btc := recCabHcoAbVta."No.";
                    recCustomer.Get(recCabHcoAbVta."Bill-to Customer No.");
                    recLogEnvio.DireccionEmail_btc := recCustomer.CorreoFactElec_btc;
                    if recLogEnvio.DireccionEmail_btc = '' then begin
                        recLogEnvio.TieneError_btc := true;
                        recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email configurada', recCustomer."No.");
                    end;

                    clear(cduMailManagement);
                    if not cduMailManagement.CheckValidEmailAddress(recLogEnvio.DireccionEmail_btc) then begin
                        recLogEnvio.TieneError_btc := true;
                        recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email válida', recCustomer."No.");
                    end;
                    recLogEnvio.NombreCliente_btc := recCustomer.Name;
                    recLogEnvio.clienteFact_btc := recCustomer."No.";
                    recLogEnvio.Insert();
                end;
            until recCabHcoAbVta.Next() = 0;


        CorreccionErrores();
        EnvioMail();//Se llama al final con todos los registros
    end;

    local procedure ObtenerRutaFichAdjunto(Fecha: date; NoDoc: code[20]): Text
    var
        recLogEnvio: Record LogEnvioEmailsClientes;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        recCabHcoAbVta: Record "Sales Cr.Memo Header";
        recCustomer: Record Customer;
        reportFactura: Report FacturaNacionalMaquinas;
        reportAbVtaReg: Report AbonoVentaRegistrado;
        reportBrasil: Report FacturaRegBrasil;
        FileMgt: Codeunit "File Management";
        RutaServidor: Text;

    begin
        if not recLogEnvio.Get(Fecha, NoDoc) then
            exit;
        if recLogEnvio.Tipo = recLogEnvio.Tipo::" " then
            exit;

        Clear(FileMgt);
        RutaServidor := FileMgt.ServerTempFileName('pdf');
        recCustomer.get(recLogEnvio.clienteFact_btc);

        if recLogEnvio.Tipo = recLogEnvio.Tipo::Abono then begin
            Clear(reportAbVtaReg);
            recCabHcoAbVta.Reset();
            recCabHcoAbVta.SetRange("No.", NoDoc);
            recCabHcoAbVta.FindFirst();
            reportAbVtaReg.SetTableView(recCabHcoAbVta);
            reportAbVtaReg.SaveAsPdf(RutaServidor);
        end else begin
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", recLogEnvio.NoDoc_btc);
            SalesInvoiceHeader.FindFirst();
            case recCustomer.TipoFormarto_btc of
                recCustomer.TipoFormarto_btc::Brasil:
                    begin
                        clear(reportBrasil);
                        reportBrasil.SetTableView(SalesInvoiceHeader);
                        reportBrasil.SaveAsPdf(RutaServidor);
                    end;
                recCustomer.TipoFormarto_btc::"Exportación":
                    begin
                        clear(reportFactura);
                        reportFactura.EsExportacion();
                        reportFactura.SetTableView(SalesInvoiceHeader);
                        reportFactura.SaveAsPdf(RutaServidor);
                    end;
                recCustomer.TipoFormarto_btc::Lidl:
                    begin
                        clear(reportFactura);
                        reportFactura.EsLidl();
                        reportFactura.SetTableView(SalesInvoiceHeader);
                        reportFactura.SaveAsPdf(RutaServidor);
                    end;
                recCustomer.TipoFormarto_btc::Nacional:
                    begin
                        clear(reportFactura);
                        reportFactura.EsNacional();
                        reportFactura.SetTableView(SalesInvoiceHeader);
                        reportFactura.SaveAsPdf(RutaServidor);
                    end;
            end;
        end;
        exit(RutaServidor);
    end;

    local procedure CorreccionErrores()
    var
        recLogEnvio: Record LogEnvioEmailsClientes;
        recCustomer: Record Customer;
        cduMailManagement: Codeunit "Mail Management";
    begin
        // Corrección de errores anteriores
        recLogEnvio.Reset();
        recLogEnvio.SetRange(TieneError_btc, true);
        recLogEnvio.SetRange(Enviado_btc, false);
        recLogEnvio.SetFilter(Tipo, '%1|%2', recLogEnvio.Tipo::Abono, recLogEnvio.Tipo::Factura);
        if recLogEnvio.FindSet() then
            repeat
                if recCustomer.Get(recLogEnvio.clienteFact_btc) then begin
                    if recLogEnvio.DireccionEmail_btc <> recCustomer.CorreoFactElec_btc then begin
                        recLogEnvio.TieneError_btc := false;
                        recLogEnvio.DescError_btc := '';
                        recLogEnvio.DireccionEmail_btc := recCustomer.CorreoFactElec_btc;
                    end;

                    if recLogEnvio.DireccionEmail_btc = '' then begin
                        recLogEnvio.TieneError_btc := true;
                        recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email configurada', recCustomer."No.");
                        recLogEnvio.Modify();
                    end;

                    clear(cduMailManagement);
                    if not cduMailManagement.CheckValidEmailAddress(recLogEnvio.DireccionEmail_btc) then begin
                        recLogEnvio.TieneError_btc := true;
                        recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email válida', recCustomer."No.");
                        recLogEnvio.Modify();
                    end;
                end;
            until recLogEnvio.Next() = 0;
    end;


    local procedure EnvioMail()
    var
        recCompanyInfo: Record "Company Information";
        recSMTPSetup: Record "SMTP Mail Setup";
        recCabHcoFactVta: Record "Sales Invoice Header";
        recLogEnvio: Record LogEnvioEmailsClientes;
        recCabHcoAbVta: Record "Sales Cr.Memo Header";
        cduSmtp: Codeunit "SMTP Mail";
        txtAsunto: Text;
        txtCuerpo: Text;
    begin
        // Envío email
        recCompanyInfo.Get();
        recSMTPSetup.Get();
        recSMTPSetup.TestField("SMTP Server");
        recSMTPSetup.TestField("User ID");

        recLogEnvio.Reset();
        recLogEnvio.SetRange(Enviado_btc, false);
        recLogEnvio.SetRange(TieneError_btc, false);
        recLogEnvio.SetFilter(Tipo, '%1|%2', recLogEnvio.Tipo::Factura, recLogEnvio.Tipo::Abono);
        //Doble seguro
        recLogEnvio.SetFilter(DireccionEmail_btc, '<>%1', '');
        if recLogEnvio.FindSet() then
            repeat
                txtCuerpo := 'Estimado cliente,<br><br>';
                txtCuerpo += 'Remitimos factura del pedido solicitado.<br><br>';
                txtcuerpo += 'El presente envío sustituye íntegramente lo efectuado tradicionalmente a través de servicio postal. <br><br> ';
                txtCuerpo += 'La factura electrónica es, desde un punto de vista de contenido, totalmente equivalente a una factura'
                + 'en papel.  Es por lo tanto su responsabilidad proceder a la relativa impresión y archivo. La factura está en formato PDF y podrán visualizar e imprimir el adjunto con Acrobat Reader. <br><br>';
                txtCuerpo += 'Aprovechamos para agradecerle su confianza,<br><br> ';
                txtCuerpo += 'Reciban un cordial saludo.<br><br>';
                Clear(cduSmtp);
                cduSmtp.CreateMessage(recCompanyInfo.Name, recSMTPSetup."User ID", recLogEnvio.DireccionEmail_btc, txtAsunto, txtCuerpo, TRUE);
                cduSmtp.AddAttachment(ObtenerRutaFichAdjunto(recLogEnvio.FechaDocumento_btc, recLogEnvio.CodCliente_btc), recLogEnvio.NoDoc_btc + '.pdf');
                cduSmtp.Send();

                if ResultEnvioMailTxt = '' then begin

                    recLogEnvio.Enviado_btc := true;
                    recLogEnvio.FechaEnvio_btc := WorkDate();
                    recLogEnvio.Modify();

                    if recLogEnvio.Tipo = recLogEnvio.Tipo::Factura then begin
                        recCabHcoFactVta.get(recLogEnvio.NoDoc_btc);
                        recCabHcoFactVta.CorreoEnviado_btc := true;
                        recCabHcoFactVta.modify();

                    end;

                    if recLogEnvio.Tipo = recLogEnvio.Tipo::Abono then begin
                        recCabHcoAbVta.get(recLogEnvio.NoDoc_btc);
                        recCabHcoAbVta.CorreoEnviado_btc := true;
                        recCabHcoAbVta.modify();
                    end;
                    //Para asegurarnos que lo que ya esta enviado, si hay algún error después se quede enviada
                    Commit();
                end;
            until recLogEnvio.Next() = 0;
    end;

    procedure AvisosFacturasVencidas()
    var
        recCarteraDoc: Record "Cartera Doc.";
        recCarteraDoc2: Record "Cartera Doc.";
        recLogEnvio: Record LogMailManagement;
        recCustomer: Record Customer;
        recCompanyInfo: Record "Company Information";
        recSMTPSetup: Record "SMTP Mail Setup";
        recTextos: record TextosAuxiliares;
        fechaVencimiento: Date;
        cduMailManagement: Codeunit "Mail Management";
        cduSmtp: Codeunit "SMTP Mail";
        txtAsunto: Text;
        txtCuerpo: Text;
        boolNoEnviar: Boolean;
        ingles: Boolean;
        cduTrampa: Codeunit SMTP_Trampa;
        recSalesSetup: Record "Sales & Receivables Setup";
    begin
        recSalesSetup.Get();
        if recSalesSetup.NumDiasAvisoVencido_btc <= 0 then
            exit;

        fechaVencimiento := calcdate('<-' + format(recSalesSetup.NumDiasAvisoVencido_btc) + 'D>', WorkDate());

        recCarteraDoc.Reset();
        recCarteraDoc.SetFilter("Due Date", '<=%1', fechaVencimiento);
        recCarteraDoc.SetRange(Type, recCarteraDoc.Type::Receivable);
        recCarteraDoc.SetRange("Collection Agent", recCarteraDoc."Collection Agent"::Bank);
        if recCarteraDoc.FindSet() then
            repeat
                boolNoEnviar := false;

                recCustomer.Get(recCarteraDoc."Account No.");
                recTextos.Reset();
                recTextos.SetRange(TipoRegistro, recTextos.TipoRegistro::Tabla);
                recTextos.SetRange(TipoTabla, recTextos.TipoTabla::GrupoCliente);
                recTextos.SetRange(NumReg, recCustomer.GrupoCliente_btc);
                if not recTextos.FindFirst() or (recTextos.FindFirst() and recTextos.NoEnviarMailVencimientos) then
                    boolNoEnviar := true;

                recCarteraDoc2.Reset();
                recCarteraDoc2.SetRange("Due Date", fechaVencimiento);
                recCarteraDoc2.SetRange(Type, recCarteraDoc.Type::Receivable);
                recCarteraDoc2.SetRange("Collection Agent", recCarteraDoc."Collection Agent"::Bank);
                recCarteraDoc2.SetRange("Account No.", recCarteraDoc."Account No.");
                if not recCarteraDoc2.FindFirst() then
                    boolNoEnviar := true;


                if not boolNoEnviar then begin
                    recLogEnvio.Reset();
                    recLogEnvio.SetRange(FechaDocumento_btc, fechaVencimiento);
                    recLogEnvio.SetRange(CodCliente_btc, recCarteraDoc."Account No.");
                    recLogEnvio.SetRange(Tipo, recLogEnvio.Tipo::"Facturas Vencidas");
                    if not recLogEnvio.FindFirst() then begin
                        recLogEnvio.Init();
                        recLogEnvio.Entry_No := 0;
                        recLogEnvio.Insert(true);

                        recLogEnvio.FechaDocumento_btc := fechaVencimiento;
                        recLogEnvio.CodCliente_btc := recCarteraDoc."Account No.";
                        reclogenvio.Importe_btc := recCarteraDoc."Remaining Amount";
                        recLogEnvio.Tipo := recLogEnvio.Tipo::"Facturas Vencidas";

                        recCustomer.Get(recCarteraDoc."Account No.");

                        recLogEnvio.NombreCliente_btc := recCustomer.Name;

                        recLogEnvio.DireccionEmail_btc := recCustomer.CorreoFactElec_btc;

                        if recLogEnvio.DireccionEmail_btc = '' then begin
                            recLogEnvio.TieneError_btc := true;
                            recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email configurada', recCustomer."No.");
                        end else begin
                            clear(cduMailManagement);
                            if not cduMailManagement.CheckValidEmailAddress(recLogEnvio.DireccionEmail_btc) then begin
                                recLogEnvio.TieneError_btc := true;
                                recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email válida', recCustomer."No.");
                            end;
                        end;

                        recLogEnvio.Modify();
                    end else begin
                        if not recLogEnvio.Enviado_btc then begin
                            reclogenvio.Importe_btc += recCarteraDoc."Remaining Amount";
                            recLogEnvio.Modify();
                        end;
                    end;
                end;
            until recCarteraDoc.Next() = 0;

        // Corrección de errores anteriores
        VencimientosErroresAnteriores(fechaVencimiento, recLogEnvio.Tipo::"Facturas Vencidas");

        // Envío email
        recCompanyInfo.Get();
        recSMTPSetup.Get();
        recSMTPSetup.TestField("SMTP Server");
        recSMTPSetup.TestField("User ID");

        recLogEnvio.Reset();
        //recLogEnvio.SetRange(FechaDocumento_btc, fechaVencimiento);
        recLogEnvio.SetRange(Enviado_btc, false);
        recLogEnvio.SetRange(TieneError_btc, false);
        recLogEnvio.SetRange(Tipo, recLogEnvio.Tipo::"Facturas Vencidas");
        if recLogEnvio.FindSet() then
            repeat
                recCustomer.Get(recLogEnvio.CodCliente_btc);
                //SOTHIS EBR 030920 id159644
                if recCustomer."Language Code" <> 'ESP' then
                    //fin SOTHIS EBR 030920 id159644
                    ingles := true
                else
                    ingles := false;
                //fin SOTHIS EBR 030920 id159644
                if not ingles then begin
                    txtAsunto := 'Recordatorio facturas vencidas';
                    txtCuerpo := 'Estimado cliente:';
                    txtCuerpo += '<br><br>Adjuntamos relación de facturas que, salvo error, figuran como pendientes de cobro:<br>';
                end else begin
                    txtAsunto := 'Automated reminder of overdue invoices';
                    txtCuerpo := 'Dear Customer,';
                    txtCuerpo += '<br><br>We would like to notify you that the following payments are still due.<br>';
                end;


                txtCuerpo += GetCabeceraTabla(ingles);

                recCarteraDoc.Reset();
                recCarteraDoc.SetFilter("Due Date", '<=%1', fechaVencimiento);
                recCarteraDoc.SetRange("Account No.", recLogEnvio.CodCliente_btc);
                recCarteraDoc.SetRange(Type, recCarteraDoc.Type::Receivable);
                recCarteraDoc.SetRange("Collection Agent", recCarteraDoc."Collection Agent"::Bank);
                if recCarteraDoc.FindSet() then
                    txtCuerpo += GetHtmlDocumentos(recCarteraDoc, '');

                txtCuerpo += GetFooterTabla(recLogEnvio.Importe_btc);

                if not ingles then begin
                    txtCuerpo += 'La información mostrada ha sido obtenida en el momento de generar este informe y puede haber sufrido cambios. En caso de haber realizado el pago de las facturas relacionadas, consideren este correo sin validez.';
                    txtCuerpo += '<br><br>Para cualquier consulta contacte con el Departamento de Administración.';
                    txtCuerpo += '<br><br>Sin otro particular, reciba un cordial saludo. <br><br>';
                end else begin
                    txtCuerpo += 'The Information shown has been obtained at the time of this report and may have suffered some modifications. In case the payments have already been made, please discard this e-mail.';
                    txtCuerpo += '<br><br>If you have any further queries, please contact the Administration department.';
                    txtCuerpo += '<br><br>Kind regards. <br><br>';
                end;

                clear(cduTrampa);
                cduTrampa.CreateMessage(recCompanyInfo.Name, recSMTPSetup."User ID", recLogEnvio.DireccionEmail_btc, txtAsunto, txtCuerpo, recCompanyInfo.Name, recSMTPSetup.UsuarioVencimientos);
                cduTrampa.SendSmtpMail();

                recLogEnvio.Enviado_btc := true;
                recLogEnvio.FechaEnvio_btc := WorkDate();
                recLogEnvio.Modify();
            until recLogEnvio.Next() = 0;
    end;

    procedure AvisosVencimientos()
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recCarteraDoc: Record "Cartera Doc.";
        recLogEnvio: Record LogMailManagement;
        recCustomer: Record Customer;
        recCompanyInfo: Record "Company Information";
        recSMTPSetup: Record "SMTP Mail Setup";
        recTextos: record TextosAuxiliares;
        cduMailManagement: Codeunit "Mail Management";
        cduSmtp: Codeunit "SMTP Mail";
        cduTrampa: Codeunit SMTP_Trampa;
        fechaVencimiento: Date;
        txtAsunto: Text;
        txtCuerpo: Text;
        boolNoEnviar: Boolean;
        ingles: Boolean;
    begin
        recSalesSetup.Get();

        if recSalesSetup.NumDiasAvisoVencimiento_btc <= 0 then
            exit;

        fechaVencimiento := calcdate('<+' + format(recSalesSetup.NumDiasAvisoVencimiento_btc) + 'D>', WorkDate());

        // Preparar envío email
        recCarteraDoc.Reset();
        recCarteraDoc.Setrange("Due Date", fechaVencimiento);
        recCarteraDoc.SetRange(Type, recCarteraDoc.Type::Receivable);
        recCarteraDoc.SetRange("Collection Agent", recCarteraDoc."Collection Agent"::Bank);
        //recCarteraDoc.SetFilter("Bill Gr./Pmt. Order No.", '<>%1', '');        
        if recCarteraDoc.FindSet() then
            repeat
                boolNoEnviar := false;

                recCustomer.Get(recCarteraDoc."Account No.");
                recTextos.Reset();
                recTextos.SetRange(TipoRegistro, recTextos.TipoRegistro::Tabla);
                recTextos.SetRange(TipoTabla, recTextos.TipoTabla::GrupoCliente);
                recTextos.SetRange(NumReg, recCustomer.GrupoCliente_btc);
                if not recTextos.FindFirst() or (recTextos.FindFirst() and recTextos.NoEnviarMailVencimientos) then
                    boolNoEnviar := true;

                if not boolNoEnviar then begin
                    recLogEnvio.Reset();
                    recLogEnvio.SetRange(FechaDocumento_btc, fechaVencimiento);
                    recLogEnvio.SetRange(CodCliente_btc, recCarteraDoc."Account No.");
                    recLogEnvio.SetRange(Tipo, recLogEnvio.Tipo::"Prox. Vencimientos");
                    if not recLogEnvio.FindFirst() then begin
                        recLogEnvio.Init();
                        recLogEnvio.Entry_No := 0;
                        recLogEnvio.Insert(true);

                        recLogEnvio.FechaDocumento_btc := fechaVencimiento;
                        recLogEnvio.CodCliente_btc := recCarteraDoc."Account No.";
                        reclogenvio.Importe_btc := recCarteraDoc."Remaining Amount";
                        recLogEnvio.Tipo := recLogEnvio.Tipo::"Prox. Vencimientos";

                        recCustomer.Get(recCarteraDoc."Account No.");

                        recLogEnvio.NombreCliente_btc := recCustomer.Name;
                        recLogEnvio.DireccionEmail_btc := recCustomer.CorreoFactElec_btc;


                        if recLogEnvio.DireccionEmail_btc = '' then begin
                            recLogEnvio.TieneError_btc := true;
                            recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email configurada', recCustomer."No.");
                        end else begin
                            clear(cduMailManagement);
                            if not cduMailManagement.CheckValidEmailAddress(recLogEnvio.DireccionEmail_btc) then begin
                                recLogEnvio.TieneError_btc := true;
                                recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email válida', recCustomer."No.");
                            end;
                        end;

                        recLogEnvio.Modify();
                    end else begin
                        if not recLogEnvio.Enviado_btc then begin
                            reclogenvio.Importe_btc += recCarteraDoc."Remaining Amount";
                            recLogEnvio.Modify();
                        end;
                    end;
                end;
            until recCarteraDoc.Next() = 0;

        // Corrección de errores anteriores
        VencimientosErroresAnteriores(fechaVencimiento, recLogEnvio.Tipo::"Prox. Vencimientos");

        // Envío email
        recCompanyInfo.Get();
        recSMTPSetup.Get();
        recSMTPSetup.TestField("SMTP Server");
        recSMTPSetup.TestField("User ID");

        recLogEnvio.Reset();
        recLogEnvio.SetRange(Enviado_btc, false);
        recLogEnvio.SetRange(TieneError_btc, false);
        recLogEnvio.SetRange(Tipo, recLogEnvio.Tipo::"Prox. Vencimientos");
        if recLogEnvio.FindSet() then
            repeat
                recCustomer.Get(recLogEnvio.CodCliente_btc);
                if recCustomer."Language Code" <> 'ESP' then
                    ingles := false
                else
                    ingles := true;

                if not ingles then begin
                    txtAsunto := 'Recordatorio próximos vencimientos';
                    txtCuerpo := 'Estimado cliente:';
                    txtCuerpo += '<br><br>Le informamos de los vencimientos próximos para que pueda planificar sus pagos:<br>';
                end else begin
                    txtAsunto := 'Automated Reminder of next payment';
                    txtCuerpo := 'Dear Customer,';
                    txtCuerpo += '<br><br>We would like to notify you of the upcoming invoice due dates so that you can plan your payments:<br>';
                end;


                txtCuerpo += GetCabeceraTabla(ingles);

                recCarteraDoc.Reset();
                recCarteraDoc.setrange("Due Date", fechaVencimiento);
                recCarteraDoc.SetRange("Account No.", recLogEnvio.CodCliente_btc);
                recCarteraDoc.SetRange(Type, recCarteraDoc.Type::Receivable);
                recCarteraDoc.SetRange("Collection Agent", recCarteraDoc."Collection Agent"::Bank);
                if not recCarteraDoc.FindSet() then begin
                    recLogEnvio.Enviado_btc := true;
                    recLogEnvio.FechaEnvio_btc := WorkDate();
                    recLogEnvio.Modify();
                end else begin
                    txtCuerpo += GetHtmlDocumentos(recCarteraDoc, '');

                    txtCuerpo += GetFooterTabla(recLogEnvio.Importe_btc);

                    if not ingles then begin
                        txtCuerpo += 'La información mostrada ha sido obtenida en el momento de generar este informe y puede haber sufrido cambios. En caso de haber realizado el pago de las facturas relacionadas, consideren este correo sin validez.';
                        txtCuerpo += '<br><br>Para cualquier consulta contacte con el Departamento de Administración.';
                        txtCuerpo += '<br><br>Sin otro particular, reciba un cordial saludo. <br><br>';
                    end else begin
                        txtCuerpo += 'The Information shown has been obtained at the time of this report and may have suffered some modifications. In case the payments have already been made, please disregard this e-mail.';
                        txtCuerpo += '<br><br>If you have any further queries, please contact the Administration department.';
                        txtCuerpo += '<br><br>Kind regards. <br><br>';
                    end;

                    clear(cduTrampa);
                    cduTrampa.CreateMessage(recCompanyInfo.Name, recSMTPSetup."User ID", recLogEnvio.DireccionEmail_btc, txtAsunto, txtCuerpo, recCompanyInfo.Name, recSMTPSetup.UsuarioVencimientos);
                    cduTrampa.SendSmtpMail();

                    recLogEnvio.Enviado_btc := true;
                    recLogEnvio.FechaEnvio_btc := WorkDate();
                    recLogEnvio.Modify();
                end;
            until recLogEnvio.Next() = 0;
    end;

    // Vencimientos corrección errores anteriores
    local procedure VencimientosErroresAnteriores(fechaVencimiento: Date; tipoLog: Integer)
    var
        recLogEnvio: Record LogMailManagement;
        recCustomer: Record Customer;
        cduMailManagement: Codeunit "Mail Management";
    begin
        exit;

        recLogEnvio.Reset();
        recLogEnvio.SetFilter(FechaDocumento_btc, '<%1', fechaVencimiento);
        recLogEnvio.SetRange(TieneError_btc, true);
        recLogEnvio.SetRange(Enviado_btc, false);
        recLogEnvio.SetRange(Tipo, tipoLog);
        if recLogEnvio.FindSet() then
            repeat
                if recCustomer.Get(recLogEnvio.CodCliente_btc) then
                    if recLogEnvio.DireccionEmail_btc <> recCustomer.CorreoFactElec_btc then begin
                        recLogEnvio.TieneError_btc := false;
                        recLogEnvio.DescError_btc := '';
                        recLogEnvio.DireccionEmail_btc := recCustomer.CorreoFactElec_btc;

                        if recLogEnvio.DireccionEmail_btc = '' then begin
                            recLogEnvio.TieneError_btc := true;
                            recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email configurada', recCustomer."No.");
                        end else begin
                            clear(cduMailManagement);
                            if not cduMailManagement.CheckValidEmailAddress(recLogEnvio.DireccionEmail_btc) then begin
                                recLogEnvio.TieneError_btc := true;
                                recLogEnvio.DescError_btc := StrSubstNo('Cliente: %1 no tiene dirección de email válida', recCustomer."No.");
                            end;
                        end;

                        recLogEnvio.Modify();
                    end;
            until recLogEnvio.Next() = 0;
    end;

    local procedure GetHtmlDocumentos(var pRecCartera: Record "Cartera Doc."; textoHtml: Text): Text
    begin
        textoHtml += '<tr style="border: 1px solid black;">';
        if pRecCartera."Document No." = 'APERTURA CLIENTES' THEN
            pRecCartera."Document No." := pRecCartera."No.";
        textoHtml +=
            '<td style="border: 1px solid black; text-align: center;">' +
                Format(pRecCartera."Posting Date") +
            '</td>' +
            '<td style="border: 1px solid black; text-align: center;">' +
                Format(pRecCartera."Due Date") +
            '</td>' +
            '<td style="border: 1px solid black; text-align: center;">' +
                pRecCartera."Document No." +
            '</td>' +
            '<td style="border: 1px solid black; text-align: right; padding-right: 3px;">' +
                Format(pRecCartera."Remaining Amount", 0, '<Precision,2><sign><Integer Thousand><Decimals>') +
            '</td>';

        textoHtml += '</tr>';

        if pRecCartera.Next() <> 0 then
            exit(GetHtmlDocumentos(pRecCartera, textoHtml))
        else
            exit(textoHtml);
    end;

    local procedure GetCabeceraTabla(pIngles: Boolean): text
    var
        textoHtml: Text;
        txtFactura: Text;
        txtFechaVencimiento: Text;
        txtFechaFactura: Text;
        txtImporte: Text;
    begin
        if not pIngles then begin
            txtFactura := 'Factura';
            txtFechaVencimiento := 'Fecha vencimiento';
            txtFechaFactura := 'Fecha factura';
            txtImporte := 'Importe';
        end else begin
            txtFactura := 'Invoice number';
            txtFechaVencimiento := 'Due date';
            txtFechaFactura := 'Post date';
            txtImporte := 'Amount';
        end;

        textoHtml := '<br><br>';

        textoHtml +=
            '<table style="width:100%; border-collapse: collapse;">' +
                '<tr style="border: 1px solid black;">' +
                    '<td style="border: 1px solid black; text-align: center;">' +
                        txtFechaFactura +
                    '</td>' +
                    '<td style="border: 1px solid black; text-align: center;">' +
                        txtFechaVencimiento +
                    '</td>' +
                    '<td style="border: 1px solid black; text-align: center;">' +
                        txtFactura +
                    '</td>' +
                    '<td style="border: 1px solid black; text-align: center;">' +
                        txtImporte +
                    '</td>' +
                '</tr>';

        exit(textoHtml);
    end;

    local procedure GetFooterTabla(pImporte: Decimal): Text
    var
        textoHtml: Text;
    begin
        textoHtml := '';

        textoHtml +=
            '<tr style="border: 1px solid black;">' +
                '<td>' +

                '</td>' +
                '<td>' +

                '</td>' +
                '<td>' +

                '</td>' +
                '<td style="border: 1px solid black; text-align: right;">' +
                    Format(pImporte, 0, '<Precision,2><sign><Integer Thousand><Decimals>') +
                '</td>' +
            '</tr>' +
        '</table>';

        exit(textoHtml + '<br><br>');
    end;

    //400 --> SMTP Mail
    [EventSubscriber(ObjectType::Codeunit, 400, 'OnAfterTrySend', '', false, false)]
    local procedure ResultadoEnvioMail(var SendResult: Text)
    begin
        ResultEnvioMailTxt := SendResult;
    end;

    local procedure CalculateVtoAseguradora()
    var
        Funciones: Codeunit Funciones;
    begin
        Funciones.CustomerCalculateFechaVto();
    end;

    procedure AvisosFacturasVencidasTodosAreaManager(var TextosAux: Record TextosAuxiliares)
    var

        Salesperson: Record "Salesperson/Purchaser";
        Customer: Record Customer;
        MovsCustomer: Record "Cust. Ledger Entry";
        ExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Record TempBlob;
    begin

        if Ejecucioncola then
            CreateTotalExcelBuffer();

        TextosAux.SetRange(TipoTabla, TextosAux.TipoTabla::AreaManager);
        if TextosAux.FindSet() then
            repeat
                if Salesperson.Get(TextosAux.NumReg) then begin
                    if Salesperson."E-Mail" <> '' then begin
                        Customer.SetRange(AreaManager_btc, Salesperson.Code);

                        //Exportacion Excel
                        if ExportarFacturasVencidasClientesExcel(Customer, MovsCustomer, ExcelBuffer, Salesperson, false, TempBlob) then
                            //Enviar Correo
                            EnvioCorreoFacturasVencidasClientes(Salesperson, 'Facturas Vencidas.xlsx', ExcelBuffer, TempBlob);
                    end;
                end;
            until TextosAux.Next() = 0;
        if Ejecucioncola then
            EnvioCorreoElectronicoJefes();
    end;

    local procedure CreateTotalExcelBuffer()
    var
        Customer: Record customer;
    begin
        TotalExcelBuffer.DeleteAll();
        //1ª Hoja Resumen
        TotalExcelBuffer.CreateNewBook('Facturas Vencidas');
        TotalExcelBuffer.NewRow();
        TotalExcelBuffer.NewRow();
        TotalExcelBuffer.AddColumn('Area Manager', false, '', true, false, false, '', TotalExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.AddColumn(Customer.FieldCaption("No."), false, '', true, false, false, '', TotalExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.AddColumn(Customer.FieldCaption(Name), false, '', true, false, false, '', TotalExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.AddColumn(Customer.FieldCaption("Payment Method Code"), false, '', true, false, false, '', TotalExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.AddColumn('Total Importe Pendiente', false, '', true, false, false, '', TotalExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.NewRow();
    end;

    procedure AvisosFacturasVencidasAreaManager(CodigoAreaManager: Code[20])
    var
        TextosAux: Record TextosAuxiliares;
        Salesperson: Record "Salesperson/Purchaser";
        Customer: Record Customer;
        MovsCustomer: Record "Cust. Ledger Entry";
        ExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Record TempBlob;
    begin
        TextosAux.SetRange(TipoTabla, TextosAux.TipoTabla::AreaManager);
        TextosAux.SetRange(NumReg, CodigoAreaManager);
        if TextosAux.FindSet() then begin
            if Salesperson.Get(TextosAux.NumReg) then begin
                if Salesperson."E-Mail" <> '' then begin
                    Customer.SetRange(AreaManager_btc, Salesperson.Code);

                    //Exportacion Excel
                    ExportarFacturasVencidasClientesExcel(Customer, MovsCustomer, ExcelBuffer, Salesperson, true, TempBlob);

                end;
            end;
        end;
    end;

    local procedure ExportarFacturasVencidasClientesExcel(var Customer: Record Customer; var MovsCustomer: Record "Cust. Ledger Entry"; var ExcelBuffer: Record "Excel Buffer"; Salesperson: Record "Salesperson/Purchaser"; GuardarExcel: Boolean; var TempBlob: Record TempBlob) ExistenClientes: Boolean;
    var
        CompanyInfo: Record "Company Information";
        // ExcelFileName: Label 'Facturas Vencidas Clientes';
        ExcelFileName: Text;
        BookName: Text;
        importeTotalPendiente: Decimal;
        CurrentRow: Integer;

        FileMngt: Codeunit "File Management";
        OutStr: OutStream;
        InStr: InStream;
    begin
        CurrentRow := 6;

        //Exportacion a Excel
        CompanyInfo.Get();
        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();
        //1ª Hoja Resumen
        ExcelBuffer.CreateNewBook('Facturas Vencidas');
        ExcelBuffer.AddColumn('Codigo', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Salesperson.Code, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Nombre', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Salesperson.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Email', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Salesperson."E-Mail", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(Customer.FieldCaption("No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Customer.FieldCaption(Name), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Customer.FieldCaption("Payment Method Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Importe Pendiente', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.WriteSheet('Facturas Vencidas', CompanyInfo.Name, Customer."No.");

        //Hojas Clientes
        if Customer.FindSet() then begin
            repeat
                importeTotalPendiente := 0;

                ExcelBuffer.DeleteAll();
                ExcelBuffer.SetCurrent(0, 0);
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn('Cliente', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn('Nombre', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn('Cód. Forma Pago', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Customer."Payment Method Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow();
                ExcelBuffer.NewRow();
                ExcelBuffer.NewRow();

                ExcelBuffer.AddColumn('Tipo', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Nº Documento', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Fecha', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Fecha Vto.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Estado', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Importe', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Importe Pendiente', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow();

                if ExportarFacturasVencidasClienteExcel(Customer, MovsCustomer, importeTotalPendiente, ExcelBuffer, CompanyInfo) then begin
                    BookName := CopyStr(Customer."No." + ' - ' + Customer.Name, 1, 50);
                    ExcelBuffer.SelectOrAddSheet(BookName);
                    ExcelBuffer.WriteSheet(BookName, CompanyInfo.Name, Customer."No.");
                    // actualizamos el total del resumen del area manager
                    añadirResumenFacturasVencidasClientes(Customer, importeTotalPendiente, CurrentRow, ExcelBuffer, CompanyInfo);
                    // actualizamos el resumen de los jefes
                    if Ejecucioncola then
                        TotalAñadirResumenFacturasVencidasClientes(Customer.AreaManager_btc, Customer, importeTotalPendiente, CurrentRow, ExcelBuffer, CompanyInfo);
                    CurrentRow += 1;
                    ExistenClientes := true;
                end;
            until (Customer.Next() = 0);
        end;

        // ponemos la formula del total en el Resumen
        añadirTotalResumenFacturasVencidasClientes(Customer, importeTotalPendiente, CurrentRow, ExcelBuffer, CompanyInfo);

        if ExistenClientes then begin
            ExcelBuffer.CloseBook();
            ExcelFileName := 'Facturas Vencidas Clientes ' + Salesperson.Code;
            ExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, Customer.AreaManager_btc));
            if GuardarExcel then begin
                ExcelBuffer.OpenExcel();
            end else begin
                TempBlob.blob.CreateOutStream(OutStr);
                ExcelBuffer.SaveToStream(OutStr, true);
            end;
        end;
    end;

    local procedure ExportarFacturasVencidasClienteExcel(var Customer: Record Customer; var MovsCustomer: Record "Cust. Ledger Entry"; var importeTotalPendiente: Decimal; var ExcelBuffer: Record "Excel Buffer"; CompanyInfo: Record "Company Information"): Boolean
    var
        BookName: Text;
        existenFacturas: Boolean;
    begin
        MovsCustomer.SetRange("Customer No.", Customer."No.");
        MovsCustomer.SetRange("Document Status", MovsCustomer."Document Status"::Open);
        MovsCustomer.SetFilter("Document Type", '%1|%2', MovsCustomer."Document Type"::Invoice, MovsCustomer."Document Type"::Bill);

        if MovsCustomer.FindSet() then
            repeat
                MovsCustomer.CalcFields(Amount);
                MovsCustomer.CalcFields("Remaining Amount");

                if (MovsCustomer."Due Date" < WorkDate()) AND (MovsCustomer."Remaining Amount" > 0) then begin
                    // Añadir datos Facturas Vencidas a la Hoja
                    ExcelBuffer.AddColumn(MovsCustomer."Document Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovsCustomer."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovsCustomer."Document Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn(MovsCustomer."Due Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn(MovsCustomer."Document Status", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovsCustomer.Amount, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(MovsCustomer."Remaining Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.NewRow();

                    importeTotalPendiente += MovsCustomer."Remaining Amount";

                    existenFacturas := true;
                end;
            until MovsCustomer.Next() = 0;

        exit(existenFacturas);
    end;

    local procedure añadirResumenFacturasVencidasClientes(Customer: Record Customer; var importeTotalPendiente: Decimal; CurrentRow: Integer; var ExcelBuffer: Record "Excel Buffer"; CompanyInfo: Record "Company Information")
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.SetCurrent(CurrentRow, 0);

        ExcelBuffer.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Customer."Payment Method Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(importeTotalPendiente, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.SelectOrAddSheet('Facturas Vencidas');
        ExcelBuffer.WriteSheet('Facturas Vencidas', CompanyInfo.Name, Customer."No.");

    end;

    local procedure TotalAñadirResumenFacturasVencidasClientes(AreaManager: text; Customer: Record Customer; var importeTotalPendiente: Decimal; CurrentRow: Integer; var ExcelBuffer: Record "Excel Buffer"; CompanyInfo: Record "Company Information")
    begin

        TotalExcelBuffer.AddColumn(AreaManager, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.AddColumn(Customer."Payment Method Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        TotalExcelBuffer.AddColumn(importeTotalPendiente, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        TotalExcelBuffer.NewRow();

    end;

    local procedure añadirTotalResumenFacturasVencidasClientes(Customer: Record Customer; var importeTotalPendiente: Decimal; CurrentRow: Integer; var ExcelBuffer: Record "Excel Buffer"; CompanyInfo: Record "Company Information")
    var
        Formula: text;
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.SetCurrent(CurrentRow, 3);
        Formula := '=suma(C6:C' + format(CurrentRow - 1) + ')';
        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.SelectOrAddSheet('Facturas Vencidas');
        ExcelBuffer.WriteSheet('Facturas Vencidas', CompanyInfo.Name, Customer."No.");

    end;

    local procedure EnvioCorreoElectronicoJefes()
    var
        Salesperson: Record "Salesperson/Purchaser";
        TempBlob: Record TempBlob;
        OutStr: OutStream;
    begin
        TempBlob.blob.CreateOutStream(OutStr);
        TotalExcelBuffer.WriteSheet('Facturas Vencidas', '', '');
        TotalExcelBuffer.CloseBook();
        TotalExcelBuffer.SaveToStream(OutStr, true);
        Salesperson.SetRange("Send email due invocies", true);
        if Salesperson.findset() then
            repeat
                EnvioCorreoFacturasVencidasClientes(Salesperson, 'Facturas Vencidas.xlsx', TotalExcelBuffer, TempBlob);
            Until Salesperson.next() = 0;
    end;

    local procedure EnvioCorreoFacturasVencidasClientes(Salesperson: Record "Salesperson/Purchaser"; BookName: Text; var ExcelBuffer: Record "Excel Buffer"; var TempBlob: Record TempBlob)
    var
        recCompanyInfo: Record "Company Information";
        recSMTPSetup: Record "SMTP Mail Setup";
        cduMailManagement: Codeunit "Mail Management";
        cduSmtp: Codeunit "SMTP Mail";
        txtAsunto: Text;
        txtCuerpo: Text;
        cduTrampa: Codeunit SMTP_Trampa;
        InStr: InStream;
    begin
        // TempBlob.Blob.CreateOutStream(OutStr);
        // ExcelBuffer.SaveToStream(OutStr, true);
        TempBlob.Blob.CreateInStream(InStr);

        //Envio Email a SalesPerson con Excel
        recCompanyInfo.Get();
        recSMTPSetup.Get();
        recSMTPSetup.TestField("SMTP Server");
        recSMTPSetup.TestField("User ID");

        txtAsunto := 'Recordatorio facturas vencidas';
        txtCuerpo := 'Buenos dias ' + Salesperson.Name;
        txtCuerpo += '<br><br>Adjuntamos el listado de facturas de tus correspondientes clientes, vencidas y pendientes de cobro.<br>';
        txtCuerpo += '<br><br>';
        txtCuerpo += '<br><br>Un cordial Saludo.<br>';

        clear(cduSmtp);
        cduSmtp.CreateMessage(recCompanyInfo.Name, recSMTPSetup."User ID", Salesperson."E-Mail", txtAsunto, txtCuerpo, TRUE);
        cduSmtp.AddAttachmentStream(InStr, BookName);
        cduSmtp.Send();

    end;
}