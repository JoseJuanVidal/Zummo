pageextension 50102 "STHInventorySetup" extends "Inventory Setup"
{
    layout
    {
        addafter("Copy Item Descr. to Entries")
        {
            field("Fecha Diario dentro periodo"; "Fecha Diario dentro periodo")
            {
                ApplicationArea = all;
            }
        }
        addafter(Numbering)
        {
            group(CalcNeed)
            {
                Caption = 'Calculate Balance Qty.', comment = 'ESP="Calcular Cantidad Balance"';

                field(Inventory; Inventory)
                {
                    ApplicationArea = all;
                }
                field("Qty. on Assembly Order"; "Qty. on Assembly Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Prod. Order"; "Qty. on Prod. Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                    ApplicationArea = all;
                }
                field("Trans. Ord. Receipt (Qty.)"; "Trans. Ord. Receipt (Qty.)")
                {
                    ApplicationArea = all;
                }

                field("Qty. on Asm. Component"; "Qty. on Asm. Component")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Component Lines"; "Qty. on Component Lines")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Job Order"; "Qty. on Job Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Service Order"; "Qty. on Service Order")
                {
                    ApplicationArea = all;
                }
                field("Trans. Ord. Shipment (Qty.)"; "Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Sales Quote"; "Qty. on Sales Quote")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Component Quote"; "Qty. on Component Quote")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Planning MPS Component"; "Qty. on Planning MPS Component")
                {
                    ApplicationArea = all;
                }
                field("MRP Bitec Activo"; "MRP Bitec Activo")
                {
                    ApplicationArea = all;
                }
            }
            group(UtilesCalidad)
            {
                Caption = 'Quality tools', comment = 'ESP="Útiles calidad"';

                field("Email aviso revision utiles"; "Email aviso revision utiles")
                {
                    ApplicationArea = all;
                    ToolTip = 'Recipients (separated by ;) of the monthly email with the tools to be revised this month.', comment = 'ESP="Destinatarios (separados por ;) del email mensual con los útiles que se tienen que revisar este mes."';
                }
                field("Ult. aviso revision utiles"; "Ult. aviso revision utiles")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(EnviarAvisoRevisionUtiles)
            {
                ApplicationArea = all;
                Caption = 'Send tools revision warning', comment = 'ESP="Enviar aviso revisión útiles"';
                ToolTip = 'Sends now the email with the quality tools to be revised this month, without waiting for the job queue.', comment = 'ESP="Envía ahora el email con los útiles de calidad a revisar este mes, sin esperar a la cola."';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CUCron: Codeunit CU_Cron;
                    lblConfirm: Label '¿Enviar ahora el aviso de revisión de útiles a %1?', comment = 'ESP="¿Enviar ahora el aviso de revisión de útiles a %1?"';
                    lblEnviado: Label 'Aviso enviado', comment = 'ESP="Aviso enviado"';
                begin
                    Rec.TestField("Email aviso revision utiles");
                    if not Confirm(lblConfirm, false, Rec."Email aviso revision utiles") then
                        exit;
                    CUCron.AvisoRevisionUtiles(true);
                    Message(lblEnviado);
                end;
            }
        }
    }

    var
        myInt: Integer;
}