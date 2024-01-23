page 50010 "Tarifas Precios"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Price";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(ItemDesc; Item.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Nombre producto', comment = 'ESP="Nombre producto"';
                }
                field("Sales Type"; "Sales Type")
                {
                    ApplicationArea = all;
                }
                field("Sales Code"; "Sales Code")
                {
                    ApplicationArea = all;
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Price Includes VAT"; "Price Includes VAT")
                {
                    ApplicationArea = all;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    ApplicationArea = all;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }

                field(ItemBlocked; Item.Blocked)
                {
                    ApplicationArea = all;
                    Caption = 'Bloqueado', comment = 'ESP="Bloqueado"';
                    Editable = false;
                }
                field(ItemBlockedSales; Item."Sales Blocked")
                {
                    ApplicationArea = all;
                    Caption = 'Bloqueado Ventas', comment = 'ESP="Bloqueado Ventas"';
                    Editable = false;
                }
                field(selClasVtas_btc; selClasVtas_btc)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(selFamilia_btc; selFamilia_btc)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(selGama_btc; selGama_btc)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(selLineaEconomica_btc; selLineaEconomica_btc)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(ItemClasVtas; desClasVtas_btc)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ItemFamilia; desFamilia_btc)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ItemGamma; desGama_btc)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ItemLineaEco; desLineaEconomica_btc)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ItemCategory; Item."Item Category Code")
                {
                    ApplicationArea = all;
                    Caption = 'Categoria producto', comment = 'ESP="Categoria producto"';
                    Editable = false;
                }
                field(ItemCostingMethod; Item."Costing Method")
                {
                    ApplicationArea = all;
                    Caption = 'Valoración Existencias', comment = 'ESP="Valoración Existencias"';
                    Editable = false;
                }
                field(ItemUnitCost; Item."Unit Cost")
                {
                    ApplicationArea = all;
                    Caption = 'Coste Unitario', comment = 'ESP="Coste Unitario"';
                    Editable = false;
                }
                field(ItemStandardCost; Item."Standard Cost")
                {
                    ApplicationArea = all;
                    Caption = 'Coste Estandar', comment = 'ESP="Coste Estandar"';
                    Editable = false;
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
                action(UpdateCRM)
                {
                    Caption = 'Sync. Price Group', comment = 'ESP="Sincronizar Grupo de precio"';
                    ApplicationArea = All;
                    Visible = true;
                    Image = RefreshText;
                    Enabled = CDSIsCoupledToRecord;
                    ToolTip = 'Update owner of ALL CRM customers by assigning them to their Area Manager.', comment = 'ESP="Actualiza propietario de TODOS los clientes CRM asignandolos a su Area Manager"';
                    trigger OnAction()
                    var
                    begin
                        Update_CRM();
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

    trigger OnAfterGetRecord()
    begin
        if Item.Get("Item No.") then;
    end;

    var
        Item: Record Item;
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        CDSIntegrationEnabled: Boolean;
        CDSIsCoupledToRecord: Boolean;

    local procedure Update_CRM()
    var
        Integracion_crm: Codeunit "Integracion_crm_btc";
        lblConfirm: Label '¿Desea actualizar toda la lista de precios %1 y fecha final %2?', comment = 'ESP="¿Desea actualizar toda la lista de precios %1 y fecha final %2"';
    begin
        IF Confirm(lblConfirm, false, Rec."Sales Code") then
            Integracion_crm.UpdateSalesPriceGroup(Rec."Sales Code", Rec."Ending Date");
    end;




}