page 17205 "Customer Items blockeds"
{
    ApplicationArea = All;
    Caption = 'Blocked Products by Customers', Comment = 'ESP="Bloqueos Productos por Clientes"';
    PageType = List;
    SourceTable = "ZM Customer Items blocked";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
