page 60023 "STH API POST Purchase Price"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Purchase Price';
    // EntityCaption = 'STH API Purchase Price';
    // EntitySetCaption = 'STH API Purchase Price';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostPurchasePrice';
    EntitySetName = 'sthPostPurchasePrice';
    ODataKeyFields = "Item No.", "Vendor No.", "Currency Code", "Starting Date", "Minimum Quantity", "Unit of Measure Code", "Variant Code";
    PageType = API;
    SourceTable = "Purchase Price";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(startingDate; auxStartingDate)
                {
                    Caption = 'Starting Date';
                }
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field(minimumQuantity; Rec."Minimum Quantity")
                {
                    Caption = 'Minimum Quantity';
                }
                field(endingDate; auxEndingDate)
                {
                    Caption = 'Ending Date';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                // field(systemId; Rec.SystemId)
                // {
                //     Caption = 'SystemId';
                // }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
                field(ProcessNo; "Process No.")
                {
                    Caption = 'Process No.';
                }
                field(ProcessDescription; "Process Description")
                {
                    Caption = 'Process Description';
                }
            }
        }
    }
    var
        purchasePrice: Record "Purchase Price";
        actionHTTP: Text;
        result: Text;
        auxStartingDate: Text;
        auxEndingDate: Text;
        anyo: Integer;
        dia: Integer;
        mes: Integer;
        auxDate: Date;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if purchasePrice.Get(Rec."Item No.", Rec."Vendor No.", Rec."Starting Date", Rec."Currency Code", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Minimum Quantity") then begin
                        purchasePrice.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    auxDate := setDate(auxStartingDate);
                    if purchasePrice.Get(Rec."Item No.", Rec."Vendor No.", auxDate, Rec."Currency Code", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Minimum Quantity") then
                        Error('El registro ya existe %1', Rec."Item No.");

                    if checkUniqueProcessNo() then
                        Error('El registro ya existe %1', Rec."Process No.");

                    actualizarTarifas();
                    purchasePrice.Init();
                    purchasePrice.TransferFields(Rec);
                    purchasePrice."Starting Date" := setDate(auxStartingDate);
                    purchasePrice."Ending Date" := setDate(auxEndingDate);
                    purchasePrice.Insert();
                end;
            'PATCH':
                begin
                    auxDate := setDate(auxStartingDate);
                    actualizarTarifas();
                    if purchasePrice.Get(Rec."Item No.", Rec."Vendor No.", auxDate, Rec."Currency Code", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Minimum Quantity") then begin
                        purchasePrice.TransferFields(Rec);
                        purchasePrice."Starting Date" := setDate(auxStartingDate);
                        purchasePrice."Ending Date" := setDate(auxEndingDate);
                        purchasePrice.Modify();
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Starting Date" := 0D;
        Rec."Ending Date" := 0D;
    end;

    local procedure checkUniqueProcessNo(): Boolean
    var
        purchasePriceAux: Record "Purchase Price";
    begin
        purchasePriceAux.SetRange("Process No.", Rec."Process No.");

        exit(purchasePriceAux.FindFirst());
    end;

    local procedure setDate(auxDate: Text): Date
    begin
        Evaluate(anyo, CopyStr(auxDate, 1, 4));
        Evaluate(mes, CopyStr(auxDate, 6, 2));
        Evaluate(dia, CopyStr(auxDate, 9, 2));
        exit(DMY2Date(dia, mes, anyo));
    end;

    local procedure actualizarTarifas()
    var
        PurchasePrice: Record "Purchase Price";
    begin
        PurchasePrice.SetRange("Item No.", Rec."Item No.");
        PurchasePrice.SetRange("Vendor No.", Rec."Vendor No.");
        PurchasePrice.SetRange("Starting Date", 0D, auxDate - 1);
        PurchasePrice.SetRange("Ending Date", 0D);
        if PurchasePrice.FindFirst() then begin
            repeat
                PurchasePrice."Ending Date" := auxDate - 1;
                PurchasePrice.Modify();
            until PurchasePrice.Next() = 0;
        end;
    end;
}
