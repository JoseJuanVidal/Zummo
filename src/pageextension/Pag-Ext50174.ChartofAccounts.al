pageextension 50174 "ChartofAccounts" extends "Chart of Accounts"
{
    layout
    {
        addbefore(Balance)
        {
            field(saldoAnterior; saldoAnterior)
            {
                ApplicationArea = All;
                BlankZero = true;
                Editable = false;
                Caption = 'Saldo apertura', comment = 'ESP="Saldo apertura"';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recGlEntry: Record "G/L Entry";
        txtFechaInicio: Text;
        txtAux: Text;
        fecha: Date;
    begin
        saldoAnterior := 0;

        recGlEntry.Reset();
        recGlEntry.SetRange("G/L Account No.", "No.");
        recGlEntry.SetFilter("Business Unit Code", rec.GetFilter("Business Unit Filter"));
        recGlEntry.SetFilter("Global Dimension 1 Code", rec.GetFilter("Global Dimension 1 Filter"));
        recGlEntry.SetFilter("Global Dimension 2 Code", rec.GetFilter("Global Dimension 2 Filter"));

        if rec.GetFilter("Date Filter") <> '' then begin
            txtAux := rec.GetFilter("Date Filter");

            if StrPos(txtAux, '.') = 0 then
                txtFechaInicio := txtAux
            else
                txtFechaInicio := CopyStr(rec.GetFilter("Date Filter"), 1, StrPos(rec.GetFilter("Date Filter"), '.') - 1);

            if Evaluate(fecha, txtFechaInicio) then
                recGlEntry.SetFilter("Posting Date", '<%1', fecha);
        end;

        recGlEntry.SetFilter("Dimension Set ID", rec.GetFilter("Dimension Set ID Filter"));
        recGlEntry.CalcSums(Amount);
        saldoAnterior := recGlEntry.Amount;
        // if recGlEntry.FindSet() then
        //     repeat
        //         saldoAnterior += recGlEntry.Amount;
        //     until recGlEntry.Next() = 0;
    end;

    var
        saldoAnterior: Decimal;
}