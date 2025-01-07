pageextension 50087 "ZM EXT Customer Price Groups" extends "Customer Price Groups"
{
    layout
    {
        addlast(Control1)
        {
            field("Block without Sales Items"; "Block without Sales Items")
            {
                ApplicationArea = all;
            }
            field("Aplicar Precio Total Servicio"; "Aplicar Precio Total Servicio")
            {
                ApplicationArea = all;
            }
        }
    }
}
