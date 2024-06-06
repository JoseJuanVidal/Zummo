pageextension 50213 "ZM Service Contract" extends "Service Contract"
{
    layout
    {
        addfirst(factboxes)
        {
            part("Attachment Document"; "ZM Document Attachment Factbox")
            {
                ApplicationArea = all;
                Caption = 'Attachment Document', comment = 'ESP="Documentos adjuntos"';
                SubPageLink = "Table ID" = const(5965), "No." = field("Contract No.");

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetCurrRecord()
    var
        RefRecord: recordRef;
    begin
        if RefRecord.Get(Rec.RecordId) then;
        CurrPage."Attachment Document".Page.SetTableNo(5965, Rec."Contract No.", 0, RefRecord)
    end;
}