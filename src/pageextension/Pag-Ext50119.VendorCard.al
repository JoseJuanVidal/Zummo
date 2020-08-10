pageextension 50119 "VendorCard" extends "Vendor Card"
{
    layout
    {
        addafter(Blocked)
        {
            field(CodMotivoBloqueo_btc; CodMotivoBloqueo_btc)
            {
                ApplicationArea = All;
                ToolTip = 'It allows to indicate the reason for which it has been blocked', comment = 'ESP="Permite indicar el motivo por el cual ha sido bloqueado"';
                Enabled = MotivoBloqueoEnabled;
            }
        }

        //101219 S19/01393 Clasificación proveedor
        addafter(Name)
        {
            field(ClasProveedor_btc; ClasProveedor_btc)
            {
                ApplicationArea = All;
            }
        }

        modify(Blocked)
        {
            trigger OnAfterValidate()
            begin
                CompruebaMotivoBloqueoEnabled();
            end;
        }
    }

    actions
    {


        addbefore("Entry Statistics")
        {
            action("Imprimir Extracto")
            {
                ApplicationArea = All;
                Caption = 'Imprimir Extracto', comment = 'NLB="Imprimir Extracto"';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintForm;
                trigger OnAction()
                var
                    Proveedor: Record Vendor;
                begin
                    Proveedor.SetRange("No.", Rec."No.");
                    if (Proveedor.FindFirst()) then
                        Report.Run(Report::"Extracto Proveedor", true, false, Proveedor);
                end;
            }
        }


        addafter("Co&mments")
        {
            action(ComentariosBloqueo)
            {
                ApplicationArea = All;
                Image = Compress;
                Caption = 'Lock Comments', comment = 'ESP="Comentarios bloqueo"';
                ToolTip = 'Show comments on blocking reason', comment = 'ESP="Musestra los comentarios del motivo de bloqueo"';
                Visible = false;  //161219 S19/01177 Se usará la tabla estándar

                trigger OnAction()
                var
                    recComentVarios: Record ComentariosVarios;
                    pageComentarios: page ComentariosVarios;
                begin
                    recComentVarios.Reset();
                    recComentVarios.SetRange(TablaOrigen_btc, Database::Vendor);
                    recComentVarios.SetRange(No_btc, "No.");
                    recComentVarios.SetRange(TipoComentario_btc, recComentVarios.TipoComentario_btc::"Lock Comment");

                    clear(pageComentarios);
                    pageComentarios.SetTableView(recComentVarios);
                    pageComentarios.RunModal();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CompruebaMotivoBloqueoEnabled();
    end;

    local procedure CompruebaMotivoBloqueoEnabled()
    var
        myInt: Integer;
    begin
        MotivoBloqueoEnabled := false;

        if Blocked = Blocked::" " then
            MotivoBloqueoEnabled := false
        else
            MotivoBloqueoEnabled := true;
    end;

    var
        MotivoBloqueoEnabled: Boolean;
}