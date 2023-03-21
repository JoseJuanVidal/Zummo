page 17379 "Sharepont Drive Items"
{
    Caption = 'Sharepont Documents', Comment = 'ESP="Sharepoint Documentos"';
    PageType = List;
    SourceTable = "Online Drive Item";
    SourceTableTemporary = true;
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
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

                trigger OnAction()
                begin
                    DeleteItem;
                end;
            }
            action("Upload a File")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    UploadFile();
                end;
            }
            action("Download a File")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    DownloadFile();
                end;
            }

        }
    }
    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        SharepointAppHelper: Codeunit "Sharepoint OAuth App. Helper";
        AccessToken: Text;
        FolderPath: Text;
        ConfirmMsg: Label '¿Do you want to delete the selected item?', Comment = 'ESP="¿Desea eliminar el elemento seleccionado?"';

    procedure SetProperties(NewAccessToken: Text; NewFolderPath: Text; DriveID: Text; ParentID: Text)
    var
        TempOnlineDriveItem: Record "Online Drive Item" temporary;
    begin
        AccessToken := NewAccessToken;
        FolderPath := NewFolderPath;

        if ParentID = '' then
            SharepointAppHelper.FetchDrivesItems(AccessToken, DriveID, TempOnlineDriveItem)
        else
            SharepointAppHelper.FetchDrivesChildItems(AccessToken, ParentID, DriveID, TempOnlineDriveItem);

        Rec.Copy(TempOnlineDriveItem, true);
    end;

    // local procedure OpenDriveItems()
    // var
    //     OnlineDriveItems: Page "Sharepont Drive Items";
    //     Stream: InStream;
    // begin
    //     if not isFile then begin
    //         OnlineDriveItems.SetProperties(AccessToken, StrSubstNo('%1/%2', FolderPath, name), driveId, Id);
    //         OnlineDriveItems.Run();
    //     end else begin
    //         if OnlineDriveAPI.DownloadFile(AccessToken, driveId, id, Stream) then
    //             DownloadFromStream(Stream, '', '', '', name);
    //     end;
    // end;

    local procedure DeleteItem()
    begin
        if not Confirm(ConfirmMsg, false) then
            exit;
        PurchaseSetup.Get();
        AccessToken := SharepointAppHelper.GetAccessToken(PurchaseSetup."Sharepoint Connection");
        if SharepointAppHelper.DeleteDriveItem(AccessToken, driveId, id) then
            Delete();
    end;

    local procedure UploadFile()
    var
        OnlineDriveItem: Record "Online Drive Item" temporary;
        FromFile: Text;
        Stream: InStream;
    begin
        PurchaseSetup.Get();
        AccessToken := SharepointAppHelper.GetAccessToken(PurchaseSetup."Sharepoint Connection");
        if UploadIntoStream('Select a File', '', '', FromFile, Stream) then begin
            SharepointAppHelper.UploadFile(AccessToken, driveId, parentId, FolderName, FromFile, Stream, OnlineDriveItem);



        end;

    end;

    local procedure DownloadFile()
    var
        FromFile: Text;
        Stream: InStream;
    begin
        PurchaseSetup.Get();
        AccessToken := SharepointAppHelper.GetAccessToken(PurchaseSetup."Sharepoint Connection");
        if SharepointAppHelper.DownloadFile(AccessToken, driveId, id, Stream) then
            DownloadFromStream(Stream, '', '', '', name);
    end;
}
