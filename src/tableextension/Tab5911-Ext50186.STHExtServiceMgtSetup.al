tableextension 50186 "STH Ext ServiceMgtSetup" extends "Service Mgt. Setup"  //5911
{
    fields
    {
        field(50100; PeriodoRevisionGarantia; DateFormula)
        {
            Caption = 'Periodo revisión Garantias', comment = 'Periodo revisión Garantias';
        }
        field(50101; "Config. importe servicio"; Decimal)
        {
            Caption = 'Config. importe servicio', comment = 'ESP="Config. importe servicio"';
        }
    }
}