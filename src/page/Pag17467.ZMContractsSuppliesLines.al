page 17467 "ZM Contracts/Supplies Lines"
{
    PageType = ListPart;
    SourceTable = "ZM Contracts/supplies Lines";
    AutoSplitKey = true;
    Caption = 'Lines', Comment = 'ESP="Líneas"';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Precio negociado"; Rec."Precio negociado")
                {
                    ApplicationArea = all;
                }
                field(Unidades; Unidades)
                {
                    ApplicationArea = all;
                }
                field("Unit of measure"; "Unit of measure")
                {
                    ApplicationArea = all;
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    ApplicationArea = all;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = all;
                }
                field("Minimum Order Quantity"; "Minimum Order Quantity")
                {
                    ApplicationArea = all;
                }
                field("Order Multiple"; "Order Multiple")
                {
                    ApplicationArea = all;
                }
                field("Unidades Entregadas"; "Unidades Entregadas")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        PurchRcptLine: record "Purch. Rcpt. Line";
                    begin
                        PurchRcptLine.SetRange("Contracts No.", Rec."Document No.");
                        PurchRcptLine.SetRange("Contracts Line No.", Rec."Line No.");
                        page.RunModal(0, PurchRcptLine);

                    end;
                }
                field("Unidades Devolución"; "Unidades Devolución")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        ReturnShipmentLines: Record "Return Shipment Line";
                        PostedReturnShipmentLines: Page "Posted Return Shipment Lines";
                    begin
                        ReturnShipmentLines.SetRange("Contracts No.", Rec."Document No.");
                        ReturnShipmentLines.SetRange("Contracts Line No.", Rec."Line No.");
                        PostedReturnShipmentLines.SetTableView(ReturnShipmentLines);
                        PostedReturnShipmentLines.RunModal();
                    end;

                }
                field("Quantity in Purch. Order"; Rec."Quantity in Purch. Order")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        PurchaseLine: record "Purchase Line";
                    begin
                        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SetRange("Contracts No.", Rec."Document No.");
                        PurchaseLine.SetRange("Contracts Line No.", Rec."Line No.");
                        page.RunModal(0, PurchaseLine);
                    end;
                }
                field("Dimension 1 code"; "Dimension 1 code")
                {
                    ApplicationArea = all;
                }
                field("Dimension 2 code"; "Dimension 2 code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(lines)
            {
                Caption = 'Lines', comment = 'ESP="Líneas"';
                action(SetPrices)
                {
                    ApplicationArea = all;
                    Caption = 'Set Prices', comment = 'ESP="Establecer precios"';

                    RunObject = page "Purchase Prices";
                    RunPageView = sorting("Item No.");
                    RunPageLink = "Item No." = field("No.");
                }
                action(SetDiscounts)
                {
                    ApplicationArea = all;
                    Caption = 'Set Discounts', comment = 'ESP="Establecer descuentos"';

                    RunObject = page "Purchase Line Discounts";
                    RunPageLink = "Item No." = field("No.");
                }
            }
        }
    }
}