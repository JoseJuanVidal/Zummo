tableextension 50106 "ShippingAgent" extends "Shipping Agent"  // 291
{
    fields
    {
        field(50000; ProveedorAsociado_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Assoc. Vendor No.', Comment = 'ESP="Cód. Proveedor Asociado"';
            Description = 'Bitec';
            TableRelation = Vendor;
        }
    }
}