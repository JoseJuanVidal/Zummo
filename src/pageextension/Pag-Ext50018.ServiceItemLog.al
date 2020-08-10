pageextension 50018 "ServiceItemLog" extends "Service Item Log"
{
    // Clasificación pedido servicio
    Editable = true;

    layout
    {
        modify("Service Item No.")
        {
            Editable = false;
        }

        modify("Entry No.")
        {
            Editable = false;
        }

        modify(After)
        {
            Editable = false;
        }

        modify(Before)
        {
            Editable = false;
        }

        modify("Document Type")
        {
            Editable = false;
        }

        modify("Document No.")
        {
            Editable = false;
        }

        modify("User ID")
        {
            Editable = false;
        }

        modify("Change Date")
        {
            Editable = true;
        }

        modify("Change Time")
        {
            Editable = true;
        }
    }
}