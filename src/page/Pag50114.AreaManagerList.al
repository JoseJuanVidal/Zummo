page 50114 "Area Manager List"
{

    PageType = List;
    SourceTable = TextosAuxiliares;
    Caption = 'Area Managers', Comment = 'ESP="Area Managers"';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = where(TipoTabla = const(AreaManager));
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
                field("CRM ID"; "CRM ID")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Sales Manager"; "Sales Manager")
                {
                    ApplicationArea = all;
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
                action(CRMOwnerID)
                {
                    Caption = 'Sync. Owner CRM', comment = 'ESP="Sincronizar Propietario CRM"';
                    ApplicationArea = All;
                    Visible = true;
                    Image = RefreshText;
                    Enabled = CDSIsCoupledToRecord;
                    ToolTip = 'Update owner of ALL CRM customers by assigning them to their Area Manager.', comment = 'ESP="Actualiza propietario de TODOS los clientes CRM asignandolos a su Area Manager"';
                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit Integracion_crm_btc;
                    begin
                        CRMIntegrationManagement.UpdateOwneridAreaManager;
                    end;
                }
                action(AreaManagerCustomerUpdate)
                {
                    Caption = 'Update Account CRM', comment = 'ESP="Actualiza Propietario Cuentas CRM"';
                    ApplicationArea = All;
                    Visible = true;
                    Image = RefreshText;
                    Enabled = CDSIsCoupledToRecord;
                    ToolTip = 'Update owner of CRM clients assigned to Integration to their Area Manager.', comment = 'ESP="Actualiza propietario de los clientes del Area Manager"';
                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit Integracion_crm_btc;
                    begin
                        CRMIntegrationManagement.UpdateAccountAreaManager(Rec);
                    end;
                }
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

        area(Reporting)
        {
            action(FacturasVencidasExcelTODAS)
            {
                ApplicationArea = All;
                // Promoted = true;
                // PromotedIsBig = true;
                // PromotedCategory = New;
                Image = Email;
                Caption = 'Send email Overdue Invoices', comment = 'ESP="Facturas Vencidas por Correo electronico"';
                ToolTip = 'Export and send an Excel by mail to each Area Manager with the Overdue Invoices of their clients', comment = 'ESP="Exporta y envia un Excel por correo a cada Area Manager con las Facturas Vencidas de sus clientes"';

                trigger OnAction()
                var
                    CUCron: Codeunit CU_Cron;
                    TextosAux: Record TextosAuxiliares;
                    lblConfirm: Label '¿Desea enviar email a los Area Manager seleccionados %1 ?', comment = 'ESP="¿Desea enviar email a los Area Manager seleccionados %1 ?"';
                begin
                    CurrPage.SetSelectionFilter(TextosAux);
                    if Confirm(lblConfirm, false, TextosAux.Count) then
                        CUCron.AvisosFacturasVencidasTodosAreaManager(TextosAux);
                end;
            }
            action(FacturasVencidasExcelUNICA)
            {
                ApplicationArea = All;
                // Promoted = true;
                // PromotedIsBig = true;
                // PromotedCategory = New;
                Image = Excel;
                Caption = 'Export Area Manager Overdue Invoices', comment = 'ESP="Exportar Facturas Vencidas Area Manager"';
                ToolTip = 'Export and send an Excel by mail to the current Area Manager with the Overdue Invoices of his clients', comment = 'ESP="Exporta y envia un Excel por correo al Area Manager seleccionado con las Facturas Vencidas de sus clientes"';

                trigger OnAction()
                var
                    CUCron: Codeunit CU_Cron;
                begin
                    CUCron.AvisosFacturasVencidasAreaManager(Rec.NumReg);
                end;
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
