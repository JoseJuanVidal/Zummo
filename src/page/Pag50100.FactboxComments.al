page 50100 "FactboxComments"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Comment Line";
    Caption = 'Comments', comment = 'ESP="Comentarios",FRA="Comments"';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Date)
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field(Comment; ComentarioCliente_btc)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }

                field(Fecha_btc; Fecha_btc)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }

                field(Usuario_btc; Usuario_btc)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
        }
    }
}