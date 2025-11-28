page 17393 "ZM Order mail Register Factbox"
{
    Caption = 'Order mail Register', comment = 'ESP="Registro envío Pedido"';
    PageType = ListPart;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "ZM Order mail Register";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Date-Time Sent"; "Date-Time Sent")
                {
                    ApplicationArea = all;
                }
                field(Receipts; Receipts)
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}