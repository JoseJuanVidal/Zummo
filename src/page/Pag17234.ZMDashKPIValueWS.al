page 17234 "ZM Dash KPI Value WS"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Dash KPI Value";
    Caption = 'Dashboard KPI Value', comment = 'ESP="Dashboard valor KPI"';
    DelayedInsert = true;
    ODataKeyFields = "GAP Code", Date, "KPI Code";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("GAP Code"; Rec."GAP Code") { }
                field(Date; Rec.Date) { }
                field("KPI Code"; Rec."KPI Code") { }
                field(Value; Rec.Value) { }
                field("Has Value"; Rec."Has Value") { }
                field("Created By"; Rec."Created By") { }
                field("Created At"; Rec."Created At") { }
                field("Modified By"; Rec."Modified By") { }
                field("Modified At"; Rec."Modified At") { }
            }
        }
    }
}
