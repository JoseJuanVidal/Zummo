pageextension 50155 "ServiceItemList" extends "Service Item List"
{
    layout
    {
        addafter("No.")
        {
            field(CodAnterior_btc; CodAnterior_btc)
            {
                ApplicationArea = All;
            }

        }
        addlast(Control1)
        {
            field(PeriodoAmplacionGarantica_sth; PeriodoAmplacionGarantica_sth)
            {
                ApplicationArea = all;
            }
            field(FechaMantGarantia_sth; FechaMantGarantia_sth)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addfirst(Processing)
        {
            action(Movimientos)
            {
                ApplicationArea = all;
                Caption = 'Trazabilidad Serie', comment = 'ESP="Trazabilidad Serie"';
                ToolTip = 'Trazabilidad Serie',
                    comment = 'ESP="Trazabilidad Serie"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Track;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                    tempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                begin
                    if (Rec."Serial No." <> '') then
                        Funciones.ObtenerMtosTrazabilidadNumSerie(Rec."Serial No.", tempItemLedgerEntry, true)
                    else
                        if (Rec.CodSerieHistorico_btc <> '') then
                            Funciones.ObtenerMtosTrazabilidadNumSerie(Rec.CodAnterior_btc, tempItemLedgerEntry, true)
                        else
                            Funciones.ObtenerMtosTrazabilidadNumSerie(Rec.CodAnterior_btc, tempItemLedgerEntry, true);
                end;
            }
            action(WarrantyMto)
            {
                ApplicationArea = all;
                Caption = 'Generar Ped. Serv. Ampliación Garantia', comment = 'ESP="Generar Ped. Serv. Ampliación Garantia"';
                ToolTip = 'Generar Ped. Servicio de Ampliación Garantia', Comment = 'ESP="Generar Ped. Servicio de Ampliación Garantia"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = WarrantyLedger;
                RunObject = report "Service Mgt. Warranty";

            }
        }
        addlast(Navigation)
        {
            action(MtoWarranty)
            {
                ApplicationArea = all;
                Caption = 'Mto. Ampl. Garantia', comment = 'ESP="Mto. Ampl. Garantia"';
                ToolTip = 'Ped. Servicois de mantenimientos Ampliación de Garantias', Comment = 'ESP="Ped. Servicois de mantenimientos Ampliación de Garantias"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = WarrantyLedger;

                RunObject = page "Service Orders";
                RunPageLink = "Customer No." = field("Customer No."), NumSerie_btc = field("Serial No.");
                RunPageView = where(IsWarranty = const(true));
            }
        }
    }
}