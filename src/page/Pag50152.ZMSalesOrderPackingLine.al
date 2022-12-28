page 50152 "ZM ZM Sales Order Packing Line"
{
    //ApplicationArea = none;
    Caption = 'ZM Sales Order Packing Line', Comment = 'ESP="Líneas Ped. Venta Packing"';
    PageType = ListPart;
    SourceTable = "ZM Sales Order Packing";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document type"; Rec."Document type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                Field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Package Plastic Qty. (kg)"; "Package Plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Package Recycled plastic (kg)"; "Package Recycled plastic (kg)")
                {
                    ApplicationArea = all;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = All;
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = All;
                }
                field(Height; Rec.Height)
                {
                    ApplicationArea = All;
                }
                field(Cubage; Rec.Cubage)
                {
                    ApplicationArea = All;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
