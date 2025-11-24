page 17392 "ZM Order mail Registers"
{
    Caption = 'Order mail Register', comment = 'ESP="Registro envío Pedido"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ZM Order mail Register";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Subject; Subject)
                {
                    ApplicationArea = all;
                }
                field(Receipts; Receipts)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Date-Time Sent"; "Date-Time Sent")
                {
                    ApplicationArea = all;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}