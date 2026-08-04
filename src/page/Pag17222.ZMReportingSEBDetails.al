page 17222 "ZM Reporting SEB Details"
{
    Caption = 'Reporting SEB Details', comment = 'ESP="Reporting SEB Details"';
    PageType = list;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "ZM Reporting SEB Detail";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; "Entry No.") { }
                field("Posting Date"; "Posting Date") { }
                field("Document No."; "Document No.") { }
                field("Item No."; "Item No.") { }
                field(Description; Description) { }
                field(Quantity; Quantity) { }
                field(Amount; Amount) { }
                field(Costs; Costs) { }
                field("Reporting SEB Entry No"; "Reporting SEB Entry No") { }
                field("Source No."; "Source No.") { }
                field("Source Name"; "Source Name") { }
                field("Vat Registration Name"; "Vat Registration Name") { }
                field("CMMF Code"; "CMMF Code") { }
                field(MLA; MLA) { }
            }
        }
    }

}