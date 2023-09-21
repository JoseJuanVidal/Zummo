pageextension 50207 "ZM Ext Planning Component List" extends "Planning Component List"
{
    layout
    {
        addfirst(Control1)
        {
            field("Worksheet Template Name"; "Worksheet Template Name")
            {
                ApplicationArea = all;
            }
            field("Worksheet Batch Name"; "Worksheet Batch Name")
            {
                ApplicationArea = all;
            }
        }
    }
}