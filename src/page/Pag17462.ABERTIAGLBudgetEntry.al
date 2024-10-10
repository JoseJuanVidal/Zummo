page 17462 "ABERTIA GL Budget Entry"
{
    // ApplicationArea = All;
    Caption = 'ABERTIA GL Budget Entry';
    PageType = List;
    SourceTable = "ABERTIA GL Budget";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Nombre; Nombre)
                {
                    ApplicationArea = all;
                }
                field(Cuenta; Cuenta)
                {
                    ApplicationArea = All;
                }
                field("Año"; "Año")
                {
                    ApplicationArea = All;
                }
                field(fecha; fecha)
                {
                    ApplicationArea = All;
                }
                field("Dimension 1 Code"; "Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("00 - Origen"; "00 - Origen")
                {
                    ApplicationArea = all;
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Actualizar)
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Rec.CreateGLBudget();
                end;

            }
        }
    }
    trigger OnInit()
    begin
        OpenTableConnection();
    end;

    var
        GenLedgerSetup: Record "General Ledger Setup";

    procedure OpenTableConnection()
    begin
        GenLedgerSetup.Get();
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI', GenLedgerSetup.AbertiaTABLECONNECTION());
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;


}
