tableextension 50107 "PurchSetup" extends "Purchases & Payables Setup" //312
{
    fields
    {
        field(50000; TextoEmailPedCompra_btc; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Text e-mail purchase order', Comment = 'ESP="Texto e-mail pedido compra"';
            Description = 'Bitec';
        }
        field(50010; WarningPlasticReceiptIntra; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Warning Intra-Communitary plastics', Comment = 'ESP="Aviso Norm. plastico intracomunitario"';
            Description = 'Zummo';
        }
        field(50020; "Sharepoint Connection"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sharepoint Connection', comment = 'ESP="Conexión Sharepoint"';
            TableRelation = "ZM OAuth 2.0 Application".Code;
        }
        field(50022; "Sharepoint Folder"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sharepoint Folder', comment = 'ESP="Carpeta Sharepoint"';
            TableRelation = "ZM OAuth20Application Folders".Code where("Application Code" = field("Sharepoint Connection"));
        }
        field(50030; driveId; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Drive Id', comment = 'ESP="Drive ID"';
        }
        field(50040; "Path Purchase Documents"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Path Purchase Documents', comment = 'ESP="Ubicación Docs. compra"';
        }
        field(50050; "Path Purchase Docs. pending"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Path Purchase Documents pending', comment = 'ESP="Ubicación Docs. compra pdtes."';
        }
        field(50060; "ZM Contracts Nos."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contracts Nos.', comment = 'ESP="Nº serie contratos/suministros"';
            TableRelation = "No. Series";
        }

        field(50100; "CONSULTIA Url"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'CONSULTIA Url', comment = 'ESP="CONSULTIA Url"';
        }
        field(50101; "CONSULTIA User"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'CONSULTIA User', comment = 'ESP="CONSULTIA Usuario"';
        }
        field(50102; "CONSULTIA Password"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'CONSULTIA Password', comment = 'ESP="CONSULTIA Contraseña"';
        }
        field(50103; "CONSULTIA G/L Provide"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'CONSULTIA G/L Provide', comment = 'ESP="CONSULTIA Cuenta Contsble aprovisionamiento."';
            TableRelation = "G/L Account";
        }
        field(50104; "CONSULTIA Gen. Jnl. Template"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'CONSULTIA Gen. Jnl. Template', comment = 'ESP="CONSULTIA Libro Diario"';
            TableRelation = "Gen. Journal Template" where(Type = const(General), Recurring = const(false));
        }
        field(50105; "CONSULTIA Gen. Journal Batch"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'CONSULTIA Gen. Journal Batch', comment = 'ESP="CONSULTIA Sección Diario"';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("CONSULTIA Gen. Jnl. Template"));
        }
    }

    procedure SetTextoEmail(NewTextoEmail: Text)
    var
        TempBlob: Record TempBlob;
    begin
        Clear(TextoEmailPedCompra_btc);

        if NewTextoEmail = '' then
            exit;

        TempBlob.Blob := TextoEmailPedCompra_btc;
        TempBlob.WriteAsText(NewTextoEmail, TEXTENCODING::UTF8);
        TextoEmailPedCompra_btc := TempBlob.Blob;

        MODIFY();
    end;

    procedure GetTextoEmail(): Text
    var
        TempBlob: Record TempBlob;
        CR: Text[1];
    begin
        CALCFIELDS(TextoEmailPedCompra_btc);

        IF NOT TextoEmailPedCompra_btc.HASVALUE() THEN
            EXIT('');

        CR[1] := 10;
        TempBlob.Blob := TextoEmailPedCompra_btc;

        EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::UTF8));
    end;
}