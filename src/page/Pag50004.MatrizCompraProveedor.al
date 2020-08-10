page 50004 "MatrizCompraProveedor"
{
    PageType = ListPart;
    SourceTable = Vendor;
    //SourceTableView = where ("Qty. on Prod. Order" = filter ('> 0'));
    Caption = 'Capacity Item Matrix', comment = 'ESP="Matriz Compra Proveedor"';
    Editable = false;
    DataCaptionExpression = '';
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        Vendor: Record Vendor;
                    begin
                        Vendor.SetRange("No.", "No.");
                        Vendor.FindFirst();
                        page.run(0, Vendor);
                    end;
                }
                field(Description; Name) { ApplicationArea = All; }
                field(Field1; MATRIX_CellData[1]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[1]; trigger OnDrillDown() begin MATRIX_OnDrillDown(1); end; }
                field(Field2; MATRIX_CellData[2]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[2]; trigger OnDrillDown() begin MATRIX_OnDrillDown(2); end; }
                field(Field3; MATRIX_CellData[3]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[3]; trigger OnDrillDown() begin MATRIX_OnDrillDown(3); end; }
                field(Field4; MATRIX_CellData[4]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[4]; trigger OnDrillDown() begin MATRIX_OnDrillDown(4); end; }
                field(Field5; MATRIX_CellData[5]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[5]; trigger OnDrillDown() begin MATRIX_OnDrillDown(5); end; }
                field(Field6; MATRIX_CellData[6]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[6]; trigger OnDrillDown() begin MATRIX_OnDrillDown(6); end; }
                field(Field7; MATRIX_CellData[7]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[7]; trigger OnDrillDown() begin MATRIX_OnDrillDown(7); end; }
                field(Field8; MATRIX_CellData[8]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[8]; trigger OnDrillDown() begin MATRIX_OnDrillDown(8); end; }
                field(Field9; MATRIX_CellData[9]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[9]; trigger OnDrillDown() begin MATRIX_OnDrillDown(9); end; }
                field(Field10; MATRIX_CellData[10]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[10]; trigger OnDrillDown() begin MATRIX_OnDrillDown(10); end; }
                field(Field11; MATRIX_CellData[11]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[11]; trigger OnDrillDown() begin MATRIX_OnDrillDown(11); end; }
                field(Field12; MATRIX_CellData[12]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[12]; trigger OnDrillDown() begin MATRIX_OnDrillDown(12); end; }
                field(Field13; MATRIX_CellData[13]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[13]; trigger OnDrillDown() begin MATRIX_OnDrillDown(13); end; }
                field(Field14; MATRIX_CellData[14]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[14]; trigger OnDrillDown() begin MATRIX_OnDrillDown(14); end; }
                field(Field15; MATRIX_CellData[15]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[15]; trigger OnDrillDown() begin MATRIX_OnDrillDown(15); end; }
                field(Field16; MATRIX_CellData[16]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[16]; trigger OnDrillDown() begin MATRIX_OnDrillDown(16); end; }
                field(Field17; MATRIX_CellData[17]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[17]; trigger OnDrillDown() begin MATRIX_OnDrillDown(17); end; }
                field(Field18; MATRIX_CellData[18]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[18]; trigger OnDrillDown() begin MATRIX_OnDrillDown(18); end; }
                field(Field19; MATRIX_CellData[19]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[19]; trigger OnDrillDown() begin MATRIX_OnDrillDown(19); end; }
                field(Field20; MATRIX_CellData[20]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[20]; trigger OnDrillDown() begin MATRIX_OnDrillDown(20); end; }
                field(Field21; MATRIX_CellData[21]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[21]; trigger OnDrillDown() begin MATRIX_OnDrillDown(21); end; }
                field(Field22; MATRIX_CellData[22]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[22]; trigger OnDrillDown() begin MATRIX_OnDrillDown(22); end; }
                field(Field23; MATRIX_CellData[23]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[23]; trigger OnDrillDown() begin MATRIX_OnDrillDown(23); end; }
                field(Field24; MATRIX_CellData[24]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[24]; trigger OnDrillDown() begin MATRIX_OnDrillDown(24); end; }
                field(Field25; MATRIX_CellData[25]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[25]; trigger OnDrillDown() begin MATRIX_OnDrillDown(25); end; }
                field(Field26; MATRIX_CellData[26]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[26]; trigger OnDrillDown() begin MATRIX_OnDrillDown(26); end; }
                field(Field27; MATRIX_CellData[27]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[27]; trigger OnDrillDown() begin MATRIX_OnDrillDown(27); end; }
                field(Field28; MATRIX_CellData[28]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[28]; trigger OnDrillDown() begin MATRIX_OnDrillDown(28); end; }
                field(Field29; MATRIX_CellData[29]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[29]; trigger OnDrillDown() begin MATRIX_OnDrillDown(29); end; }
                field(Field30; MATRIX_CellData[30]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[30]; trigger OnDrillDown() begin MATRIX_OnDrillDown(30); end; }
                field(Field31; MATRIX_CellData[31]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[31]; trigger OnDrillDown() begin MATRIX_OnDrillDown(31); end; }
                field(Field32; MATRIX_CellData[32]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; CaptionClass = '3,' + MATRIX_CaptionSet[32]; trigger OnDrillDown() begin MATRIX_OnDrillDown(32); end; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        MATRIX_CurrentNoOfMatrixColumn := ArrayLen(MATRIX_CellData);
    end;

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        MATRIX_CurrentColumnOrdinal := 0;
        WHILE MATRIX_CurrentColumnOrdinal < MATRIX_CurrentNoOfMatrixColumn DO BEGIN
            MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
            //GetColorCelda(MATRIX_CurrentColumnOrdinal);
        END;
    end;

   
    local procedure MATRIX_OnDrillDown(MATRIX_ColumnOrdinal: Integer)
    var
        PedCompra: Record "Purch. Rcpt. Line";
    begin
        PedCompra.Reset();

        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            PedCompra.SetRange("Posting Date", MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            PedCompra.SetFilter("Posting Date", '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");
        PedCompra.SetRange(Type, PedCompra.Type::Item);
        PedCompra.SetRange("Buy-from Vendor No.", "No.");

        page.RunModal(0, PedCompra);
        CurrPage.Update(false);
    end;

    local procedure MATRIX_OnAfterGetRecord(MATRIX_ColumnOrdinal: Integer)
    var
        PedCompra: Record "Purch. Rcpt. Line";
    begin
        MATRIX_CellData[MATRIX_ColumnOrdinal] := 0;

        PedCompra.Reset();
   
        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            PedCompra.SetRange("Posting Date", MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            PedCompra.SetFilter("Posting Date", '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        PedCompra.SetRange(Type, PedCompra.Type::Item);
        PedCompra.SetRange("Buy-from Vendor No.", "No.");
        if PedCompra.FindSet() then
            repeat
                if ImporteOCantidad then
                    MATRIX_CellData[MATRIX_ColumnOrdinal] += PedCompra.Quantity
                else
                    MATRIX_CellData[MATRIX_ColumnOrdinal] += PedCompra."Unit Cost" * PedCompra.Quantity;
            until PedCompra.Next() = 0;
    end;

    procedure Load(MatrixColumns1: ARRAY[32] OF Text[1024]; VAR MatrixRecords1: ARRAY[32] OF Record Date; CurrentNoOfMatrixColumns: Integer)
    begin
        COPYARRAY(MATRIX_CaptionSet, MatrixColumns1, 1);
        COPYARRAY(MatrixRecords, MatrixRecords1, 1);
        MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
    end;

    procedure Inicializa(l_ImporteOCantidad: boolean)
    begin
        Clear(MATRIX_CellData);
        Clear(MatrixRecords);
        ImporteOCantidad := l_ImporteOCantidad;
    end;

    var
        MATRIX_CellData: array[32] of Decimal;
        MATRIX_CaptionSet: array[32] of Text[80];
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        MatrixRecords: array[32] of Record Date;

        ImporteOCantidad: Boolean;
}