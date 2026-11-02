page 17237 "ZM Dash Routine Check WS"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Dash Routine Check";
    Caption = 'Dashboard Routine Check', comment = 'ESP="Dashboard check rutina"';
    DelayedInsert = true;
    ODataKeyFields = "GAP Code", Date, "Check Key";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("GAP Code"; Rec."GAP Code") { }
                field(Date; Rec.Date) { }
                field("Check Key"; Rec."Check Key") { }
                field(Status; Rec.Status) { }
                field(Notes; Rec.Notes) { }
                field("Created By"; Rec."Created By") { }
                field("Created At"; Rec."Created At") { }
                field("Modified By"; Rec."Modified By") { }
                field("Modified At"; Rec."Modified At") { }
            }
        }
    }
}
