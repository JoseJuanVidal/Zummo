query 50101 "Consulta Fechas de pago"
{
    QueryType = Normal;

    elements
    {
        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
        {
            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Currency_Code; "Currency Code") { }
            column(AreaManager_btc; AreaManager_btc) { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(Payment_Method_Code; "Payment Method Code") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            dataitem(Cust__Ledger_Entry; "Cust. Ledger Entry")
            {
                DataItemLink = "Document No." = Sales_Invoice_Header."No.", "Customer No." = Sales_Invoice_Header."Sell-to Customer No.";
                DataItemTableFilter = "Document Type" = const(Invoice);
                column(Due_Date; "Due Date") { }
                column(Amount; Amount) { }
                column(Amount__LCY_; "Amount (LCY)") { }
                column(Remaining_Amount; "Remaining Amount") { }
                column(Remaining_Amt___LCY_; "Remaining Amt. (LCY)") { }
                /*  dataitem(CustLedgerEntryBill; "Cust. Ledger Entry"))
                  {
                      DataItemLink = 



                  }*/
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}