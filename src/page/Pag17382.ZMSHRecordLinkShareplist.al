page 17382 "ZM SH Record Link Sharep. list"
{
    Caption = 'Sharepoint Documents', comment = 'ESP="Documentos Sharepoint"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM SH Record Link Sharepoint";
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DownloadFile()
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    begin
                        ShowDocument();
                    end;
                }
                field(URL; URL)
                {
                    ApplicationArea = all;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DownloadFile()
                    end;
                }
            }
        }
    }

    local procedure ShowDocument()
    begin
        Rec.DownloadFile();
    end;
}