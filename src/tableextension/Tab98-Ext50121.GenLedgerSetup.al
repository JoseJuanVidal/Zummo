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
        field(50205; "GL Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Password', comment = 'ESP="Password"';
            ExtendedDatatype = Masked;
        }
        field(50206; "Path LOG"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Path LOG', comment = 'ESP="PATH LOG"';


        }
        //- ABERTIA configuracion de acceso a SQL SERVER
        field(50210; "Add Document Type Payments"; Boolean)
        {
            Caption = 'Add Type Payments when applying', Comment = 'ESP="Indicar Pagos en liquidaciones"';
            DataClassification = CustomerContent;
        }
        // ZUMMO Inventario configuracion de acceso a SQL SERVER
        field(50220; "BBDD INV Data Source"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'BBDD INV Data Source', comment = 'ESP="BBDD INV Data Source"';
        }
        field(50221; "BBDD INV Initial Catalog"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'BBDD INV Initial Catalog', comment = 'ESP="BBDD INV Initial Catalog"';
        }
        field(50222; "BBDD INV User ID"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'BBDD INV User ID', comment = 'ESP="BBDD INV User ID"';
        }
        field(50223; "BBDD INV Password"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'BBDD INV Password', comment = 'ESP="BBDD INV Password"';
            ExtendedDatatype = Masked;
        }

        field(50230; "Column Name 1"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 1', comment = 'ESP="Nombre Columna 1"';
        }
        field(50231; "Column Name 2"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 2', comment = 'ESP="Nombre Columna 2"';
        }
        field(50232; "Column Name 3"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 3', comment = 'ESP="Nombre Columna 3"';
        }
        field(50233; "Column Name 4"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 4', comment = 'ESP="Nombre Columna 4"';
        }
        field(50234; "Column Name 5"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 5', comment = 'ESP="Nombre Columna 5"';
        }
        field(50235; "Column Name 6"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 6', comment = 'ESP="Nombre Columna 6"';
        }
        field(50236; "Column Name 7"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 7', comment = 'ESP="Nombre Columna 7"';
        }
        field(50237; "Column Name 8"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 8', comment = 'ESP="Nombre Columna 8"';
        }
        field(50238; "Column Name 9"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 9', comment = 'ESP="Nombre Columna 9"';
        }
        field(50239; "Column Name 10"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 10', comment = 'ESP="Nombre Columna 10"';
        }
        field(50250; "SEB Column Name 1"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 1', comment = 'ESP="Nombre Columna 1"';
        }
        field(50251; "SEB Column Name 2"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 2', comment = 'ESP="Nombre Columna 2"';
        }
        field(50252; "SEB Column Name 3"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 3', comment = 'ESP="Nombre Columna 3"';
        }
        field(50253; "SEB Column Name 4"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 4', comment = 'ESP="Nombre Columna 4"';
        }
        field(50254; "SEB Column Name 5"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 5', comment = 'ESP="Nombre Columna 5"';
        }
        field(50255; "SEB Column Name 6"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 6', comment = 'ESP="Nombre Columna 6"';
        }
        field(50256; "SEB Column Name 7"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 7', comment = 'ESP="Nombre Columna 7"';
        }
        field(50257; "SEB Column Name 8"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 8', comment = 'ESP="Nombre Columna 8"';
        }
        field(50258; "SEB Column Name 9"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 9', comment = 'ESP="Nombre Columna 9"';
        }
        field(50259; "SEB Column Name 10"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Name 10', comment = 'ESP="Nombre Columna 10"';
        }
    }
    var
        lblPath: Label 'Select folder', comment = 'ESP="Seleccionar Carpeta"';

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

    procedure SelectPathPurchaseDocuments(): Text
    var
        FileManagement: Codeunit "File Management";
        PathName: text;
    begin
        if FileManagement.SelectFolderDialog(lblPath, PathName) then
            Exit(PathName);
    end;
}