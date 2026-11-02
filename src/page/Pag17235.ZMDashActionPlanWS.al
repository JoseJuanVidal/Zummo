page 17235 "ZM Dash Action Plan WS"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Dash Action Plan";
    Caption = 'Dashboard Action Plan', comment = 'ESP="Dashboard plan de acción"';
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
                field("Action No."; Rec."Action No.") { }
                field(Description; Rec.Description) { }
                field(Action; Rec.Action) { }
                field(Responsible; Rec.Responsible) { }
                field("Due Date"; Rec."Due Date") { }
                field("Close Date"; Rec."Close Date") { }
                field(Status; Rec.Status) { }
                field("Created By"; Rec."Created By") { }
                field("Created At"; Rec."Created At") { }
                field("Modified By"; Rec."Modified By") { }
                field("Modified At"; Rec."Modified At") { }
            }
        }
    }
}
