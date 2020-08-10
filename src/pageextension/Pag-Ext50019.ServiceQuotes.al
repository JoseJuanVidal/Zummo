pageextension 50019 "ServiceQuotes" extends "Service Quotes"
{

    layout
    {
        addafter(Status)
        {
            field(CodAnterior_btc; CodAnterior_btc)
            {
                ApplicationArea = All;
            }

        }
    }

}