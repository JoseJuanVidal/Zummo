page 50007 "Posted Sales Invoice Change"
{
    PageType = Card;
    UsageCategory = None;
    Caption = 'Posted Sales Invoice Change', comment = 'ESP="Editar Hist. Venta"';
    //    SourceTable = TableName;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name; ExternalDocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.', comment = 'ESP="Nº Documento externo"';
                }
                field(WorkDescription; WorkDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Work Description', comment = 'ESP="Descripción del trabajo"';
                    MultiLine = true;
                }
                field(AreaManager_btc; AreaManager_btc)
                {
                    ApplicationArea = all;
                    Caption = 'Area Manager', comment = 'ESP="Area Manager"';
                    TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(tabla), TipoTabla = const(AreaManager));
                }
                field(InsideSales; InsideSales)
                {
                    ApplicationArea = all;
                    Caption = 'Inside Sales', comment = 'ESP="Inside Sales"';
                }
                field(ClienteReporting_btc; ClienteReporting_btc)
                {
                    ApplicationArea = all;
                    tableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClienteReporting"), TipoRegistro = const(Tabla));
                    Caption = 'Cliente Reporting', comment = 'ESP="Cliente Reporting"';
                }
                field(Delegado_btc; Delegado_btc)
                {
                    ApplicationArea = all;
                    tableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Delegado), TipoRegistro = const(Tabla));
                    Caption = 'Delegado', comment = 'ESP="Delegado"';
                }
                field(Currencychange; Currencychange)
                {
                    ApplicationArea = all;
                    Caption = 'Cambio Divisa', comment = 'ESP="Cambio Divisa"';
                    DecimalPlaces = 0 : 4;
                }
            }
            Group(Facturacionyenvio)
            {
                Caption = 'Factuación y envío', comment = 'ESP="Factuación y envío"';

                field(PackageTrackingNo; PackageTrackingNo)
                {
                    ApplicationArea = all;
                    Caption = 'Nº seguimiento bulto', comment = 'ESP="Nº seguimiento bulto"';
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        ExternalDocumentNo: Text[35];
        WorkDescription: Text;
        AreaManager_btc: code[20];
        InsideSales: code[20];
        ClienteReporting_btc: Code[20];
        Delegado_btc: Code[20];
        Currencychange: Decimal;
        TempBlob: Record TempBlob temporary;
        PackageTrackingNo: text[30];


    procedure GetDatos(var ExtDocNo: Text[30]; var WorkDesc: Text; var AreaManager: code[20]; var ClienteReporting: code[20]; var CurChange: Decimal;
        var vPackageTrackingNo: text[30]; var vInsideSales: code[20]; var vDelegado_btc: Code[20])
    begin
        ExtDocNo := ExternalDocumentNo;
        WorkDesc := WorkDescription;
        AreaManager := AreaManager_btc;
        ClienteReporting := ClienteReporting_btc;
        CurChange := Currencychange;
        vPackageTrackingNo := PackageTrackingNo;
        vInsideSales := InsideSales;
        vDelegado_btc := Delegado_btc;
    end;

    procedure SetDatos(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CR: text[1];
    begin
        ExternalDocumentNo := SalesInvoiceHeader."External Document No.";
        SalesInvoiceHeader.CalcFields("Work Description");
        if NOT SalesInvoiceHeader."Work Description".HASVALUE then begin
            WorkDescription := '';
            exit;
        end;

        CR[1] := 10;
        TempBlob.Blob := SalesInvoiceHeader."Work Description";
        WorkDescription := TempBlob.ReadAsText(CR, TEXTENCODING::UTF8);
        AreaManager_btc := SalesInvoiceHeader.AreaManager_btc;
        Currencychange := SalesInvoiceHeader.CurrencyChange;
        PackageTrackingNo := SalesInvoiceHeader."Package Tracking No.";
        InsideSales := SalesInvoiceHeader.InsideSales_btc;
        Delegado_btc := SalesInvoiceHeader.Delegado_btc;
    end;

}