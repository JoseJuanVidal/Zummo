pageextension 50116 "ZM PurchaseOrderList" extends "Purchase Order List"
{
    layout
    {
        addafter(Status)
        {
            field(Pendiente_btc; Pendiente_btc)
            {
                ApplicationArea = All;
            }
            field(Emailsent; Emailsent)
            {
                ApplicationArea = all;
            }
            // field(EmailsentPending; EmailsentPending)
            // {
            //     ApplicationArea = all;
            // }
            field("Motivo rechazo"; "Motivo rechazo")
            {
                Caption = 'Comentario';
            }
            field("Fecha Mas Temprana"; "Fecha Mas Temprana") { }
        }
        addlast(Control1)
        {
            field(KgVendorPackagingproduct; KgVendorPackagingproduct)
            {
                ApplicationArea = all;
                Caption = 'Vendor Plastic packing (kg)', comment = 'ESP="Plástico embalaje proveedor (kg)"';
                Editable = false;
                Visible = false;

                trigger OnDrillDown()
                begin
                    ShowVendorPackage();
                end;
            }
        }
        addlast(FactBoxes)
        {
            part("ZM Order mail Register Factbox"; "ZM Order mail Register Factbox")
            {
                Caption = 'Registro Envíos', comment = 'ESP="Registro Envíos"';
                SubPageLink = "Order No." = field("No.");
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action(ExportPDF)
            {
                ApplicationArea = all;
                Image = SendAsPDF;
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                begin
                    ExportMergePDF();
                end;
            }
            action(ArchivarPedido)
            {
                ApplicationArea = all;
                Image = SendEmailPDF;
                Caption = 'Archivar PDF', comment = 'ESP="Archivar PDF"';

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    Eventosbtc: Codeunit Eventos_btc;
                    lblConfirm: Label '¿Would you like to archive %1 PDF of the purchase order?', comment = 'ESP="¿Desea Archivar %1 PDF del pedidos de compra?"';
                begin
                    CurrPage.SetSelectionFilter(PurchHeader);
                    if Confirm(lblConfirm, false, PurchHeader.Count) then
                        if PurchHeader.FindFirst() then
                            repeat
                                Eventosbtc.CreateandUploadPurchOrderArchivePDF(PurchHeader);
                            Until PurchHeader.next() = 0;
                end;
            }
            action(MarcarEnviado)
            {
                ApplicationArea = all;
                Caption = 'Marcar Enviado', comment = 'ESP="Marcar Enviado"';
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchaseHeader: record "Purchase Header";
                    lblConfirm: Label '¿Desea Marcar/Desmarcar %1 pedidos como enviado?', comment = 'ESP="¿Desea Marcar/Desmarcar %1 pedidos como enviado?"';
                begin
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    if confirm(lblConfirm, false, PurchaseHeader.Count) then
                        if PurchaseHeader.FindFirst() then
                            repeat
                                PurchaseHeader.Emailsent := not PurchaseHeader.Emailsent;
                                PurchaseHeader.Modify();
                                CurrPage.Update();
                            until PurchaseHeader.Next() = 0;
                end;
            }
        }
        addlast(Navigation)
        {
            action(RegisterSendEmail)
            {
                ApplicationArea = all;
                Caption = 'Register Send', comment = 'ESP="Registro Envío"';
                Image = SendElectronicDocument;
                RunObject = page "ZM Order mail Registers";
                RunPageLink = "Order No." = field("No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(Funciones);
        KgVendorPackagingproduct := Funciones.PurchaseOrderCalcPlasticVendor(Rec);
    end;

    var
        KgVendorPackagingproduct: Decimal;
        Funciones: Codeunit Funciones;

    local procedure ShowVendorPackage()
    begin
        Clear(Funciones);
        Funciones.PurchaseOrderShowPlasticVendor(Rec);
    end;

    local procedure ExportMergePDF()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        PurchaseHeader.SetRange("No.", Rec."No.");
        PurchaseHeader.FindFirst();
        Funciones.ExportarPDFPurchaseOrder(PurchaseHeader);
    end;
}