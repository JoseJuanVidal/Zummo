page 50103 "ComentariosVarios"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = ComentariosVarios;
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Comentario_btc; Comentario_btc)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}