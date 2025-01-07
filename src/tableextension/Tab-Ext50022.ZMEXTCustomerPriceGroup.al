tableextension 50022 "ZM EXT Customer Price Group" extends "Customer Price Group"
{
    fields
    {
        field(50000; "Block without Sales Items"; Boolean)
        {
            Caption = 'Block sales of products without tariffs', comment = 'ESP="Bloqueo ventas producto sin tarifa"';
            DataClassification = ToBeClassified;
        }
        field(50010; "Aplicar Precio Total Servicio"; Boolean)
        {
            Caption = 'Aplicar Precio Total Servicio', comment = 'ESP="Aplicar Precio Total Servicio"';
            DataClassification = ToBeClassified;
        }
    }
}
