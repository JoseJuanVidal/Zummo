page 50108 "MatrizCapacidadCentroTrabajo"
{
    PageType = ListPart;
    SourceTable = "Work Center";
    Caption = 'Capacity Work Center Matrix', comment = 'ESP="Matriz Capacidad centro trabajo"';
    Editable = false;
    DataCaptionExpression = '';
    RefreshOnActivate = true;
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
                        CalendarEntry: Record "Calendar Entry";
                    begin
                        CalendarEntry.reset;
                        CalendarEntry.SetRange("No.", Rec."No.");
                        CalendarEntry.SetRange("Capacity Type", CalendarEntry."Capacity Type"::"Work Center");
                        CalendarEntry.SetFilter("Starting Date-Time", 'T..');
                        CalendarEntry.FindSet();
                        PAGE.RunModal(0, CalendarEntry);
                        CurrPage.Update(FALSE);
                    end;
                }
                field(Description; Name) { ApplicationArea = All; }
                field(Field1; MATRIX_CellData[1]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_1; CaptionClass = '3,' + MATRIX_CaptionSet[1]; trigger OnDrillDown() begin MATRIX_OnDrillDown(1); end; }
                field(Field2; MATRIX_CellData[2]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_2; CaptionClass = '3,' + MATRIX_CaptionSet[2]; trigger OnDrillDown() begin MATRIX_OnDrillDown(2); end; }
                field(Field3; MATRIX_CellData[3]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_3; CaptionClass = '3,' + MATRIX_CaptionSet[3]; trigger OnDrillDown() begin MATRIX_OnDrillDown(3); end; }
                field(Field4; MATRIX_CellData[4]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_4; CaptionClass = '3,' + MATRIX_CaptionSet[4]; trigger OnDrillDown() begin MATRIX_OnDrillDown(4); end; }
                field(Field5; MATRIX_CellData[5]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_5; CaptionClass = '3,' + MATRIX_CaptionSet[5]; trigger OnDrillDown() begin MATRIX_OnDrillDown(5); end; }
                field(Field6; MATRIX_CellData[6]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_6; CaptionClass = '3,' + MATRIX_CaptionSet[6]; trigger OnDrillDown() begin MATRIX_OnDrillDown(6); end; }
                field(Field7; MATRIX_CellData[7]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_7; CaptionClass = '3,' + MATRIX_CaptionSet[7]; trigger OnDrillDown() begin MATRIX_OnDrillDown(7); end; }
                field(Field8; MATRIX_CellData[8]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_8; CaptionClass = '3,' + MATRIX_CaptionSet[8]; trigger OnDrillDown() begin MATRIX_OnDrillDown(8); end; }
                field(Field9; MATRIX_CellData[9]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_9; CaptionClass = '3,' + MATRIX_CaptionSet[9]; trigger OnDrillDown() begin MATRIX_OnDrillDown(9); end; }
                field(Field10; MATRIX_CellData[10]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_10; CaptionClass = '3,' + MATRIX_CaptionSet[10]; trigger OnDrillDown() begin MATRIX_OnDrillDown(10); end; }
                field(Field11; MATRIX_CellData[11]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_11; CaptionClass = '3,' + MATRIX_CaptionSet[11]; trigger OnDrillDown() begin MATRIX_OnDrillDown(11); end; }
                field(Field12; MATRIX_CellData[12]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_12; CaptionClass = '3,' + MATRIX_CaptionSet[12]; trigger OnDrillDown() begin MATRIX_OnDrillDown(12); end; }
                field(Field13; MATRIX_CellData[13]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_13; CaptionClass = '3,' + MATRIX_CaptionSet[13]; trigger OnDrillDown() begin MATRIX_OnDrillDown(13); end; }
                field(Field14; MATRIX_CellData[14]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_14; CaptionClass = '3,' + MATRIX_CaptionSet[14]; trigger OnDrillDown() begin MATRIX_OnDrillDown(14); end; }
                field(Field15; MATRIX_CellData[15]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_15; CaptionClass = '3,' + MATRIX_CaptionSet[15]; trigger OnDrillDown() begin MATRIX_OnDrillDown(15); end; }
                field(Field16; MATRIX_CellData[16]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_16; CaptionClass = '3,' + MATRIX_CaptionSet[16]; trigger OnDrillDown() begin MATRIX_OnDrillDown(16); end; }
                field(Field17; MATRIX_CellData[17]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_17; CaptionClass = '3,' + MATRIX_CaptionSet[17]; trigger OnDrillDown() begin MATRIX_OnDrillDown(17); end; }
                field(Field18; MATRIX_CellData[18]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_18; CaptionClass = '3,' + MATRIX_CaptionSet[18]; trigger OnDrillDown() begin MATRIX_OnDrillDown(18); end; }
                field(Field19; MATRIX_CellData[19]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_19; CaptionClass = '3,' + MATRIX_CaptionSet[19]; trigger OnDrillDown() begin MATRIX_OnDrillDown(19); end; }
                field(Field20; MATRIX_CellData[20]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_20; CaptionClass = '3,' + MATRIX_CaptionSet[20]; trigger OnDrillDown() begin MATRIX_OnDrillDown(20); end; }
                field(Field21; MATRIX_CellData[21]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_21; CaptionClass = '3,' + MATRIX_CaptionSet[21]; trigger OnDrillDown() begin MATRIX_OnDrillDown(21); end; }
                field(Field22; MATRIX_CellData[22]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_22; CaptionClass = '3,' + MATRIX_CaptionSet[22]; trigger OnDrillDown() begin MATRIX_OnDrillDown(22); end; }
                field(Field23; MATRIX_CellData[23]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_23; CaptionClass = '3,' + MATRIX_CaptionSet[23]; trigger OnDrillDown() begin MATRIX_OnDrillDown(23); end; }
                field(Field24; MATRIX_CellData[24]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_24; CaptionClass = '3,' + MATRIX_CaptionSet[24]; trigger OnDrillDown() begin MATRIX_OnDrillDown(24); end; }
                field(Field25; MATRIX_CellData[25]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_25; CaptionClass = '3,' + MATRIX_CaptionSet[25]; trigger OnDrillDown() begin MATRIX_OnDrillDown(25); end; }
                field(Field26; MATRIX_CellData[26]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_26; CaptionClass = '3,' + MATRIX_CaptionSet[26]; trigger OnDrillDown() begin MATRIX_OnDrillDown(26); end; }
                field(Field27; MATRIX_CellData[27]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_27; CaptionClass = '3,' + MATRIX_CaptionSet[27]; trigger OnDrillDown() begin MATRIX_OnDrillDown(27); end; }
                field(Field28; MATRIX_CellData[28]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_28; CaptionClass = '3,' + MATRIX_CaptionSet[28]; trigger OnDrillDown() begin MATRIX_OnDrillDown(28); end; }
                field(Field29; MATRIX_CellData[29]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_29; CaptionClass = '3,' + MATRIX_CaptionSet[29]; trigger OnDrillDown() begin MATRIX_OnDrillDown(29); end; }
                field(Field30; MATRIX_CellData[30]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_30; CaptionClass = '3,' + MATRIX_CaptionSet[30]; trigger OnDrillDown() begin MATRIX_OnDrillDown(30); end; }
                field(Field31; MATRIX_CellData[31]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_31; CaptionClass = '3,' + MATRIX_CaptionSet[31]; trigger OnDrillDown() begin MATRIX_OnDrillDown(31); end; }
                field(Field32; MATRIX_CellData[32]) { ApplicationArea = All; DecimalPlaces = 0 : 2; StyleExpr = estiloCelda_32; CaptionClass = '3,' + MATRIX_CaptionSet[32]; trigger OnDrillDown() begin MATRIX_OnDrillDown(32); end; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        MATRIX_CurrentNoOfMatrixColumn := ArrayLen(MATRIX_CellData);

        recLinOpTemp.Reset();
        recLinOpTemp.DeleteAll();
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

    trigger OnAfterGetCurrRecord()
    begin

    end;

    local procedure GetColorCelda(MATRIX_CurrentColumnOrdinal: integer)
    var
    begin
        case MATRIX_CurrentColumnOrdinal of
            1:
                begin
                    estiloCelda_1 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_1 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_1 := 'Attention';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_1 := 'unfavorable';
                end;
            2:
                begin
                    estiloCelda_2 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_2 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_2 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_2 := 'unfavorable';
                end;
            3:
                begin
                    estiloCelda_3 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_3 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_3 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_3 := 'unfavorable';
                end;
            4:
                begin
                    estiloCelda_4 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_4 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_4 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_4 := 'unfavorable';
                end;
            5:
                begin
                    estiloCelda_5 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_5 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_5 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_5 := 'unfavorable';
                end;
            6:
                begin
                    estiloCelda_6 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_6 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_6 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_6 := 'unfavorable';
                end;
            7:
                begin
                    estiloCelda_7 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_7 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_7 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_7 := 'unfavorable';
                end;
            8:
                begin
                    estiloCelda_8 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_8 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_8 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_8 := 'unfavorable';
                end;
            9:
                begin
                    estiloCelda_9 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_9 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_9 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_9 := 'unfavorable';
                end;
            10:
                begin
                    estiloCelda_10 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_10 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_10 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_10 := 'unfavorable';
                end;
            11:
                begin
                    estiloCelda_11 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_11 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_11 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_11 := 'unfavorable';
                end;
            12:
                begin
                    estiloCelda_12 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_12 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_12 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_12 := 'unfavorable';
                end;
            13:
                begin
                    estiloCelda_13 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_13 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_13 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_13 := 'unfavorable';
                end;
            14:
                begin
                    estiloCelda_14 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_14 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_14 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_14 := 'unfavorable';
                end;
            15:
                begin
                    estiloCelda_15 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_15 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_15 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_15 := 'unfavorable';
                end;
            16:
                begin
                    estiloCelda_16 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_16 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_16 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_16 := 'unfavorable';
                end;
            17:
                begin
                    estiloCelda_17 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_17 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_17 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_17 := 'unfavorable';
                end;
            18:
                begin
                    estiloCelda_18 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_18 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_18 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_18 := 'unfavorable';
                end;
            19:
                begin
                    estiloCelda_19 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_19 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_19 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_19 := 'unfavorable';
                end;
            20:
                begin
                    estiloCelda_20 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_20 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_20 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_20 := 'unfavorable';
                end;
            21:
                begin
                    estiloCelda_21 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_21 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_21 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_21 := 'unfavorable';
                end;
            22:
                begin
                    estiloCelda_22 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_22 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_22 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_22 := 'unfavorable';
                end;
            23:
                begin
                    estiloCelda_23 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_23 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_23 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_23 := 'unfavorable';
                end;
            24:
                begin
                    estiloCelda_24 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_24 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_24 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_24 := 'unfavorable';
                end;
            25:
                begin
                    estiloCelda_25 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_25 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_25 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_25 := 'unfavorable';
                end;
            26:
                begin
                    estiloCelda_26 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_26 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_26 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_26 := 'unfavorable';
                end;
            27:
                begin
                    estiloCelda_27 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_27 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_27 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_27 := 'unfavorable';
                end;
            28:
                begin
                    estiloCelda_28 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_28 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_28 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_28 := 'unfavorable';
                end;
            29:
                begin
                    estiloCelda_29 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_29 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_29 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_29 := 'unfavorable';
                end;
            30:
                begin
                    estiloCelda_30 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_30 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_30 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_30 := 'unfavorable';
                end;
            31:
                begin
                    estiloCelda_31 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_31 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_31 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_31 := 'unfavorable';
                end;
            32:
                begin
                    estiloCelda_32 := 'standard';

                    if not TieneCapacidad("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_32 := 'StrongAccent';

                    if TieneNotaCalendario("No.", MATRIX_CurrentColumnOrdinal) then
                        estiloCelda_32 := 'StandardAccent';

                    if MATRIX_CellData[MATRIX_CurrentColumnOrdinal] > 100 then
                        estiloCelda_32 := 'unfavorable';
                end;
        end;
    end;

    // Indica si tiene notas en el calendario en ese día/rango fecha
    local procedure TieneNotaCalendario(pCodCentro: Code[20]; MATRIX_ColumnOrdinal: Integer): Boolean
    var
        recCalEntry: Record "Calendar Entry";
        recRecordLink: Record "Record Link";
        boolTieneNotas: Boolean;
    begin
        recCalEntry.Reset();
        recCalEntry.SetRange("Capacity Type", recCalEntry."Capacity Type"::"Work Center");
        recCalEntry.SetRange("No.", pCodCentro);
        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            recCalEntry.SetRange(date, MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            recCalEntry.SetFilter(Date, '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        if recCalEntry.FindSet() then
            repeat
                recRecordLink.Reset();
                recRecordLink.SetRange("Record ID", recCalEntry.RecordId);
                recRecordLink.SetRange(Type, recRecordLink.Type::Note);
                if recRecordLink.FindFirst() then
                    exit(true);
            until recCalEntry.Next() = 0;

        exit(false);
    end;

    local procedure MATRIX_OnDrillDown(MATRIX_ColumnOrdinal: Integer)
    var
        recProdOrderLine: Record "Prod. Order Line";
    begin
        recProdOrderLine.Reset();
        recProdOrderLine.SetFilter(Status, '<%1', recProdOrderLine.Status::Finished);
        recProdOrderLine.SetRange(CentroTrabajoCalculado_btc, "No.");
        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            recProdOrderLine.SetRange(FechaInicial_btc, MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            recProdOrderLine.SetFilter(FechaInicial_btc, '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        page.RunModal(50401, recProdOrderLine);
        CurrPage.Update(false);
    end;

    local procedure MATRIX_OnAfterGetRecord(MATRIX_ColumnOrdinal: Integer)
    var
        recLinOp: Record "Prod. Order Line";
        recCapCentroTrabajo: Record CapCentrotrabajo;
        recProdOrdRutLine: Record "Prod. Order Routing Line";
        recTemp: Record "Aging Band Buffer" temporary;
        decCantFabrPeriodo: Decimal;
        codProductoFabricar: Code[20];
        intMultiplicadorCapacidad: Integer;
        decCapacidad: Decimal;
        decCapCentroFecha: Decimal;
    begin
        MATRIX_CellData[MATRIX_ColumnOrdinal] := 0;
        recTemp.Reset();
        recTemp.DeleteAll();
        decCantFabrPeriodo := 0;
        codProductoFabricar := '';
        intMultiplicadorCapacidad := 1;
        decCapacidad := 0;
        decCapCentroFecha := 0;

        recLinOp.Reset();
        recLinOp.setfilter(Status, '<%1', recLinOp.Status::Finished);

        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            recLinOp.SetRange(FechaInicial_btc, MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            recLinOp.SetFilter(FechaInicial_btc, '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        if recLinOp.FindSet() then
            repeat
                // Solo tenemos que fijarnos en la primera línea de la ruta, si no es de nuestro centro de trabajo, no la tenemos en cuenta
                recProdOrdRutLine.Reset();
                recProdOrdRutLine.SetRange(Status, recLinOp.Status);
                recProdOrdRutLine.SetRange("Prod. Order No.", recLinOp."Prod. Order No.");
                if recProdOrdRutLine.FindFirst() then
                    if recProdOrdRutLine."Work Center No." = "No." then begin
                        recTemp.Reset();
                        recTemp.SetRange("Currency Code", recLinOp."Item No.");
                        if recTemp.FindFirst() then begin
                            recTemp."Column 1 Amt." += recLinOp."Remaining Quantity";
                            recTemp.Modify();

                            decCantFabrPeriodo += recLinOp."Remaining Quantity";
                        end else begin
                            recTemp.Init();
                            recTemp."Currency Code" := recLinOp."Item No.";
                            recTemp."Column 1 Amt." := recLinOp."Remaining Quantity";
                            recTemp.Insert();

                            decCantFabrPeriodo := recLinOp."Remaining Quantity";
                        end;

                        if not recLinOpTemp.get(recLinOp.Status, recLinOp."Prod. Order No.", recLinOp."Line No.") then begin
                            recLinOpTemp.Init();
                            recLinOpTemp.TransferFields(recLinOp);
                            recLinOpTemp.CodCentroTrabajo_btc := "No.";
                            recLinOpTemp.Insert();
                        end;
                    end;
            until recLinOp.Next() = 0;

        recTemp.Reset();
        if recTemp.FindFirst() then
            codProductoFabricar := recTemp."Currency Code"
        else begin
            MATRIX_CellData[MATRIX_ColumnOrdinal] := 0;
            exit;
        end;

        //La capacidad ya no se obtiene de la ficha del centro
        decCapCentroFecha := GetCapacidadCalendario("No.", MATRIX_ColumnOrdinal);

        recCapCentroTrabajo.Reset();
        recCapCentroTrabajo.SetRange(CodCentro, "No.");

        //La capacidad ya no se obtiene de la ficha del centro
        //recCapCentroTrabajo.SetRange(NumPersonas, Capacity);
        recCapCentroTrabajo.SetRange(NumPersonas, decCapCentroFecha);


        //recCapCentroTrabajo.SetRange(CodProducto, codProductoFabricar);
        if not recCapCentroTrabajo.FindFirst() then begin
            recCapCentroTrabajo.SetRange(CodProducto);
            if not recCapCentroTrabajo.FindFirst() then begin
                MATRIX_CellData[MATRIX_ColumnOrdinal] := -1;
                exit;
            end;
        end;

        if decCantFabrPeriodo = 0 then begin
            MATRIX_CellData[MATRIX_ColumnOrdinal] := 0;
            exit;
        end;


        if (decCapCentroFecha <> 0) and (recCapCentroTrabajo.NumOrdenesFab <> 0) then               //30                        //100                        
            MATRIX_CellData[MATRIX_ColumnOrdinal] := decCantFabrPeriodo / recCapCentroTrabajo.NumOrdenesFab * 100 /// decCapCentroFecha
        else
            MATRIX_CellData[MATRIX_ColumnOrdinal] := 0;

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

        recLinOpTemp.Reset();
        recLinOpTemp.DeleteAll();
    end;

    // Obtiene la capacidad de un centro de trabajo sumando la cantidad en movimientos de calendario
    local procedure GetCapacidadCalendario(pCodCentro: Code[20]; MATRIX_ColumnOrdinal: Integer): Decimal
    var
        recCalEntry: Record "Calendar Entry";
        decCapacidad: Decimal;
        FechaAnterior: Date;
    begin
        decCapacidad := 0;
        FechaAnterior := 0D;
        recCalEntry.Reset();
        recCalEntry.SetRange("Capacity Type", recCalEntry."Capacity Type"::"Work Center");
        recCalEntry.SetRange("No.", pCodCentro);
        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            recCalEntry.SetRange(date, MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            recCalEntry.SetFilter(Date, '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        if recCalEntry.FindSet() then
            repeat
                IF FechaAnterior <> recCalEntry.Date THEN
                    decCapacidad += recCalEntry.Capacity;
                FechaAnterior := recCalEntry.Date;
            until recCalEntry.Next() = 0;

        exit(decCapacidad);
    end;

    // Comprueba si ese día/periodo tiene capacidad
    local procedure TieneCapacidad(pCodCentro: Code[20]; MATRIX_ColumnOrdinal: Integer): Boolean
    var
        recCalEntry: Record "Calendar Entry";
    begin
        recCalEntry.Reset();
        recCalEntry.SetRange("Capacity Type", recCalEntry."Capacity Type"::"Work Center");
        recCalEntry.SetRange("No.", pCodCentro);
        recCalEntry.SetFilter("Capacity (Total)", '>0');
        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
            recCalEntry.SetRange(date, MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
            recCalEntry.SetFilter(Date, '>=%1&<=%2', MatrixRecords[MATRIX_ColumnOrdinal]."Period Start", MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        if recCalEntry.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    var
        MATRIX_CellData: array[32] of Decimal;
        MATRIX_CaptionSet: array[32] of Text[80];
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        MatrixRecords: array[32] of Record Date;
        recLinOpTemp: Record "Prod. Order Line" temporary;
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