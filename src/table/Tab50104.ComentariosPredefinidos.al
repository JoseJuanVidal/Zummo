table 50104 "ComentariosPredefinidos"
{
    DataClassification = CustomerContent;
    Caption = 'Predefined Comments', comment = 'ESP="Comentarios predefinidos"';

    fields
    {
        field(1; Id; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Id', comment = 'ESP="Id"';
            Editable = false;
        }

        field(3; CodComentario; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }

        field(2; Comentario; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Comment', comment = 'ESP="Comentario"';
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }

    procedure SetComentario(NewText: Text)
    var
        TempBlob: Record TempBlob;
    begin
        Clear(Comentario);

        if NewText = '' then
            exit;

        TempBlob.Blob := Comentario;
        TempBlob.WriteAsText(NewText, TEXTENCODING::UTF8);
        Comentario := TempBlob.Blob;

        MODIFY();
    end;

    procedure GetComentario(): Text
    var
        TempBlob: Record TempBlob;
        CR: Text[1];
    begin
        CALCFIELDS(Comentario);

        IF NOT Comentario.HASVALUE() THEN
            EXIT('');

        CR[1] := 10;
        TempBlob.Blob := Comentario;

        EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::UTF8));
    end;
}