page 50158 "ZM Item Documents"
{
    Caption = 'ERPLINK Documentos productos', comment = 'ESP="ERPLINK Documentos productos"';
    PageType = ListPart;
    UsageCategory = None;
    //ApplicationArea = all;
    SourceTable = ComentariosPredefinidos;
    SourceTableView = sorting(Tipo, Extension, Description) where(Tipo = const(ERPLINKDocs));

    // pagina para Servicio WEB de ERPLINK para cimworks

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                // field(Id; Id)
                // {
                //     ApplicationArea = all;
                // }
                field(itemno; CodComentario)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lineno; "Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(txtComentario);
                    end;
                }
                field(url; txtComentario)
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(txtComentario);
                    end;
                }
                field(Extension; Extension)
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
            action(SetExtension)
            {
                ApplicationArea = all;
                Caption = 'Crear Extensión', comment = 'ESP="Crear Extensión"';
                Image = FileContract;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Extension := copystr(ExtractFileExtFromPath(Rec.Description), 1, MaxStrLen(Rec.Extension));
                    REc.Modify();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        txtComentario := Rec.GetComentario();
        if Description = '' then
            Description := copystr(ExtractFileNameFromPath(txtComentario), 1, 100);
        if Description = '' then
            Description := copystr(txtComentario, 1, 100);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Id = 0 then
            Rec.Id := GetLastID + 1;
        if "Line No." = 0 then
            Rec."Line No." := GetLastLineNo();
        txtComentario := '';
        if Extension = '' then
            Rec.Extension := copystr(ExtractFileExtFromPath(Rec.Description), 1, MaxStrLen(Rec.Extension));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Id = 0 then
            Rec.Id := GetLastID + 1;
        if "Line No." = 0 then
            Rec."Line No." := GetLastLineNo();
        if txtComentario <> '' then
            Rec.SetComentario(txtComentario);
        if Rec.Extension = '' then
            Rec.Extension := copystr(ExtractFileExtFromPath(Rec.Description), 1, MaxStrLen(Rec.Extension));
        Rec.Tipo := Rec.Tipo::ERPLINKDocs;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if txtComentario <> '' then
            Rec.SetComentario(txtComentario);
        Rec.Tipo := Rec.Tipo::ERPLINKDocs;
    end;

    var
        txtComentario: Text;

    local procedure ExtractFileNameFromPath(PathAndFileTxt: Text) FileTxt: Text
    begin
        FileTxt := PathAndFileTxt;
        WHILE STRPOS(FileTxt, '\') <> 0 DO
            FileTxt := COPYSTR(FileTxt, 1 + STRPOS(FileTxt, '\'));
    end;

    local procedure ExtractFileExtFromPath(PathAndFileTxt: Text) FileTxt: Text
    begin
        FileTxt := PathAndFileTxt;
        WHILE STRPOS(FileTxt, '.') <> 0 DO
            FileTxt := COPYSTR(FileTxt, 1 + STRPOS(FileTxt, '.'));
    end;

}