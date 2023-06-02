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
                Caption = 'Assign', comment = 'ESP="Asignar archivo"';
                Image = Allocate;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    AssignFile(Rec);
                end;
            }
            action(Limpiar)
            {
                ApplicationArea = all;
                Caption = 'Save files', comment = 'ESP="Guardar archivos"';
                Image = DeleteRow;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SaveFile();
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        ReceiptNo := GetReceiptNo(Rec);
    end;

    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        PurchaseRcptHeader: Record "Purch. Rcpt. Header";
        NameValueBuffer: Record "Name/Value Buffer" temporary;
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
        PurchaseSetup.Get();
        PurchaseSetup.TestField("Path Purchase Documents");
        SelectFolder := PurchaseSetup."Path Purchase Documents";
        Rec.DeleteAll();
        FileManagement.GetClientDirectoryFilesList(NameValueBuffer, SelectFolder);
        if NameValueBuffer.FindFirst() then
            repeat
                Rec.Init();
                Rec.Path := SelectFolder;
                Rec.Name := copystr(FileManagement.GetFileName(NameValueBuffer.Name), 1, MaxStrLen(Rec.Name));
                Rec."Is a file" := true;
                Rec.Insert();
            Until NameValueBuffer.next() = 0;

        // end;
    end;

    local procedure AssignFile(AssignFile: Record File)
    var
        TempBlob: Record TempBlob;
        Stream: InStream;
        VendorShipmentNo: text;
        FileName: text;
        ServerFileName: text;
    begin
        PurchaseSetup.Get();
        Clear(PostedPurchaseReceipts);
        PostedPurchaseReceipts.LookupMode := true;
        PurchaseRcptHeader.Reset();
        if PurchaseRcptHeader.findlast then;
        PostedPurchaseReceipts.SetTableView(PurchaseRcptHeader);
        if PostedPurchaseReceipts.RunModal() = Action::LookupOK then begin
            PostedPurchaseReceipts.SetSelectionFilter(PurchaseRcptHeader);
            if PurchaseRcptHeader.FindFirst() then
                repeat
                    FileName := StrSubstNo('%1\%2', AssignFile.Path, AssignFile.Name);
                    ServerFileName := FileManagement.ServerTempFileName(FileManagement.GetExtension(Name));
                    FileManagement.UploadFileSilentToServerPath(FileName, ServerFileName);
                    TempBlob.Blob.CreateInStream(Stream);
                    TempBlob.Blob.Import(ServerFileName);

                    VendorShipmentNo := delchr(StrSubstNo('%1 %2', PurchaseRcptHeader."No.", PurchaseRcptHeader."Vendor Shipment No."), '=', '\/');
                    RecordLinkSharepoint.UploadFilefromStream(PurchaseRcptHeader.RecordId, PurchaseRcptHeader."Buy-from Vendor Name", VendorShipmentNo, PurchaseRcptHeader."No.",
                        VendorShipmentNo, Rec.Name, Stream);
                    Commit();
                    FileManagement.CopyClientFile(StrSubstNo('%1\%2', Rec.Path, Rec.Name),
                        StrSubstNo('%1\%2 %3.%4', Rec.Path, PurchaseRcptHeader."Buy-from Vendor Name", VendorShipmentNo, FileManagement.GetExtension(Rec.Name)), true);
                    // guardar el fichero en la unidad de red de COMPRAS
                    if PurchaseSetup."Path Purchase Docs. pending" <> '' then begin
                        FileManagement.CopyClientFile(StrSubstNo('%1\%2', Rec.Path, Rec.Name),
                            StrSubstNo('%1\%2 %3.%4', PurchaseSetup."Path Purchase Docs. pending", PurchaseRcptHeader."Buy-from Vendor Name", VendorShipmentNo, FileManagement.GetExtension(Rec.Name)), true);
                    end;

                    SaveLocalFilesPosted(StrSubstNo('%1 %2.%3', PurchaseRcptHeader."Buy-from Vendor Name", VendorShipmentNo, FileManagement.GetExtension(Rec.Name)));
                until PurchaseRcptHeader.Next() = 0;
            Message(StrSubstNo('Asignados %1', PurchaseRcptHeader.Count));
        end;

    end;

    local procedure SaveLocalFilesPosted(FileName: text)
    var
        myInt: Integer;
    begin
        if not FileManagement.ClientDirectoryExists(StrSubstNo('%1\%2', format(Date2DMY(WorkDate(), 3)))) then
            FileManagement.CreateClientDirectory(StrSubstNo('%1\%2', Rec.Path, format(Date2DMY(WorkDate(), 3))));
        // movemos el fichero en historial de carpeta local
        FileManagement.CopyClientFile(StrSubstNo('%1\%2', Rec.Path, Rec.Name),
            StrSubstNo('%1\%2\%3', Rec.Path, format(Date2DMY(WorkDate(), 3)), FileName), true);

    end;

    local procedure GetReceiptNo(RecFile: Record File): Integer
    begin
        RecordLinkSharepoint.Reset();
        RecordLinkSharepoint.SetRange("File Name", RecFile.Name);
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

    local procedure SaveFile()
    var
        lblConfirm: Label '¿Do you want to save the files in a history folder?', comment = 'ESP="¿Desea guardar los archivos en carpeta histórico?"';
    begin
        if Rec.FindFirst() then
            repeat
                if GetReceiptNo(Rec) > 0 then
                    FileManagement.DeleteClientFile(StrSubstNo('%1\%2', Rec.Path, Rec.Name));

            until Rec.Next() = 0;
        UpdateFilesPath();
    end;
}