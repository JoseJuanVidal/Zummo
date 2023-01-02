page 17371 "ZM Packing List Details"
{
    Caption = 'Packing List Details', Comment = 'ESP="lista detalle línea Packing"';
    PageType = List;
    SourceTable = "ZM Packing List Detail";
    UsageCategory = None;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document type"; Rec."Document type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Packing Line No."; Rec."Packing Line No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
