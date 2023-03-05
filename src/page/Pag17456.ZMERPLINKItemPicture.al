page 17456 "ZM ERPLINK Item Picture"
{
    Caption = 'Item Picture', Comment = 'ESP="Imagen producto"';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "ZM CIM Items temporary";

    layout
    {
        area(content)
        {
            field(Picture; Picture)
            {
                ApplicationArea = Basic, Suite, Invoicing;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the item.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                ApplicationArea = All;
                Caption = 'Take', Comment = 'ESP="Hacer"';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Activate the camera on the device.', Comment = 'ESP="Activa la cámara en el dispositivo."';
                Visible = CameraAvailable AND (HideActions = FALSE);

                trigger OnAction()
                begin
                    TakeNewPicture;
                end;
            }
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import', Comment = 'ESP="Importar"';
                Image = Import;
                ToolTip = 'Import a picture file.', Comment = 'ESP="Importa un archivo de imagen."';
                Visible = HideActions = FALSE;

                trigger OnAction()
                begin
                    ImportFromDevice;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = All;
                Caption = 'Export', Comment = 'ESP="Exportar"';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTip = 'Export the picture to a file.', Comment = 'ESP="Exporta la imagen a un archivo."';
                Visible = HideActions = FALSE;

                trigger OnAction()
                var
                    DummyPictureEntity: Record "Picture Entity";
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    TESTFIELD("No.");
                    TESTFIELD(Description);

                    ToFile := DummyPictureEntity.GetDefaultMediaDescription(Rec);
                    ExportPath := TEMPORARYPATH + "No." + FORMAT(Picture.MEDIAID);
                    Picture.EXPORTFILE(ExportPath + '.' + DummyPictureEntity.GetDefaultExtension);

                    FileManagement.ExportImage(ExportPath, ToFile);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete', Comment = 'ESP="Eliminar"';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.', Comment = 'ESP="Elimina el registro."';
                Visible = HideActions = FALSE;

                trigger OnAction()
                begin
                    DeleteItemPicture;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    trigger OnOpenPage()
    begin
        CameraAvailable := CameraProvider.IsAvailable;
        IF CameraAvailable THEN
            CameraProvider := CameraProvider.Create;
    end;

    var
        [RunOnClient]
        [WithEvents]
        CameraProvider: DotNet CameraProvider;
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        HideActions: Boolean;
        MustSpecifyDescriptionErr: Label 'You must add a description to the item before you can import a picture.';

    procedure TakeNewPicture()
    var
        CameraOptions: DotNet CameraOptions;
    begin
        FIND;
        TESTFIELD("No.");
        TESTFIELD(Description);

        IF NOT CameraAvailable THEN
            EXIT;

        CameraOptions := CameraOptions.CameraOptions;
        CameraOptions.Quality := 50;
        CameraProvider.RequestPictureAsync(CameraOptions);
    end;

    [Scope('Internal')]
    procedure ImportFromDevice()
    var
        FileManagement: Codeunit "File Management";
        FileName: Text;
        ClientFileName: Text;
    begin
        FIND;
        TESTFIELD("No.");
        IF Description = '' THEN
            ERROR(MustSpecifyDescriptionErr);

        IF Picture.COUNT > 0 THEN
            IF NOT CONFIRM(OverrideImageQst) THEN
                ERROR('');

        ClientFileName := '';
        FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
        IF FileName = '' THEN
            ERROR('');

        CLEAR(Picture);
        Picture.IMPORTFILE(FileName, ClientFileName);
        IF NOT INSERT(TRUE) THEN
            MODIFY(TRUE);

        IF FileManagement.DeleteServerFile(FileName) THEN;

        if Confirm('Desea subir el archivo a Sharepoint') then
            UpdateSharepoint;
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Picture.COUNT <> 0;
    end;

    procedure IsCameraAvailable(): Boolean
    begin
        EXIT(CameraProvider.IsAvailable);
    end;

    procedure SetHideActions()
    begin
        HideActions := TRUE;
    end;

    procedure DeleteItemPicture()
    begin
        TESTFIELD("No.");

        IF NOT CONFIRM(DeleteImageQst) THEN
            EXIT;

        CLEAR(Picture);
        MODIFY(TRUE);
    end;

    trigger CameraProvider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
    var
        File: File;
        Instream: InStream;
    begin
        IF (PictureName = '') OR (PictureFilePath = '') THEN
            EXIT;

        IF Picture.COUNT > 0 THEN
            IF NOT CONFIRM(OverrideImageQst) THEN BEGIN
                IF ERASE(PictureFilePath) THEN;
                EXIT;
            END;

        File.OPEN(PictureFilePath);
        File.CREATEINSTREAM(Instream);

        CLEAR(Picture);
        Picture.IMPORTSTREAM(Instream, PictureName);
        IF NOT MODIFY(TRUE) THEN
            INSERT(TRUE);

        File.CLOSE;
        IF ERASE(PictureFilePath) THEN;
    end;

    local procedure UpdateSharepoint()
    var
        TenantMedia: Record "Tenant Media";
        Sharepoint: Codeunit "Sharepoint OAuth App. Helper";
        InStreamPic: InStream;
        Index: Integer;
    begin
        if Rec.Picture.Count = 0 then
            exit;

        for index := 1 to Rec.Picture.Count do begin
            if TenantMedia.Get(Rec.Picture.Item(Index)) then begin
                TenantMedia.CalcFields(Content);
                if TenantMedia.Content.HasValue then begin
                    TenantMedia.Content.CreateInStream(InStreamPic);

                    Sharepoint.UploadFileStreeam(Rec."No.", InStreamPic, TenantMedia."Mime Type");

                end;
            end;
        end;
    end;
}

