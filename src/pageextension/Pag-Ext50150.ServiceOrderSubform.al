pageextension 50150 "ServiceOrderSubform" extends "Service Order Subform"
{
    layout
    {
        addafter("Serial No.")
        {
            field(CodAnterior_btc; CodAnterior_btc)
            {
                ApplicationArea = All;
            }
        }
        addafter("Symptom Code")
        {
            field(CodProdFallo_btc; CodProdFallo_btc)
            {
                ApplicationArea = All;
            }

            field(NumCiclos_btc; NumCiclos_btc)
            {
                ApplicationArea = All;
            }
        }

    }
}