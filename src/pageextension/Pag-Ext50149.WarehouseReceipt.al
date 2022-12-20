pageextension 50149 "WarehouseReceipt" extends "Warehouse Receipt"
{
    //Nuevos campos recepción almacén
    layout
    {
        addbefore("Vendor Shipment No.")
        {
            field(CodProvedor; globalCodProvedor)
            {
                Editable = false;
                ApplicationArea = ALL;
                Caption = 'Vendor No.', comment = 'ESP="Cód. Proveedor"';
            }

            field(NombreProveedor; globalNombreProveedor)
            {
                Editable = false;
                ApplicationArea = ALL;
                Caption = 'Vendor Name', comment = 'ESP="Nombre Proveedor"';
            }
        }
        addlast(Content)
        {
            group(Plastic)
            {
                Caption = 'Normativa Plástico', comment = 'ESP="Normativa Plástico"';

                field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Plastic Date Declaration"; "Plastic Date Declaration")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recWhseRcptLine: record "Warehouse Receipt Line";
        recPurchHeader: Record "Purchase Header";
    begin
        globalCodProvedor := '';
        globalNombreProveedor := '';

        recWhseRcptLine.Reset();
        recWhseRcptLine.SetRange("No.", "No.");
        if recWhseRcptLine.FindFirst() then begin
            recPurchHeader.Reset();
            recPurchHeader.SetRange("Document Type", recWhseRcptLine."Source Subtype");
            recPurchHeader.SetRange("No.", recWhseRcptLine."Source No.");
            if recPurchHeader.FindFirst() then begin
                globalCodProvedor := recPurchHeader."Buy-from Vendor No.";
                globalNombreProveedor := recPurchHeader."Buy-from Vendor Name";
            end;
        end;
    end;

    var
        globalCodProvedor: Code[20];
        globalNombreProveedor: Text[100];
}