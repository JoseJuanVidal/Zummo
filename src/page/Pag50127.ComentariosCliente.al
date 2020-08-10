page 50127 "Comentarios Cliente"
{
      PageType = List;
    SourceTable = "Comment Line";
    Caption = 'Customer Comments', Comment = 'ESP="Comentarios Cliente"';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field(ComentarioCliente_btc; ComentarioCliente_btc)
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                { }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        comments: Record "Comment Line";
    begin    
        comments.reset;
        comments.SetRange("No.", GetFilter("No."));
        IF CommentS.FindLast() THEN
            Rec."Line No." := comments."Line No." + 1000;
    END;

}
