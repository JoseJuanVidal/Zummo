pageextension 50172 "VendorLedgerEntries" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Remaining Amount")
        {
            field(SaldoAcumulado; SaldoAcumulado)
            {

            }
            field(FechaEmision; FechaEmision)
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

        addafter("Vendor No.")
        {
            field(NombreProveedor; NombreProveedor)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        //JAA 30-09-2021 - Ticket #262857- Se añade el código de pais
        addafter("Currency Code")
        {
            field(CountryCode; CountryCode)
            {
                ApplicationArea = All;
                Caption = 'Country Code', Comment = 'ESP="Código país"';
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
        }
    }


    trigger OnAfterGetRecord()
    var
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
    begin
        FechaEmision := 0D;
        PurchaseInvoiceHeader.reset;
        PurchaseInvoiceHeader.SetRange("No.", Rec."Document No.");
        IF PurchaseInvoiceHeader.FindFirst() THEN begin
            FechaEmision := PurchaseInvoiceHeader."Document Date";
        END;

        //JAA 03/09/2021- Ticket #262857 SE relacionan las tablas para obtener el codigo de país del proveedor 
        CountryCode := '';
        Vendor.Reset();
        Vendor.SetRange("No.", Rec."Vendor No.");
        if Vendor.FindSet() then
            CountryCode := Vendor."Country/Region Code";


    end;

    trigger OnOpenPage()

    begin
        PonerSaldoPeriodo()
    end;

    procedure PonerSaldoPeriodo()
    var
        CustomerLedgerEntry: Record "Vendor Ledger Entry";
        Saldo: Decimal;
    begin
        if GetFilter("Vendor No.") <> '' then begin
            saldo := 0;
            CustomerLedgerEntry.reset;
            CustomerLedgerEntry.SetRange("Vendor No.", GetFilter("Vendor No."));
            CustomerLedgerEntry.SetCurrentKey("Due Date");
            CustomerLedgerEntry.SetAscending("Due Date", true);
            if CustomerLedgerEntry.FindSet() then begin
                repeat
                    CustomerLedgerEntry.CalcFields("Remaining Amount");
                    Saldo += CustomerLedgerEntry."Remaining Amount";
                    CustomerLedgerEntry.SaldoAcumulado := saldo + CustomerLedgerEntry."Remaining Amount";
                    CustomerLedgerEntry.Modify();
                until CustomerLedgerEntry.Next() = 0;
            end;
            CurrPage.Update(false);
        end;
    end;

    var
        FechaEmision: Date;
        CountryCode: Code[10];
}