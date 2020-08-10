pageextension 50177 "TransferLines" extends "Transfer Lines"
{
    layout
    {
        addafter("Unit of Measure")
        {
            field("Transfer-from Code"; "Transfer-from Code")
            {
                ApplicationArea = All;
            }
            field("Transfer-TO Code"; "Transfer-TO Code")
            {
                ApplicationArea = All;
            }
        }
    }

}


