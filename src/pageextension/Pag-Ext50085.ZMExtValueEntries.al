pageextension 50085 "ZM Ext Value Entries" extends "Value Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Prod. Order State"; "Prod. Order State")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {

            action(CostesGL)
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    ValueEntryCoste: record "ZM Value entry - G/L Entry";
                begin
                    ValueEntryCoste.UpdateEntries(Rec."Entry No.", '');
                    page.Run(page::"ZM Value entry - G/L Entries");
                end;
            }
        }
    }
}
