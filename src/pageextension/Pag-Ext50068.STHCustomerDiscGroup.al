pageextension 50068 "STH Customer Disc. Group" extends "Customer Disc. Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Oferta CRM aplicar Dto"; "Oferta CRM aplicar Dto")
            {
                ApplicationArea = all;
            }
        }
    }
}
