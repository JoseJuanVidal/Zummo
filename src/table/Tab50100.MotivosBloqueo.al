table 50100 "MotivosBloqueo"
{
    DataClassification = ToBeClassified;
    Caption = 'Blocking Motives', comment = 'ESP="Motivos Bloqueo"';
    DrillDownPageId = MotivosBloqueo;
    LookupPageId = MotivosBloqueo;
    DataCaptionFields = CodBloqueo_btc, Descripcion_btc;

    fields
    {
        field(1; CodBloqueo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Block Code', comment = 'ESP="Cód. Bloqueo"';
        }

        field(2; Descripcion_btc; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
    }

    keys
    {
        key(PK; CodBloqueo_btc)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; CodBloqueo_btc, Descripcion_btc)
        {

        }
    }

    trigger OnDelete()
    var
        recVendor: Record Vendor;
        recCustomer: Record Customer;
        lbErrorProveedor: Label 'You cannot delete this blocking reason because it is associated with the vendor: %1',
            comment = 'ESP="No puede borrar este motivo de bloqueo porque está asociado al proveedor: %1"';
        lbErrorCliente: Label 'You cannot delete this blocking reason because it is associated with the customer: %1',
            comment = 'ESP="No puede borrar este motivo de bloqueo porque está asociado al cliente: %1"';
    begin
        recVendor.Reset();
        recVendor.SetRange(CodMotivoBloqueo_btc, CodBloqueo_btc);
        if recVendor.FindFirst() then
            Error(StrSubstNo(lbErrorProveedor, recVendor."No."));

        recCustomer.Reset();
        recCustomer.SetRange(CodMotivoBloqueo_btc, CodBloqueo_btc);
        if recCustomer.FindFirst() then
            Error(StrSubstNo(lbErrorCliente, recCustomer."No."));
    end;
}