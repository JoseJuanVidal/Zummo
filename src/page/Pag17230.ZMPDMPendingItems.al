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
                field(Closed; Closed)
                {
                    ApplicationArea = All;
                    Visible = ShowClosed;
                }
                field("Closed Type"; "Closed Type")
                {
                    ApplicationArea = All;
                    Visible = ShowClosed;
                }
                field("Closed Request No."; "Closed Request No.")
                {
                    ApplicationArea = All;
                    Visible = ShowClosed;
                }
                field("Closed By"; "Closed By")
                {
                    ApplicationArea = All;
                    Visible = ShowClosed;
                }
                field("Closed Date"; "Closed Date")
                {
                    ApplicationArea = All;
                    Visible = ShowClosed;
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
                Visible = not ShowClosed;

                trigger OnAction()
                var
                    TempSelected: Record "ZM PDM Document" temporary;
                begin
                    TempSelected.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(TempSelected);
                    PDMSync.CreateRequestsFromTray(TempSelected);
                    RefreshTray(true);
                end;
            }
            action(CloseDocuments)
            {
                ApplicationArea = All;
                Caption = 'Close', comment = 'ESP="Cerrar"';
                ToolTip = 'Removes the selected drawings from the tray without creating a request. They can be seen in the closed history.', comment = 'ESP="Quita de la bandeja los planos seleccionados sin crear solicitud. Se ven en el histórico de cerrados."';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = not ShowClosed;

                trigger OnAction()
                var
                    TempSelected: Record "ZM PDM Document" temporary;
                begin
                    TempSelected.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(TempSelected);
                    PDMSync.CloseTrayDocuments(TempSelected);
                    RefreshTray(true);
                end;
            }
            action(ReopenDocuments)
            {
                ApplicationArea = All;
                Caption = 'Reopen', comment = 'ESP="Reabrir"';
                ToolTip = 'Returns the selected drawings to the tray.', comment = 'ESP="Devuelve a la bandeja los planos seleccionados."';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowClosed;

                trigger OnAction()
                var
                    TempSelected: Record "ZM PDM Document" temporary;
                begin
                    TempSelected.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(TempSelected);
                    PDMSync.ReopenTrayDocuments(TempSelected);
                    RefreshTray(true);
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
                    RefreshTray(true);
                end;
            }
        }
        area(Navigation)
        {
            action(ClosedHistory)
            {
                ApplicationArea = All;
                Caption = 'Closed history', comment = 'ESP="Histórico cerrados"';
                ToolTip = 'Drawings closed in the tray, by hand or when creating the request.', comment = 'ESP="Planos cerrados en la bandeja, a mano o al crear la solicitud."';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                Visible = not ShowClosed;

                trigger OnAction()
                var
                    PDMPendingItems: Page "ZM PDM Pending Items";
                begin
                    PDMPendingItems.SetShowClosed(true);
                    PDMPendingItems.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        lblClosedCaption: Label 'PDM closed in tray', comment = 'ESP="Aprobados PDM cerrados"';
    begin
        if ShowClosed then
            CurrPage.Caption := lblClosedCaption;
        RefreshTray(false);
    end;

    var
        PDMSync: Codeunit "ZM PDM Sync";
        ShowClosed: Boolean;

    procedure SetShowClosed(NewShowClosed: Boolean)
    begin
        // false (por defecto): pendientes; true: histórico de cerrados
        ShowClosed := NewShowClosed;
    end;

    local procedure RefreshTray(UpdatePage: Boolean)
    begin
        PDMSync.BuildPendingTray(Rec, ShowClosed);
        Rec.SetRange(Closed, ShowClosed);
        if UpdatePage then
            CurrPage.Update(false);
    end;
}
