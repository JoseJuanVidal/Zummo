tableextension 50023 "ZM EXT Bank Account" extends "Bank Account"
{
    fields
    {
        field(17200; "Contrac Confirming Caixabanc"; Code[14])
        {
            Caption = 'Nº contrato Confirming Caixabanc';
            DataClassification = CustomerContent;
        }
    }
}
