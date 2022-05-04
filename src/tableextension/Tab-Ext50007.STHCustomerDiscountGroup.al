tableextension 50007 "STH Customer Discount Group" extends "Customer Discount Group"
{
    fields
    {
        field(50000; "Oferta CRM aplicar Dto"; Boolean)
        {
            Caption = 'Oferta CRM con Dto';
            DataClassification = CustomerContent;
        }
    }
}
