report 50144 "Cargar Comentarios Excel"
{
    Caption = 'Cargar Comentarios Excel';
    dataset
    {
        dataitem(Item; Item)
        {
        }
    }

    var
        ExcelBuf: Record "Excel Buffer";
        FileName: Text;
        ServerFileName: text;
        SheetName: Text;
        cdtFileMgt: Codeunit "File Management";
        Text50000: Label 'Seleccione fichero';
        txtFileName: Text;
        RecordLink: Record "Record Link";
        ItemRecordId: RecordId;
        OStream: OutStream;
        txtEncoding: TextEncoding;

    trigger OnInitReport()
    begin
        ExcelBuf.LockTable();
        Item.LockTable();

        //FileName := cdtFileMgt.OpenFileDialog(Text50000, txtFileName, 'Archivos de Excl (*.xlsx)|*.xlsx|Todos los archivos (*.*)|*.*');
        ServerFileName := cdtFileMgt.UploadFile('Seleccione el fichero', FileName);


        // UploadFileWithFilter(Text50000, txtFileName, 'Archivos de Excl (*.xlsx)|*.xlsx|Todos los archivos (*.*)|*.*', '*.*');
        // ExcelBuf.OpenExcel();
        ExcelBuf.OpenExcelWithName(ServerFileName);
        ExcelBuf.ReadSheet();
        CargarComentarioProducto();
    end;

    trigger OnPostReport()
    begin
        ExcelBuf.DeleteAll();
    end;

    local procedure CargarComentarioProducto()
    begin
        if ExcelBuf.Find('-') then
            repeat
                if ExcelBuf."Column No." = 1 then
                    LocalizarRecordIdProducto();

                if ExcelBuf."Column No." = 2 then
                    AñadirComentarioProducto();

            until ExcelBuf.Next() = 0;
    end;

    local procedure LocalizarRecordIdProducto()
    begin
        Item.Get(ExcelBuf."Cell Value as Text");
        ItemRecordId := Item.RecordId;
    end;

    local procedure AñadirComentarioProducto()
    begin
        RecordLink.Init();
        RecordLink."Record ID" := ItemRecordId;
        RecordLink.Description := 'Ficha producto - ' + Item.Description;
        RecordLink.Note.CreateOutStream(OStream, txtEncoding);
        OStream.WriteText(ExcelBuf."Cell Value as Text");
        RecordLink.Insert();
    end;
}
