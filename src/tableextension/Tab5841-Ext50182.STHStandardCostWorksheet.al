tableextension 50182 "STH StandardCostWorksheet" extends "Standard Cost Worksheet"  //5841
{
    fields
    {

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                GetLastPurchaseCost();
            end;
        }
        Field(50100; LastUnitCost; Decimal)
        {
            Caption = 'Ultimo coste directo', comment = 'ESP="Ultimo coste directo"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Last Direct Cost" where("No." = field("No.")));
            DecimalPlaces = 0 : 5;
        }
        Field(50101; Blocked; Boolean)
        {
            Caption = 'Bloqueado', comment = 'ESP="Bloqueado"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Blocked where("No." = field("No.")));
            Editable = false;
        }
        Field(50102; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost', comment = 'ESP="Coste unitario"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Unit Cost" where("No." = field("No.")));
            DecimalPlaces = 0 : 5;
        }
        Field(50103; "Costing Method"; Option)
        {
            OptionMembers = FIFO,LIFO,Specific,Average,Standard;
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard', comment = 'ESP="FIFO,LIFO,Especial,Medio,Estándar"';
            Caption = 'Costing Method', comment = 'ESP="Valoración existencias"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Costing Method" where("No." = field("No.")));
        }
        Field(50105; LastPurchaseUnitCost; Decimal)
        {
            Caption = 'Ultimo coste Compra/Producción', comment = 'ESP="Ultimo coste Compra/Producción"';
            DecimalPlaces = 0 : 5;
        }
        Field(50106; LastPurchaseDate; Date)
        {
            Caption = 'Ultima Fecha Compra/Producción', comment = 'ESP="Ultimo Fecha Compra/Producción"';
        }
        Field(50107; LastPurchaseDocumentNo; code[20])
        {
            Caption = 'Ultimo Nº Doc. Compra/Producción', comment = 'ESP="Ultimo Nº Doc. Compra/Producción"';
        }
        Field(50108; LastPurchaseDocumentType; text[50])
        {
            Caption = 'Ultimo Tipo Doc. Compra/Producción', comment = 'ESP="Ultimo Tipo Doc. Compra/Producción"';
        }
        Field(50110; DesvLastPurchase; Decimal)
        {
            Caption = '% Desv. coste compra/producción', comment = 'ESP="% Desv. coste compra/producción"';
            DecimalPlaces = 0 : 2;
        }
    }
    var
        Item: Record Item;
        Itemledgerentry: Record "Item Ledger Entry";
        PurchaseLine: record "Purchase Line";
        ValueEntry: Record "Value Entry";

    procedure GetLastPurchaseCost()
    var

    begin
        Rec.LastPurchaseUnitCost := 0;
        Rec.LastPurchaseDate := 0D;
        Rec.LastPurchaseDocumentNo := '';
        Rec.DesvLastPurchase := 0;
        if not (Rec.Type in [Rec.Type::Item]) then
            exit;
        if not Item.Get(Rec."No.") then
            exit;

        // primero buscamos si existe linea de compra del proveedor de ficha
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Buy-from Vendor No.", Item."Vendor No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", Rec."No.");
        PurchaseLine.SetFilter(Quantity, '>0');
        if PurchaseLine.FindLast() then begin
            if PurchaseLine.Quantity > 0 then
                Rec.LastPurchaseUnitCost := round(PurchaseLine."Line Amount" / PurchaseLine.Quantity, 0.00001);
            Rec.LastPurchaseDate := PurchaseLine."Order Date";
            Rec.LastPurchaseDocumentNo := PurchaseLine."Document No.";
            if Rec.LastPurchaseUnitCost <> 0 then
                Rec.DesvLastPurchase := Rec."Standard Cost" / Rec.LastPurchaseUnitCost * 100;
            Rec.LastPurchaseDocumentType := format(Itemledgerentry."Entry Type"::Purchase);
            exit;
        end;


        Itemledgerentry.Reset();
        Itemledgerentry.SetRange("Item No.", Rec."No.");
        Itemledgerentry.SetRange(Positive, true);
        case Item."Replenishment System" of
            Item."Replenishment System"::Purchase:
                begin
                    Itemledgerentry.SetRange("Entry Type", Itemledgerentry."Entry Type"::Purchase);
                    Itemledgerentry.Setfilter("Document Type", '%1|%2', Itemledgerentry."Document Type"::"Purchase Receipt", Itemledgerentry."Document Type"::"Purchase Invoice");
                    if Itemledgerentry.FindLast() then begin
                        Itemledgerentry.CalcFields("Cost Amount (Expected)", "Cost Amount (Actual)");
                        Rec.LastPurchaseUnitCost := Round((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") / ItemLedgerEntry.Quantity, 0.00001);
                    end else begin
                        Itemledgerentry.SetRange("Document Type");
                        if Itemledgerentry.FindLast() then begin
                            Itemledgerentry.CalcFields("Cost Amount (Expected)", "Cost Amount (Actual)");
                            Rec.LastPurchaseUnitCost := Round((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") / ItemLedgerEntry.Quantity, 0.00001);
                        end else begin
                            Itemledgerentry.SetRange("Entry Type", Itemledgerentry."Entry Type"::"Positive Adjmt.");
                            if Itemledgerentry.FindLast() then begin
                                Itemledgerentry.CalcFields("Cost Amount (Expected)", "Cost Amount (Actual)");
                                Rec.LastPurchaseUnitCost := Round((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") / ItemLedgerEntry.Quantity, 0.00001);
                            end;
                        end;
                    end;
                    Rec.LastPurchaseDocumentNo := Itemledgerentry."Document No.";
                    Rec.LastPurchaseDocumentType := format(Itemledgerentry."Entry Type");
                end;
            Item."Replenishment System"::"Prod. Order":
                begin
                    Itemledgerentry.SetRange("Entry Type", Itemledgerentry."Entry Type"::Output);
                    if Itemledgerentry.FindLast() then begin
                        ValueEntry.SetRange("Item Ledger Entry No.", Itemledgerentry."Entry No.");
                        ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                        ValueEntry.CalcSums("Cost Amount (Actual)", "Cost Amount (Expected)", "Item Ledger Entry Quantity");
                        if ValueEntry.FindFirst() then
                            Rec.LastPurchaseUnitCost := Round((ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)") / ValueEntry."Item Ledger Entry Quantity", 0.00001);
                        Rec.LastPurchaseDocumentNo := Itemledgerentry."Document No.";
                        Rec.LastPurchaseDocumentType := format(Itemledgerentry."Entry Type");
                    end;
                end;
            Item."Replenishment System"::Assembly:
                begin
                    Itemledgerentry.SetRange("Entry Type", Itemledgerentry."Entry Type"::"Assembly Output");
                    if Itemledgerentry.FindLast() then begin
                        Itemledgerentry.CalcFields("Cost Amount (Expected)", "Cost Amount (Actual)");
                        Rec.LastPurchaseUnitCost := Round((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") / ItemLedgerEntry.Quantity, 0.00001);
                        Rec.LastPurchaseDocumentNo := Itemledgerentry."Document No.";
                        Rec.LastPurchaseDocumentType := format(Itemledgerentry."Entry Type");
                    end;
                end;
        end;
        rec.DesvLastPurchase := 0;

        if Rec.LastPurchaseUnitCost <> 0 then
            Rec.DesvLastPurchase := Rec."Standard Cost" / Rec.LastPurchaseUnitCost * 100;
        Rec.LastPurchaseDate := Itemledgerentry."Posting Date";
    end;

    procedure DrillDown_Lastpurchase()
    var
        myInt: Integer;
    begin
        if not (Rec.Type in [Rec.Type::Item]) then
            exit;
        if not Item.Get(Rec."No.") then
            exit;
        Itemledgerentry.Reset();
        Itemledgerentry.SetRange("Item No.", Rec."No.");
        case Item."Replenishment System" of
            Item."Replenishment System"::Purchase:
                begin
                    Itemledgerentry.SetRange("Entry Type", Itemledgerentry."Entry Type"::Purchase);
                    page.RunModal(0, Itemledgerentry);
                end;
            Item."Replenishment System"::"Prod. Order":
                begin
                    Itemledgerentry.SetRange("Entry Type", Itemledgerentry."Entry Type"::Output);
                    if Itemledgerentry.FindLast() then begin
                        ValueEntry.SetRange("Item Ledger Entry No.", Itemledgerentry."Entry No.");
                        ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                        page.RunModal(0, ValueEntry);
                    end;
                end;
            Item."Replenishment System"::Assembly:
                begin
                    Itemledgerentry.SetRange("Entry Type", Itemledgerentry."Entry Type"::"Assembly Output");
                    page.RunModal(0, Itemledgerentry);
                end;
        end;

    end;
}