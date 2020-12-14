tableextension 50181 "STH Intrastat JnlLine" extends "Intrastat Jnl. Line"
{
    fields
    {
        field(50000; "Invoice No."; code[20])
        {
            Editable = false;
            Caption = 'Invoice No.', comment = 'ESP="Nº Factura"';
        }

        field(50001; "Customer No."; code[20])
        {
            Editable = false;
            Caption = 'Customer No.', comment = 'ESP="Cód. Cliente"';
        }

        field(50002; "Customer Name"; text[100])
        {
            Editable = false;
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
        }
    }
}