page 50134 "Salidas Fabricacion"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Item Ledger Entry";
    SourceTableView = where("Entry Type" = const(Output), "Serial No." = filter(<> ''));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; "Entry No.") { }
                field("Posting Date"; "Posting Date") { }
                field("Item No."; "Item No.") { }
                field("Entry Type"; "Entry Type") { }
                field("Source No."; "Source No.") { }
                field("Document No."; "Document No.") { }
                field(Description; Description) { }
                field("Location Code"; "Location Code") { }
                field(Quantity; Quantity) { }
                field("Remaining Quantity"; "Remaining Quantity") { }
                field(Open; Open) { }
                field("Source Type"; "Source Type") { }
                field("Document Date"; "Document Date") { }
                field("External Document No."; "External Document No.") { }
                field("Order Type"; "Order Type") { }
                field("Order No."; "Order No.") { }
                field("Order Line No."; "Order Line No.") { }
                field("Serial No."; "Serial No.") { }
                field("Lot No."; "Lot No.") { }
                field(RoutingNo; RoutingNo) { }
                field(RoutingProduction; RoutingProduction) { }
                field(selClasVtas_btc; selClasVtas_btc) { }
                field(selFamilia_btc; selFamilia_btc) { }
                field(selLineaEconomica_btc; selLineaEconomica_btc) { }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RoutingNo := '';
        selClasVtas_btc := '';
        selFamilia_btc := '';
        selLineaEconomica_btc := '';
        RoutingProduction := false;
        UpdateProductión();
    end;

    var
        Item: Record Item;
        ProdOrderLine: Record "Prod. Order Line";
        Funciones: Codeunit Funciones;
        RoutingNo: code[20];
        selClasVtas_btc: code[20];
        selFamilia_btc: code[20];
        selLineaEconomica_btc: code[20];
        RoutingProduction: Boolean;

    local procedure UpdateProductión()
    var
        RoutingHeader: Record "Routing Header";
        vRecRef: RecordRef;
    begin
        Item.Reset();
        if Item.Get(Rec."Item No.") then begin
            selClasVtas_btc := Item.selClasVtas_btc;
            selFamilia_btc := Item.selFamilia_btc;
            selLineaEconomica_btc := Item.selLineaEconomica_btc;
        end;
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange("Prod. Order No.", Rec."Order No.");
        ProdOrderLine.SetRange("Line No.", Rec."Order Line No.");
        if ProdOrderLine.FindSet() then begin
            RoutingNo := ProdOrderLine."Routing No.";
            // 50400; "Salidas Fabricas"; Boolean)

            if RoutingHeader.Get(ProdOrderLine."Routing No.") then begin
                vRecRef.GetTable(RoutingHeader);
                RoutingProduction := Funciones.GetExtensionFieldValueboolean(vRecRef.RecordId, 50400, false);
            end
        end;

    end;
}