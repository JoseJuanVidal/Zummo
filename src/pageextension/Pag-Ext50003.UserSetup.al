pageextension 50003 "UserSetup" extends "User Setup"
{
    // 161219 S19/01406 Validar productos
    layout
    {
        addafter(Email)
        {
            field(PermiteValidarProcutos_bc; PermiteValidarProcutos_bc)
            {
                ApplicationArea = all;
            }
        }
    }
}