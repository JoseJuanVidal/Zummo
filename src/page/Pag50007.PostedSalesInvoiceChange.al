page 50007 "Posted Sales Invoice Change"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
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
                    Caption = 'External Document No.', comment = 'ESP="Nº documento externo"';
                }
                field(WorkDescription; WorkDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Work Description', comment = 'ESP="Descripción del trabajo"';
                    MultiLine = true;
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
        TempBlob: Record TempBlob temporary;

    procedure GetDatos(var ExtDocNo: Text[30]; var WorkDesc: Text)
    begin
        ExtDocNo := ExternalDocumentNo;
        WorkDesc := WorkDescription;
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
    end;

}