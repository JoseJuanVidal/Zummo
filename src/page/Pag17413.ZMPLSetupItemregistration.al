page 17413 "ZM PL Setup Item registration"
{
    Caption = 'General Setup Item registration', comment = 'ESP="Conf. Solicitud Alta productos"';
    PageType = Card;
    ApplicationArea = all;
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
                field("Enabled Approval Price List"; "Enabled Approval Price List")
                {
                    ApplicationArea = all;
                }
                field("Max. Digits Item No."; "Max. Digits Item No.")
                {
                    ApplicationArea = all;
                }
                field("Max. Digits Item Desc."; "Max. Digits Item Desc.")
                {
                    ApplicationArea = all;
                }
            }
            group(Sequence)
            {
                Caption = 'Sequence', comment = 'ESP="Secuencia"';

                field("First Department"; "First Department")
                {
                    ApplicationArea = all;
                }
                field("Last Department"; "Last Department")
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
                Caption = 'Sharepoint', comment = 'ESP="Sharepoint"';
                field("OAuth Request Archive"; "OAuth Request Archive")
                {
                    ApplicationArea = all;
                }
                field("OAuth Request Arch. Folder"; "OAuth Request Arch. Folder")
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
            action(ConfAprobAltaProd)
            {
                ApplicationArea = all;
                Caption = 'Conf. Departamentos Alta Productos', comment = 'ESP="Conf. Departamentos Alta Productos"';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "ZM PL Item Setup approvals";
            }
            action(configDepartment)
            {
                ApplicationArea = all;
                Caption = 'Conf. Departamentos', comment = 'ESP="Conf. Departamentos"';
                Image = Departments;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "ZM PL Item Setup Depart. List";
            }
        }
    }

    trigger OnOpenPage()
    begin
        ItemRegistrationApproval.CheckSUPERUserConfiguration(true);
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;

    end;

    var
        ItemRegistrationApproval: Codeunit "ZM PL Items Regist. aprovals";
        lblConfirmSendEmail: Label 'Do you want to execute the emailing process?', comment = 'ESP="¿Desea ejecutar el proceso de envío por email?"';
}