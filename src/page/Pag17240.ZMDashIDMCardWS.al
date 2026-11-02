page 17240 "ZM Dash IDM Card WS"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Dash IDM Card";
    Caption = 'Dashboard IDM Card', comment = 'ESP="Dashboard tarjeta IDM"';
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
                field("Column Id"; Rec."Column Id") { }
                field("Sort Order"; Rec."Sort Order") { }
                field("Card Created At"; Rec."Card Created At") { }
                field("Created By"; Rec."Created By") { }
                field("Created At"; Rec."Created At") { }
                field("Modified By"; Rec."Modified By") { }
                field("Modified At"; Rec."Modified At") { }
            }
        }
    }
}
