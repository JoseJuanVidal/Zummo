tableextension 50168 "VendorLedgerEntry" extends "Vendor Ledger Entry" //25
{

    fields
    {
        field(50001; SaldoAcumulado; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Saldo Acumulado', comment = 'ESP="Saldo Acumulado"';
            Editable = false;
       }

        field(50002; NombreProveedor; Text[100])
        {
            Editable = false;
            Caption = 'Vendor Name', comment = 'ESP="Nombre Proveedor"';
            FieldClass = FlowField;
            CalcFormula = lookup (Vendor.Name where("No." = field("Vendor No.")));
        }
        field(50003; "código clasificación"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Cartera Doc."."Category Code" where("Entry No." = field("Entry No."), Type = const(Payable)));
            Caption = 'código clasificación', comment = 'ESP="código clasificación"';
        }
    }

}