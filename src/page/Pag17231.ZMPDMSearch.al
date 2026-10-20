page 17231 "ZM PDM Search"
{
    // Búsqueda directa en el PDM (cualquier estado) para relacionar una solicitud de alta con su plano
    Caption = 'Search in PDM', comment = 'ESP="Buscar en el PDM"';
    PageType = Worksheet;
    UsageCategory = None;
    SourceTable = "ZM PDM Document";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(Search)
            {
                Caption = 'Search', comment = 'ESP="Búsqueda"';

                field(SearchText; SearchText)
                {
                    ApplicationArea = All;
                    Caption = 'Code, description or file name contains', comment = 'ESP="Código, descripción o nombre de fichero contiene"';

                    trigger OnValidate()
                    begin
                        DoSearch();
                    end;
                }
            }
            repeater(General)
            {
                Editable = false;

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
                field(Revision; Revision)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Current Status"; "Current Status")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Approval Date"; "Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
                field(Folder; Folder)
                {
                    ApplicationArea = All;
                }
                field("Document ID"; "Document ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if SearchText <> '' then
            DoSearch();
    end;

    trigger OnAfterGetRecord()
    begin
        // verde: aprobado (sincronizado en BC); ámbar: en modificación o pendiente de aprobar
        StyleTxt := 'Ambiguous';
        if ("Approved Version" <> 0) and not "In Modification" then
            StyleTxt := 'Favorable';
    end;

    var
        PDMSync: Codeunit "ZM PDM Sync";
        SearchText: Text;
        StyleTxt: Text;

    procedure SetSearchText(NewSearchText: Text)
    begin
        SearchText := NewSearchText;
    end;

    procedure GetSelectedDocumentID(): Integer
    begin
        exit(Rec."Document ID");
    end;

    local procedure DoSearch()
    var
        lblShortText: Label 'Enter at least 3 characters.', comment = 'ESP="Indique al menos 3 caracteres."';
        lblNoConnection: Label 'The PDM could not be checked.\%1', comment = 'ESP="No se ha podido consultar el PDM.\%1"';
    begin
        if StrLen(DelChr(SearchText, '<>', ' ')) < 3 then
            Error(lblShortText);
        if not PDMSync.SearchPDM('', DelChr(SearchText, '<>', ' '), 0, Rec) then
            if GetLastErrorText() <> '' then
                Message(lblNoConnection, GetLastErrorText());
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;
}
