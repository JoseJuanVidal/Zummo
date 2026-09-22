page 17483 "ZM PL Items Temporary API"
{
    PageType = List;
    //    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "ZM PL Items Temporary";
    SourceTableView = where("State Creation" = filter('' | Requested));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; "No.") { }
                field("State Creation"; "State Creation") { }
                field(Type; Type) { }
                field("Item No."; "Item No.") { }
                field(Description; Description) { }
                field("Base Unit of Measure"; "Base Unit of Measure") { }
                field("Clasification Type"; "Clasification Type") { }
                field("User ID"; "User ID") { }
                field("Codigo Empleado"; "Codigo Empleado") { }
                field(Department; Department) { }
                field("Product manager"; "Product manager") { }
                field(Activity; Activity) { }
                field("Posting Date"; "Posting Date") { }
                field(Prototype; Prototype) { }
                field("Tipo de Cambio"; "Tipo de Cambio") { }
                field("Replaces Item No."; "Replaces Item No.") { }
                field("Replenishment System"; "Replenishment System") { }
                field(Reason; ReasonText) { }
                field(Blocked; Blocked) { }
                field("Reason Blocked"; "Reason Blocked") { }
                field("Purch. Family"; "Purch. Family") { }
                field("Purch. Category"; "Purch. Category") { }
                field("Purch. SubCategory"; "Purch. SubCategory") { }
                field(Alto; Alto) { }
                field(Ancho; Ancho) { }
                field(Largo; Largo) { }
                field("Net Weight"; "Net Weight") { }
                field("Gross Weight"; "Gross Weight") { }
                field(Material; Material) { }
                field(Packaging; Packaging) { }
                field(Lanzado; Lanzado) { }
            }
        }
    }
    var
        ReasonText: text;
        Lanzado: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;
}