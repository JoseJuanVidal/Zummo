page 17386 "ZM General Ledger Mapeo ZUMMO"
{
    Caption = 'Mapeo ZUMMO', comment = 'ESP="Mapeo ZUMMO"';
    ;
    PageType = List;
    SourceTable = "ZM General Ledger Mapeo Zummo";
    UsageCategory = None;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                }
                field(Empresa; Rec.Empresa)
                {
                    ApplicationArea = All;
                }
                field(Informe; Rec.Informe)
                {
                    ApplicationArea = All;
                }
                field(Ajuste; Rec.Ajuste)
                {
                    ApplicationArea = All;
                }
                field(C1; Rec.C1)
                {
                    ApplicationArea = All;
                }
                field(C2; Rec.C2)
                {
                    ApplicationArea = All;
                }
                field(C3; Rec.C3)
                {
                    ApplicationArea = All;
                }
                field(C4; Rec.C4)
                {
                    ApplicationArea = All;
                }
                field(C5; Rec.C5)
                {
                    ApplicationArea = All;
                }
                field(C6; Rec.C6)
                {
                    ApplicationArea = All;
                }
                field(Tipo; Rec.Tipo)
                {
                    ApplicationArea = All;
                }
                field(H1; Rec.H1)
                {
                    ApplicationArea = All;
                }
                field(H2; Rec.H2)
                {
                    ApplicationArea = All;
                }
                field(H3; Rec.H3)
                {
                    ApplicationArea = All;
                }
                field(H4; Rec.H4)
                {
                    ApplicationArea = All;
                }
                field(H5; Rec.H5)
                {
                    ApplicationArea = All;
                }
                field(H6; Rec.H6)
                {
                    ApplicationArea = All;
                }
                field("DescCuentaEspañol"; Rec."DescCuentaEspañol")
                {
                    ApplicationArea = All;
                }
                field(CuentaAmericana; Rec.CuentaAmericana)
                {
                    ApplicationArea = All;
                }
                field(IC1; Rec.IC1)
                {
                    ApplicationArea = All;
                }
                field(IC2; Rec.IC2)
                {
                    ApplicationArea = All;
                }
                field(IC3; Rec.IC3)
                {
                    ApplicationArea = All;
                }
                field(IC4; Rec.IC4)
                {
                    ApplicationArea = All;
                }
                field(IC5; Rec.IC5)
                {
                    ApplicationArea = All;
                }
                field(IC6; Rec.IC6)
                {
                    ApplicationArea = All;
                }
                field(IH1; Rec.IH1)
                {
                    ApplicationArea = All;
                }
                field(IH2; Rec.IH2)
                {
                    ApplicationArea = All;
                }
                field(IH3; Rec.IH3)
                {
                    ApplicationArea = All;
                }
                field(IH4; Rec.IH4)
                {
                    ApplicationArea = All;
                }
                field(IH5; Rec.IH5)
                {
                    ApplicationArea = All;
                }
                field(IH6; Rec.IH6)
                {
                    ApplicationArea = All;
                }
                field(Columna1; Columna1)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                }
                field(Columna2; Columna2)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                }
                field(Columna3; Columna3)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                }
                field(Columna4; Columna4)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                }
                field(Columna5; Columna5)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                }
                field(Columna6; Columna6)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[6];
                }
                field(Columna7; Columna7)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[7];
                }
                field(Columna8; Columna8)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[8];
                }
                field(Columna9; Columna9)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[9];
                }
                field(Columna10; Columna10)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[10];
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        GLSetup.Get();
        MATRIX_CaptionSet[1] := GLSetup."Column Name 1";
        MATRIX_CaptionSet[2] := GLSetup."Column Name 2";
        MATRIX_CaptionSet[3] := GLSetup."Column Name 3";
        MATRIX_CaptionSet[4] := GLSetup."Column Name 5";
        MATRIX_CaptionSet[5] := GLSetup."Column Name 5";
        MATRIX_CaptionSet[6] := GLSetup."Column Name 6";
        MATRIX_CaptionSet[7] := GLSetup."Column Name 7";
        MATRIX_CaptionSet[8] := GLSetup."Column Name 8";
        MATRIX_CaptionSet[9] := GLSetup."Column Name 9";
        MATRIX_CaptionSet[10] := GLSetup."Column Name 10";
    end;

    var
        GLSetup: record "General Ledger Setup";
        MATRIX_CaptionSet: array[10] of text;
}
