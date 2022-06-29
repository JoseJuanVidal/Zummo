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
            var
                ServiceSetup: Record "Service Mgt. Setup";
            begin
                ServiceSetup.Get();
                ServiceSetup.TestField(PeriodoRevisionGarantia);
                if not Confirm(lblConfirm, false, PeriodoAmplacionGarantica_sth) then
                    exit;

                if format(xrec.PeriodoAmplacionGarantica_sth) <> '' then begin
                    FechaIniAmpliacion_sth := 0D;
                    "Warranty Ending Date (Parts)" := CalcDate('-' + format(xRec.PeriodoAmplacionGarantica_sth), "Warranty Ending Date (Parts)");
                    "Warranty Ending Date (Labor)" := calcDate('-' + format(xRec.PeriodoAmplacionGarantica_sth), "Warranty Ending Date (Labor)");
                    FechaMantGarantia_sth := 0D;
                    Modify();
                end;

                if format(Rec.PeriodoAmplacionGarantica_sth) <> ' ' then begin
                    FechaIniAmpliacion_sth := "Warranty Ending Date (Parts)";
                    "Warranty Ending Date (Parts)" := CalcDate(PeriodoAmplacionGarantica_sth, "Warranty Ending Date (Parts)");
                    "Warranty Ending Date (Labor)" := calcDate(PeriodoAmplacionGarantica_sth, "Warranty Ending Date (Labor)");
                    FechaMantGarantia_sth := CalcDate(ServiceSetup.PeriodoRevisionGarantia, "Warranty Starting Date (Parts)");
                    Modify();
                end;
            end;
        }
        field(50210; FechaIniAmpliacion_sth; Date)
        {
            Caption = 'Fecha Inicio periodo de Ampliacion', comment = 'Fecha Inicio periodo de Ampliación"';
            Editable = false;
        }
        field(50220; FechaMantGarantia_sth; date)
        {
            Caption = 'Fecha próxima revision garantia', comment = 'ESP="Fecha próxima revision garantia"';
        }
        field(50230; "Estado CS"; Code[20])
        {
            Caption = 'Estado', Comment = 'ESP="Estado"';
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(Tabla), TipoTabla = const(ServiceItem));
        }
    }
    var
        lblConfirm: Label '¿Desea ampliar la garantia %1?', comment = 'ESP="¿Desea ampliar la garantia %1?"';
        lblError: label 'Primero debe anular la Garantia', Comment = '';
}