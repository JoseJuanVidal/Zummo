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
        //#region ERPLINK
        field(10; Tipo; Option)
        {
            Caption = 'Tipo', comment = 'ESP="Tipo"';
            OptionMembers = " ",ERPLINKDocs;
        }
        field(11; "Line No."; Integer)
        {
            Caption = 'Nº Línea', comment = 'ESP="Nº Línea"';
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        //#region ERPLINK
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Id = 0 then
            Rec.Id := GetLastID + 1;
        if "Line No." = 0 then
            "Line No." := GetLastLineNo();
    end;

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

    procedure GetLastID(): Integer
    var
        ComentariosPredefinidos: Record ComentariosPredefinidos;
    begin
        ComentariosPredefinidos.Reset();
        if ComentariosPredefinidos.FindLast() then
            exit(ComentariosPredefinidos.id);
    end;

    procedure GetLastLineNo(): Integer
    var
        ComentariosPredefinidos: Record ComentariosPredefinidos;
    begin
        if Rec.CodComentario = '' then
            exit;
        ComentariosPredefinidos.Reset();
        ComentariosPredefinidos.SetRange(CodComentario, Rec.CodComentario);
        if ComentariosPredefinidos.FindLast() then
            exit(ComentariosPredefinidos.id);
    end;
}