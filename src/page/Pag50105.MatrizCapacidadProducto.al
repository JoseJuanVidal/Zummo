page 50105 "MatrizCapacidadProducto"
{
    PageType = ListPart;
    SourceTable = Item;
    SourceTableView = where("Qty. on Prod. Order" = filter('> 0'));
    Caption = 'Capacity Item Matrix', comment = 'ESP="Matriz Capacidad productos"';
    Editable = false;
    DataCaptionExpression = '';
    LinksAllowed = false;
    RefreshOnActivate = true;

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
                        Item: Record Item;
                    begin
                        Item.SetRange("No.", "No.");
                        Item.FindFirst();
                        page.run(30, Item);
                    end;
                }
                field(Description; Description) { ApplicationArea = All; }
                field(Field1; MATRIX_CellData[1]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_1; CaptionClass = '3,' + MATRIX_CaptionSet[1]; trigger OnDrillDown() begin MATRIX_OnDrillDown(1); end; }
                field(Field2; MATRIX_CellData[2]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_2; CaptionClass = '3,' + MATRIX_CaptionSet[2]; trigger OnDrillDown() begin MATRIX_OnDrillDown(2); end; }
                field(Field3; MATRIX_CellData[3]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_3; CaptionClass = '3,' + MATRIX_CaptionSet[3]; trigger OnDrillDown() begin MATRIX_OnDrillDown(3); end; }
                field(Field4; MATRIX_CellData[4]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_4; CaptionClass = '3,' + MATRIX_CaptionSet[4]; trigger OnDrillDown() begin MATRIX_OnDrillDown(4); end; }
                field(Field5; MATRIX_CellData[5]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_5; CaptionClass = '3,' + MATRIX_CaptionSet[5]; trigger OnDrillDown() begin MATRIX_OnDrillDown(5); end; }
                field(Field6; MATRIX_CellData[6]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_6; CaptionClass = '3,' + MATRIX_CaptionSet[6]; trigger OnDrillDown() begin MATRIX_OnDrillDown(6); end; }
                field(Field7; MATRIX_CellData[7]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_7; CaptionClass = '3,' + MATRIX_CaptionSet[7]; trigger OnDrillDown() begin MATRIX_OnDrillDown(7); end; }
                field(Field8; MATRIX_CellData[8]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_8; CaptionClass = '3,' + MATRIX_CaptionSet[8]; trigger OnDrillDown() begin MATRIX_OnDrillDown(8); end; }
                field(Field9; MATRIX_CellData[9]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_9; CaptionClass = '3,' + MATRIX_CaptionSet[9]; trigger OnDrillDown() begin MATRIX_OnDrillDown(9); end; }
                field(Field10; MATRIX_CellData[10]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_10; CaptionClass = '3,' + MATRIX_CaptionSet[10]; trigger OnDrillDown() begin MATRIX_OnDrillDown(10); end; }
                field(Field11; MATRIX_CellData[11]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_11; CaptionClass = '3,' + MATRIX_CaptionSet[11]; trigger OnDrillDown() begin MATRIX_OnDrillDown(11); end; }
                field(Field12; MATRIX_CellData[12]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_12; CaptionClass = '3,' + MATRIX_CaptionSet[12]; trigger OnDrillDown() begin MATRIX_OnDrillDown(12); end; }
                field(Field13; MATRIX_CellData[13]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_13; CaptionClass = '3,' + MATRIX_CaptionSet[13]; trigger OnDrillDown() begin MATRIX_OnDrillDown(13); end; }
                field(Field14; MATRIX_CellData[14]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_14; CaptionClass = '3,' + MATRIX_CaptionSet[14]; trigger OnDrillDown() begin MATRIX_OnDrillDown(14); end; }
                field(Field15; MATRIX_CellData[15]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_15; CaptionClass = '3,' + MATRIX_CaptionSet[15]; trigger OnDrillDown() begin MATRIX_OnDrillDown(15); end; }
                field(Field16; MATRIX_CellData[16]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_16; CaptionClass = '3,' + MATRIX_CaptionSet[16]; trigger OnDrillDown() begin MATRIX_OnDrillDown(16); end; }
                field(Field17; MATRIX_CellData[17]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_17; CaptionClass = '3,' + MATRIX_CaptionSet[17]; trigger OnDrillDown() begin MATRIX_OnDrillDown(17); end; }
                field(Field18; MATRIX_CellData[18]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_18; CaptionClass = '3,' + MATRIX_CaptionSet[18]; trigger OnDrillDown() begin MATRIX_OnDrillDown(18); end; }
                field(Field19; MATRIX_CellData[19]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_19; CaptionClass = '3,' + MATRIX_CaptionSet[19]; trigger OnDrillDown() begin MATRIX_OnDrillDown(19); end; }
                field(Field20; MATRIX_CellData[20]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_20; CaptionClass = '3,' + MATRIX_CaptionSet[20]; trigger OnDrillDown() begin MATRIX_OnDrillDown(20); end; }
                field(Field21; MATRIX_CellData[21]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_21; CaptionClass = '3,' + MATRIX_CaptionSet[21]; trigger OnDrillDown() begin MATRIX_OnDrillDown(21); end; }
                field(Field22; MATRIX_CellData[22]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_22; CaptionClass = '3,' + MATRIX_CaptionSet[22]; trigger OnDrillDown() begin MATRIX_OnDrillDown(22); end; }
                field(Field23; MATRIX_CellData[23]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_23; CaptionClass = '3,' + MATRIX_CaptionSet[23]; trigger OnDrillDown() begin MATRIX_OnDrillDown(23); end; }
                field(Field24; MATRIX_CellData[24]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_24; CaptionClass = '3,' + MATRIX_CaptionSet[24]; trigger OnDrillDown() begin MATRIX_OnDrillDown(24); end; }
                field(Field25; MATRIX_CellData[25]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_25; CaptionClass = '3,' + MATRIX_CaptionSet[25]; trigger OnDrillDown() begin MATRIX_OnDrillDown(25); end; }
                field(Field26; MATRIX_CellData[26]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_26; CaptionClass = '3,' + MATRIX_CaptionSet[26]; trigger OnDrillDown() begin MATRIX_OnDrillDown(26); end; }
                field(Field27; MATRIX_CellData[27]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_27; CaptionClass = '3,' + MATRIX_CaptionSet[27]; trigger OnDrillDown() begin MATRIX_OnDrillDown(27); end; }
                field(Field28; MATRIX_CellData[28]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_28; CaptionClass = '3,' + MATRIX_CaptionSet[28]; trigger OnDrillDown() begin MATRIX_OnDrillDown(28); end; }
                field(Field29; MATRIX_CellData[29]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_29; CaptionClass = '3,' + MATRIX_CaptionSet[29]; trigger OnDrillDown() begin MATRIX_OnDrillDown(29); end; }
                field(Field30; MATRIX_CellData[30]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_30; CaptionClass = '3,' + MATRIX_CaptionSet[30]; trigger OnDrillDown() begin MATRIX_OnDrillDown(30); end; }
                field(Field31; MATRIX_CellData[31]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_31; CaptionClass = '3,' + MATRIX_CaptionSet[31]; trigger OnDrillDown() begin MATRIX_OnDrillDown(31); end; }
                field(Field32; MATRIX_CellData[32]) { ApplicationArea = All; BlankZero = true; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_32; CaptionClass = '3,' + MATRIX_CaptionSet[32]; trigger OnDrillDown() begin MATRIX_OnDrillDown(32); end; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(FiltrarCentroTrabajoProducciones)
            {
                ApplicationArea = All;
                Caption = 'FiltrarCentroTrabajoProducciones', comment = 'ESP="FiltrarCentroTrabajoProducciones"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //Visible = true;

                trigger OnAction()
                begin
                    FiltrarCentroTrabajo();
                    MarkedOnly(true);
                    if FindSet() then
                        CurrPage.Update(false)
                    else
                        Message('No hay ordenes');
                end;
            }
            action(DesfiltrarCentroTrabajo)
            {
                ApplicationArea = All;
                Caption = 'DesfiltrarCentroTrabajo', comment = 'ESP="DesfiltrarCentroTrabajo"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //Image = Image;
                trigger OnAction()
                begin
                    //FiltrarCentroTrabajo();
                    ClearMarks();
                    MarkedOnly(false);
                    if FindSet() then
                        CurrPage.Update(false)
                    else
                        Message('No hay ordenes');
                end;
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
            GetColorCelda(MATRIX_CurrentColumnOrdinal);
        END;
    end;

    local procedure GetColorCelda(MATRIX_CurrentColumnOrdinal: integer)
    var
    begin
        case MATRIX_CurrentColumnOrdinal of
            1:
                begin
                    estiloCelda_1 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_1 := 'Attention';
                end;
            2:
                begin
                    estiloCelda_2 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_2 := 'Attention';
                end;
            3:
                begin
                    estiloCelda_3 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_3 := 'Attention';
                end;
            4:
                begin
                    estiloCelda_4 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_4 := 'Attention';
                end;
            5:
                begin
                    estiloCelda_5 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_5 := 'Attention';
                end;
            6:
                begin
                    estiloCelda_6 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_6 := 'Attention';
                end;
            7:
                begin
                    estiloCelda_7 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_7 := 'Attention';
                end;
            8:
                begin
                    estiloCelda_8 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_8 := 'Attention';
                end;
            9:
                begin
                    estiloCelda_9 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_9 := 'Attention';
                end;
            10:
                begin
                    estiloCelda_10 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_10 := 'Attention';
                end;
            11:
                begin
                    estiloCelda_11 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_11 := 'Attention';
                end;
            12:
                begin
                    estiloCelda_12 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_12 := 'Attention';
                end;
            13:
                begin
                    estiloCelda_13 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_13 := 'Attention';
                end;
            14:
                begin
                    estiloCelda_14 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_14 := 'Attention';
                end;
            15:
                begin
                    estiloCelda_15 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_15 := 'Attention';
                end;
            16:
                begin
                    estiloCelda_16 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_16 := 'Attention';
                end;
            17:
                begin
                    estiloCelda_17 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_17 := 'Attention';
                end;
            18:
                begin
                    estiloCelda_18 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_18 := 'Attention';
                end;
            19:
                begin
                    estiloCelda_19 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_19 := 'Attention';
                end;
            20:
                begin
                    estiloCelda_20 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_20 := 'Attention';
                end;
            21:
                begin
                    estiloCelda_21 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_21 := 'Attention';
                end;
            22:
                begin
                    estiloCelda_22 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_22 := 'Attention';
                end;
            23:
                begin
                    estiloCelda_23 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_23 := 'Attention';
                end;
            24:
                begin
                    estiloCelda_24 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_24 := 'Attention';
                end;
            25:
                begin
                    estiloCelda_25 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_25 := 'Attention';
                end;
            26:
                begin
                    estiloCelda_26 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_26 := 'Attention';
                end;
            27:
                begin
                    estiloCelda_27 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_27 := 'Attention';
                end;
            28:
                begin
                    estiloCelda_28 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_28 := 'Attention';
                end;
            29:
                begin
                    estiloCelda_29 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_29 := 'Attention';
                end;
            30:
                begin
                    estiloCelda_30 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_30 := 'Attention';
                end;
            31:
                begin
                    estiloCelda_31 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_31 := 'Attention';
                end;
            32:
                begin
                    estiloCelda_32 := 'standard';

                    if TieneNotaOrden(MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_32 := 'Attention';
                end;
        end;
    end;

    local procedure TieneNotaOrden(MATRIX_ColumnOrdinal: Integer): Boolean
    var
        recRecordLink: Record "Record Link";
        boolTieneNotas: Boolean;
        recLinOp: Record "Prod. Order Line";
        recOP: Record "Production Order";
    begin
        recLinOp.Reset();
        recLinOp.setfilter(Status, '<%1', recLinOp.Status::Finished);

        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            recLinOp.SetRange(FechaInicial_btc, MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            recLinOp.SetFilter(FechaInicial_btc, '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        recLinOp.SetRange("Item No.", "No.");
        if recLinOp.FindSet() then
            repeat
                recOP.Get(recLinOp.Status, recLinOp."Prod. Order No.");

                recRecordLink.Reset();
                recRecordLink.SetRange("Record ID", recOP.RecordId);
                recRecordLink.SetRange(Type, recRecordLink.Type::Note);
                if recRecordLink.FindFirst() then
                    exit(true)
                else begin
                    recRecordLink.SetRange("Record ID", recLinOp.RecordId);
                    if recRecordLink.FindFirst() then
                        exit(true);
                end;
            until recLinOp.Next() = 0;
    end;

    local procedure MATRIX_OnDrillDown(MATRIX_ColumnOrdinal: Integer)
    var
        recLinOp: Record "Prod. Order Line";
    begin
        recLinOp.Reset();
        recLinOp.setfilter(Status, '<%1', recLinOp.Status::Finished);

        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            recLinOp.SetRange(FechaInicial_btc, MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            recLinOp.SetFilter(FechaInicial_btc, '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        recLinOp.SetFilter("Starting Date", recLinOp.GetFilter(FechaInicial_btc));
        recLinOp.SetRange("Item No.", "No.");

        page.RunModal(50401, recLinOp);
        CurrPage.Update(false);
    end;

    local procedure MATRIX_OnAfterGetRecord(MATRIX_ColumnOrdinal: Integer)
    var
        recLinOp: Record "Prod. Order Line";
    begin
        MATRIX_CellData[MATRIX_ColumnOrdinal] := 0;

        recLinOp.Reset();
        recLinOp.setfilter(Status, '<%1', recLinOp.Status::Finished);

        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            recLinOp.SetRange(FechaInicial_btc, MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            recLinOp.SetFilter(FechaInicial_btc, '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        recLinOp.SetRange("Item No.", "No.");
        if recLinOp.FindSet() then
            repeat
                MATRIX_CellData[MATRIX_ColumnOrdinal] += recLinOp."Remaining Quantity";
            until recLinOp.Next() = 0;
    end;

    procedure Load(MatrixColumns1: ARRAY[32] OF Text[1024]; VAR MatrixRecords1: ARRAY[32] OF Record Date; CurrentNoOfMatrixColumns: Integer)
    begin
        COPYARRAY(MATRIX_CaptionSet, MatrixColumns1, 1);
        COPYARRAY(MatrixRecords, MatrixRecords1, 1);
        MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
    end;

    procedure Inicializa()
    begin
        Clear(MATRIX_CellData);
        Clear(MatrixRecords);
    end;

    local procedure FiltrarCentroTrabajo()
    var
        CentroTrabajo: Record "Work Center";
        pageLista: Page "Work Center List";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        clear(pageLista);
        CentroTrabajo.Reset();
        pageLista.LookupMode(true);
        if pageLista.RunModal() = Action::LookupOK then begin
            pageLista.GetRecord(CentroTrabajo);
            Rec.ClearMarks();
            ProdOrderLine.reset;
            ProdOrderLine.SetFilter(Status, '<=3');
            ProdOrderLine.SetRange(CentroTrabajoCalculado_btc, CentroTrabajo."No.");
            if ProdOrderLine.FindSet() then begin
                repeat
                    rec.get(ProdOrderLine."Item No.");
                    rec.Mark(true);
                until ProdOrderLine.Next() = 0;
            end;
            rec.MarkedOnly;
        end
    end;

    procedure SetFiltrarCentro(CentroTrabajo: Record "Work Center")
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        Rec.ClearMarks();
        ProdOrderLine.reset;
        ProdOrderLine.SetFilter(Status, '<=3');
        ProdOrderLine.SetRange(CentroTrabajoCalculado_btc, CentroTrabajo."No.");
        if ProdOrderLine.FindSet() then begin
            repeat
                rec.get(ProdOrderLine."Item No.");
                rec.Mark(true);
            until ProdOrderLine.Next() = 0;
        end;
        rec.MarkedOnly;
        CurrPage.Update(false)
    end;

    var
        MATRIX_CellData: array[32] of Decimal;
        MATRIX_CaptionSet: array[32] of Text[80];
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        MatrixRecords: array[32] of Record Date;
        estiloCelda_1: text;
        estiloCelda_2: text;
        estiloCelda_3: text;
        estiloCelda_4: text;
        estiloCelda_5: text;
        estiloCelda_6: text;
        estiloCelda_7: text;
        estiloCelda_8: text;
        estiloCelda_9: text;
        estiloCelda_10: text;
        estiloCelda_11: text;
        estiloCelda_12: text;
        estiloCelda_13: text;
        estiloCelda_14: text;
        estiloCelda_15: text;
        estiloCelda_16: text;
        estiloCelda_17: text;
        estiloCelda_18: text;
        estiloCelda_19: text;
        estiloCelda_20: text;
        estiloCelda_21: text;
        estiloCelda_22: text;
        estiloCelda_23: text;
        estiloCelda_24: text;
        estiloCelda_25: text;
        estiloCelda_26: text;
        estiloCelda_27: text;
        estiloCelda_28: text;
        estiloCelda_29: text;
        estiloCelda_30: text;
        estiloCelda_31: text;
        estiloCelda_32: text;
}