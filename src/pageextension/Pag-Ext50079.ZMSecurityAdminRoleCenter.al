pageextension 50079 "ZM Security Admin Role Center" extends "Security Admin Role Center"
{
    actions
    {
        addlast(Processing)
        {
            group(Usuarios)
            {
                action(Bloqueos)
                {
                    Caption = 'Bloqueos Basedatos', comment = 'ESP="Bloqueos Basedatos"';
                    ApplicationArea = all;
                    image = TestDatabase;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    RunObject = page 9511;
                }
                action(Sessions)
                {
                    Caption = 'Sesiones', comment = 'ESP="Sesiones"';
                    ApplicationArea = all;
                    image = Users;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    RunObject = page 9506;
                }
            }
        }
    }
}
