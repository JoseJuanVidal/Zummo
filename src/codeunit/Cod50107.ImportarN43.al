codeunit 50107 "ImportarN43"
{

    TableNo = "Data Exch.";
    Permissions = TableData 1221 = rimd;

    trigger OnRun()
    var
        ReadStream: InStream;
        ReadText: Text;
        ReadLen: Integer;
        LineNo: Integer;
        SkippedLineNo: Integer;
    begin
        "File Content".CREATEINSTREAM(ReadStream);
        DataExchDef.GET("Data Exch. Def Code");
        LineNo := 1;
        FechaMov := '';
        ConceptoMov := '';
        ImporteMov := '';
        SignoMov := '';
        NDocumento := '';
        CodigoAnt := '';
        InfAdicional := '';
        REPEAT
            ReadLen := ReadStream.READTEXT(ReadText);
            IF ReadLen > 0 THEN
                Parseador(ReadText, Rec, LineNo, FechaMov, ConceptoMov, ImporteMov, SignoMov, NDocumento, CodigoAnt);
        UNTIL ReadLen = 0;

    end;

    LOCAL PROCEDURE Parseador(Line: Text; DataExch: Record "Data Exch."; VAR LineNo: Integer; VAR FechaMov: Text; VAR ConceptoMov: Text;
        VAR ImporteMov: Text; VAR CodigoAnt: Text; VAR SignoMov: Text; VAR NDocumento: Text);
    VAR
        DataExchLineDef: Record "Data Exch. Line Def";
        DataExchField: Record "Data Exch. Field";
    BEGIN
        DataExchLineDef.SETRANGE("Data Exch. Def Code", DataExch."Data Exch. Def Code");
        DataExchLineDef.FINDFIRST;
        Codigo := COPYSTR(Line, 1, 4);
        IF (Codigo = '2201')
          THEN BEGIN
            IF (CodigoAnt = '2201') OR (CodigoAnt = '2301') OR (CodigoAnt = '2302')
              THEN BEGIN
                DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 1, '', FechaMov, DataExchLineDef.Code);
                DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 2, '', ImporteMov, DataExchLineDef.Code);
                DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 3, '', ConceptoMov, DataExchLineDef.Code);
                DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 4, '', SignoMov, DataExchLineDef.Code);
                DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 5, '', NDocumento, DataExchLineDef.Code);
                DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 6, '', InfAdicional, DataExchLineDef.Code);
            END;
            FechaMov := COPYSTR(Line, 11, 6);
            ImporteMov := Formateador(COPYSTR(Line, 29, 14));
            SignoMov := COPYSTR(Line, 28, 1);
            NDocumento := COPYSTR(Line, 43, 10);
            IF NDocumento = '0000000000' THEN
                NDocumento := COPYSTR(Line, STRLEN(Line) - 10, 10);
            InfAdicional := DelChr(CopyStr(Line, 53, 28), '<>', ' ');
            ConceptoMov := DelChr(CopyStr(Line, 53, 28), '<>', ' ');
        END;

        IF (Codigo = '2301') THEN BEGIN
            ConceptoMov := DELCHR(COPYSTR(Line, 5, 76), '<>', ' ');
        END;
        IF (Codigo = '2303') THEN BEGIN
            ConceptoMov += ' ' + DELCHR(COPYSTR(Line, 5, 76), '<>', ' ');
        END;
        IF ((Codigo = '3301') AND (CodigoAnt <> '1101')) THEN BEGIN
            DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 1, '', FechaMov, DataExchLineDef.Code);
            DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 2, '', ImporteMov, DataExchLineDef.Code);
            DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 3, '', ConceptoMov, DataExchLineDef.Code);
            DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 4, '', SignoMov, DataExchLineDef.Code);
            DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 5, '', NDocumento, DataExchLineDef.Code);
            DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, 6, '', InfAdicional, DataExchLineDef.Code);
        END;

        CodigoAnt := Codigo;
        LineNo += 1;
    END;

    LOCAL PROCEDURE Formateador(CadenaEntrada: Text) CadenaSalida: Text;
    VAR
        tantes: Text;
        tdespues: Text;
    BEGIN

        tantes := COPYSTR(CadenaEntrada, 1, STRLEN(CadenaEntrada) - 2);
        tdespues := COPYSTR(CadenaEntrada, STRLEN(CadenaEntrada) - 1, 2);
        CadenaSalida := tantes + ',' + tdespues;
    END;


    var
        DataExchDef: Record "Data Exch. Def";
        Codigo: Text;
        CodigoAnt: Text;
        FechaMov: Text;
        ImporteMov: Text;
        ConceptoMov: Text;
        ImporteDec: Decimal;
        SignoMov: Text;
        NDocumento: Text;
        InfAdicional: Text;

}