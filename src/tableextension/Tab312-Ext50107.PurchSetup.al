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
        field(50010; WarningPlasticReceiptIntra; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Warning Intra-Communitary plastics', Comment = 'ESP="Aviso Norm. plastico intracomunitario"';
            Description = 'Bitec';
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