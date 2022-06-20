tableextension 50005 "STH BOM BufferExt" extends "BOM Buffer"
{
    fields
    {
        field(50000; "Description Language"; Text[100])
        {
            Caption = 'Description Language', Comment = 'ESP="Descripción Idioma"';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Translation".Description where("Item No." = field("No."), "Language Code" = field("Language Filter")));
            editable = false;
        }
        field(50001; "Language Filter"; code[10])
        {
            Caption = 'Language Filter', comment = 'ESP="Filtro Idioma"';
            FieldClass = FlowFilter;
        }
    }
}
