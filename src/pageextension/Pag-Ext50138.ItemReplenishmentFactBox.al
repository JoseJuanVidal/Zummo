pageextension 50138 "ItemReplenishmentFactBox" extends "Item Replenishment FactBox"
{
    layout
    {
        addafter("Replenishment System")
        {
            field("Lead Time Calculation"; "Lead Time Calculation")
            {
                ApplicationArea = All;
            }

            field("Minimum Order Quantity"; "Minimum Order Quantity")
            {
                ApplicationArea = All;
            }

            field("Order Multiple"; "Order Multiple")
            {
                ApplicationArea = All;
            }
        }
    }
}