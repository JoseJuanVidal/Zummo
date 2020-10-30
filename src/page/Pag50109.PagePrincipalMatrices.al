page 50109 "PagePrincipalMatrices"
{
    PageType = Card;
    Caption = 'Work Center Calendar', comment = 'ESP="Calendario Centro Trabajo"';
    DataCaptionExpression = '';
    InsertAllowed = false;
    DeleteAllowed = false;
    SaveValues = true;
    LinksAllowed = false;
    SourceTable = "Work Center";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(MatrixOptions)
            {
                Caption = 'Matrix Options', comment = 'ESP="Opciones Matriz"';

                field(PeriodType; PeriodType)
                {
                    ApplicationArea = All;
                    Caption = 'View by', comment = 'ESP="Ver por"';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period', comment = 'ESP="Día,Semana,Mes,Trimestre,Año,Periodo contable"';
                    Editable = true;
                    Enabled = true;

                    trigger OnValidate()
                    begin
                        MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                    end;
                }

                field(MATRIX_CaptionRange; MATRIX_CaptionRange)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Column set', comment = 'ESP="Conjunto de columnas"';
                }
            }

            part(MatrizCentros; MatrizCapacidadCentroTrabajo)
            {
                ApplicationArea = All;
            }

            part(MatrizProductos; MatrizCapacidadProducto)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowMatrix)
            {
                ApplicationArea = All;
                Caption = 'Show matrix', comment = 'ESP="Mostrar matriz"';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegeneraMatrices();
                end;
            }

            action(PreviousSet)
            {
                ApplicationArea = All;
                Caption = 'Previous Set', comment = 'ESP="Conjunto anterior"';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    MATRIX_GenerateColumnCaptions(SetWanted::Previus);
                end;
            }

            action(NextSet)
            {
                ApplicationArea = all;
                Caption = 'Next Set', comment = 'ESP="Conjunto siguiente"';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    MATRIX_GenerateColumnCaptions(SetWanted::Next);
                end;
            }

            action(VerPendientes)
            {
                ApplicationArea = all;
                Caption = 'View pending production orders', comment = 'ESP="Ver OP atrasadas pendientes"';
                ToolTip = 'Show a list of pending backorder production orders',
                    comment = 'ESP="Muestra un listado con las ordenes de producción pendientes atrasadas"';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ViewRegisteredOrder;

                trigger OnAction()
                var
                    recProdOrderLine: Record "Prod. Order Line";
                begin
                    recProdOrderLine.Reset();
                    recProdOrderLine.SetFilter(Status, '<%1', recProdOrderLine.Status::Finished);
                    recProdOrderLine.SetFilter(FechaInicial_btc, '<=%1', WorkDate());
                    recProdOrderLine.SetFilter("Remaining Quantity", '>%1', 0);

                    page.RunModal(50401, recProdOrderLine);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        MATRIX_GenerateColumnCaptions(SetWanted::Initial);
        MATRIX_UseNameForCaption := FALSE;
        MATRIX_CurrentSetLenght := ARRAYLEN(MATRIX_CaptionSet);

        RegeneraMatrices();
    end;


    local procedure RegeneraMatrices()
    begin
        MATRIX_CurrentSetLenght := ARRAYLEN(MATRIX_CaptionSet);

        CurrPage.MatrizCentros.Page.Inicializa();
        CurrPage.MatrizCentros.Page.Load(MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentSetLenght);
        CurrPage.MatrizCentros.Page.Update(true);

        CurrPage.MatrizProductos.Page.Inicializa();
        CurrPage.MatrizProductos.Page.Load(MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentSetLenght);
        CurrPage.MatrizProductos.Page.Update(true);
    end;

    local procedure MATRIX_GenerateColumnCaptions(SetWanted: Option Initial,Previus,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted, ARRAYLEN(MATRIX_CaptionSet), MATRIX_UseNameForCaption, PeriodType, MATRIX_DateFilter,
            MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentSetLenght, MATRIX_MatrixRecords);
    end;

    procedure SetCentro(CentroTrabajo: record "Work Center")
    begin
        CurrPage.MatrizProductos.Page.SetFiltrarCentro(CentroTrabajo);
        CurrPage.MatrizProductos.Page.Update(true);

    end;

    var
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        MATRIX_CaptionRange: Text;
        SetWanted: Option Initial,Previus,Same,Next;
        MATRIX_CaptionSet: array[32] of Text[80];
        MATRIX_UseNameForCaption: Boolean;
        MATRIX_DateFilter: Text;
        MATRIX_PrimKeyFirstCaptionInCu: Text;
        MATRIX_CurrentSetLenght: Integer;
        MATRIX_MatrixRecords: array[32] of Record Date;
        MATRIX_CurrentNoOfColumns: Integer;
        CentroNo: code[20];
}