tableextension 50143 "Service Item" extends "Service Item"
//5940
{
    fields
    {
        field(50100; CodAnterior_btc; Code[20])
        {
            Caption = 'Cod.Anterior', comment = 'ESP="Cod.Anterior"';
        }
        field(50110; CodSerieHistorico_btc; Code[20])
        {
            Caption = 'Nº.Serie.Historico', comment = 'ESP="Nº.Serie.Histórico"';
        }
        field(50200; PeriodoAmplacionGarantica_sth; DateFormula)
        {
            Caption = 'Periodo de Ampliacion Garantia', comment = 'Periodo de Ampliación Garantía"';
            trigger OnValidate()
            begin
                if not Confirm(lblConfirm, false, PeriodoAmplacionGarantica_sth) then
                    exit;

                if format(xrec.PeriodoAmplacionGarantica_sth) <> '' then begin
                    FechaIniAmpliacion_sth := 0D;
                    "Warranty Ending Date (Parts)" := CalcDate('-' + format(xRec.PeriodoAmplacionGarantica_sth), "Warranty Ending Date (Parts)");
                    "Warranty Ending Date (Labor)" := calcDate('-' + format(xRec.PeriodoAmplacionGarantica_sth), "Warranty Ending Date (Labor)");
                    Modify();
                end;

                if format(Rec.PeriodoAmplacionGarantica_sth) <> ' ' then begin
                    FechaIniAmpliacion_sth := "Warranty Ending Date (Parts)";
                    "Warranty Ending Date (Parts)" := CalcDate(PeriodoAmplacionGarantica_sth, "Warranty Ending Date (Parts)");
                    "Warranty Ending Date (Labor)" := calcDate(PeriodoAmplacionGarantica_sth, "Warranty Ending Date (Labor)");
                    Modify();
                end;
            end;
        }
        field(50210; FechaIniAmpliacion_sth; Date)
        {
            Caption = 'Fecha Inicio periodo de Ampliacion', comment = 'Fecha Inicio periodo de Ampliación"';
            Editable = false;
        }
    }
    var
        lblConfirm: Label '¿Desea ampliar la garantia %1?', comment = 'ESP="¿Desea ampliar la garantia %1?"';
        lblError: label 'Primero debe anular la Garantia', Comment = '';
}