pageextension 50222 "ZM Comment Sheet" extends "Comment Sheet"
{
    layout
    {
        addlast(Control1)
        {
            field(AvisoVentas; AvisoVentas)
            {
                ApplicationArea = all;
                Visible = SalesVisible;
                Editable = SalesVisible;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    var
        Filter: text;
    begin
        SalesVisible := false;
        Filter := Rec.GetFilter("Table Name");
        if Filter = format(Rec."Table Name"::Item) then
            SalesVisible := true;
    end;

    var
        SalesVisible: Boolean;
}