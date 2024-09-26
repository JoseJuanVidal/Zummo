tableextension 50121 "GenLedgerSetup" extends "General Ledger Setup"  //98
{
    fields
    {
        field(50100; TipoCambioPorFechaEmision_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculate the exchange rate by document date', comment = 'ESP="Calcular el tipo de cambio por fecha de emisión"';
        }
        field(50101; BloqueoCompras; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'BloqueoCompras', comment = 'ESP="Bloqueo Compras"';
        }
        field(50102; BloqueoVentas; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'BloqueoVentas', comment = 'ESP="Bloqueo Ventas"';
        }
        field(50103; "Cta. Contable IVA Recuperacion"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cta. Contable IVA Recuperación', comment = 'ESP="Cta. Contable IVA Recuperación"';
            TableRelation = "G/L Account";
        }
        field(50104; "Proveedor IVA Recuperacion"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Proveedor varios IVA Recuperación', comment = 'ESP="Proveedor varios IVA Recuperación"';
            TableRelation = Vendor;
        }
        // ABERTIA configuracion de acceso a SQL SERVER
        field(50201; "Data Source"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Data Source', comment = 'ESP="Data Source"';
        }
        field(50202; "Initial Catalog"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Initial Catalog', comment = 'ESP="Initial Catalog"';
        }
        field(50203; "User ID"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID', comment = 'ESP="User ID"';
        }
        field(50204; "Password"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Password', comment = 'ESP="Password"';
            ExtendedDatatype = Masked;
        }
        //- ABERTIA configuracion de acceso a SQL SERVER
    }

    procedure AbertiaTABLECONNECTION(): Text
    var
        GenLedgerSetup: Record "General Ledger Setup";
        lblConnectionString: Label 'Data Source=%1;Initial Catalog=%2;User ID=%3;Password=%4';
    begin
        GenLedgerSetup.Get();
        GenLedgerSetup.TestField("Data Source");
        GenLedgerSetup.TestField("User ID");
        GenLedgerSetup.TestField(Password);
        exit(StrSubstNo(lblConnectionString, GenLedgerSetup."Data Source", GenLedgerSetup."Initial Catalog", GenLedgerSetup."User ID", GenLedgerSetup.Password));

    end;
}