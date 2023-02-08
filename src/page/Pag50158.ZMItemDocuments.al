page 50158 "ZM Item Documents"
{
    Caption = 'ERPLINK Documentos productos', comment = 'ESP="ERPLINK Documentos productos"';
    PageType = ListPart;
    UsageCategory = None;
    SourceTable = ComentariosPredefinidos;
    SourceTableView = where(Tipo = const(ERPLINKDocs));

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
                field(Description; txtDescription)
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
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        txtComentario := Rec.GetComentario();
        txtDescription := ExtractFileNameFromPath(txtComentario);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Id = 0 then
            Rec.Id := GetLastID + 1;
        if "Line No." = 0 then
            Rec."Line No." := GetLastLineNo();
        txtComentario := '';
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Id = 0 then
            Rec.Id := GetLastID + 1;
        if "Line No." = 0 then
            Rec."Line No." := GetLastLineNo();
        if txtComentario <> '' then
            Rec.SetComentario(txtComentario);
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
        txtDescription: text;

    local procedure ExtractFileNameFromPath(PathAndFileTxt: Text) FileTxt: Text
    begin
        FileTxt := PathAndFileTxt;
        WHILE STRPOS(FileTxt, '\') <> 0 DO
            FileTxt := COPYSTR(FileTxt, 1 + STRPOS(FileTxt, '\'));
    end;

}