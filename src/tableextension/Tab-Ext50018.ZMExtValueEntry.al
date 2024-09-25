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
        field(50010; "Updated Cost Entry"; Boolean)
        {
            Caption = 'Updated Cost Entry', comment = 'ESP="Actualizado Mov. Coste"';
        }
        field(50100; "Posting Date Old"; Date)
        {
            Caption = 'Posting Date Old', comment = 'ESP="Fecha Registro Anterior"';
        }
        field(50101; ChangePostingDate; Boolean)
        {
            Caption = 'Cambiada Fecha Registro', comment = 'ESP="Cambiada Fecha Registro"';
        }
    }
}
