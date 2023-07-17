page 17465 "ZM Contracts Suplies List"
{

    ApplicationArea = All;
    Caption = 'Contracts Suplies List', Comment = 'ESP="Lista Contratos/Suministros"';
    PageType = List;
    SourceTable = "ZM Contracts/supplies Header";
    // SourceTableView = where(Status = filter(Abierto | lanzado));
    UsageCategory = Lists;
    CardPageId = "ZM Contracts Suplies Header";
    RefreshOnActivate = true;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Date creation"; Rec."Date creation")
                {
                    ApplicationArea = All;
                }
                field("Data Start Validity"; Rec."Data Start Validity")
                {
                    ApplicationArea = All;
                }
                field("Date End Validity"; Rec."Date End Validity")
                {
                    ApplicationArea = All;
                }
                field("Contract No. Vendor"; Rec."Contract No. Vendor")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Expend Quantity"; Rec."Expend Quantity")
                {
                    ApplicationArea = all;
                }
                field("Return Quantity"; Rec."Return Quantity")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        ReturnShipmentLines: Record "Return Shipment Line";
                        PostedReturnShipmentLines: Page "Posted Return Shipment Lines";
                    begin
                        ReturnShipmentLines.SetRange("Contracts No.", Rec."No.");
                        PostedReturnShipmentLines.SetTableView(ReturnShipmentLines);
                        PostedReturnShipmentLines.RunModal();
                    end;
                }
                field("Quantity in Purch. Order"; Rec."Quantity in Purch. Order")
                {
                    ApplicationArea = all;
                }
                field("No. of Purchase Line"; "No. of Purchase Line")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        PurchaseLine: record "Purchase Line";
                    begin
                        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SetRange("Contracts No.", Rec."No.");
                        page.RunModal(0, PurchaseLine);
                    end;
                }
            }
        }
    }
}


