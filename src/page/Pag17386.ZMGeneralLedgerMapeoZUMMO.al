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
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }
}
