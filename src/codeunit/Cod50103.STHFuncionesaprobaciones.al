codeunit 50103 "STH Funciones aprobaciones"
{
    trigger OnRun()
    begin

    end;

    procedure SetAprovals(documentno: code[20]; codeemployee: code[20]; state: text; tag: text): text
    begin
        // TODO aprobaciones, 
        // hacer historico y marcar las aprobaciones.

        Exit(StrSubstNo('Aprobación del documento %1 con tag %4 por %2, el resultado ha sido %3', documentno, codeemployee, state, tag));
    end;

    var
        myInt: Integer;
}