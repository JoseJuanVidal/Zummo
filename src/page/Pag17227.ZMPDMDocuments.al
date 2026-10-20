page 17227 "ZM PDM Documents"
{
    Caption = 'PDM Documents', comment = 'ESP="Documentos PDM"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM PDM Document";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PDM Code"; "PDM Code")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field(Extension; Extension)
                {
                    ApplicationArea = All;
                }
                field("Has PDF"; "Has PDF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Revision; Revision)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Approval Date"; "Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
                field("Current Status"; "Current Status")
                {
                    ApplicationArea = All;
                }
                field("In Modification"; "In Modification")
                {
                    ApplicationArea = All;
                }
                field(Obsolete; Obsolete)
                {
                    ApplicationArea = All;
                }
                field(Modification; Modification)
                {
                    ApplicationArea = All;
                }
                field(Machine; Machine)
                {
                    ApplicationArea = All;
                }
                field(Material; Material)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Weight; Weight)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Description ENG"; "Description ENG")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Description FRA"; "Description FRA")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Approved Version"; "Approved Version")
                {
                    ApplicationArea = All;
                }
                field("Latest Version"; "Latest Version")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Approval User"; "Approval User")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Folder; Folder)
                {
                    ApplicationArea = All;
                }
                field("No. of Items"; "No. of Items")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        PDMSync.ShowDocumentItems(Rec);
                    end;
                }
                field("Document ID"; "Document ID")
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
            action(OpenFile)
            {
                ApplicationArea = All;
                Caption = 'Open file', comment = 'ESP="Abrir fichero"';
                ToolTip = 'Opens the approved version of the file from the PDM vault.', comment = 'ESP="Abre la versión aprobada del fichero desde el almacén del PDM."';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PDMSync.OpenDocumentFile(Rec);
                end;
            }
        }
        area(Navigation)
        {
            action(History)
            {
                ApplicationArea = All;
                Caption = 'PDM History', comment = 'ESP="Histórico PDM"';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "ZM PDM History";
                RunPageLink = "Document ID" = field("Document ID");
                RunPageView = sorting("Date") order(descending);
            }
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items', comment = 'ESP="Productos"';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    PDMSync.ShowDocumentItems(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := '';
        if "In Modification" then
            StyleTxt := 'Ambiguous';
        if Obsolete then
            StyleTxt := 'Subordinate';
    end;

    var
        PDMSync: Codeunit "ZM PDM Sync";
        StyleTxt: Text;
}
