page 17205 "API Shipment linea Zummo IC"
{
    PageType = List;
    SourceTable = "Sales Shipment Line";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; "Document No.") { ApplicationArea = all; }
                field("Line No."; "Line No.") { ApplicationArea = all; }
                field(Type; Type) { ApplicationArea = all; }
                field("No."; "No.") { ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; }
                field(Quantity; Quantity) { ApplicationArea = all; }
            }
        }
    }
}