page 17372 "ZM Sales Order Packing Line"
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
                field("Item Quantity"; "Item Quantity")
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
    actions
    {
        area(Processing)
        {
            action(CreateingLines)
            {
                ApplicationArea = all;
                Caption = 'Create Lines', comment = 'ESP="Crear Líneas"';
                Image = CreatePutawayPick;

                trigger OnAction()
                begin
                    ActionCreateingLines();
                end;


            }
        }
    }

    local procedure ActionCreateingLines()
    var
        PackingListDetail: Record "ZM Packing List Detail";
        PackingListDetails: page "ZM Packing List Details";
    begin
        PackingListDetail.Reset();
        PackingListDetail.SetRange("Document type", Rec."Document type");
        PackingListDetail.SetRange("Document No.", Rec."Document No.");
        PackingListDetail.SetRange("Packing Line No.", Rec."Line No.");
        PackingListDetails.SetTableView(PackingListDetail);
        PackingListDetails.RunModal();

    end;
}
