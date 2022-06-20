pageextension 50154 "ServiceItemCard" extends "Service Item Card"
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
        addafter("Serial No.")
        {
            field(CodSerieHistorico_btc; CodSerieHistorico_btc)
            {
                ApplicationArea = All;
            }
        }
        addafter("Warranty % (Labor)")
        {
            field(PeriodoAmplacionGarantica_sth; PeriodoAmplacionGarantica_sth)
            {
                ApplicationArea = All;
            }
            field(FechaIniAmpliacion_sth; FechaIniAmpliacion_sth)
            {
                ApplicationArea = All;

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