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
            field(ItemNo_btc; ItemNo_btc)
            {
                ApplicationArea = all;
            }
            field(ItemName_btc; ItemName_btc)
            {
                ApplicationArea = all;
                Visible = false;
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

            field("Solicitado a Técnico"; "Solicitado a Técnico") { }
            field(Fechaemtregamaterial_sth; Fechaemtregamaterial_sth)
            {
                Visible = false;
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

                    Funciones.ObtenerMtosTrazabilidadNumSerie('', tempItemLedgerEntry, true)

                end;
            }

            // action("Listado NºSerie")
            // {
            //     ApplicationArea = all;
            //     Caption = 'Listado NºSerie', comment = 'ESP="Listado NºSerie"';
            //     ToolTip = 'Listado NºSerie',
            //         comment = 'ESP="Listado NºSerie"';
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     PromotedCategory = Process;
            //     Image = Report;

            //     trigger OnAction()
            //     var
            //         Funciones: Codeunit Funciones;
            //         tempItemLedgerEntry: Record "Item Ledger Entry" temporary;
            //     begin

            //         Funciones.ObtenerMtosVentaSerie(tempItemLedgerEntry, true)

            //     end;
            // }
            action("PS por NºSerie")
            {
                ApplicationArea = all;
                Caption = 'Ped. Servicio NºSerie', comment = 'ESP="Ped. Servicio NºSerie"';
                ToolTip = 'Ped. Servicio NºSerie',
                    comment = 'ESP="Ped. Servicio NºSerie"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Navigate;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                    tempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                begin

                    Funciones.ObtenerPedServicioxSerie(Rec);

                end;
            }
        }
    }
}