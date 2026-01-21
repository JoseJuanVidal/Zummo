tableextension 50209 "ZM Extended Text Header" extends "Extended Text Header"
{
    fields
    {
        field(50000; Signature; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Signature', comment = 'ESP="Firma"';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        TempBlob: Record TempBlob;

    procedure GetSignature(): Text

    begin
        CALCFIELDS(Signature);
        EXIT(GetSignatureCalculated());
    end;

    local procedure GetSignatureCalculated(): Text
    var
        CR: text[1];
    begin
        IF NOT Rec.Signature.HASVALUE THEN
            EXIT('');

        CR[1] := 10;
        TempBlob.Blob := Rec.Signature;
        EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::UTF8));
    end;

    procedure SetSignature(NewSignature: text)
    var
        myInt: Integer;
    begin
        CLEAR(Signature);
        IF NewSignature = '' THEN
            EXIT;
        TempBlob.Blob := Rec.Signature;
        TempBlob.WriteAsText(NewSignature, TEXTENCODING::UTF8);
        Rec.Signature := TempBlob.Blob;
        Rec.MODIFY;
    end;
}