pageextension 50016 "ServiceOrders" extends "Service Orders"
{
    // Personalizaciones servicios

    layout
    {
        addafter(Name)
        {
            field(NumEstanteria_btc; NumEstanteria_btc)
            {
                ApplicationArea = All;
            }
            field(CodResolucion_btc; CodResolucion_btc)
            {
                ApplicationArea = All;
            }
            field(NumSerie_btc; NumSerie_btc)
            {
                ApplicationArea = All;
            }
            field(CodAnterior_btc; CodAnterior_btc)
            {
                ApplicationArea = All;
            }
            field(ComentarioAlmacen_btc; ComentarioAlmacen_btc)
            {
                ApplicationArea = All;
            }

            field(Description; Description)
            {
                ApplicationArea = All;
            }

            field("Operation Description"; "Operation Description")
            {
                ApplicationArea = all;
            }

            field("Operation Description 2"; "Operation Description 2")
            {
                ApplicationArea = all;
            }

            field("Cerrado en plataforma"; "Cerrado en plataforma") { }





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

                    Funciones.ObtenerMtosTrazabilidadNumSerie('', tempItemLedgerEntry, true)

                end;
            }

            action("Listado N??Serie")
            {
                ApplicationArea = all;
                Caption = 'Listado N??Serie', comment = 'ESP="Listado N??Serie"';
                ToolTip = 'Listado N??Serie',
                    comment = 'ESP="Listado N??Serie"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Report;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                    tempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                begin

                    Funciones.ObtenerMtosVentaSerie(tempItemLedgerEntry, true)

                end;
            }


        }
    }
}