page 17381 "ZM Import files folder"
{
    Caption = 'Import files folders', comment = 'ESP="Importar ficheros de carpeta"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = File;
    SourceTableTemporary = true;
    InsertAllowed = false;

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

    local procedure AssignFile()
    var
        VendorShipmentNo: text;
    begin
        if PostedPurchaseReceipts.RunModal() = Action::LookupOK then begin
            PostedPurchaseReceipts.GetRecord(PurchaseRcptHeader);
            RecordLinkSharepoint.UploadFile(PurchaseRcptHeader.RecordId, FileManagement.GetExtension(Rec.Name), VendorShipmentNo, Rec.Name);
        end
    end;

    local procedure GetReceiptNo(): Integer
    var

    begin
        RecordLinkSharepoint.Reset();
        // RecordLinkSharepoint.SetRange("Document No.", Rec.);
    end;
}