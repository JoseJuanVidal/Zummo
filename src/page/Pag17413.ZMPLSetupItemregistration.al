page 17413 "ZM PL Setup Item registration"
{
    Caption = 'General Setup Item registration', comment = 'ESP="Conf. General Alta productos"';
    PageType = Card;
    UsageCategory = None;
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
            group(Sharepoint)
            {
                field("OAuth Sharepoint"; "OAuth Sharepoint")
                {
                    ApplicationArea = all;
                }
                field("OAuth Sharepoint Folder"; "OAuth Sharepoint Folder")
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