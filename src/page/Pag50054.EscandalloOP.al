page 50054 "Escandallo OP"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Prod. Order Line";
    SourceTableView = where(Status = filter(Released | Finished));

    layout
    {
        area(Content)
        {
            repeater(ProdOrder)
            {
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(NSerie; NSerie)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = all;
                }
                field("Finished Quantity"; "Finished Quantity")
                {
                    ApplicationArea = all;
                }
                field(IsSerialNo; IsSerialNo)
                {
                    ApplicationArea = all;
                }
                field("Direct Cost"; DirectCost)
                {
                    ApplicationArea = all;
                }
                /* part(escandallo; "Escandallo LM Consumption")
                 {
                     SubPageLink = "Order No." = field("Prod. Order No."), "Order Line No." = field("Line No.");
                     SubPageView = where("Entry Type" = const(consumption));
                 }*/
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // calculamos o buscamos el numero de serie
        CalcSerialNo();
        case Status of
            status::Released:
                begin
                    DirectCost := 0;
                end;
            Status::Finished:
                begin
                    CalcDirectCost();
                end;
        end
    end;

    var
        Item: Record Item;
        ItemLdgEntry: Record "Item Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
        ItemTrackingCode: Record "Item Tracking Code";
        NSerie: code[50];
        IsSerialNo: Boolean;
        DirectCost: Decimal;

    local procedure CalcSerialNo()
    begin
        NSerie := '';
        if item.get(Rec."Item No.") then
            if CheckSeguimientoSerial(Item) then begin
                ItemLdgEntry.SetRange("Entry Type", ItemLdgEntry."Entry Type"::Output);
                ItemLdgEntry.SetRange("Order Type", ItemLdgEntry."Order Type"::Production);
                ItemLdgEntry.SetRange("Order No.", Rec."Prod. Order No.");
                ItemLdgEntry.SetRange("Order Line No.", Rec."Line No.");
                if ItemLdgEntry.FindSet() then begin
                    NSerie := ItemLdgEntry."Serial No.";
                end else begin
                    // todavia no esta realizada la salida, por lo que está en seguimiento de productos
                    ReservationEntry.Reset();
                    ReservationEntry.SetRange("Source Type", Database::"Prod. Order Line");
                    ReservationEntry.SetRange("Source ID", Rec."Prod. Order No.");
                    ReservationEntry.SetRange("Source Prod. Order Line", Rec."Line No.");
                    if ReservationEntry.FindSet() then
                        NSerie := ReservationEntry."Serial No.";

                end;
            end;
    end;

    local procedure CheckSeguimientoSerial(Item: record Item): Boolean
    begin
        IsSerialNo := false;
        if ItemTrackingCode.Get(Item."Item Tracking Code") then begin
            if ItemTrackingCode."SN Specific Tracking" then
                IsSerialNo := true;
        end;
        exit(IsSerialNo);
    end;

    local procedure CalcDirectCost()
    begin
        ItemLdgEntry.SetRange("Entry Type", ItemLdgEntry."Entry Type"::Output);
        ItemLdgEntry.SetRange("Order Type", ItemLdgEntry."Order Type"::Production);
        ItemLdgEntry.SetRange("Order No.", Rec."Prod. Order No.");
        ItemLdgEntry.SetRange("Order Line No.", Rec."Line No.");
        ItemLdgEntry.CalcSums("Cost Amount (Expected)", "Cost Amount (Actual)");
        DirectCost := ItemLdgEntry."Cost Amount (Actual)" + ItemLdgEntry."Cost Amount (Expected)";
    end;
}