report 50145 "OrdenPago-Confirming CaixaBank"
{
    // Confirming Caixa.
    // //001 TSC 110719 Requerir marcar el check 'Exportar Pago electrónico' en la Orden de Pago
    // //002 TSC 110719 Poner ruta de exportación parametrizada en Info Empresa
    // //003 TSC 110719 Valor de campo Oficina, en Request Page por defecto (Text Constant)
    // //004 TSC 120719 Valor de campo Número de Contrato, en RequestPage por defecto
    // //005 TSC 120719 Buscar e informar abono
    // //006 TSC 170719 No informar CCC si el tipo de pago es cheque
    // //007 TSC 050919 Marcar como exportado
    // //008 TSC 01042020 Parche para encontrar Factura de Compra que viene de Recircular Facturas:

    Permissions = TableData "Payment Order" = m;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payment Order"; "Payment Order")
        {
            RequestFilterFields = "No.", "Due Date Filter";
            dataitem("Cartera Doc."; "Cartera Doc.")
            {
                DataItemLink = "Bill Gr./Pmt. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "Bill Gr./Pmt. Order No.", "Currency Code", "Account No.", "Due Date", "Document Type")
                                    ORDER(Ascending)
                                    WHERE(Type = CONST(Payable));

                trigger OnAfterGetRecord()
                begin
                    TESTFIELD("Payment Method Code");
                    ///TipoDoc2 := DocVarios.DocType3("Payment Method Code");
                    TipoDoc2 := DocVarios.DocType2("Payment Method Code");

                    CLEAR(W_FormaPago);
                    IF TipoDoc2 = '4' THEN BEGIN
                        W_FormaPago := 'C';
                    END;
                    IF TipoDoc2 = '5' THEN BEGIN
                        W_FormaPago := 'T';
                    END;
                    IF W_FormaPago = ''
                      THEN
                        ERROR(Txt002, "Document No.");

                    TESTFIELD("Account No.");
                    Proveedor.GET("Account No.");

                    IVARegProv := Proveedor."VAT Registration No.";
                    IVARegProv := PADSTR('', MAXSTRLEN(IVARegProv) - STRLEN(IVARegProv), ' ') + IVARegProv;
                    ImportePdte := PADSTR('', MAXSTRLEN(ImportePdte) - STRLEN(ImportePdte), '0') + ImportePdte;
                    ProvNtraCta := COPYSTR(Proveedor."Our Account No.", 1, MAXSTRLEN(ProvNtraCta));

                    CLEAR(NomPais);
                    CLEAR(W_ISOPaisDestino);
                    IF Pais.GET(Proveedor."Country/Region Code") THEN BEGIN
                        NomPais := PADSTR(Pais.Name, 9, ' ');
                        W_ISOPaisDestino := Pais."EU Country/Region Code";
                    END;

                    CASE TRUE OF
                        DL = DL::Peseta:
                            IF EsEuro THEN BEGIN
                                ImporteTotal := "Remaining Amount";
                                ImportePdte := ImpEuro(ImporteTotal);
                            END ELSE BEGIN
                                ImportePdte := FORMAT("Remaining Amt. (LCY)" * 100, 12, '<Integer>');
                                ImporteTotal := "Remaining Amount";
                            END;
                        DL = DL::Euro:
                            IF EsEuro THEN BEGIN
                                ImporteTotal := "Remaining Amount";
                                ImportePdte := ImpEuro(ImporteTotal);
                            END ELSE BEGIN
                                ImportePdte := FORMAT("Remaining Amount" * 100, 12, '<Integer>');
                                ImporteTotal := "Remaining Amount";
                            END;
                        DL = DL::Otro:
                            IF EsEuro THEN BEGIN
                                ImporteTotal := "Remaining Amount";
                                ImportePdte := ImpEuro(ImporteTotal);
                            END ELSE BEGIN
                                ImportePdte := FORMAT("Remaining Amount" * 100, 12, '<Integer>');
                                ImporteTotal := "Remaining Amount" * 100;
                            END;
                    END;

                    ProvCCCNoCta := '';
                    ProvCCCDigControl := '';
                    ProvCCCBanco := '';
                    ProvCCCNoSucBanco := '';
                    ProvDCIBAN := '';
                    ProvBIC := '';
                    ProvBBAN := '';

                    ProvCodBanco := "Cust./Vendor Bank Acc. Code";
                    IF TipoDoc2 <> '4' THEN BEGIN   //006 TSC 170719 No informar CCC si el tipo de pago es cheque
                        IF BancoProv.GET("Account No.", ProvCodBanco) THEN BEGIN
                            ProvCCCNoCta := BancoProv."CCC Bank Account No.";
                            ProvCCCDigControl := BancoProv."CCC Control Digits";
                            ProvCCCBanco := BancoProv."CCC Bank No.";
                            ProvCCCNoSucBanco := BancoProv."CCC Bank Branch No.";
                            ProvDCIBAN := COPYSTR(BancoProv.IBAN, 3, 2);
                            ProvBIC := COPYSTR(BancoProv."SWIFT Code", 1, 12);
                            ProvBBAN := BancoProv."CCC No.";
                        END;
                    END;

                    /*//TSC 101019 Comentamos para Forma Pago=Tipo TRANSFERENCIA, no pida estos datos
                    IF TipoDoc2 = '5' THEN BEGIN
                      TESTFIELD("Cust./Vendor Bank Acc. Code");
                      IF (ProvCCCBanco = '') OR (ProvCCCNoSucBanco = '') OR
                       (ProvCCCDigControl = '') OR (ProvCCCNoCta = '')
                      THEN
                        ERROR(Txt003,BancoProv."Vendor No.");
                    END;*/

                    IF TipoDoc2 <> '4' THEN BEGIN   //006 TSC 170719 No informar CCC si el tipo de pago es cheque
                        ProvCCCNoCta := PADSTR('', MAXSTRLEN(ProvCCCNoCta) - STRLEN(ProvCCCNoCta), '0') + ProvCCCNoCta;
                        ProvCCCDigControl := PADSTR('', MAXSTRLEN(ProvCCCDigControl) - STRLEN(ProvCCCDigControl), '0')
                          + ProvCCCDigControl;
                    END;

                    IF EsEuro THEN
                        IF TipoDoc2 <> '5' THEN
                            TipoDoc := '57'
                        ELSE BEGIN
                            TipoDoc := '56';
                            //IF NOT BancoProv.ISEMPTY THEN   //TSC 101019 Modifico para Forma Pago=Tipo TRANSFERENCIA, pida este dato sólo si venimos posicionados
                            //IF BancoProv.FINDSET THEN   //TSC 101019 Modifico para Forma Pago=Tipo TRANSFERENCIA, pida este dato sólo si venimos posicionados
                            IF BancoProv.GET("Account No.", ProvCodBanco) THEN
                                BancoProv.TESTFIELD("CCC Bank Account No.");
                        END
                    ELSE
                        IF TipoDoc2 <> '5' THEN
                            TipoDoc := '07'
                        ELSE BEGIN
                            TipoDoc := '06';
                            IF NOT BancoProv.ISEMPTY THEN   //TSC 101019 Modifico para Forma Pago=Tipo TRANSFERENCIA, pida este dato sólo si venimos posicionados
                                BancoProv.TESTFIELD("CCC Bank Account No.");
                        END;

                    // PROVEEDOR - COMPROBAR SI ES RESIDENTE O NO
                    CLEAR(W_NoResidente);
                    W_NoResidente := 'N';
                    IF (Proveedor."Country/Region Code" <> '') AND
                       (Proveedor."Country/Region Code" <> InfoEmpresa."Country/Region Code")
                      THEN
                        W_NoResidente := 'S';

                    // NUMERO DE LA FACTURA DEL PROVEEDOR
                    CLEAR(W_NumFacturaProveedor);
                    CLEAR(MovProvAux);
                    IF R_HCabFactura.GET("Document No.") THEN BEGIN
                        W_NumFacturaProveedor := COPYSTR(R_HCabFactura."Vendor Invoice No.", 1, 15);
                    END ELSE BEGIN
                        //++008 TSC 01042020 Parche para encontrar Factura de Compra que viene de Recircular Facturas:
                        //Buscar por Mov.Prod. y quitar el punto final al 'Vendor Invoice No.', o buscar Cab.Fac.Compra eliminando " REC"...
                        MovProvAux.SETCURRENTKEY("Document No.", "Document Type");
                        MovProvAux.SETRANGE("Document No.", "Document No.");
                        MovProvAux.SETRANGE("Document Type", MovProvAux."Document Type"::Invoice);
                        IF MovProvAux.FINDFIRST THEN BEGIN
                            //W_NumFacturaProveedor := COPYSTR(MovProvAux."External Document No.",1,STRLEN(MovProvAux."External Document No.")-1);//Quitar punto final
                            W_NumFacturaProveedor := COPYSTR(MovProvAux."External Document No.", 1, 15);
                            W_NumFacturaProveedor := COPYSTR(W_NumFacturaProveedor, 1, 15);
                        END;
                        //--008 TSC 01042020
                    END;

                    ///IF "Cartera Doc."."Clase de pago" = "Cartera Doc."."Clase de pago"::"1" THEN
                    ///ClasePAGO := '01'
                    ///ELSE IF "Cartera Doc."."Clase de pago" = "Cartera Doc."."Clase de pago"::"2" THEN
                    ///ClasePAGO := '02';
                    ClasePAGO := '01';

                    EscribirRegistrosBeneficiarios(FALSE);

                    //++005 TSC 120719 Buscar e informar abono
                    BuscarAbonoMovProv("Cartera Doc.");

                    IF NOT MovProvLiqui.ISEMPTY THEN BEGIN
                        MovProvLiqui.FINDFIRST;
                        REPEAT
                            EscribirRegistrosBeneficiarios(TRUE);
                        UNTIL MovProvLiqui.NEXT = 0;
                    END;
                    //--005 TSC 120719

                end;
            }

            trigger OnAfterGetRecord()
            begin
                //++001 TSC 110719 Requerir marcar el check 'Exportar Pago electrónico' en la Orden de Pago
                "Payment Order".TESTFIELD("Export Electronic Payment", TRUE);
                //--001 TSC 110719

                TESTFIELD("Bank Account No.");
                CtaBanco.GET("Bank Account No.");

                CCCNoBanco := CtaBanco."CCC Bank No.";
                CCCNoSucBanco := CtaBanco."CCC Bank Branch No.";
                // CAIXA : OFICINA CONTRATO, NO OFICINA CUENTA : 6202
                IF W_NumeroOficina <> ''
                  THEN
                    CCCNoSucBanco := W_NumeroOficina;

                CCCNoCta := CtaBanco."CCC Bank Account No.";
                CCCDigControl := CtaBanco."CCC Control Digits";
                W_NumeroContratoSoporte := CtaBanco."Contrac Confirming Caixabanc";


                IF "Posting Date" = 0D THEN
                    FechaReg := PADSTR('', 6, '0')
                ELSE
                    FechaReg := FORMAT("Posting Date", 0, '<Day,2><month,2><year>');

                CLEAR(W_DetalleDelCargo_Text);
                IF W_DetalleDelCargo
                  THEN
                    W_DetalleDelCargo_Text := '1'
                ELSE
                    W_DetalleDelCargo_Text := '0';

                CLEAR(W_MonedaSoporte);
                IF "Currency Code" = ''
                  THEN
                    W_MonedaSoporte := UPPERCASE(PADSTR(ConfCG."LCY Code", 3, ' '))
                ELSE
                    W_MonedaSoporte := UPPERCASE(PADSTR("Currency Code", 3, ' '));


                EscribirRegistrosCabecera;

                //++007 TSC 050919 Marcar como exportado
                "Elect. Pmts Exported" := TRUE;
                MODIFY;
                //--007 TSC 050919
            end;

            trigger OnPostDataItem()
            begin
                // TOTALES - OBLIGATORIO
                EscribirRegistroTotales;


                //MESSAGE(Txt004, ArchExt);
            end;

            trigger OnPreDataItem()
            begin

                ConfCG.GET;
                IF TestExport THEN
                    Relat := '1'
                ELSE
                    Relat := '0';

                "Payment Order".FIND('-');

                ///IF NOT DocVarios.CheckCurrency("Payment Order"."Currency Code",DL) THEN
                ///ERROR (Txt001);

                EsEuro := DocVarios.GetRegisterCode("Payment Order"."Currency Code", CodRegistro, CadenaRegistro);

                IF CodRegistro <> 0 THEN
                    CadenaRegistro := '56'
                ELSE
                    CadenaRegistro := '06';
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ArchExt; ArchExt)
                    {
                        Caption = 'Archivo externo';
                        Visible = false;
                        ApplicationArea = All;

                        /*trigger OnAssistEdit()
                        var
                            NFich: Text[1024];
                        begin
                            ArchExt := CommonDialogMgt.SaveFileDialog(Text001, NFich, FiltroFicheros);
                            //IF ArchExt = '' THEN
                            //ArchExt := InfoEmpresa."Ruta Descargas" + NombreArchivoLbl + ExtensionArchivoLbl;   //002 TSC 110719 Poner ruta de exportación parametrizada en Info Empresa
                        end;*/
                    }
                    field(crelacion; TestExport)
                    {
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field(FechaEmision; FechaEmision)
                    {
                        Caption = 'Fecha emisión';
                        ApplicationArea = All;
                    }
                    field(BankSufix; BankSufix)
                    {
                        Caption = 'Sufijo banco';
                        TableRelation = Suffix.Suffix;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Sufix: Record Suffix;
                            Sufixes: Page Suffixes;
                        begin
                            Sufixes.SETTABLEVIEW(Sufix);
                            Sufixes.SETRECORD(Sufix);
                            Sufixes.LOOKUPMODE(TRUE);
                            Sufixes.EDITABLE(FALSE);
                            IF Sufixes.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                Sufixes.GETRECORD(Sufix);
                                BankSufixBankAcc := Sufix."Bank Acc. Code";
                                BankSufix := Sufix.Suffix;
                            END;
                        end;
                    }
                    field("W_NumeroContratoSoporte"; W_NumeroContratoSoporte)
                    {
                        Caption = 'Número contra soporte (01NNNNNNDD)';
                        Visible = false;
                        DrillDown = false;
                        Lookup = false;
                        ApplicationArea = All;
                    }
                    field("W_DetalleDelCargo"; W_DetalleDelCargo)
                    {
                        Caption = 'Detalle del cargo';
                        ApplicationArea = All;
                    }
                    field("W_ConceptoDeLaOrden"; W_ConceptoDeLaOrden)
                    {
                        Caption = 'Concepto de la orden';
                        DrillDown = false;
                        Lookup = false;
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field("W_IndicadorConfirmacion"; W_IndicadorConfirmacion)
                    {
                        Caption = 'Indicador de confirmación (C o en blanco)';
                        DrillDown = false;
                        Lookup = false;
                        ApplicationArea = All;
                    }
                    field("W_GastosACtaOrdenante"; W_GastosACtaOrdenante)
                    {
                        Caption = 'Bank Sufix';
                        DrillDown = false;
                        Lookup = false;
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field("W_NumeroOficina"; W_NumeroOficina)
                    {
                        Caption = 'Número oficina contrato (CAIXA 6202)';
                        Visible = false;
                        DrillDown = false;
                        Lookup = false;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //ArchExt := InfoEmpresa."Ruta Descargas" + NombreArchivoLbl + ExtensionArchivoLbl;   //002 TSC 110719 Poner ruta de exportación parametrizada en Info Empresa
            W_NumeroOficina := ValorOficinaTxt;    //003 TSC 110719 Valor de campo Oficina de Request Page por defecto (Text Constant=6202, no 7306)
            // W_NumeroContratoSoporte := NumContratoTxt;    //004 TSC 120719 Valor de campo Número de Contrato, en RequestPage por defecto

            IF FechaEmision = 0D THEN
                FechaEmision := TODAY;

            IF W_ConceptoDeLaOrden = ''
              THEN
                W_ConceptoDeLaOrden := '9';
            IF W_GastosACtaOrdenante = ''
              THEN
                W_GastosACtaOrdenante := '1';
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        InfoEmpresa.GET;
        InfoEmpresa.TESTFIELD("VAT Registration No.");
        NoCIF := COPYSTR(InfoEmpresa."VAT Registration No.", 1, 10);
    end;

    trigger OnPreReport()
    begin
        CR := 13;
        LF := 10;
        tempblob.blob.CreateOutStream(ArchSalida);
    end;

    trigger OnPostReport()
    begin
        tempblob.blob.CreateInStream(inStr);
        ArchExt := "Payment Order"."No." + '.txt';
        DownloadFromStream(inStr, '', '', '', ArchExt);
        MESSAGE(Txt004, ArchExt);
    end;

    var
        InfoEmpresa: Record "Company Information";
        Proveedor: Record "Vendor";
        CtaBanco: Record "Bank Account";
        BancoProv: Record "Vendor Bank Account";
        FormaPago: Record "Payment Method";
        ConfCG: Record "General Ledger Setup";
        DocVarios: Codeunit "Document-Misc";
        ArchSalida: OutStream;
        inStr: InStream;
        tempblob: Record TempBlob;
        CR: Char;
        LF: Char;
        ArchExt: Text[1024];
        TestExport: Boolean;
        NoCIF: Text[20];
        CCCNoBanco: Text[4];
        IVARegProv: Text[12];
        CCCNoSucBanco: Text[4];
        ProvCCCDigControl: Text[2];
        CCCDigControl: Text[2];
        CCCNoCta: Text[10];
        ProvCCCBanco: Text[4];
        ProvCCCNoSucBanco: Text[4];
        ProvCCCNoCta: Text[10];
        ProvDCIBAN: Text[2];
        ProvBIC: Text[12];
        ProvBBAN: Text[30];
        TotalReg: Decimal;
        TotalDocProv: Decimal;
        ImporteTotal: Decimal;
        TextoSalida: Text[120];
        FechaEmision: Date;
        Relat: Text[1];
        TipoDoc2: Code[10];
        TipoDoc: Text[2];
        ImportePdte: Text[12];
        ProvCodBanco: Code[20];
        CodDiv: Text[3];
        FechaReg: Text[6];
        DL: Option Peseta,Euro,Otro;
        EsEuro: Boolean;
        CodRegistro: Integer;
        CadenaRegistro: Text[2];
        ImporteDoc: Text[12];
        Sufijo: Text[3];
        Pais: Record "Country/Region";
        NomPais: Text[9];
        RecDocCartera: Record "Cartera Doc." temporary;
        TotCta: Decimal;
        ConfCar: Record "Cartera Setup";
        GestNoSerie: Codeunit NoSeriesManagement;
        NumPago: Code[8];
        ImpPdte: Decimal;
        _DocCartera: Record "Cartera Doc.";
        BankSufix: Code[3];
        BankSufixBankAcc: Code[20];
        ImpPdteAgrupado: array[9] of Decimal;
        i: Integer;
        j: Integer;
        txt015: Text[3];
        NumaIBAN2: Text[30];
        Longitud: Integer;
        Cont: Integer;
        MovProveedor: Record "Vendor Ledger Entry";
        DocExterno: Text[12];
        Count2: Decimal;
        R_HCabFactura: Record "Purch. Inv. Header";
        W_NumeroContratoSoporte: Text[14];
        W_DetalleDelCargo: Boolean;
        W_DetalleDelCargo_Text: Text[1];
        W_MonedaSoporte: Text[3];
        W_NombreOrdenante: Text[36];
        W_DireccionOrdenante: Text[36];
        W_PlazaDelOrdenante: Text[36];
        W_NifProveedor: Text[12];
        W_Importe: Text[12];
        W_EntidadCreditoReceptora: Text[4];
        W_SucursalCreditoReceptora: Text[4];
        W_CuentaCreditoReceptora: Text[10];
        W_GastosACtaOrdenante: Text[1];
        ___W_ConceptoOrden: Text[9];
        W_DigitosCCCCreditoReceptora: Text[2];
        W_IndicadorProveedorNoResident: Text[1];
        W_IndicadorConfirmacion: Text[1];
        W_MonedaDeLaFactura: Text[3];
        W_ISOPaisDestino: Text[2];
        W_DigitosControlIBAN: Text[2];
        W_CuentaBancariaNacional: Text[30];
        W_ConceptoDeLaOrden: Text[1];
        W_ClaveGastos: Text[1];
        W_CodigoSwiftBancoDestino: Text[12];
        W_NombreProveedor: Text[36];
        W_DomicilioProveedor_1: Text[36];
        W_DomicilioProveedor_2: Text[36];
        W_CodigoPostal: Text[5];
        W_PlazaProveedor: Text[31];
        W_CodigoInternoProveedor: Text[15];
        W_NIFProveedorSiEndosado: Text[12];
        W_ClasificacionProveedorPorCli: Text[1];
        W_PaisDestino: Text[9];
        W_FormaPago: Text[2];
        W_NoResidente: Text[1];
        W_DomicilioTotal: Text[250];
        W_NumFacturaProveedor: Text[15];
        W_TotalImporteFacturas: Decimal;
        W_TotalFacturas: Decimal;
        W_TotalImporteFacturas_Texto: Text[12];
        W_TotalFacturas_Texto: Text[8];
        W_TotalRegistros_Texto: Text[10];
        W_NumeroOficina: Text[4];
        Text000: Label 'Document';
        Txt001: Label 'Solo puede utilizar las Normas del CSB con Cod. Peseta o Euro.';
        Txt002: Label 'La forma de pago tiene que ser cheque y o transferencia - Documento %1.';
        Txt003: Label 'Falta alguna información sobre el banco del proveedor %1';
        ProvFAX: Text[30];
        ProvTELF: Text[30];
        ClasePAGO: Text[2];
        RFormaPago: Record "Payment Method";
        Txt004: Label 'Se ha generado el fichero Orden de pago Confirming Caixabank: %1';
        ProvNtraCta: Text[15];
        Text001: Label 'Fichero a exportar';
        FiltroFicheros: Label 'ASC (*.asc)|*.asc|TXT (*.txt)|*.txt|Todos (*.*)|*.*';
        CommonDialogMgt: Codeunit "File Management";
        W_NombreFichero: Text[1000];
        NombreArchivoLbl: Label 'Confirming';
        ExtensionArchivoLbl: Label '.txt';
        ValorOficinaTxt: Label '4553';
        NumContratoTxt: Label '0101702409';
        MovProvLiqui: Record "Vendor Ledger Entry";
        MovProvAux: Record "Vendor Ledger Entry";

    procedure ImpEuro(Importe: Decimal): Text[12]
    var
        TextoImp: Text[15];
    begin
        TextoImp := CONVERTSTR(FORMAT(Importe), ' ', '0');
        IF STRPOS(TextoImp, ',') = 0 THEN
            TextoImp := TextoImp + '00'
        ELSE BEGIN
            IF STRLEN(COPYSTR(TextoImp, STRPOS(TextoImp, ','), STRLEN(TextoImp))) = 2 THEN
                TextoImp := TextoImp + '0';
            TextoImp := DELCHR(TextoImp, '=', ',');
        END;
        IF STRPOS(TextoImp, '.') = 0 THEN
            TextoImp := TextoImp
        ELSE
            TextoImp := DELCHR(TextoImp, '=', '.');

        WHILE STRLEN(TextoImp) < 12 DO
            TextoImp := '0' + TextoImp;

        EXIT(TextoImp);
    end;

    procedure ImpATexto(Importe: Decimal; Longitud: Decimal; Decimales: Decimal): Text[250]
    var
        TextoImp: Text[15];
    begin
        TextoImp := CONVERTSTR(FORMAT(Importe), ' ', '0');

        IF Decimales <> 0 THEN BEGIN
            IF STRPOS(TextoImp, ',') = 0 THEN
                TextoImp := TextoImp + ',';

            WHILE (STRLEN(COPYSTR(TextoImp, STRPOS(TextoImp, ',') + 1)) < Decimales) DO
                TextoImp := TextoImp + '0';
            TextoImp := DELCHR(TextoImp, '=', ',');

            IF STRPOS(TextoImp, '.') = 0 THEN
                TextoImp := TextoImp
            ELSE
                TextoImp := DELCHR(TextoImp, '=', '.');
        END;

        WHILE STRLEN(TextoImp) < Longitud DO
            TextoImp := '0' + TextoImp;


        EXIT(TextoImp);
    end;

    procedure EscribirRegistrosCabecera()
    begin
        // REGISTROS DE CABECERA - 4

        // CABECERA 1 - OBLIGARIO
        TextoSalida := '01' +
                       '56' +
                       UPPERCASE(PADSTR(COPYSTR(NoCIF, 1, 10), 10, ' ')) +
                       PADSTR('', 12, ' ') +
                       '001' +
                       PADSTR(FORMAT(FechaEmision, 0, '<Day,2><month,2><year>'), 6, ' ') +
                       PADSTR('', 6, ' ') +
                       PADSTR(CCCNoBanco, 4, ' ') +
                       PADSTR(W_NumeroContratoSoporte, 14, ' ') +
                       PADSTR(W_DetalleDelCargo_Text, 1, ' ') +
                       UPPERCASE(PADSTR(W_MonedaSoporte, 3, ' ')) +
                       PADSTR('', 7, ' ') +
                       PADSTR('', 2, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;


        // CABECERA 2 - OBLIGARIO
        TextoSalida := '01' +
                       '56' +
                       UPPERCASE(PADSTR(COPYSTR(NoCIF, 1, 10), 10, ' ')) +
                       PADSTR('', 12, ' ') +
                       '002' +
                       UPPERCASE(PADSTR(InfoEmpresa.Name + ' ' + InfoEmpresa."Name 2", 36, ' ')) +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;


        // CABECERA 3 - OBLIGARIO
        TextoSalida := '01' +
                       '56' +
                       UPPERCASE(PADSTR(COPYSTR(NoCIF, 1, 10), 10, ' ')) +
                       PADSTR('', 12, ' ') +
                       '003' +
                       UPPERCASE(PADSTR(InfoEmpresa.Address + ' ' + InfoEmpresa."Address 2", 36, ' ')) +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;


        // CABECERA 4 - OBLIGARIO
        TextoSalida := '01' +
                       '56' +
                       UPPERCASE(PADSTR(COPYSTR(NoCIF, 1, 10), 10, ' ')) +
                       PADSTR('', 12, ' ') +
                       '004' +
                       UPPERCASE(PADSTR(InfoEmpresa.City, 36, ' ')) +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
    end;

    procedure EscribirRegistrosBeneficiarios(EsAbono: Boolean)
    var
        FechaRegistro: Text;
        FechaVencimiento: Text;
        NumDoc: Text;
    begin
        // REGISTROS DE BENEFICIARIO - OBLIGATORIOS - 5 NACIONAL 5+4 NO RESIDENTES
        FechaRegistro := FORMAT("Cartera Doc."."Posting Date", 0, '<Day,2><month,2><year>');
        FechaVencimiento := FORMAT("Cartera Doc."."Due Date", 0, '<Day,2><month,2><year>');
        NumDoc := "Cartera Doc."."Document No.";
        IF EsAbono THEN BEGIN
            MovProvLiqui.CALCFIELDS(Amount);

            ImportePdte := '-' + FORMAT(MovProvLiqui.Amount * 100);
            ImportePdte := DELCHR(ImportePdte, '=', ',');
            ImportePdte := DELCHR(ImportePdte, '=', '.');
            WHILE STRLEN(ImportePdte) < 12 DO
                ImportePdte := '0' + ImportePdte;

            FechaRegistro := FORMAT(MovProvLiqui."Posting Date", 0, '<Day,2><month,2><year>');
            FechaVencimiento := FORMAT(MovProvLiqui."Due Date", 0, '<Day,2><month,2><year>');
            NumDoc := MovProvLiqui."Document No.";
        END;
        // BENEFICIARIO - 10 - OBLIGATORIO
        TextoSalida := '06' +
                       '56' +
                       UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                       UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                       '010' +
                       PADSTR(ImportePdte, 12, ' ') +
                       PADSTR(ProvCCCBanco, 4, ' ') +
                       PADSTR(ProvCCCNoSucBanco, 4, ' ') +
                       PADSTR(ProvCCCNoCta, 10, ' ') +
                       PADSTR(W_GastosACtaOrdenante, 1, ' ') +
                       UPPERCASE(PADSTR(W_ConceptoDeLaOrden, 1, ' ')) +
                       PADSTR('', 2, ' ') +
                       PADSTR(ProvCCCDigControl, 2, ' ') +
                       PADSTR(W_NoResidente, 1, ' ') +
                       UPPERCASE(PADSTR(W_IndicadorConfirmacion, 1, ' ')) +
                       'EUR' +
                       PADSTR('', 2, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;

        W_TotalFacturas := W_TotalFacturas + 1;
        IF EsAbono THEN BEGIN
            MovProvLiqui.CALCFIELDS(Amount);
            W_TotalImporteFacturas := W_TotalImporteFacturas - MovProvLiqui.Amount;
        END ELSE
            W_TotalImporteFacturas := W_TotalImporteFacturas + "Cartera Doc."."Remaining Amount";
        // BENEFICIARIO - 43 - OPCIONAL - OBLIGATORIO NO RESIDENTES
        IF W_NoResidente = 'S' THEN BEGIN
            TextoSalida := '06' +
                         '56' +
                         UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                         UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                         '043' +
                         UPPERCASE(PADSTR(W_ISOPaisDestino, 2, ' ')) +
                         PADSTR(ProvDCIBAN, 2, ' ') +
                         PADSTR(ProvBBAN, 30, ' ') +
                         '7' +
                         PADSTR('', 8, ' ');
            ArchSalida.WriteText(TextoSalida + CR + LF);
            TotalReg := TotalReg + 1;
        END;
        // BENEFICIARIO - 44 - OPCIONAL - OBLIGATORIO NO RESIDENTES
        IF W_NoResidente = 'S' THEN BEGIN
            TextoSalida := '06' +
                         '56' +
                         UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                         UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                         '044' +
                         '1' +
                         UPPERCASE(PADSTR(W_ISOPaisDestino, 2, ' ')) +
                         PADSTR('', 6, ' ') +
                         PADSTR(ProvBIC, 12, ' ') +
                         PADSTR('', 22, ' ');

            ArchSalida.WriteText(TextoSalida + CR + LF);
            TotalReg := TotalReg + 1;
        END;
        // BENEFICIARIO - 45 - OPCIONAL - CUADERNO SEPTIEMBRE 2015
        // BENEFICIARIO - 46 - OPCIONAL - CUADERNO SEPTIEMBRE 2015
        // BENEFICIARIO - 11 - OBLIGATORIO
        TextoSalida := '06' +
                       '56' +
                       UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                       UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                       '011' +
                       UPPERCASE(PADSTR(Proveedor.Name + Proveedor."Name 2", 36, ' ')) +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
        // BENEFICIARIO - 12 - OBLIGATORIO
        CLEAR(W_DomicilioTotal);
        W_DomicilioTotal := COPYSTR(Proveedor.Address + Proveedor."Address 2", 1, MAXSTRLEN(W_DomicilioTotal));
        W_DomicilioProveedor_1 := COPYSTR(W_DomicilioTotal, 1, 36);
        W_DomicilioProveedor_2 := COPYSTR(W_DomicilioTotal, 37, 36);

        TextoSalida := '06' +
                       '56' +
                       UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                       UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                       '012' +
                       UPPERCASE(PADSTR(W_DomicilioProveedor_1, 36, ' ')) +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
        // BENEFICIARIO - 13 - OPCIONAL
        IF W_DomicilioProveedor_2 <> '' THEN BEGIN
            TextoSalida := '06' +
                           '56' +
                           UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                           UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                           '013' +
                           UPPERCASE(PADSTR(W_DomicilioProveedor_2, 36, ' ')) +
                           PADSTR('', 7, ' ');

            ArchSalida.WriteText(TextoSalida + CR + LF);
            TotalReg := TotalReg + 1;

        END;
        // BENEFICIARIO - 14 - OBLIGATORIO
        TextoSalida := '06' +
                       '56' +
                       UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                       UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                       '014' +
                       PADSTR(Proveedor."Post Code", 5, ' ') +
                       UPPERCASE(PADSTR(Proveedor.City, 31, ' ')) +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
        // BENEFICIARIO - 15 - OPCIONAL - OBLIGATORIO NO RESIDENTES
        IF W_NoResidente = 'S' THEN BEGIN
            TextoSalida := '06' +
                           '56' +
                           UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                           UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                           '015' +
                           UPPERCASE(PADSTR(ProvNtraCta, 15, ' ')) +
                           PADSTR('', 12, ' ') +
                           PADSTR('', 1, ' ') +
                           PADSTR(W_ISOPaisDestino, 2, ' ') +
                           UPPERCASE(PADSTR(NomPais, 9, ' ')) +
                           PADSTR('', 4, ' ')
                           ;
            ArchSalida.WriteText(TextoSalida + CR + LF);
            TotalReg := TotalReg + 1;
        END;
        // BENEFICIARIO - 16 - OBLIGATORIO
        TextoSalida := '06' +
                       '56' +
                       UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                       UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                       '016' +
                       W_FormaPago +
                       PADSTR(FechaRegistro, 6, ' ') +
                       PADSTR(W_NumFacturaProveedor, 15, ' ') +
                       PADSTR(FechaVencimiento, 6, ' ') +
                       PADSTR('', 8, ' ') +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
        // BENEFICIARIO - 17 - OPCIONAL
        TextoSalida := '06' +
                       '56' +
                       UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                       UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                       '017' +
                       PADSTR(NumDoc, 15, ' ') +
                       PADSTR("Payment Order"."No.", 15, ' ') +
                       PADSTR('', 6, ' ') +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
        // BENEFICIARIO - 18 - OPCIONAL - OBLIGATORIO NO RESIDENTES
        IF W_NoResidente = 'S' THEN BEGIN
            TextoSalida := '06' +
                           '56' +
                           UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                           UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                           '018' +
                           PADSTR(ProvTELF, 15, ' ') +
                           PADSTR(ProvFAX, 15, ' ') +
                           PADSTR('', 6, ' ') +
                           PADSTR('', 7, ' ');
            ArchSalida.WriteText(TextoSalida + CR + LF);
            TotalReg := TotalReg + 1;

        END;
        // BENEFICIARIO - 19 - OPCIONAL
        TextoSalida := '06' +
                       '56' +
                       UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                       UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                       '019' +
                       PADSTR(COPYSTR(Proveedor."E-Mail", 1, 36), 36, ' ') +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
        // BENEFICIARIO - 20 - OPCIONAL
        TextoSalida := '06' +
                     '56' +
                     UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                     UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                     '020' +
                     PADSTR(COPYSTR(Proveedor."E-Mail", 37, 36), 36, ' ') +
                     PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
        // BENEFICIARIO - 55 - OPCIONAL - OBLIGATORIO NO RESIDENTES
        IF W_NoResidente = 'S' THEN BEGIN
            TextoSalida := '06' +
                           '56' +
                           UPPERCASE(PADSTR(NoCIF, 10, ' ')) +
                           UPPERCASE(PADSTR(IVARegProv, 12, ' ')) +
                           '055' +
                           PADSTR(ClasePAGO, 2, ' ') +
///PADSTR("Cod. estadistico CIN",6,' ') +  //--TSC 080719 comentado
PADSTR('', 6, ' ') +
                           //++TSC 080719 cambiado
                           PADSTR(W_ISOPaisDestino, 2, ' ') +
                           //ISO PAIS DESTINO PAGO
                           UPPERCASE(PADSTR(COPYSTR(IVARegProv, 4, 9), 9, ' ')) +
                           //NIF BENEFICIARIO
                           PADSTR('', 8, ' ') +
                           //NUMERO OPERACION FINANCIERA
                           PADSTR('', 12, ' ') +
                           //CODIGO ISIN
                           PADSTR('', 4, ' ');
            ArchSalida.WriteText(TextoSalida + CR + LF);
            TotalReg := TotalReg + 1;
        END;

    end;

    procedure EscribirRegistroTotales()
    begin
        // TOTALES - OBLIGATORIO
        CLEAR(W_TotalImporteFacturas_Texto);
        CLEAR(W_TotalFacturas_Texto);
        CLEAR(W_TotalRegistros_Texto);

        W_TotalImporteFacturas_Texto := ImpATexto(W_TotalImporteFacturas, 12, 2);
        W_TotalFacturas_Texto := ImpATexto(W_TotalFacturas, 8, 0);
        W_TotalRegistros_Texto := ImpATexto(TotalReg + 1, 10, 0);

        TextoSalida := '08' +
                       '56' +
                       UPPERCASE(PADSTR(COPYSTR(NoCIF, 1, 10), 10, ' ')) +
                       PADSTR('', 12, ' ') +
                       PADSTR('', 3, ' ') +
                       PADSTR(W_TotalImporteFacturas_Texto, 12, ' ') +
                       PADSTR(W_TotalFacturas_Texto, 8, ' ') +
                       PADSTR(W_TotalRegistros_Texto, 10, ' ') +
                       PADSTR('', 6, ' ') +
                       PADSTR('', 7, ' ');

        ArchSalida.WriteText(TextoSalida + CR + LF);
        TotalReg := TotalReg + 1;
    end;

    //[Scope('Personalization')]
    procedure BuscarAbonoMovProv(var DocCartera: Record "Cartera Doc.")
    var
        CarteraDoc: Record "Cartera Doc.";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CreateVendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        AmountVisible: Boolean;
        DebitCreditVisible: Boolean;
        Heading: Text[50];
    begin
        //005 TSC 120719 Buscar e informar abono
        //CarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.",PaymentOrder."No.");  //Si recibiera Orden Pago por parámetro
        //IF CarteraDoc.FINDFIRST THEN
        //REPEAT
        CLEAR(VendorLedgerEntry);
        CLEAR(MovProvLiqui);
        MovProvLiqui.SETFILTER("Document Type", '%1', MovProvLiqui."Document Type"::Bill);///
        MovProvLiqui.SETFILTER("Buy-from Vendor No.", DocCartera."Account No.");///
        MovProvLiqui.SETFILTER("Document No.", DocCartera."Document No.");///
        MovProvLiqui.SETFILTER("Bill No.", DocCartera."No.");///
        IF MovProvLiqui.FINDFIRST THEN BEGIN
            //++P.62 Mov. liquidados > T.25 Mov. Prov.
            MovProvLiqui.RESET;
            //++SetConrolVisibility;
            GLSetup.GET;
            AmountVisible := NOT (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
            DebitCreditVisible := NOT (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
            //--SetConrolVisibility;

            IF MovProvLiqui."Entry No." <> 0 THEN BEGIN
                CreateVendLedgEntry := MovProvLiqui;
                IF CreateVendLedgEntry."Document Type" = CreateVendLedgEntry."Document Type"::" " THEN
                    Heading := Text000
                ELSE
                    Heading := FORMAT(CreateVendLedgEntry."Document Type");
                Heading := Heading + ' ' + CreateVendLedgEntry."Document No.";

                FindApplnEntriesDtldtLedgEntry(CreateVendLedgEntry, MovProvLiqui);
                MovProvLiqui.SETCURRENTKEY("Entry No.");
                MovProvLiqui.SETRANGE("Entry No.");

                IF CreateVendLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
                    MovProvLiqui."Entry No." := CreateVendLedgEntry."Closed by Entry No.";
                    MovProvLiqui.MARK(TRUE);
                END;

                MovProvLiqui.SETCURRENTKEY("Closed by Entry No.");
                MovProvLiqui.SETRANGE("Closed by Entry No.", CreateVendLedgEntry."Entry No.");
                IF MovProvLiqui.FIND('-') THEN
                    REPEAT
                        MovProvLiqui.MARK(TRUE);
                    UNTIL MovProvLiqui.NEXT = 0;

                MovProvLiqui.SETCURRENTKEY("Entry No.");
                MovProvLiqui.SETRANGE("Closed by Entry No.");
            END;

            MovProvLiqui.MARKEDONLY(TRUE);
            //--P.62 > T.25
        END;
        //UNTIL CarteraDoc.NEXT = 0;
        //--009 TSC 040719
    end;

    local procedure FindApplnEntriesDtldtLedgEntry(var CreateVendLedgEntry: Record "Vendor Ledger Entry"; var MovProvLiq: Record "Vendor Ledger Entry")
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        //005 TSC 120719 Para buscar e informar abono
        DtldVendLedgEntry1.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SETRANGE("Vendor Ledger Entry No.", CreateVendLedgEntry."Entry No.");
        DtldVendLedgEntry1.SETRANGE(Unapplied, FALSE);
        IF DtldVendLedgEntry1.FIND('-') THEN
            REPEAT
                IF DtldVendLedgEntry1."Vendor Ledger Entry No." =
                   DtldVendLedgEntry1."Applied Vend. Ledger Entry No."
                THEN BEGIN
                    DtldVendLedgEntry2.INIT;
                    DtldVendLedgEntry2.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SETRANGE(
                      "Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SETRANGE(Unapplied, FALSE);
                    IF DtldVendLedgEntry2.FIND('-') THEN
                        REPEAT
                            IF DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                               DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                            THEN BEGIN
                                MovProvLiq.SETCURRENTKEY("Entry No.");
                                MovProvLiq.SETRANGE("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                IF MovProvLiq.FIND('-') THEN
                                    MovProvLiq.MARK(TRUE);
                            END;
                        UNTIL DtldVendLedgEntry2.NEXT = 0;
                END ELSE BEGIN
                    MovProvLiq.SETCURRENTKEY("Entry No.");
                    MovProvLiq.SETRANGE("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    IF MovProvLiq.FIND('-') THEN
                        MovProvLiq.MARK(TRUE);
                END;
            UNTIL DtldVendLedgEntry1.NEXT = 0;
    end;
}

