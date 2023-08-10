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
        field(50003; CalculadoSaldoAcumulado; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculado Saldo Acumulado', comment = 'ESP="Calculado Saldo Acumulado"';
            Editable = false;
        }
        field(50102; AreaManager_btc; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.AreaManager_btc where("No." = field("Customer No.")));
            Caption = 'Area Manager', comment = 'ESP="Area Manager"';
        }

        field(50002; "código clasificación"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Cartera Doc."."Category Code" where("Entry No." = field("Entry No."), Type = const(Receivable)));
            Caption = 'Código clasificación', comment = 'ESP="Código clasificación"';
        }
        field(50050; "Cred_ Max_ Aseg. Autorizado Por_btc"; Code[20])
        {
            Caption = 'Crédito Maximo Aseguradora Autorizado Por', Comment = 'ESP="Crédito Maximo Aseguradora Autorizado Por"';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Cred_ Max_ Aseg. Autorizado Por_btc" where("No." = field("Customer No.")));
            Description = 'Bitec';
            Editable = true;
        }
        field(50051; "Credito Maximo Aseguradora_btc"; Integer)
        {
            Caption = 'Crédito Maximo Aseguradora', Comment = 'ESP="Crédito Maximo Aseguradora"';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Credito Maximo Aseguradora_btc" where("No." = field("Customer No.")));
            Description = 'Bitec';
            Editable = true;
        }
        field(50052; Suplemento_aseguradora; Code[20])
        {
            Caption = 'Suplemento aseguradora', comment = 'ESP="Suplemento aseguradora"';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Suplemento_aseguradora where("No." = field("Customer No.")));
        }
        field(50053; "FechaVtoAsegurador"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Vto. Aseguradora', comment = 'ESP="Fecha Vto. Aseguradora"';
            Editable = false;
        }
        field(50054; "ABC Cliente"; option)
        {
            OptionMembers = " ","3A","A","B","C","Z";
            OptionCaption = ' ,3A,A,B,C,Z', Comment = 'ESP=" ,3A,A,B,C,Z"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."ABC Cliente" where("No." = field("Customer No.")));
        }
    }

}