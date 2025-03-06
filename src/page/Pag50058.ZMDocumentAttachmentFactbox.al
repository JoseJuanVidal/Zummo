page 50058 "ZM Document Attachment Factbox"
{
    Caption = 'Documents Attached';
    PageType = CardPart;
    SourceTable = "Document Attachment";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Documents; COUNT)
                {
                    ApplicationArea = All;
                    Caption = 'Documents', comment = 'ESP="Nº Documentos"';
                    ;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the number of attachments.';

                    trigger OnDrillDown()
                    begin
                        DocNo_DrillDown;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        RecRef: RecordRef;
        iTableID: Integer;
        LineNo: Integer;
        cNo: code[20];


    local procedure DocNo_DrillDown()
    var
        DocumentAttachment: Record "Document Attachment";
        DocumentAttachmentDetails: Page "Document Attachment Details";
        lblError: Label 'El registro anterior no está correctamente grabado.\Rellene primero los datos obligados', comment = 'ESP="El registro anterior no está correctamente grabado.\Rellene primero los datos obligados."';
    begin
        if (cNo = '') or (iTableID = 0) then
            Error(lblError);
        DocumentAttachment.SetRange("Table ID", iTableID);
        DocumentAttachment.SetRange("No.", cNo);
        DocumentAttachment.SetRange("Line No.", LineNo);

        CASE "Table ID" OF
            DATABASE::"ZM Productión Tools":
                BEGIN
                    DocumentAttachment.SetRange("No.", "No.");
                END;
            DATABASE::"ZM Prod. Tools Ledger Entry":
                BEGIN
                    // no hace falta, porque se utiliza la funcion para posicionar el registro
                    // SetProdToolLedgerEntry
                END;
        END;
        DocumentAttachmentDetails.OpenForRecRef(RecRef);
        DocumentAttachmentDetails.SetTableView(DocumentAttachment);
        DocumentAttachmentDetails.RUNMODAL;
    end;

    procedure SetTableNo(ptableId: Integer; pNo: code[20]; vLineNo: Integer; RefRecord: RecordRef)
    begin
        iTableID := ptableId;
        cNo := pNo;
        LineNo := vLineNo;
        RecRef := RefRecord;
        Rec.SetRange("Table ID", iTableID);
        Rec.SetRange("No.", cNo);
        Rec.SetRange("Line No.", LineNo);
        CurrPage.Update();
    end;

    procedure SetProdTools_RecordRef(ZMProductiónTools: Record "ZM Productión Tools")
    begin
        RecRef.GetTable(ZMProductiónTools);
    end;

    procedure SetProdToolsLdgEntry_RecordRef(ZMProductiónTools: Record "ZM Prod. Tools Ledger Entry")
    begin
        RecRef.GetTable(ZMProductiónTools);
    end;
}

