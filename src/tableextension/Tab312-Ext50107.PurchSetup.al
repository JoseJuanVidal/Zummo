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