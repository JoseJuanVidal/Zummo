page 50003 "PageMatricesComprasProducto"
{
    PageType = Card;
    Caption = 'Estadisticas Compras', comment = 'ESP="Estadisticas Compras"';
    DataCaptionExpression = '';
    InsertAllowed = false;
    DeleteAllowed = false;
    SaveValues = true;
    LinksAllowed = false;

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

            part(MatrizCompraArticulo; MatrizCompraArticulo)
            {
                ApplicationArea = All;
            }

            part(MatrizCompraArticulo2; MatrizCompraArticulo)
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

        CurrPage.MatrizCompraArticulo.Page.Inicializa(true);
        CurrPage.MatrizCompraArticulo.Page.Load(MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentSetLenght);
        CurrPage.MatrizCompraArticulo.Page.Update(true);

        CurrPage.MatrizCompraArticulo2.Page.Inicializa(false);
        CurrPage.MatrizCompraArticulo2.Page.Load(MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentSetLenght);
        CurrPage.MatrizCompraArticulo2.Page.Update(true);
    end;

    local procedure MATRIX_GenerateColumnCaptions(SetWanted: Option Initial,Previus,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted, ARRAYLEN(MATRIX_CaptionSet), MATRIX_UseNameForCaption, PeriodType, MATRIX_DateFilter,
            MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentSetLenght, MATRIX_MatrixRecords);
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
}