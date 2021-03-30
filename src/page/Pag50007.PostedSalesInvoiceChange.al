page 50007 "Posted Sales Invoice Change"
{
    PageType = Card;
    UsageCategory = Administration;
    Caption = 'Posted Sales Invoice Change', comment = 'Editar Hist. Fact. Venta ';
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
                    Caption = 'Area Manager', comment = 'Area Manager';
                    TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(tabla), TipoTabla = const(AreaManager));
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
        TempBlob: Record TempBlob temporary;

    procedure GetDatos(var ExtDocNo: Text[30]; var WorkDesc: Text; var AreaManager: code[20])
    begin
        ExtDocNo := ExternalDocumentNo;
        WorkDesc := WorkDescription;
        AreaManager := AreaManager_btc;
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
    end;

}