tableextension 50019 "ZM Ext Warehouse Setup" extends "Warehouse Setup"
{
    fields
    {
        field(50000; "Recep. alm. cantidad a cero"; Boolean)
        {
            Caption = 'Recep. alm. cantidad a cero', comment = 'ESP="Recep. alm. cantidad a cero"';
            DataClassification = ToBeClassified;
        }
    }
}
