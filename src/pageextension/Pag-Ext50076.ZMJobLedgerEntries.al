pageextension 50076 "ZM Job Ledger Entries" extends "Job Ledger Entries"
{
    actions
    {
        addlast(Creation)
        {
            action(EditarDescripcion)
            {
                ApplicationArea = all;
                Caption = 'Editar Descripción', comment = 'ESP="Editar Descripción"';
                Image = Description;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = New;

                trigger OnAction()
                begin
                    ChangeDescription;
                end;

            }
        }
    }

    local procedure ChangeDescription()
    var
        JobLedgerEntries: Page "ZM Job Ledger Entries Modify";
    begin
        JobLedgerEntries.SetTableView(Rec);
        JobLedgerEntries.RunModal();
    end;
}
