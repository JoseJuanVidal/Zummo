query 50013 "ZM WS Movs. Contabilidad"
{
    // Servicio web de movimientos de contabilidad para Excel/Power BI.
    // Sustituye a la página 20 publicada (lenta por leer fila a fila): una sola consulta SQL.
    // Dimensiones y cliente con los FlowFields de G/L Entry (subconsultas en SQL); no usar JOIN a
    // "Dimension Set Entry" con DataItemTableFilter: el filtro va al WHERE y descarta los movimientos sin esa dimensión.
    // El tiempo de OData en BC14 depende del nº de columnas: añadir solo las que se usen.
    Caption = 'WS G/L Entries', comment = 'ESP="WS Movs. contabilidad"';
    OrderBy = ascending(Entry_No);

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(Entry_No; "Entry No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Document_Type; "Document Type") { }
            column(Document_No; "Document No.") { }
            column(Bill_No; "Bill No.") { }
            column(External_Document_No; "External Document No.") { }
            column(G_L_Account_No; "G/L Account No.") { }
            column(G_L_Account_Name; "G/L Account Name") { }
            column(Description; Description) { }
            column(CECO; "Global Dimension 1 Code") { }
            column(Proyecto_Codigo; "Global Dimension 2 Code") { }
            column(Detalle; "Global Dimension 3 Code") { }
            column(Partida; "Global Dimension 8 Code") { }
            column(Business_Unit; "Business Unit") { }
            column(DIVISION; DIVISION) { }
            column(Gen_Posting_Type; "Gen. Posting Type") { }
            column(Gen_Bus_Posting_Group; "Gen. Bus. Posting Group") { }
            column(Gen_Prod_Posting_Group; "Gen. Prod. Posting Group") { }
            column(Amount; Amount) { }
            column(Debit_Amount; "Debit Amount") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Cust_Ledger_Currency_Factor; "Cust. Ledger Currency Factor") { }
            column(Bal_Account_Type; "Bal. Account Type") { }
            column(Bal_Account_No; "Bal. Account No.") { }
            column(Source_Type; "Source Type") { }
            column(Source_No; "Source No.") { }
            column(Customer_Name; "Customer Name") { }
            column(Customer_Country_Region_Code; "Customer Country/Region Code") { }
            column(Purch_Request_less_200; "Purch. Request less 200") { }

            filter(Posting_Date_Filter; "Posting Date") { }

            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = GLEntry."Source No.";
                SqlJoinType = LeftOuterJoin;
                column(Vendor_Name; Name) { }
                column(Vendor_Country_Region_Code; "Country/Region Code") { }
            }
        }
    }
}
