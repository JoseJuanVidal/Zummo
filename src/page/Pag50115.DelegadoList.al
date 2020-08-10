page 50115 "Delegado List"
{

    PageType = List;
    SourceTable = TextosAuxiliares;
    Caption = 'Delegados', Comment = 'ESP="Delegados"';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = where(TipoTabla = const(Delegado));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(NumReg; NumReg)
                {
                    ApplicationArea = All;
                }
                field(Origen; Origen)
                {
                    ApplicationArea = All;
                }

                field(Descripcion; Descripcion)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(ActionGroupCDS)
            {
                Caption = 'CDS';
                Visible = CDSIntegrationEnabled;

                action(CDSSynchronizeNow)
                {
                    Caption = 'Synchronize', comment = 'ESP="Sincronizar"';
                    ApplicationArea = All;
                    Visible = true;
                    Image = Refresh;
                    Enabled = CDSIsCoupledToRecord;
                    ToolTip = 'Send or get updated data to or from Common Data Service.', comment = 'ESP="Enviar/Recibir a/de Common Data Service."';
                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.UpdateOneNow(RecordId);
                    end;
                }
                action(ShowLog)
                {
                    Caption = 'Synchronization Log', comment = 'ESP="Log de Sincronización"';
                    ApplicationArea = All;
                    Visible = true;
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs', comment = 'ESP="Ver tareas de sincronización programadas de esta tabla"';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowLog(RecordId);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Business Central record and a Common Data Service record.';

                    action(ManageCDSCoupling)
                    {
                        Caption = 'Set Up Coupling';
                        ApplicationArea = All;
                        Visible = true;
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Common Data Service Worker.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.DefineCoupling(RecordId);
                        end;
                    }
                    action(DeleteCDSCoupling)
                    {
                        Caption = 'Delete Coupling';
                        ApplicationArea = All;
                        Visible = true;
                        Image = UnLinkAccount;
                        Enabled = CDSIsCoupledToRecord;
                        ToolTip = 'Delete the coupling to a Common Data Service Worker.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(RecordId);
                        end;
                    }

                }
            }
        }
    }




    trigger OnOpenPage()
    begin
        CDSIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if CDSIntegrationEnabled then
            CDSIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
    end;

    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        CDSIntegrationEnabled: Boolean;
        CDSIsCoupledToRecord: Boolean;

}
