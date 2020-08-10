tableextension 50166 "GLAccount" extends "G/L Account"  //15
{//15
    fields
    {
        field(50001; SaldoApertura; Decimal)
        {
            Caption = 'Saldo Apertura', comment = 'ESP="Saldo Apertura"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula =
                Sum ("G/L Entry".Amount
                WHERE(
                    "G/L Account No." = FIELD("No."),
                    "G/L Account No." = FIELD(FILTER(Totaling)),
                     "Business Unit Code" = FIELD("Business Unit Filter"),
                     "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                     "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                      "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                     "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
        }
    }
}