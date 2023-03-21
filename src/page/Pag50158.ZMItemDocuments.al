page 50158 "ZM Item Documents"
{
    Caption = 'ERPLINK Documentos productos', comment = 'ESP="ERPLINK Documentos productos"';
    PageType = ListPart;
    UsageCategory = None;
    //ApplicationArea = all;
    SourceTable = ComentariosPredefinidos;
    SourceTableView = sorting(Tipo, Extension, Description) where(Tipo = const(ERPLINKDocs));
    InsertAllowed = false;
    ModifyAllowed = false;

    // pagina para Servicio WEB de ERPLINK para cimworks

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                // field(Id; Id)
                // {
                //     ApplicationArea = all;
                // }
                field(itemno; CodComentario)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lineno; "Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        Rec.Extension := copystr(ExtractFileExtFromPath(Rec.Description), 1, MaxStrLen(Rec.Extension));
                    end;

                    trigger OnAssistEdit()
                    begin
                        DownloadFile;
                    end;
                }
                field(url; txtComentario)
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(txtComentario);
                    end;
                }
                field(Extension; Extension)
                {
                    ApplicationArea = All;
                    Visible = false;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action(SetExtension)
            // {
            //     ApplicationArea = all;
            //     Caption = 'Crear Extensión', comment = 'ESP="Crear Extensión"';
            //     Image = FileContract;

            //     trigger OnAction()
            //     begin
            //         Rec.Extension := copystr(ExtractFileExtFromPath(Rec.Description), 1, MaxStrLen(Rec.Extension));
            //         REc.Modify();
            //     end;
            // }
            action(HyperlinkURL)
            {
                ApplicationArea = all;
                Caption = 'URL', comment = 'ESP="URL"';
                Image = FileContract;

                trigger OnAction()
                begin
                    Hyperlink(txtComentario);
                end;
            }
            action(UpdatePicture)
            {
                ApplicationArea = all;
                Caption = 'Update picture', comment = 'ESP="Actualizar imagen"';
                Image = Picture;

                trigger OnAction()
                begin
                    UpdateFileJpg();

                end;
            }
            action(uploadFile)
            {
                ApplicationArea = all;
                Caption = 'Update picture', comment = 'ESP="Importar fichero"';
                Image = Picture;

                trigger OnAction()
                begin
                    UploadFileAttachment()
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        txtComentario := Rec.GetComentario();
        if Description = '' then
            Description := copystr(ExtractFileNameFromPath(txtComentario), 1, 100);
        if Description = '' then
            Description := copystr(txtComentario, 1, 100);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Id = 0 then
            Rec.Id := GetLastID + 1;
        if "Line No." = 0 then
            Rec."Line No." := GetLastLineNo();
        txtComentario := '';
        if Extension = '' then
            Rec.Extension := copystr(ExtractFileExtFromPath(Rec.Description), 1, MaxStrLen(Rec.Extension));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Id = 0 then
            Rec.Id := GetLastID + 1;
        if "Line No." = 0 then
            Rec."Line No." := GetLastLineNo();
        if txtComentario <> '' then
            Rec.SetComentario(txtComentario);
        if Rec.Extension = '' then
            Rec.Extension := copystr(ExtractFileExtFromPath(Rec.Description), 1, MaxStrLen(Rec.Extension));
        Rec.Tipo := Rec.Tipo::ERPLINKDocs;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if txtComentario <> '' then
            Rec.SetComentario(txtComentario);
        Rec.Tipo := Rec.Tipo::ERPLINKDocs;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Confirm(lblDelete) then
            Rec.DeleteFileAttachment(true);
    end;

    var
        Sharepoint: Codeunit "Sharepoint OAuth App. Helper";
        txtComentario: Text;
        lblDelete: Label '¿Do you want to delete the file attachment?', comment = 'ESP="¿Desea Eliminar el archivo adjunto?"';


    local procedure ExtractFileNameFromPath(PathAndFileTxt: Text) FileTxt: Text
    begin
        FileTxt := PathAndFileTxt;
        WHILE STRPOS(FileTxt, '\') <> 0 DO
            FileTxt := COPYSTR(FileTxt, 1 + STRPOS(FileTxt, '\'));
    end;

    local procedure ExtractFileExtFromPath(PathAndFileTxt: Text) FileTxt: Text
    begin
        FileTxt := PathAndFileTxt;
        WHILE STRPOS(FileTxt, '.') <> 0 DO
            FileTxt := COPYSTR(FileTxt, 1 + STRPOS(FileTxt, '.'));
    end;

    local procedure ExtractFileName(FileNameTxt: Text) FileTxt: Text
    begin
        FileTxt := FileNameTxt;
        WHILE STRPOS(FileTxt, '.') <> 0 DO
            FileTxt := COPYSTR(FileTxt, 1, STRPOS(FileTxt, '.') - 1);
    end;

    local procedure UpdateFileJpg()
    var
        CIMItemstemporary: Record "ZM CIM Items temporary";
        Docs: Record ComentariosPredefinidos;
        Sharepoint: Codeunit "Sharepoint OAuth App. Helper";
        Stream: InStream;
        lblConfirm: Label '¿Do you want to update the images?', comment = 'ESP="¿Desea actualizar la imagen?"';
    begin
        if not (Rec.Extension in ['jpg']) then
            exit;
        if not Confirm(lblConfirm) then
            exit;

        Docs.Reset();
        Docs.SetRange(CodComentario, Rec.CodComentario);
        Docs.SetRange(Extension, 'jpg');
        if Docs.FindFirst() then begin
            if Sharepoint.DownloadFileName(Docs.Description, Stream, 'jpg') then begin
                if CIMItemstemporary.Get(Rec.CodComentario) then begin
                    CIMItemstemporary.Picture.ImportStream(Stream, Docs.Description);
                    CIMItemstemporary.Modify();
                    //DownloadFromStream(Stream, '', '', '', Docs.Description);
                end;
            end;
        end;
        Message('Fin');
    end;


    local procedure DownloadFile()
    var
        CIMItemstemporary: Record "ZM CIM Items temporary";
        FileName: text;
        Stream: InStream;
        lblConfirm: Label '¿Do you want to download the file?', comment = 'ESP="¿Desea descargar el fichero?"';
    begin
        if not Confirm(lblConfirm) then
            exit;

        if Sharepoint.DownloadFileName(Rec.Description, Stream, Rec.Extension) then begin
            if CIMItemstemporary.Get(Rec.CodComentario) then begin
                FileName := Rec.Description;
                DownloadFromStream(Stream, '', '', '', FileName);
            end;
        end;

    end;

    local procedure UploadFileAttachment()
    var
        ComentariosPredefinidos: Record ComentariosPredefinidos;
        NVInStream: InStream;
        filterCode: text;
        FileName: text;
        OnlyFileName: text;
        FileExtension: text;
        WebUrl: text;
        Text000: Label 'Upload File', comment = 'ESP="Seleccionar fichero"';
    begin
        Rec.FilterGroup(4);
        filterCode := rec.GetFilter(CodComentario);
        Rec.FilterGroup(0);
        if UploadIntoStream(Text000, '', '', FileName, NVInStream) then begin
            FileExtension := ExtractFileExtFromPath(FileName);
            FileName := ExtractFileNameFromPath(FileName);
            OnlyFileName := ExtractFileName(FileName);
            if not Confirm('Subir fichero %1', true, FileName) then
                exit;
            ComentariosPredefinidos.Init();
            ComentariosPredefinidos.CodComentario := filterCode;
            ComentariosPredefinidos.Description := FileName;
            ComentariosPredefinidos.Extension := FileExtension;
            ComentariosPredefinidos.Tipo := ComentariosPredefinidos.Tipo::ERPLINKDocs;
            ComentariosPredefinidos.Insert(true);
            if Sharepoint.UploadFileStreeam(OnlyFileName, NVInStream, FileExtension, WebUrl) then begin
                ComentariosPredefinidos.SetComentario(WebUrl);
                ComentariosPredefinidos.Modify();
            end;
        end;
    end;
}