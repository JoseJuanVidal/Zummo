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
    actions
    {
        addlast(Processing)
        {
            action(cargarhojafallos)
            {
                ApplicationArea = all;
                Caption = 'Actualizar Reclamacion BT', comment = 'ESP="Actualizar Reclamacion BT"';
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;

                trigger OnAction()
                var
                    HistFallos: Record "ZM Hist. Reclamaciones ventas";
                begin
                    HistFallos.CreateHistReclamaciones(0D);
                end;
            }
        }
    }
}