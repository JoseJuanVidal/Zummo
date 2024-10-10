page 17461 "ABERTIA GL Account"
{
    //    ApplicationArea = All;
    Caption = 'ABERTIA GL Account';
    PageType = List;
    SourceTable = "ABERTIA GL Account";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("C7 - Cuenta1"; "C7 - Cuenta1")
                {
                    ApplicationArea = All;
                }
                field("C7 - Cuenta2"; "C7 - Cuenta2")
                {
                    ApplicationArea = All;
                }
                field("C7 - Cuenta3"; "C7 - Cuenta3")
                {
                    ApplicationArea = All;
                }
                field("C7 - Cuenta4"; "C7 - Cuenta4")
                {
                    ApplicationArea = All;
                }
                field("C8 - Cuenta Cod7"; "C8 - Cuenta Cod7")
                {
                    ApplicationArea = All;
                }
                field(DescCuenta1; DescCuenta1)
                {
                    ApplicationArea = All;
                }
                field(DescCuenta2; DescCuenta2)
                {
                    ApplicationArea = All;
                }
                field(DescCuenta3; DescCuenta3)
                {
                    ApplicationArea = All;
                }
                field(DescCuenta4; DescCuenta4)
                {
                    ApplicationArea = All;
                }
                field(DescCuenta7; DescCuenta7)
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
                    Rec.CreateGLAccount();
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
        GenLedgerSetup.Get;
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI', GenLedgerSetup.AbertiaTABLECONNECTION());

        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;


}
