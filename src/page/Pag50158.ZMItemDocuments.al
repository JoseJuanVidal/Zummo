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
                }
                field(lineno; "Line No.")
                {
                    ApplicationArea = all;
                }
                field(url; txtComentario)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        txtComentario := Rec.GetComentario();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Id = 0 then
            Rec.Id := GetLastID + 1;
        txtComentario := '';
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Id = 0 then begin
            Rec.Id := GetLastID + 1;
        end;
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


}