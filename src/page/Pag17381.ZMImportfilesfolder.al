page 17381 "ZM Import files folder"
{
    Caption = 'Import files folders', comment = 'ESP="Importar ficheros de carpeta"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = File;
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Files)
            {
                Caption = 'Files', comment = 'ESP="Ficheros"';
                field(Name; Name)
                {
                    ApplicationArea = all;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(StrSubstNo('%1\%2', Rec.Path, Rec.Name));
                    end;
                }
                field(Path; Path)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Date; Date)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Size; Size)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Is a file"; "Is a file")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(ReceiptNo; ReceiptNo)
                {
                    ApplicationArea = all;
                    Caption = 'Nº Albaranes', comment = 'ESP="Nº Albaranes"';

                    trigger OnAssistEdit()
                    begin
                        ShowReceipts();
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh', comment = 'ESP="Actualizar"';
                Image = Refresh;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    UpdateFilesPath();
                end;
            }
            action(Assing)
            {
                ApplicationArea = all;
                Caption = 'Assign', comment = 'ESP="Asignar Fichero"';
                Image = Allocate;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    AssignFile(Rec);
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        ReceiptNo := GetReceiptNo();
    end;

    var
        PurchaseRcptHeader: Record "Purch. Rcpt. Header";
        FileFolder: Record File;
        RecordLinkSharepoint: record "ZM SH Record Link Sharepoint";
        PostedPurchaseReceipts: page "Posted Purchase Receipts";
        FileManagement: Codeunit "File Management";
        ReceiptNo: Integer;
        lblName: Label 'Select Folder', comment = 'ESP="Seleccionar carpeta"';

    local procedure UpdateFilesPath()
    var
        SelectFolder: text;
    begin
        // if FileManagement.SelectFolderDialog('', SelectFolder) then begin
        SelectFolder := 'C:\Zummo\temp';
        Rec.DeleteAll();
        FileFolder.Reset();
        FileFolder.SetRange(Path, SelectFolder);
        FileFolder.SetRange("Is a file", true);
        if FileFolder.FindFirst() then
            repeat
                Rec.Init();
                Rec.Copy(FileFolder);
                Rec.Insert();
            Until FileFolder.next() = 0;

        // end;
    end;

    local procedure AssignFile(AssignFile: Record File)
    var
        TempBlob: Record TempBlob;
        FileManagement: Codeunit "File Management";
        Stream: InStream;
        VendorShipmentNo: text;
        FileName: text;
        ServerFileName: text;
    begin
        Clear(PostedPurchaseReceipts);
        PostedPurchaseReceipts.LookupMode := true;
        if PostedPurchaseReceipts.RunModal() = Action::LookupOK then begin
            FileName := StrSubstNo('%1\%2', AssignFile.Path, AssignFile.Name);
            ServerFileName := FileManagement.ServerTempFileName(FileManagement.GetExtension(Name));
            FileManagement.UploadFileSilentToServerPath(FileName, ServerFileName);
            TempBlob.Blob.CreateInStream(Stream);
            TempBlob.Blob.Import(ServerFileName);
            // DownloadFromStream(Stream, '', '', '', FileName);
            PostedPurchaseReceipts.GetRecord(PurchaseRcptHeader);
            if PurchaseRcptHeader."Vendor Shipment No." = '' then
                VendorShipmentNo := PurchaseRcptHeader."No."
            else
                VendorShipmentNo := PurchaseRcptHeader."Vendor Shipment No.";
            RecordLinkSharepoint.UploadFilefromStream(PurchaseRcptHeader.RecordId, PurchaseRcptHeader."Buy-from Vendor Name", VendorShipmentNo, PurchaseRcptHeader."No.",
                VendorShipmentNo, Rec.Name, Stream);
        end
    end;

    local procedure GetReceiptNo(): Integer
    begin
        RecordLinkSharepoint.Reset();
        RecordLinkSharepoint.SetRange("File Name", Rec.Name);
        exit(RecordLinkSharepoint.Count);
    end;

    local procedure ShowReceipts()
    var
        RecordLinkShareplist: page "ZM SH Record Link Sharep. list";
    begin
        RecordLinkSharepoint.Reset();
        RecordLinkSharepoint.SetRange("File Name", Rec.Name);
        RecordLinkShareplist.SetTableView(RecordLinkSharepoint);
        RecordLinkShareplist.RunModal();
    end;
}