page 60019 "STH API POST PurchaseLineDisc"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Purchase Line Discount';
    // EntityCaption = 'STH API Purchase Line Discount';
    // EntitySetCaption = 'STH API Purchase Line Discount';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostPurchaseLineDiscount';
    EntitySetName = 'sthPostPurchaseLineDiscount';
    ODataKeyFields = "Item No.", "Vendor No.", "Currency Code", "Minimum Quantity", "Unit of Measure Code", "Variant Code";//, "Starting Date";
    PageType = API;
    SourceTable = "Purchase Line Discount";
    // Extensible = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(systemId; Rec.SystemId)
                // {
                //     Caption = 'SystemId';
                // }
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
                field(lineDiscount; Rec."Line Discount %")
                {
                    Caption = 'Line Discount %';
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
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }

    var
        PurchaseLineDiscount: Record "Purchase Line Discount";
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
                    Evaluate(anyo, CopyStr(auxStartingDate, 1, 4));
                    Evaluate(mes, CopyStr(auxStartingDate, 6, 2));
                    Evaluate(dia, CopyStr(auxStartingDate, 9, 2));
                    auxDate := DMY2Date(dia, mes, anyo);
                    if PurchaseLineDiscount.Get(Rec."Item No.", Rec."Vendor No.", auxDate, Rec."Currency Code", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Minimum Quantity") then begin
                        PurchaseLineDiscount.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    Evaluate(anyo, CopyStr(auxStartingDate, 1, 4));
                    Evaluate(mes, CopyStr(auxStartingDate, 6, 2));
                    Evaluate(dia, CopyStr(auxStartingDate, 9, 2));
                    auxDate := DMY2Date(dia, mes, anyo);
                    if PurchaseLineDiscount.Get(Rec."Item No.", Rec."Vendor No.", auxDate, Rec."Currency Code", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Minimum Quantity") then
                        Error('El registro ya existe %1', Rec."Item No.");

                    PurchaseLineDiscount.Init();
                    PurchaseLineDiscount.TransferFields(Rec);
                    PurchaseLineDiscount."Starting Date" := DMY2Date(dia, mes, anyo);
                    Evaluate(anyo, CopyStr(auxEndingDate, 1, 4));
                    Evaluate(mes, CopyStr(auxEndingDate, 6, 2));
                    Evaluate(dia, CopyStr(auxEndingDate, 9, 2));
                    PurchaseLineDiscount."Ending Date" := DMY2Date(dia, mes, anyo);
                    PurchaseLineDiscount.Insert();
                end;
            'PATCH':
                begin
                    Evaluate(anyo, CopyStr(auxStartingDate, 1, 4));
                    Evaluate(mes, CopyStr(auxStartingDate, 6, 2));
                    Evaluate(dia, CopyStr(auxStartingDate, 9, 2));
                    auxDate := DMY2Date(dia, mes, anyo);
                    if PurchaseLineDiscount.Get(Rec."Item No.", Rec."Vendor No.", auxDate, Rec."Currency Code", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Minimum Quantity") then begin
                        PurchaseLineDiscount.TransferFields(Rec);
                        PurchaseLineDiscount."Starting Date" := DMY2Date(dia, mes, anyo);
                        Evaluate(anyo, CopyStr(auxEndingDate, 1, 4));
                        Evaluate(mes, CopyStr(auxEndingDate, 6, 2));
                        Evaluate(dia, CopyStr(auxEndingDate, 9, 2));
                        PurchaseLineDiscount."Ending Date" := DMY2Date(dia, mes, anyo);
                        PurchaseLineDiscount.Modify();
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
}