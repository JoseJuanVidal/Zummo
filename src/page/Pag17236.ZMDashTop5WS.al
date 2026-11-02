page 17236 "ZM Dash Top5 WS"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Dash Top5";
    Caption = 'Dashboard TOP 5 Minutes', comment = 'ESP="Dashboard acta TOP 5"';
    DelayedInsert = true;
    ODataKeyFields = "GAP Code", Id;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("GAP Code"; Rec."GAP Code") { }
                field(Id; Rec.Id) { }
                field(Date; Rec.Date) { }
                field("Improvement Point"; Rec."Improvement Point") { }
                field(PDA; Rec.PDA) { }
                field("Supervisor Approval"; Rec."Supervisor Approval") { }
                field("Created By"; Rec."Created By") { }
                field("Created At"; Rec."Created At") { }
                field("Modified By"; Rec."Modified By") { }
                field("Modified At"; Rec."Modified At") { }
            }
        }
    }
}
