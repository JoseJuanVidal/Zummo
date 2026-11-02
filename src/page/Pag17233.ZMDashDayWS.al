page 17233 "ZM Dash Day WS"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Dash Day";
    Caption = 'Dashboard Day', comment = 'ESP="Dashboard día"';
    DelayedInsert = true;
    ODataKeyFields = "GAP Code", Date;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("GAP Code"; Rec."GAP Code") { }
                field(Date; Rec.Date) { }
                field("Working Day"; Rec."Working Day") { }
                field(Remarks; Rec.Remarks) { }
                field("Created By"; Rec."Created By") { }
                field("Created At"; Rec."Created At") { }
                field("Modified By"; Rec."Modified By") { }
                field("Modified At"; Rec."Modified At") { }
            }
        }
    }
}
