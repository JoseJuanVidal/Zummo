page 17413 "ZM PL Setup Item registration"
{
    Caption = 'Setup Item registration', comment = 'ESP="Conf. Alta productos"';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ZM PL Setup Item registration";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Active email queue"; "Active email queue")
                {
                    ApplicationArea = All;
                }
                field("Frequency of reminders"; "Frequency of reminders")
                {
                    ApplicationArea = all;
                }
                field("Last process date"; "Last process date")
                {
                    ApplicationArea = all;
                }
            }
            group(SerieNos)
            {
                Caption = 'Number Series', comment = 'ESP="Serie numérica"';

                field("Temporary Nos."; "Temporary Nos.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Process)
            {
                ApplicationArea = all;
                Caption = 'Send Email', comment = 'ESP="Enviar email"';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm(lblConfirmSendEmail) then
                        Rec.ProcessSendNoticeEmailPendingdata();
                end;

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;

    end;

    var
        lblConfirmSendEmail: Label 'Do you want to execute the emailing process?', comment = 'ESP="¿Desea ejecutar el proceso de envío por email?"';
}