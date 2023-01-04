codeunit 50119 "ZM Visual code utilities"
{
    trigger OnRun()
    begin

    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;

    procedure CheckLanguageTranslation()
    // var
    //     LanguageFile: File;
    //     FileMngt: Codeunit "File Management";
    //     FileName: Text;
    // begin
    //     FileName := FileMngt.OpenFileDialog('Fichero translation', '', 'Translation (*.XLF)|*.XLF|All Files (*.*)|*.*');
    //     if FileName = '' then
    //         exit;
    //     LanguageFile.TextMode(True);
    //     LanguageFile.WriteMode(False);
    //     LanguageFile.Open(FileName);

    var
        InStr: InStream;
        FileName: Text;
        NumberOfBytesRead: Integer;
        Position: Integer;
        Contar: Integer;
        TextRead: Text;
        Completo: Text;
        Valor1: text;
        Valor2: text;
        Valor3: text;
        Ventana: Dialog;
    begin
        // https://community.dynamics.com/business/b/tabrezblog/posts/how-to-read-file-content-in-dynamics-365-business-central-al-programming
        // You can read from or write to streams by using the InStream and OutStream methods.The Temp Blob codeunit can be used to convert between the two stream types.
        // The InStream data type can be used to read bytes from a stream object.The data is read in binary format, and you can use the Read and ReadText functions to read that format.
        if (File.UploadIntoStream('Open File', '', 'Translation (*.XLF)|*.XLF|All Files (*.*)|*.*',
                                 FileName, InStr)) then begin
            // If you use read then while written after read will not read anything because already everything in InStream variable is read -- vice versa
            // InStr.Read(TextRead);
            // Message(TextRead);
            Ventana.Open('#1#########\#2##########################################################');

            InitExcel();

            // Start: Read Each Line one by one
            while not InStr.EOS() do begin
                Contar += 1;
                Ventana.Update(1, Contar);
                NumberOfBytesRead := InStr.ReadText(TextRead, 500);
                Ventana.Update(2, TextRead);
                Position := text.StrPos(TextRead, 'priority="2">');
                if Position > 0 then begin
                    Completo := CopyStr(TextRead, Position, NumberOfBytesRead - Position);


                    Valor3 := copystr(GetTranslate3(Completo), 1, 250);
                    if Valor3 <> '' then begin
                        Valor2 := copystr(GetTranslate2(Valor3), 1, 250);
                        Valor1 := copystr(GetTranslate1(Valor3), 1, 250);

                        AddExcelLine(format(Contar), Valor1, Valor2, Valor3);
                    end;

                end;
                // Message('%1\Size: %2', TextRead, NumberOfBytesRead);
            end;
            // Stop: Read Each Line one by one
            Ventana.Close();
            FinExcel();
        end;
    end;

    local procedure GetTranslate3(Valor: text) respuesta: text;
    var
        Posicion: Integer;
        Posicion2: Integer;
    begin
        Posicion := StrPos(Valor, '>') + 1;
        Posicion2 := StrPos(Valor, '<');
        if Posicion2 > Posicion then
            respuesta := CopyStr(Valor, Posicion, Posicion2 - Posicion);
    end;

    local procedure GetTranslate2(Valor: text) respuesta: text;
    var
        Posicion: Integer;
    begin
        Posicion := StrPos(Valor, '",') + 1;
        respuesta := CopyStr(Valor, Posicion + 1, 5);
    end;

    local procedure GetTranslate1(Valor: text) respuesta: text;
    var
        Posicion: Integer;
    begin
        respuesta := CopyStr(Valor, 1, 5);
    end;


    local procedure AddExcelLine(Valor: text; Valor2: text; Valor3: text; Valor4: text)
    begin
        ExcelBuffer.AddColumn(Valor, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Valor2, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Valor3, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Valor4, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

    local procedure InitExcel()
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.AddColumn('Idioma', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Idioma2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Idioma3', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

    local procedure FinExcel()
    begin
        ExcelBuffer.CreateNewBook('Planificacion');

        ExcelBuffer.WriteSheet('Traducción', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Traduccion');
        ExcelBuffer.DownloadAndOpenExcel;
    end;

}