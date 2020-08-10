tableextension 50138 "UserSetup" extends "User Setup"  // 91
{
    // Validar productos

    fields
    {
        field(50100; PermiteValidarProcutos_bc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allows to validate items', comment = 'ESP="Permite validar productos"';
        }
    }
}