page 17379 "Sharepont Drive Items"
{
    Caption = 'Sharepont Documents', Comment = 'ESP="Sharepoint Documentos"';
    PageType = List;
    SourceTable = "Online Drive Item";
    SourceTableTemporary = true;
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(Creation)
            {
                Caption = 'Creation', comment = 'ESP="Datos Crear"';
                field(FolderName; FolderName)
                {
                    ApplicationArea = all;
                    Caption = 'New Folder Name', comment = 'ESP="Nuevo Nombre carpeta"';
                }

            }
            repeater(General)
            {
                Editable = false;
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(parentId; Rec.parentId)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(driveId; Rec.driveId)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                // field(FolderName; Rec.FolderName)
                // {
                //     ApplicationArea = All;
                //     Visible = false;
                // }
                field(name; Rec.name)
                {
                    ApplicationArea = All;
                }
                field(webUrl; webUrl)
                {
                    ApplicationArea = all;

                    trigger OnAssistEdit()
                    begin
                        if REc.isFile then
                            Hyperlink(Weburl)
                        else
                            Rec.OpenDriveItems();

                    end;
                }
                // field("Table id"; Rec."Table id")
                // {
                //     ApplicationArea = All;
                //     Visible = false;
                // }
                // field("Record id"; Rec."Record id")
                // {
                //     ApplicationArea = All;
                //     Visible = false;
                // }
                field(createdDateTime; Rec.createdDateTime)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(HyperlinkURL)
            {
                ApplicationArea = all;
                Caption = 'URL', comment = 'ESP="URL"';
                Image = FileContract;

                trigger OnAction()
                begin
                    Hyperlink(Weburl);
                end;
            }
            action("Delete the selected item")
            {
                ApplicationArea = All;
                ShortcutKey = 'shift + f4';
                Image = Delete;

                trigger OnAction()
                begin
                    DeleteItem;
                end;
            }
            action("Upload a File")
            {
                ApplicationArea = All;
                Image = MachineCenterLoad;

                trigger OnAction()
                begin
                    UploadFile();
                end;
            }
            action("Download a File")
            {
                ApplicationArea = All;
                Image = Download;

                trigger OnAction()
                begin
                    DownloadFile();
                end;
            }
            action("Create Folder")
            {
                ApplicationArea = All;
                Image = CreateMovement;

                trigger OnAction()
                begin
                    CreateFolder();
                end;
            }
        }
        area(Navigation)
        {
            action(Folders)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Folders', Comment = 'ESP="Carpetas"';
                Image = SelectField;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Refresh the access and refresh tokens.';

                trigger OnAction()
                begin
                    Rec.TestField(isFile, false);
                    Rec.OpenDriveItems();
                end;
            }
        }
    }
    var
        SharepointAppHelper: Codeunit "Sharepoint OAuth App. Helper";
        ApplicationCode: code[20];
        FolderName: Text;
        AccessToken: Text;
        FolderPath: Text;
        ConfirmMsg: Label '¿Do you want to delete the selected item?', Comment = 'ESP="¿Desea eliminar el elemento seleccionado?"';
        lblError: Label 'You must specify a Folder name.', comment = 'ESP="Debe indicar un nombre de Carpeta."';

    procedure SetProperties(NewApplicationCode: code[20]; NewAccessToken: Text; NewFolderPath: Text; DriveID: Text; ParentID: Text)
    var
        TempOnlineDriveItem: Record "Online Drive Item" temporary;
    begin
        AccessToken := NewAccessToken;
        FolderPath := NewFolderPath;
        ApplicationCode := NewApplicationCode;

        if ParentID = '' then
            SharepointAppHelper.FetchDrivesItems(ApplicationCode, AccessToken, DriveID, TempOnlineDriveItem)
        else
            SharepointAppHelper.FetchDrivesChildItems(ApplicationCode, AccessToken, ParentID, DriveID, TempOnlineDriveItem);

        Rec.Copy(TempOnlineDriveItem, true);
    end;



    local procedure DeleteItem()
    begin
        if not Confirm(ConfirmMsg, false) then
            exit;

        AccessToken := SharepointAppHelper.GetAccessToken(Rec."Application Code");
        if SharepointAppHelper.DeleteDriveItem(AccessToken, driveId, id) then
            Delete();
    end;

    local procedure UploadFile()
    var
        OnlineDriveItem: Record "Online Drive Item" temporary;
        FromFile: Text;
        Stream: InStream;
    begin

        AccessToken := SharepointAppHelper.GetAccessToken(Rec."Application Code");
        if UploadIntoStream('Select a File', '', '', FromFile, Stream) then begin
            SharepointAppHelper.UploadFile(AccessToken, driveId, parentId, FolderName, FromFile, Stream, OnlineDriveItem);
        end;

    end;

    local procedure DownloadFile()
    var
        FromFile: Text;
        Stream: InStream;
    begin

        AccessToken := SharepointAppHelper.GetAccessToken(Rec."Application Code");
        if SharepointAppHelper.DownloadFile(AccessToken, driveId, id, Stream) then
            DownloadFromStream(Stream, '', '', '', name);
    end;

    local procedure CreateFolder()
    var
        lblConfirFolder: Label '¿Do you want to create the %1 folder?', comment = 'ESP="¿Desea crear la carpeta %1?"';
    begin
        if FolderName = '' then
            Error(lblError);
        AccessToken := SharepointAppHelper.GetAccessToken(Rec."Application Code");
        if Confirm(ConfirmMsg, true, FolderName) then
            if SharepointAppHelper.CreateDriveFolder(ApplicationCode, AccessToken, driveId, parentId, FolderName, Rec) then
                Message(StrSubstNo('Folder %1 created.', FolderName));

    end;
}
