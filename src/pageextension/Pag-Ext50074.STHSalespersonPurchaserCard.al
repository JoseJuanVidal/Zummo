pageextension 50074 "STH Salesperson/Purchaser Card" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addafter("Commission %")
        {
            field("Send email due invocies"; "Send email due invocies")
            {
                ApplicationArea = all;
            }
            field(AreaManager_btc; AreaManager_btc)
            {
                ApplicationArea = all;
            }
        }
    }
}
