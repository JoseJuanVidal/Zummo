pageextension 50171 "CustomerLedgerEntries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Remaining Amount")
        {
            field(SaldoAcumulado; SaldoAcumulado)
            {
            }
            field("Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = all;
            }
            field(AreaManager_btc; AreaManager_btc)
            {
                ApplicationArea = all;
            }
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                var
                    Movconta: Record "G/L Entry";
                begin
                    Movconta.reset;
                    Movconta.SetRange("Transaction No.", "Transaction No.");
                    Movconta.FindSet();
                    page.run(0, Movconta);
                end;
            }
            field("código clasificación"; "código clasificación")
            {
                ApplicationArea = all;
            }
        }
        addafter("Due Date")
        {
            field(FechaVtoAseguradora; FechaVtoAsegurador)
            {
                ApplicationArea = all;
                Caption = 'Fecha Vto. Aseguradora', comment = 'ESP="Fecha Vto. Aseguradora"';
                StyleExpr = StyleExp;
            }
            field("Cred_ Max_ Aseg. Autorizado Por_btc"; "Cred_ Max_ Aseg. Autorizado Por_btc")
            {
                ApplicationArea = all;
            }
            field(Suplemento_aseguradora; Suplemento_aseguradora)
            {
                ApplicationArea = all;
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

        addafter("F&unctions")
        {
            action(CalcularSaldoPeriodo)
            {
                ApplicationArea = All;
                Caption = 'Calcular Saldo Periodo', comment = 'NLB="Calcular Saldo Periodo"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Calculate;
                trigger OnAction()
                begin
                    PonerSaldoPeriodo;
                end;
            }

            action("Imprimir Extracto")
            {
                ApplicationArea = All;
                Caption = 'Imprimir Extracto', comment = 'NLB="Imprimir Extracto"';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintForm;
                trigger OnAction()
                var
                    Cliente: Record Customer;
                begin
                    Cliente.SetRange("No.", Rec."Customer No.");
                    if (Cliente.FindFirst()) then
                        Report.Run(Report::"Extracto Cliente", true, false, Cliente);
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        PonerSaldoPeriodo()
    end;

    trigger OnAfterGetRecord()
    begin
        if rec.FechaVtoAsegurador <> 0D then
            if CalcDate('-15D', FechaVtoAsegurador) <= WorkDate() then
                StyleExp := 'UnFavorable'
            else
                StyleExp := 'Ambiguous';
    end;

    var
        StyleExp: text;

    procedure PonerSaldoPeriodo()
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        Saldo: Decimal;
    begin
        if GetFilter("Customer No.") <> '' then begin
            saldo := 0;
            CustomerLedgerEntry.reset;
            CustomerLedgerEntry.SetCurrentKey("Entry No.");
            // CustomerLedgerEntry.SetAscending("Due Date", true);
            CustomerLedgerEntry.SetRange("Customer No.", GetFilter("Customer No."));
            CustomerLedgerEntry.SetRange(CalculadoSaldoAcumulado, false);
            if CustomerLedgerEntry.FindSet() then begin
                saldo := GetSaldoAcumulado(CustomerLedgerEntry."Customer No.", CustomerLedgerEntry."Entry No.");
                repeat
                    CustomerLedgerEntry.CalcFields("Amount (LCY)");
                    saldo := saldo + CustomerLedgerEntry."Amount (LCY)";
                    CustomerLedgerEntry.SaldoAcumulado := saldo;
                    CustomerLedgerEntry.CalculadoSaldoAcumulado := true;
                    CustomerLedgerEntry.Modify();
                until CustomerLedgerEntry.Next() = 0;
            end;
            CurrPage.Update(false);
        end;
    end;

    local procedure GetSaldoAcumulado(CustomerNo: code[20]; EntryNo: Integer): Decimal
    var
        DetailCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DetailCustLedgerEntry.Reset();
        DetailCustLedgerEntry.SetRange("Customer No.", CustomerNo);
        DetailCustLedgerEntry.SetRange("Ledger Entry Amount", true);
        DetailCustLedgerEntry.SetFilter("Cust. Ledger Entry No.", '..%1', EntryNo - 1);
        DetailCustLedgerEntry.CalcSums("Amount (LCY)");
        exit(DetailCustLedgerEntry."Amount (LCY)");
    end;
}