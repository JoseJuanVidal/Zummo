page 17380 "ZM SH Record Link Sharepoints"
{
    Caption = 'Sharepoint Documents', comment = 'ESP="Documentos Sharepoint"';
    PageType = ListPart;
    UsageCategory = None;
    SourceTable = "ZM SH Record Link Sharepoint";
    InsertAllowed = false;
    ModifyAllowed = false;

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

    actions
    {
        area(Processing)
        {
            action("Upload a File")
            {
                ApplicationArea = All;
                Caption = 'Upload a file', comment = 'ESP="Importar fichero"';
                Image = Import;

                trigger OnAction()
                begin
                    UploadFile(Record_ID, PrefixNo, ExtDocNo);
                    CurrPage.Update();
                end;
            }
            // action(Filtro)
            // {
            //     ApplicationArea = All;
            //     Image = FilterLines;

            //     trigger OnAction()
            //     begin
            //         if Rec.GetFilter("Record ID") = '' then
            //             Rec.SetRange("Record ID", Record_ID)
            //         else
            //             Rec.SetRange("Record ID");
            //     end;
            // }
        }
    }

    trigger OnOpenPage()
    begin
        SetRecordIR(Record_ID, '', ExtDocNo);
    end;

    var

        Record_ID: RecordId;
        ExtDocNo: text;
        PrefixNo: text;


    procedure SetRecordIR(NewRecordID: RecordId; PrefixDocNo: text; ExternaltDocNo: text)
    begin
        PrefixNo := PrefixDocNo;
        Record_ID := NewRecordID;
        ExtDocNo := ExternaltDocNo;
        Rec.SetRange("Record ID", Record_ID);
        CurrPage.Update();
    end;


}