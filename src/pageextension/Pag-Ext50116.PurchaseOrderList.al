pageextension 50116 "PurchaseOrderList" extends "Purchase Order List"
{
    layout
    {
        addafter(Status)
        {
            field(Pendiente_btc; Pendiente_btc)
            {
                ApplicationArea = All;
            }
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

                trigger OnAction()
                begin
                    ExportMergePDF();
                end;
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