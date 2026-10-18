page 17230 "ZM PDM Pending Items"
{
    // Bandeja: planos aprobados en el PDM (desde la fecha de configuración) sin producto ni solicitud de alta
    Caption = 'PDM approved without item', comment = 'ESP="Aprobados PDM sin producto"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM PDM Document";
    SourceTableTemporary = true;
    SourceTableView = sorting("PDM Code");
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PDM Code"; "PDM Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Revision; Revision)
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
                field(Machine; Machine)
                {
                    ApplicationArea = All;
                }
                field(Modification; Modification)
                {
                    ApplicationArea = All;
                }
                field("Has PDF"; "Has PDF")
                {
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                }
                field(Folder; Folder)
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
            action(CreateRequests)
            {
                ApplicationArea = All;
                Caption = 'Create request', comment = 'ESP="Crear solicitud"';
                ToolTip = 'Creates a new item request for each selected drawing (one per color when the drawing is a color variant ''-X'').', comment = 'ESP="Crea una solicitud de alta por cada plano seleccionado (una por color si el plano es de variantes ''-X'')."';
                Image = NewItem;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TempSelected: Record "ZM PDM Document" temporary;
                begin
                    TempSelected.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(TempSelected);
                    PDMSync.CreateRequestsFromTray(TempSelected);
                    PDMSync.BuildPendingTray(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(OpenPDF)
            {
                ApplicationArea = All;
                Caption = 'View drawing (PDF)', comment = 'ESP="Ver plano (PDF)"';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    PDMSync.OpenCodePDF(Rec."PDM Code");
                end;
            }
            action(OpenFile)
            {
                ApplicationArea = All;
                Caption = 'Open SolidWorks file', comment = 'ESP="Abrir fichero SolidWorks"';
                Image = Document;

                trigger OnAction()
                begin
                    PDMSync.OpenDocumentFile(Rec);
                end;
            }
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
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh', comment = 'ESP="Actualizar"';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    PDMSync.BuildPendingTray(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        PDMSync.BuildPendingTray(Rec);
    end;

    var
        PDMSync: Codeunit "ZM PDM Sync";
}
