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
        field(50120; ContratoMantenimiento; Boolean)
        {
            Caption = 'Contrato Mantenimiento', comment = 'ESP="Contrato Mantenimiento"';

            trigger OnValidate()
            begin
                ContratoMantenimiento_OnValidate();
            end;
        }
        field(50130; TipoContratoMantenimiento; Code[20])
        {
            Caption = 'Tipo Contrato', comment = 'ESP="Tipo Contrato"';
            TableRelation = "ZM Tipo contrato Mantenimiento";
        }
        field(50140; FechaInicioContrato; Date)
        {
            Caption = 'Fecha inicio Contrato', comment = 'ESP="Fecha inicio Contrato"';
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
        field(50240; "Mostrar aviso pedido servicio"; Boolean)
        {
            Caption = 'Mostrar aviso pedido servicio', Comment = 'ESP="Mostrar aviso pedido servicio"';
            DataClassification = CustomerContent;
        }
        field(50250; "Aviso pedido servicio"; Text[150])
        {
            Caption = 'Aviso pedido servicio', Comment = 'ESP="Aviso pedido servicio"';
            DataClassification = CustomerContent;
        }
    }
    var
        lblConfirm: Label '¿Desea ampliar la garantia %1?', comment = 'ESP="¿Desea ampliar la garantia %1?"';
        lblError: label 'Primero debe anular la Garantia', Comment = '';
        lblConfirmContrato: Label 'Ya se ha iniciado anteriormente el contrato de garantia en %1.\¿Desea actualizar la fecha?', comment = 'ESP="Ya se ha iniciado anteriormente el contrato de garantia en %1.\¿Desea actualizar la fecha?"';

    local procedure ContratoMantenimiento_OnValidate()
    var
        myInt: Integer;
    begin
        if Rec.ContratoMantenimiento <> xRec.ContratoMantenimiento then
            if Rec.ContratoMantenimiento then begin
                if Rec.FechaInicioContrato <> 0D then
                    if not Confirm(lblConfirmContrato, false, Rec.FechaInicioContrato) then
                        exit;
                Rec.FechaInicioContrato := WorkDate();
            end;
    end;
}