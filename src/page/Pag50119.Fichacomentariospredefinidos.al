page 50119 "Ficha comentarios predefinidos"
{
    //Comentarios predefinidos
    PageType = Card;
    SourceTable = ComentariosPredefinidos;
    Caption = 'Predefined comments tab', Comment = 'ESP="Ficha comentarios predefinidos"';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CodComentario; CodComentario)
                {
                    ApplicationArea = All;
                }
                field(Comentario; textoComentario)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        SetComentario(textoComentario);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        textoComentario := GetComentario();
    end;

    var
        textoComentario: Text;
}
