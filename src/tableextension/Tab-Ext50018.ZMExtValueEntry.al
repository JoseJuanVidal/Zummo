tableextension 50018 "ZM Ext Value Entry" extends "Value Entry"
{
    fields
    {
        field(50000; "Prod. Order State"; Option)
        {
            Caption = 'Prod. Order State', comment = 'ESP="Estado Ord. Prod."';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished',
                  Comment = 'Simulada,Planificada,Planif. en firme,Lanzada,Terminada';
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order".Status where("No." = field("Document No.")));
        }
    }
}
