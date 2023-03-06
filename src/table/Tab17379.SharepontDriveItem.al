table 17379 "Sharepont Drive Item"
{
    Caption = 'SharePoint Documents', comment = 'ESP="Sharepoint Documentos"';
    DataClassification = CustomerContent;
    LookupPageId = "Sharepont Drive Items";
    DrillDownPageId = "Sharepont Drive Items";

    fields
    {
        field(1; id; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Id', comment = 'ESP="Código"';
        }
        field(2; driveId; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Drive Id', comment = 'ESP="ID Carpeta"';
        }
        field(3; parentId; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Parent ID', comment = 'ESP="ID Parent"';

        }
        field(4; FolderName; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Folder Name', comment = 'ESP="Nombre Carpeta"';
        }
        field(5; name; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Name', comment = 'ESP="Nombre"';
        }
        field(6; url; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'URL', comment = 'ESP="URL"';
        }
        field(9; createdDateTime; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Creation DateTime', comment = 'ESP="Fecha/Hora Creación"';
        }
        field(20; "Table id"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Record id"; RecordId)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }

    var
        FilterTableID: Integer;
        FilterRecorId: RecordId;
        FilterFolderName: Text;

    procedure SetIDS(TableID: Integer; RecorId: RecordId; FolderName: text)
    begin
        FilterTableID := TableID;
        FilterRecorId := RecorId;
        FilterFolderName := FolderName;
    end;


    procedure CreateRecordOnlineDriveItem(OnlineDriveItem: Record "Online Drive Item")
    var
        SharepontDriveItem: record "Sharepont Drive Item";
    begin
        SharepontDriveItem.Init();
        SharepontDriveItem.id := CreateGuid();
        SharepontDriveItem."Table id" := FilterTableID;
        SharepontDriveItem."Record id" := FilterRecorId;
        SharepontDriveItem.FolderName := FilterFolderName;
        SharepontDriveItem.driveId := OnlineDriveItem.driveId;
        SharepontDriveItem.parentId := OnlineDriveItem.parentId;
        SharepontDriveItem.name := OnlineDriveItem.name;
        SharepontDriveItem.url := OnlineDriveItem.webUrl;
        SharepontDriveItem.createdDateTime := CreateDateTime(WorkDate(), time());
        SharepontDriveItem.Insert();
    end;
}
