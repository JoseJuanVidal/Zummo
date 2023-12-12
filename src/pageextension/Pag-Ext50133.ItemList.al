pageextension 50133 "ItemList" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field(Ordenacion_btc; Ordenacion_btc)
            {
                ApplicationArea = All;
                BlankZero = true;
            }
            field(STHQuantityWhse; STHQuantityWhse)
            {
                ApplicationArea = all;
                ToolTip = 'Qty. en Stockkeeping Unit', Comment = 'ESP="Cantidad en contenido de almacén"';
                Visible = false;
            }
            field("Safety Stock Quantity"; "Safety Stock Quantity")
            {
                ApplicationArea = all;
            }
            field(Material; Material)
            {
                ApplicationArea = all;
                Visible = false;
            }

            // Validar productos
            field(ValidadoContabiliad_btc; ValidadoContabiliad_btc)
            {
                ApplicationArea = All;
            }
            field(selClasVtas_btc; selClasVtas_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(desClasVtas_btc; desClasVtas_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(selFamilia_btc; selFamilia_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(desFamilia_btc; desFamilia_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(selGama_btc; selGama_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            Field(desGama_btc; desGama_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            Field(selLineaEconomica_btc; selLineaEconomica_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            Field(desLineaEconomica_btc; desLineaEconomica_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Canal; Canal)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Manufacturer; Manufacturer)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Item No. Manufacturer"; "Item No. Manufacturer")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
            {
                ApplicationArea = all;
            }
            field("Inventory to date"; "Inventory to date")
            {
                ApplicationArea = all;
            }
            field(STHCostEstandarOLD; STHCostEstandarOLD)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(CambiadoCoste; CambiadoCoste)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(RecalcularCosteEstandar; RecalcularCosteEstandar)
            {
                ApplicationArea = all;
                Visible = false;
            }

        }
    }
    actions
    {
        modify("Co&mments")
        {
            Promoted = true;
            PromotedCategory = Category4;
        }
        addafter(Dimensions)
        {
            action(importarComentarios)
            {
                ApplicationArea = all;
                Caption = 'Importar Comentarios', comment = 'ESP="Importar Comentarios"';
                ToolTip = 'Importar Comentarios', comment = 'ESP="Importar Comentarios"';
                // Promoted = true;
                // PromotedIsBig = true;
                // PromotedCategory = Process;
                Image = Excel;

                trigger OnAction()
                var
                    rimportarComentarios: Report "Cargar Comentarios Excel";
                begin
                    // Message('Importar Comentarios');
                    rimportarComentarios.Run();
                end;
            }
        }
        addafter("C&alculate Counting Period")
        {
            action(CalculatePlastic)
            {
                ApplicationArea = all;
                Caption = 'Calculate Plastic BOM', comment = 'ESP="Calcular peso plastico L.M."';
                Image = CalculateHierarchy;
                // Promoted = true;
                // PromotedCategory = New;

                trigger OnAction()
                begin
                    CalculatePlastic;
                end;

            }
        }
        addafter(ShowLog)
        {
            action(UpdateBloqueados)
            {
                ApplicationArea = all;
                Caption = 'Dyn 365 Sales Sync State', comment = 'ESP="Dyn 365 Sales Sync. Estado"';
                Image = RefreshText;

                trigger OnAction()
                var
                    IntegracionCRM: codeunit Integracion_crm_btc;
                    lblConfirm: Label '¿Do you want to upgrade the State Dyn 365 Sales Items State?', comment = 'ESP="¿Desea actualizar el estado de los productos de Dyn 365 Sales?"';
                begin
                    if Confirm(lblConfirm) then
                        IntegracionCRM.CRMUpdateItems();
                end;

            }
            action(UpdateBomComponents)
            {
                ApplicationArea = all;
                Caption = 'Dyn 365 Sales Bom Components', comment = 'ESP="Dyn 365 Sales Sync. Ensamblado"';
                Image = AssemblyOrder;

                trigger OnAction()
                var
                    IntegracionCRM: codeunit Integracion_crm_btc;
                    lblConfirm: Label '¿Do you want to upgrade the State Dyn 365 Sales All Items Assembly?', comment = 'ESP="¿Desea actualizar ensamblados de todos los productos de Dyn 365 Sales?"';
                begin
                    if Confirm(lblConfirm) then
                        IntegracionCRM.UpdateCRMSalesbyBCItemsRelations();
                end;

            }
            action(UpdateBomComponent)
            {
                ApplicationArea = all;
                Caption = 'Dyn 365 Sales Item Bom Component', comment = 'ESP="Dyn 365 Sales Sync. Ensamblado Prod."';
                Image = AssemblyBOM;

                trigger OnAction()
                var
                    IntegracionCRM: codeunit Integracion_crm_btc;
                    Ventana: Dialog;
                    lblConfirm: Label '¿Do you want to upgrade the State Dyn 365 Sales Item Assembly %1?', comment = 'ESP="¿Desea actualizar ensamblados del producto %1 a Dyn 365 Sales?"';
                begin
                    if Confirm(lblConfirm, false, Rec."No.") then begin
                        Ventana.Open('Producto #1###################\L.M.: #2###########################');
                        IntegracionCRM.UpdateCRMSalesbyBCItemRelations(Rec, Ventana);
                        Ventana.Close();
                    end;
                end;

            }
        }

        addafter(Action24)
        {
            action(ExportExcelCost)
            {
                ApplicationArea = all;
                Caption = 'Exportar Excel de costes', comment = 'ESP="Exportar Excel de costes"';
                Image = Excel;
                Visible = ShowExcelCostes;

                trigger OnAction()
                var
                    Funciones: Codeunit "STH Funciones IVA Recuperacion";
                begin
                    Funciones.CreateExcelBufferItemBom(Rec."No.");
                end;

            }
        }
        addafter(PurchPricesandDiscounts)
        {
            action("Exportar Tarifas")
            {
                ApplicationArea = All;
                Caption = 'Exportar Tarifas', comment = 'NLB="Exportar Tarifas"';
                Image = Excel;
                trigger OnAction()
                var
                    ExportExcelPrices: Codeunit "ZM Ext Excel Export";
                begin
                    ExportExcelPrices.ExportVendorPrice();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then
            ShowExcelCostes := UserSetup."Permite exportacion costes BOM";
    end;

    var
        UserSetup: Record "User Setup";
        WarehouseEntry: Record "Warehouse Entry";
        ValueEntry: Record "Value Entry";
        ShowExcelCostes: Boolean;

    local procedure CalculatePlastic()
    var
        Item: Record Item;
        Funciones: Codeunit Funciones;
        lblConfirm: Label '¿Desea calcular la cantidad del plastico de la L.M. de %1 producto/s?', comment = '¿Desea calcular la cantidad del plastico de la L.M. de %1 producto/s?';
    begin
        CurrPage.SetSelectionFilter(Item);
        if Confirm(lblConfirm, false, Item.Count) then
            Funciones.PlasticCalculateItems(Rec);
    end;
}