page 17239 "ZM Dash IDM Column WS"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Dash IDM Column";
    Caption = 'Dashboard IDM Column', comment = 'ESP="Dashboard columna IDM"';
    DelayedInsert = true;
    ODataKeyFields = Id;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Id; Rec.Id) { }
                field(Title; Rec.Title) { }
                field("Sort Order"; Rec."Sort Order") { }
                field("Created By"; Rec."Created By") { }
                field("Created At"; Rec."Created At") { }
                field("Modified By"; Rec."Modified By") { }
                field("Modified At"; Rec."Modified At") { }
            }
        }
    }
}
