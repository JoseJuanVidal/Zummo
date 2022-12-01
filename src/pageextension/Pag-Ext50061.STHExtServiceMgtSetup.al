pageextension 50061 "STH Ext Service MgtSetup" extends "Service Mgt. Setup"
{
    layout
    {
        addlast(General)
        {
            field(PeriodoRevisionGarantia; PeriodoRevisionGarantia)
            {
                ApplicationArea = all;
            }
            field("Config. importe servicio"; "Config. importe servicio")
            {
                ApplicationArea = all;
            }
        }
    }
}