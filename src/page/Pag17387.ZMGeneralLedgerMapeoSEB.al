page 17387 "ZM General Ledger Mapeo SEB"
{
    Caption = 'Mapeo SEB';
    PageType = List;
    SourceTable = "ZM General Ledger Mapeo SEB";
    UsageCategory = None;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Company or."; Rec."Company or.")
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
                field(Reparto; Rec.Reparto)
                {
                    ApplicationArea = All;
                    AutoFormatType = 10;
                    AutoFormatExpression = '<precision, 2:4><standard format,0>%';
                }
                field("Account Number (7d)"; Rec."Account Number (7d)")
                {
                    ApplicationArea = All;
                }
                field(Nombre; Rec.Nombre)
                {
                    ApplicationArea = All;
                }
                field("Account Number (4d)"; Rec."Account Number (4d)")
                {
                    ApplicationArea = All;
                }
                field(CECO; Rec.CECO)
                {
                    ApplicationArea = All;
                }
                field("Conso item code"; Rec."Conso item code")
                {
                    ApplicationArea = All;
                }
                field("Conso item description"; Rec."Conso item description")
                {
                    ApplicationArea = All;
                }
                field("Nature code"; Rec."Nature code")
                {
                    ApplicationArea = All;
                }
                field("Nature description"; Rec."Nature description")
                {
                    ApplicationArea = All;
                }
                field("Chart of accounts by function (Lvl.1)"; Rec."Chart of accounts 1")
                {
                    ApplicationArea = All;
                }
                field("Chart of accounts by function (Lvl.2)"; Rec."Chart of accounts 2")
                {
                    ApplicationArea = All;
                }
                field("ROPA-UNDER ROPA"; Rec."ROPA-UNDER ROPA")
                {
                    ApplicationArea = All;
                }
                field("Reporting Zummo C1 - Clasif1"; Rec."Reporting Zummo C1 - Clasif1")
                {
                    ApplicationArea = All;
                }
                field("Reporting Zummo C2 - Clasif2"; Rec."Reporting Zummo C2 - Clasif2")
                {
                    ApplicationArea = All;
                }
                field("Reporting Zummo C3 - Clasif3"; Rec."Reporting Zummo C3 - Clasif3")
                {
                    ApplicationArea = All;
                }
                field("EBITDA-UNDER EBITDA"; Rec."EBITDA-UNDER EBITDA")
                {
                    ApplicationArea = All;
                }
                field("CONCILIACIÓN"; Rec."CONCILIACIÓN")
                {
                    ApplicationArea = All;
                }
                field("LEVEL 2"; Rec."LEVEL 2")
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
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DistributionCheck)
            {
                ApplicationArea = all;
                Caption = 'Distribution Check', comment = 'ESP="Comprobación Reparto"';
                Image = DistributionGroup;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Rec.DistributionCheck();
                end;

            }
        }

    }
    trigger OnOpenPage()
    begin
        GLSetup.Get();
        MATRIX_CaptionSet[1] := GLSetup."SEB Column Name 1";
        MATRIX_CaptionSet[2] := GLSetup."SEB Column Name 2";
        MATRIX_CaptionSet[3] := GLSetup."SEB Column Name 3";
        MATRIX_CaptionSet[4] := GLSetup."SEB Column Name 5";
        MATRIX_CaptionSet[5] := GLSetup."SEB Column Name 5";
        MATRIX_CaptionSet[6] := GLSetup."SEB Column Name 6";
        MATRIX_CaptionSet[7] := GLSetup."SEB Column Name 7";
        MATRIX_CaptionSet[8] := GLSetup."SEB Column Name 8";
        MATRIX_CaptionSet[9] := GLSetup."SEB Column Name 9";
        MATRIX_CaptionSet[10] := GLSetup."SEB Column Name 10";
    end;

    var
        GLSetup: record "General Ledger Setup";
        MATRIX_CaptionSet: array[10] of text;
}
