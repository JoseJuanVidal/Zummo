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
            field(TickMarksurvey_zm; TickMarksurvey_zm)
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
            action(UpdateDocument)
            {
                ApplicationArea = all;
                Caption = 'Actualizar Documento', comment = 'ESP="Actualizar Documento"';
                Image = Process;

                trigger OnAction()
                var
                    HistFallos: Record "ZM Hist. Reclamaciones ventas";
                begin
                    HistFallos.UpdateServiceOrder(Rec);
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
            action(UpdateHistReclamacionesVenta)
            {
                ApplicationArea = all;
                Caption = 'Act. Hist. Reclamaciones', comment = 'ESP="Act. Hist. Reclamaciones"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = AddToHome;

                trigger OnAction()
                var
                    HistReclamacion: Record "ZM Hist. Reclamaciones ventas";
                begin
                    HistReclamacion.UpdateServiceOrder(Rec);
                end;
            }
        }
    }
}