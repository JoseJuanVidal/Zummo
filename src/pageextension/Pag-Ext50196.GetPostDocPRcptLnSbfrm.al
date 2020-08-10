pageextension 50196 "GetPostDocPRcptLnSbfrm" extends "Get Post.Doc - P.RcptLn Sbfrm"
{
    layout
    {
        addafter(Description)
        {
            field("Order No."; "Order No.") { }
        }
    }


}