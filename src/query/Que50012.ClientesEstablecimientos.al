query 50012 "Clientes - Establecimientos"
{
    elements
    {
        dataitem(Ship_to_Address; "Ship-to Address")
        {
            DataItemTableFilter = "Codigo Anterior" = filter(<> '');
            column(Codigo; Code) { }
            column(NombreEstablecimiento; Name) { }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = Ship_to_Address."Customer No.";
                column(CodigoCliente; "No.") { }
                column(RazonSocial; Name) { }
                column(CIF; "VAT Registration No.") { }
                column(Formapago; "Payment Method Code") { }
                column(TerminoPago; "Payment Terms Code") { }

                filter(No_; "No.") { }
            }
            filter(Code; Code)
            {
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}