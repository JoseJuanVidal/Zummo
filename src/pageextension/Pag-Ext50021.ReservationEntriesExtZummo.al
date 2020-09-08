pageextension 50021 "Reservation Entries Ext Zummo" extends "Reservation Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            action(QuitReservation)
            {
                Caption = 'Quit Reservation', Comment = 'ESP="Deshacer Reserva"';
                Image = DeleteQtyToHandle;

                trigger OnAction()
                var
                    ReservEntry: Record "Reservation Entry";
                    ReservEntry2: Record "Reservation Entry";
                    ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
                    MsgConfirm: Label 'Cancel reservation of %1 of item number %2, reserved for %3 from %4?', Comment = 'ESP="¿Eliminar la reserva de %1 del producto %2, reservado para %3 de %4?"';
                begin
                    CurrPage.SETSELECTIONFILTER(ReservEntry);
                    IF ReservEntry.FIND('-') THEN
                        REPEAT
                            IF CONFIRM(MsgConfirm, FALSE, ReservEntry."Quantity (Base)", ReservEntry."Item No.", ReservEngineMgt.CreateForText(Rec),
                                ReservEngineMgt.CreateFromText(Rec)) then begin
                                ReservEntry2.SetRange("Entry No.", ReservEntry."Entry No.");
                                ReservEntry2.DeleteAll();
                            end;
                        until ReservEntry.Next() = 0;
                end;
            }
        }
    }

    var
        myInt: Integer;
}