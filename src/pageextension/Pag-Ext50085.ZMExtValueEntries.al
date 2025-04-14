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
                    ValueEntry: Record "Value Entry";
                    // ValueEntryCoste: record "ZM Cost Value entry Sales";
                    Functions: Codeunit "Zummo Inn. IC Functions";
                begin
                    // ValueEntryCoste.
                    CurrPage.SetSelectionFilter(ValueEntry);
                    if Confirm('actualizar %1', true, ValueEntry.GetFilter("Entry No.")) then
                        Functions.UpdateEntries('', ValueEntry.GetFilter("Entry No."));
                    // page.Run(page::"ZM Value entry - G/L Entries");
                end;
            }
        }
    }
}
