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

    procedure PonerSaldoPeriodo()
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        Saldo: Decimal;
    begin

        if GetFilter("Customer No.") <> '' then begin
            saldo := 0;
            CustomerLedgerEntry.reset;
            CustomerLedgerEntry.SetRange("Customer No.", GetFilter("Customer No."));
            CustomerLedgerEntry.SetCurrentKey("Due Date");
            CustomerLedgerEntry.SetAscending("Due Date", true);
            if CustomerLedgerEntry.FindSet() then begin
                repeat
                    //Message(GetFilter("Customer No."));
                    //Message(format(saldo))
                    CustomerLedgerEntry.CalcFields("Remaining Amount");
                    saldo := saldo + CustomerLedgerEntry."Remaining Amount";
                    CustomerLedgerEntry.SaldoAcumulado := saldo;
                    CustomerLedgerEntry.Modify();
                until CustomerLedgerEntry.Next() = 0;
            end;
            CurrPage.Update(false);
        end;
    end;
}