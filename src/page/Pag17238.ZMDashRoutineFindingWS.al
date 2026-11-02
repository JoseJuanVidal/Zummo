page 17238 "ZM Dash Routine Finding WS"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Dash Routine Finding";
    Caption = 'Dashboard Routine Finding', comment = 'ESP="Dashboard hallazgo rutina"';
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
                field("Check Key"; Rec."Check Key") { }
                field(Description; Rec.Description) { }
                field(Action; Rec.Action) { }
                field(Status; Rec.Status) { }
                field("Opened Date"; Rec."Opened Date") { }
                field("Close Date"; Rec."Close Date") { }
                field("Created By"; Rec."Created By") { }
                field("Created At"; Rec."Created At") { }
                field("Modified By"; Rec."Modified By") { }
                field("Modified At"; Rec."Modified At") { }
            }
        }
    }
}
