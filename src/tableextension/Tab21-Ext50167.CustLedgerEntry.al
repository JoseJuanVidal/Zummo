tableextension 50167 "CustLedgerEntry" extends "Cust. Ledger Entry" //21
{

    fields
    {
        field(50001; SaldoAcumulado; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Saldo Acumulado', comment = 'ESP="Saldo Acumulado"';
            Editable = false;
         }

        field(50102; AreaManager_btc; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (Customer.AreaManager_btc where("No." = field("Customer No.")));
            Caption = 'Area Manager', comment = 'ESP="Area Manager"';
        }

        field(50002; "código clasificación"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Cartera Doc."."Category Code" where("Entry No." = field("Entry No."), Type = const(Receivable)));
            Caption = 'código clasificación', comment = 'ESP="código clasificación"';
        }
    }

}