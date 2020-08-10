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
    }
}