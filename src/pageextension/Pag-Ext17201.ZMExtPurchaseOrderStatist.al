pageextension 17201 "ZM Ext Purchase Order Statist" extends "Purchase Order Statistics"
{
    layout
    {
        addlast(General)
        {
            field(KgVendorPackagingproduct; KgVendorPackagingproduct)
            {
                ApplicationArea = all;
                Caption = 'Vendor Plastic packing (kg)', comment = 'ESP="Plástico embalaje proveedor (kg)"';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowVendorPackage();
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


}
