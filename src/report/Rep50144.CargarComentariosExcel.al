report 50144 "Cargar Comentarios Excel"
{
    Caption = 'Cargar Comentarios Excel';
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem(Item; Item)
        {
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field(FileName; FileName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Nombre del ficharo', Comment = 'ESP="Nombre del fichero"';
                        Editable = false;
                    }
                }
            }
        }
    }

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        ServerFileName: text;
        SheetName: Text;
        cdtFileMgt: Codeunit "File Management";
        Text50000: Label 'Seleccione fichero';
        txtFileName: Text;
        RecordLink: Record "Record Link";
        TypeHelper: Codeunit "Type Helper";
        OStream: OutStream;
        txtEncoding: TextEncoding;
        NVInStream: InStream;
        RecordAdd: Integer;
        Text000: label 'Cargar Fichero de Excel';
        Text001: Label '¿Desea importar el fichero %1?', comment = 'ESP="¿Desea importar el fichero %1?"';

    trigger OnPreReport()
    begin
        ExcelBuffer.LockTable();

        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            exit;
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream);

        // UploadFileWithFilter(Text50000, txtFileName, 'Archivos de Excl (*.xlsx)|*.xlsx|Todos los archivos (*.*)|*.*', '*.*');
        // ExcelBuf.OpenExcel();
        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();
        if Confirm(Text001, false, FileName) then
            CargarComentarioProducto();
    end;

    trigger OnPostReport()
    begin
        ExcelBuffer.DeleteAll();
    end;

    local procedure CargarComentarioProducto()
    var
        ContarRow: Integer;
        TotalRown: Integer;
    begin
        ExcelBuffer.SetRange("Column No.", 1);
        if ExcelBuffer.FindLast() then
            TotalRown := ExcelBuffer."Row No.";
        for ContarRow := 2 to TotalRown do begin
            ExcelBuffer.Reset();
            ExcelBuffer.SetRange("Row No.", ContarRow);
            ExcelBuffer.SetRange("Column No.", 1);
            if ExcelBuffer.FindSet() then
                LocalizarRecordIdProducto(ExcelBuffer."Cell Value as Text");
            ExcelBuffer.SetRange("Column No.", 2);
            if ExcelBuffer.FindSet() then begin
                AñadirComentarioProducto(ExcelBuffer."Cell Value as Text");
                RecordAdd += 1;
            end;
        end;
        Message(StrSubstNo('Insertados %1 comentarios', RecordAdd));
    end;

    local procedure LocalizarRecordIdProducto(ItemNo: Text)
    begin
        Item.Get(ItemNo);
    end;

    local procedure AñadirComentarioProducto(Comment: Text)
    begin
        RecordLink.Init();
        RecordLink."Link ID" := GetLastRecordLink;
        RecordLink."Record ID" := item.RecordId;
        RecordLink.Company := CompanyName;
        RecordLink.Created := CreateDateTime(Today, time);
        RecordLink."User ID" := UserId;
        RecordLink.Type := RecordLink.Type::Note;

        TypeHelper.WriteRecordLinkNote(RecordLink, Comment);

        RecordLink.Insert();
    end;

    local procedure GetLastRecordLink(): Integer;
    var
        RLink: record "Record Link";
    begin
        if RLink.FindLast() then
            exit(RLink."Link ID" + 1);
        exit(1)

    end;
}
