page 50116 "Lista comentarios predefinidos"
{

    PageType = List;
    SourceTable = ComentariosPredefinidos;
    Caption = 'List of predefined comments', comment = 'ESP="Lista comentarios predefinidos"';
    ApplicationArea = All;
    UsageCategory = Lists;
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CodComentario; CodComentario)
                {
                    ApplicationArea = All;
                }

                field(Comentario; textoComentario)
                {
                    ApplicationArea = All;
                    Caption = 'Comment', comment = 'ESP="Comentario"';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        SetComentario(textoComentario);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Ficha)
            {
                Caption = 'Card', comment = 'ESP="Ficha"';
                ToolTip = 'Browse the comment detail', comment = 'ESP="Navega al detalle del comentario"';
                PromotedCategory = New;
                PromotedIsBig = true;
                Promoted = true;
                Image = EditLines;
                RunObject = Page "Ficha comentarios predefinidos";
                RunPageOnRec = true;
                ApplicationArea = all;
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
