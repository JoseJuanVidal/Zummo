page 17415 "ZM PL Items temporary card"
{
    Caption = 'Items registration', Comment = 'ESP="Alta de productos"';
    PageType = card;
    SourceTable = "ZM PL Items temporary";
    UsageCategory = Tasks;
    PromotedActionCategories = 'New,Process,Report,Navigate',
            comment = 'ESP="Nuevo,Procesar,Informe,Navegar"';


    layout
    {
        area(content)
        {

            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Nº Identificador del producto', comment = 'ESP="Nº Identificador del producto"';
                    Editable = boolEditNo;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;


                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = boolEditDescription;
                }
                // field(EnglishDescription; Rec.EnglishDescription)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Descripción en Ingles', comment = 'ESP="Descripción en Ingles"';
                // }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la unidad base que se usa para medir el producto, como pieza, caja o palé. La unidad de medida base también sirve como base de conversión para las unidades de medida alternativas.'
                        , comment = 'ESP="Especifica la unidad base que se usa para medir el producto, como pieza, caja o palé. La unidad de medida base también sirve como base de conversión para las unidades de medida alternativas."';
                    Editable = boolEditBaseUnit;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Especifica si la ficha de producto representa una unidad de inventario físico (Inventario), una unidad de tiempo de mano de obra (Servicio) o una unidad física sin seguimiento en el inventario (Fuera de inventario).'
                        , comment = 'ESP="Especifica si la ficha de producto representa una unidad de inventario físico (Inventario), una unidad de tiempo de mano de obra (Servicio) o una unidad física sin seguimiento en el inventario (Fuera de inventario)."';
                    Editable = boolEditType;
                }
                field("State Creation"; "State Creation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Indica el estado de la solicitud de datos.', comment = 'ESP="Indica el estado de la solicitud de datos."';
                }
                group(ITBID)
                {
                    Caption = 'Plataforma ITBID', comment = 'ESP="Plataforma ITBID"';
                    field("ITBID Create"; "ITBID Create")
                    {
                        ApplicationArea = all;
                    }
                    field("ITBID Status"; "ITBID Status")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Indica si se ha creado el producto en la plataforma ITBID.', comment = 'ESP="Indica si se ha creado el producto en la plataforma ITBID."';
                        Editable = false;
                    }
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = all;
                    ToolTip = 'Especifica que se ha bloqueado el registro relacionado para que no se registre en transacciones, por ejemplo, en el caso de un cliente que ha sido declarado insolvente o de un elemento que se encuentra en cuarentena.'
                        , comment = 'ESP="Especifica que se ha bloqueado el registro relacionado para que no se registre en transacciones, por ejemplo, en el caso de un cliente que ha sido declarado insolvente o de un elemento que se encuentra en cuarentena."';
                    Editable = boolEditBlocked;
                }
                field("Reason Blocked"; "Reason Blocked")
                {
                    ApplicationArea = all;
                    ToolTip = 'Especifica el motivo para el cambio del estado de Bloqueado o Desbloqueado.'
                    , comment = 'ESP="Especifica el motivo para el cambio del estado de Bloqueado o Desbloqueado."';
                    Editable = boolEditReasonBlocked;
                }
            }
            group(Applicant)
            {
                Caption = 'Applicant', comment = 'ESP="Solicitante"';
                Editable = boolEditUserCreate;
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                }
                field("Codigo Empleado"; "Codigo Empleado")
                {
                    ApplicationArea = all;
                }
                field("Nombre Empleado"; "Nombre Empleado")
                {
                    ApplicationArea = all;
                }
                field(Department; Department)
                {
                    ApplicationArea = all;
                }
                field("Product manager"; "Product manager")
                {
                    ApplicationArea = all;
                }

                field(Activity; Activity)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Prototype; Prototype)
                {
                    ApplicationArea = all;
                }
                group(Motivo)
                {
                    field(WorkDescription; WorkDescription)
                    {
                        ApplicationArea = all;
                        Caption = 'Reason', comment = 'ESP="Motivo"';
                        ShowCaption = false;
                        MultiLine = true;

                        trigger OnValidate()
                        begin
                            SetWorkDescription(WorkDescription);
                        end;
                    }
                }
            }
            group(Additional)
            {
                Caption = 'Additional', comment = 'ESP="Adicionales"';
                field(Color; Rec.Color)
                {
                    ApplicationArea = All;
                    Editable = boolEditColor;
                }
                field(Alto; Rec.Alto)
                {
                    ApplicationArea = All;
                    Editable = boolEditAlto;
                }
                field(Ancho; Rec.Ancho)
                {
                    ApplicationArea = All;
                    Editable = boolEditAncho;
                }
                field(Largo; Rec.Largo)
                {
                    ApplicationArea = All;
                    Editable = boolEditLargo;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                }
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                    Editable = boolEditMaterial;
                }
                field(Packaging; Rec.Packaging)
                {
                    ApplicationArea = All;
                    Editable = boolEditPackaging;
                }
            }
            group(Clasification)
            {
                Caption = 'Clasification', comment = 'ESP="Clasificación"';

                Grid(Clasif)
                {
                    Caption = 'Clasificación Ventas', comment = 'ESP="Clasificación Ventas"';
                    GridLayout = Rows;
                    group(SelClas)
                    {
                        ShowCaption = false;
                        field(selClasVtas_btc; selClasVtas_btc)
                        {
                            ApplicationArea = all;
                            Editable = boolEditselClasVtas_btc;
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field(desClasVtas_btc; desClasVtas_btc)
                        {
                            ApplicationArea = all;
                            ShowCaption = false;
                        }
                    }
                    group(SelFam)
                    {
                        ShowCaption = false;
                        field(selFamilia_btc; selFamilia_btc)
                        {
                            ApplicationArea = all;
                            Editable = boolEditselFamilia_btc;
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field(desFamilia_btc; desFamilia_btc)
                        {
                            ApplicationArea = all;
                            ShowCaption = false;
                        }

                    }
                    group(SelGamma)
                    {
                        ShowCaption = false;
                        field(selGama_btc; selGama_btc)
                        {
                            ApplicationArea = all;
                            Editable = boolEditselGama_btc;
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field(desGama_btc; desGama_btc)
                        {
                            ApplicationArea = all;
                            ShowCaption = false;
                        }
                    }
                    group(SelLinea)
                    {
                        ShowCaption = false;
                        field(selLineaEconomica_btc; selLineaEconomica_btc)
                        {
                            ApplicationArea = all;
                            Editable = boolEditselLineaEconomica_btc;
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field(desLineaEconomica_btc; desLineaEconomica_btc)
                        {
                            ApplicationArea = all;
                            ShowCaption = false;
                        }
                    }
                    group(SelCanal)
                    {
                        ShowCaption = false;
                        field(Canal; Canal)
                        {
                            ApplicationArea = all;
                            Editable = boolEditCanal;
                        }
                    }
                }

                Grid(ClasifPurch)
                {
                    Caption = 'Clasificación Compras', comment = 'ESP="Clasificación Compras"';
                    GridLayout = Rows;
                    // Caption = 'Compras - Plataforma ITBID', comment = 'ESP="Compras - Plataforma ITBID"';
                    group(PurcFam)
                    {
                        ShowCaption = false;
                        field("Purch. Family"; "Purch. Family")
                        {
                            ApplicationArea = all;
                            Editable = boolEditPurchFamily;
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("Desc. Purch. Family"; "Desc. Purch. Family")
                        {
                            ApplicationArea = all;
                            ShowCaption = false;
                        }
                    }
                    group(PurcCat)
                    {
                        ShowCaption = false;
                        field("Purch. Category"; "Purch. Category")
                        {
                            ApplicationArea = all;
                            Editable = boolEditPurchCategory;
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("Desc. Purch. Category"; "Desc. Purch. Category")
                        {
                            ApplicationArea = all;
                            ShowCaption = false;
                        }
                    }
                    group(PurcSubCat)
                    {
                        ShowCaption = false;
                        field("Purch. SubCategory"; "Purch. SubCategory")
                        {
                            ApplicationArea = all;
                            Editable = boolEditPurchSubCategory;
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("Desc. Purch. SubCategory"; "Desc. Purch. SubCategory")
                        {
                            ApplicationArea = all;
                            ShowCaption = false;
                        }
                    }
                }

            }

            group("Costs & Posting")
            {
                Caption = 'Costs & Posting', comment = 'ESP="Costes y registro"';

                field("Costing Method"; "Costing Method")
                {
                    ApplicationArea = all;
                    Editable = boolEditCostingMethod;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = all;
                    Editable = boolEditUnitCost;
                }
                group("Posting Details")
                {
                    Caption = 'Posting Details', comment = 'ESP="Detalles del registro"';
                    field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                    {
                        ApplicationArea = all;
                        Editable = boolEditGenProdPostingGroup;
                    }
                    field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                    {
                        ApplicationArea = all;
                        Editable = boolEditVATProdPostingGroup;
                    }
                }
                group(ForeignTrade)
                {
                    Caption = 'ForeignTrade', comment = 'ESP="Comercio Exterior"';
                    field("Tariff No."; "Tariff No.")
                    {
                        ApplicationArea = all;
                        Editable = boolEditTariffNo;
                    }
                }
            }
            group("Prices & Sales")
            {
                Caption = 'Prices & Sales', comment = 'ESP="Precios y ventas"';
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                    Editable = boolEditUnitPrice;
                }
                field("Item Disc. Group"; "Item Disc. Group")
                {
                    ApplicationArea = all;
                    Editable = boolEditItemDiscGroup;
                }
                field("Sales Unit of Measure"; "Sales Unit of Measure")
                {
                    ApplicationArea = all;
                    Editable = boolEditSalesUnitofMeasure;
                }
                field("Sales Blocked"; "Sales Blocked")
                {
                    ApplicationArea = all;
                    Editable = boolEditSalesBlocked;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = all;
                    Editable = boolEditVATBusPostingGrPrice;
                }
            }
            group(Reposición)
            {
                field("Replenishment System"; "Replenishment System")
                {
                    ApplicationArea = all;
                    Editable = boolEditReplenishmentSystem;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                    Editable = boolEditVendorNo;
                }
                field(Manufacturer; Manufacturer)
                {
                    ApplicationArea = all;
                    Editable = boolEditManufacturer;
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    ApplicationArea = all;
                    Editable = boolEditLeadTimeCalculation;
                }
                group(Produccion)
                {
                    field("Manufacturing Policy"; "Manufacturing Policy")
                    {
                        ApplicationArea = all;
                        Editable = boolEditManufacturingPolicy;
                    }
                    field("Routing No."; "Routing No.")
                    {
                        ApplicationArea = all;
                        Editable = boolEditRoutingNo;
                    }
                    field("Production BOM No."; "Production BOM No.")
                    {
                        ApplicationArea = all;
                        Editable = boolEditProductionBOMNo;
                    }
                    field("Rounding Precision"; "Rounding Precision")
                    {
                        ApplicationArea = all;
                        Editable = boolEditRoundingPrecision;
                    }
                    field("Flushing Method"; "Flushing Method")
                    {
                        ApplicationArea = all;
                        Editable = boolEditFlushingMethod;
                    }
                }
                group(Ensamblado)
                {
                    field("Assembly Policy"; "Assembly Policy")
                    {
                        ApplicationArea = all;
                        Editable = boolEditAssemblyPolicy;
                    }
                    field("Assembly BOM"; "Assembly BOM")
                    {
                        ApplicationArea = all;
                        Editable = boolEditAssemblyBOM;
                    }
                }
            }
            group(Planificacion)
            {
                field("Reordering Policy"; "Reordering Policy")
                {
                    ApplicationArea = all;
                    Editable = boolEditReorderingPolicy;
                }
                field(Reserve; Reserve)
                {
                    ApplicationArea = all;
                    Editable = boolEditReserve;
                }
                field("Safety Lead Time"; "Safety Lead Time")
                {
                    ApplicationArea = all;
                    Editable = boolEditSafetyLeadTime;
                }
                field("Safety Stock Quantity"; "Safety Stock Quantity")
                {
                    ApplicationArea = all;
                    Editable = boolEditSafetyStockQuantity;
                }
                group("Parámetros de lote a lote")
                {
                    field("Include Inventory"; "Include Inventory")
                    {
                        ApplicationArea = all;
                        Editable = boolEditIncludeInventory;
                    }
                    field("Rescheduling Period"; "Rescheduling Period")
                    {
                        ApplicationArea = all;
                        Editable = boolEditReschedulingPeriod;
                    }
                }
                group("Parámetros de punto de pedido")
                {
                    field("Reorder Point"; "Reorder Point")
                    {
                        ApplicationArea = all;
                        Editable = boolEditReorderPoint;
                    }
                    field("Reorder Quantity"; "Reorder Quantity")
                    {
                        ApplicationArea = all;
                        Editable = boolEditReorderQuantity;
                    }
                    field("Maximum Inventory"; "Maximum Inventory")
                    {
                        ApplicationArea = all;
                        Editable = boolEditMaximumInventory;
                    }
                }
                group("Modificadores de pedido")
                {
                    field("Minimum Order Quantity"; "Minimum Order Quantity")
                    {
                        ApplicationArea = all;
                        Editable = boolEditMinimumOrderQuantity;
                    }
                    field("Maximum Order Quantity"; "Maximum Order Quantity")
                    {
                        ApplicationArea = all;
                        Editable = boolEditMaximumOrderQuantity;
                    }
                    field("Order Multiple"; "Order Multiple")
                    {
                        ApplicationArea = all;
                        Editable = boolEditOrderMultiple;
                    }
                }
                group("Seguim. prod.")
                {
                    field("Item Tracking Code"; "Item Tracking Code")
                    {
                        ApplicationArea = all;
                        Editable = boolEditItemTrackingCode;
                    }
                    field("Serial Nos."; "Serial Nos.")
                    {
                        ApplicationArea = all;
                        Editable = boolEditSerialNos;
                    }
                    field("Lot Nos."; "Lot Nos.")
                    {
                        ApplicationArea = all;
                        Editable = boolEditLotNos;
                    }
                    field("Expiration Calculation"; "Expiration Calculation")
                    {
                        ApplicationArea = all;
                        Editable = boolEditExpirationCalculation;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action(Release)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Release', comment = 'ESP="Lanzar"';
            //     Image = ReleaseDoc;
            //     Promoted = true;
            //     PromotedCategory = Process;

            //     trigger OnAction()
            //     begin
            //         OnAction_Release();
            //     end;
            // }
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open', comment = 'ESP="Abrir"';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_Open();
                end;
            }
            action(SolicitudAlta)
            {
                ApplicationArea = All;
                Caption = 'Solicitud Alta', Comment = 'ESP="Solicitud Alta/Actualización"';
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    Rec.LaunchRegisterItemTemporary();
                end;

            }
            action(CheckItem)
            {
                ApplicationArea = All;
                Caption = 'Confirmar Producto', comment = 'ESP="Confirmar Producto"';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                Visible = IsUserApproval;

                trigger OnAction()
                begin
                    OnAction_CheckItemRequest();
                end;
            }
            action(FinalizeDepartment)
            {
                ApplicationArea = All;
                Caption = 'Comprobación Departamento', comment = 'ESP="Comprobación Departamento"';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                Visible = IsUserApproval;

                trigger OnAction()
                begin
                    OnAction_CheckItemRequest();
                end;
            }
            action(UpdateItem)
            {
                ApplicationArea = All;
                Caption = 'Crear/Actualizar Producto', comment = 'ESP="Crear/Actualizar Producto"';
                Image = CreateSKU;
                Promoted = true;
                PromotedCategory = Process;
                Visible = IsUserCreateItem;

                trigger OnAction()
                begin
                    OnAction_CreateItemRequest();
                end;
            }

            action(UploadExcel)
            {
                ApplicationArea = All;
                Caption = 'Cargar Excel', comment = 'ESP="Cargar Excel"';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_UploadExcel();
                end;
            }
            // action(UpdateITBID)
            // {
            //     ApplicationArea = All;
            //     Caption = 'ITBID Update', Comment = 'ESP="Alta/Actualización ITBID"';
            //     Image = Purchasing;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         Item: Record Item;
            //         zummoFunctions: Codeunit "STH Zummo Functions";
            //         JsonText: Text;
            //         IsUpdate: Boolean;
            //         lblUpdate: Label 'Actualizada la plataforma ITBID', comment = 'ESP="Actualizada la plataforma ITBID"';
            //     begin
            //         if not Confirm(lblConfirmUpdateITBID) then
            //             exit;
            //         if Rec.ITBIDUpdate() then
            //             Message(lblUpdate);
            //     end;
            // }
        }
        area(Navigation)
        {
            action(ItemsReview)
            {
                ApplicationArea = all;
                Caption = 'Review Items temporary', comment = 'ESP="Revisión productos pendientes"';
                Image = ReviewWorksheet;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    OnAction_NavigateReview();
                end;

            }
            action(Translations)
            {
                ApplicationArea = all;
                Caption = 'Traducciones', comment = 'ESP="Traducciones"';
                Image = Translations;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = page "ZM Item Translation temporary";
                RunPageView = sorting("Item No.");
                RunPageLink = "Item No." = field("No.");
            }
            action(ItemApprovalsDept)
            {
                ApplicationArea = all;
                Caption = 'Approvals', comment = 'ESP="Aprobaciones"';
                Image = Translations;
                RunObject = page "Item Approval Departments";
                RunPageLink = "GUID Creation" = field("GUID Creation");
            }
            Group("Lista de materiales")
            {
                Image = Production;
                // group(AssemblyML)
                // {
                // action(ShowLMAssembly)
                // {
                //     ApplicationArea = all;
                //     Caption = 'L. M. Ensamblado', comment = 'ESP="L. M. Ensamblado"';
                //     Image = BOM;
                //     Promoted = true;
                //     PromotedCategory = Category4;
                //     trigger OnAction()
                //     begin
                //         Navigate_AssemblyML();
                //     end;
                // }
                // }
                group(LMProducion)
                {
                    Caption = 'Producción', comment = 'ESP="Producción"';
                    action(ShowLMProduction)
                    {
                        ApplicationArea = all;
                        Caption = 'L. M. Producción', comment = 'ESP="L. M. Producción"';
                        Image = BOM;
                        Promoted = true;
                        PromotedCategory = Category4;
                        trigger OnAction()
                        begin
                            Navigate_ProductionML();
                        end;
                    }
                }
                action(PurchasePrices)
                {
                    ApplicationArea = all;
                    Caption = 'Purchases prices', comment = 'ESP="Precios Compra"';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    begin
                        Navigate_PurchasesPrices();
                    end;
                }
            }
            action(PostedItems)
            {
                ApplicationArea = all;
                Caption = 'Hist. de Altas de productos', comment = 'ESP="Hist. de Altas de productos"';
                Image = PostedReceivableVoucher;

                RunObject = page "Posted PL Items temporary list";
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        WorkDescription := GetWorkDescription;
        CheckActivesFields();
        RefreshUserActions();
    end;

    var
        ItemSetupApproval: Record "ZM PL Item Setup Approval";
        ItemSetupDepartment: Record "ZM PL Item Setup Department";
        ItemsRegisterAprovals: Codeunit "ZM PL Items Regist. aprovals";
        WorkDescription: text;
        ShowField: array[100] of Integer;
        IsUserApproval: Boolean;
        IsUserCreateItem: Boolean;
        boolEditNo: Boolean;
        boolEditDescription: Boolean;
        boolEditAssemblyBOM: Boolean;
        boolEditBaseUnit: Boolean;
        boolEditType: Boolean;
        boolEditInventoryPostingGroup: Boolean;
        boolEditItemDiscGroup: Boolean;
        boolEditUnitPrice: Boolean;
        boolEditCostingMethod: Boolean;
        boolEditUnitCost: Boolean;
        boolEditVendorNo: Boolean;
        boolEditVendorItemNo: Boolean;
        boolEditLeadTimeCalculation: Boolean;
        boolEditReorderPoint: Boolean;
        boolEditMaximumInventory: Boolean;
        boolEditReorderQuantity: Boolean;
        boolEditAlternativeItemNo: Boolean;
        boolEditGrossWeight: Boolean;
        boolEditNetWeight: Boolean;
        boolEditUnitsperParcel: Boolean;
        boolEditUnitVolume: Boolean;
        boolEditDurability: Boolean;
        boolEditFreightType: Boolean;
        boolEditTariffNo: Boolean;
        boolEditBlocked: Boolean;
        boolEditVATBusPostingGrPrice: Boolean;
        boolEditGenProdPostingGroup: Boolean;
        boolEditPicture: Boolean;
        boolEditNosseries: Boolean;
        boolEditVATProdPostingGroup: Boolean;
        boolEditReserve: Boolean;
        boolEditAssemblyPolicy: Boolean;
        boolEditGTIN: Boolean;
        boolEditSerialNos: Boolean;
        boolEditMinimumOrderQuantity: Boolean;
        boolEditMaximumOrderQuantity: Boolean;
        boolEditSafetyStockQuantity: Boolean;
        boolEditOrderMultiple: Boolean;
        boolEditSafetyLeadTime: Boolean;
        boolEditFlushingMethod: Boolean;
        boolEditReplenishmentSystem: Boolean;
        boolEditRoundingPrecision: Boolean;
        boolEditSalesUnitofMeasure: Boolean;
        boolEditPurchUnitofMeasure: Boolean;
        boolEditTimeBucket: Boolean;
        boolEditReorderingPolicy: Boolean;
        boolEditIncludeInventory: Boolean;
        boolEditManufacturingPolicy: Boolean;
        boolEditReschedulingPeriod: Boolean;
        boolEditManufacturerCode: Boolean;
        boolEditItemCategoryCode: Boolean;
        boolEditServiceItemGroup: Boolean;
        boolEditItemTrackingCode: Boolean;
        boolEditLotNos: Boolean;
        boolEditExpirationCalculation: Boolean;
        boolEditSalesBlocked: Boolean;
        boolEditPurchasingBlocked: Boolean;
        boolEditselClasVtas_btc: Boolean;
        boolEditselFamilia_btc: Boolean;
        boolEditselGama_btc: Boolean;
        boolEditselLineaEconomica_btc: Boolean;
        boolEditABC: Boolean;
        boolEditCanal: Boolean;
        boolEditMaterial: Boolean;
        boolEditPurchFamily: Boolean;
        boolEditDescPurchFamily: Boolean;
        boolEditPurchCategory: Boolean;
        boolEditDescPurchCategory: Boolean;
        boolEditPurchSubCategory: Boolean;
        boolEditDescPurchSubCategory: Boolean;
        boolEditManufacturer: Boolean;
        boolEditItemNoManufacturer: Boolean;
        boolEditPlasticQtykg: Boolean;
        boolEditRecycledplasticQtykg: Boolean;
        boolEditRecycledplastic: Boolean;
        boolEditPackingPlasticQtykg: Boolean;
        boolEditPackingRecycledplastickg: Boolean;
        boolEditPackingRecycledplastic: Boolean;
        boolEditSteel: Boolean;
        boolEditCarton: Boolean;
        boolEditWood: Boolean;
        boolEditShowdetaileddocuments: Boolean;
        boolEditPackagingproduct: Boolean;
        boolEditVendorPackagingproduct: Boolean;
        boolEditVendorPackagingproductKG: Boolean;
        boolEditVendorPackagingSteel: Boolean;
        boolEditVendorPackagingCarton: Boolean;
        boolEditVendorPackagingWood: Boolean;
        boolEditLargo: Boolean;
        boolEditAncho: Boolean;
        boolEditAlto: Boolean;
        boolEditPackaging: Boolean;
        boolEditColor: Boolean;
        boolEditReason: Boolean;
        boolEditReasonBlocked: Boolean;
        boolEditRoutingNo: Boolean;
        boolEditProductionBOMNo: Boolean;
        boolEditUserCreate: Boolean;
        lblRelease: Label '¿Do you want to send the request for Item Registration %1 %2?', comment = 'ESP="¿Desea enviar la solicitud de Alta del producto %1 %2?"';
        lblConfirmUpdateITBID: Label '¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?', comment = 'ESP="¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?"';

    // local procedure OnAction_Release()
    // begin
    //     Rec.TestField("State Creation", Rec."State Creation"::" ");
    //     if Confirm(lblRelease, true, Rec."No.", Rec.Description) then
    //         ItemsRegisterAprovals.ItemRegistrationChangeState(Rec);
    // end;

    local procedure OnAction_Open()
    begin
        Rec.TestField("State Creation", Rec."State Creation"::Requested);
        if ItemsRegisterAprovals.ItemRegistratio_OpenRequested(Rec) then
            CurrPage.Update();
    end;

    local procedure Navigate_ProductionML()
    begin
        Rec.Navigate_ProductionML();
    end;

    local procedure OnAction_NavigateReview()
    begin
        Rec.NavigateItemsReview();
    end;

    local procedure GetFieldEditable()
    var
        myInt: Integer;
    begin

    end;

    local procedure CheckActivesFields()
    var
        myInt: Integer;
    begin
        DissableAllFields();
        case Rec."State Creation" of
            Rec."State Creation"::" ":
                begin
                    ActiveAllFields();
                    exit;
                end;
            Rec."State Creation"::Requested:
                if Rec."User ID" = UserId then
                    ActiveAllFields();
        end;

        // como no es el mismo usuario que la comienza hay que ver si tiene permiso en que campos
        UserFieldsActive();
    end;

    local procedure UserFieldsActive()
    var
        RefRecord: RecordRef;
    begin
        if Rec."User ID" = UserId then
            boolEditUserCreate := true;
        ItemSetupDepartment.Reset();
        ItemSetupDepartment.SetRange("User Id", UserId);
        if not ItemSetupDepartment.FindFirst() then
            exit;
        RefRecord.GetTable(Rec);

        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetRange(Department, ItemSetupDepartment.Code);
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Approval, ItemSetupApproval.Rol::Both);
        ItemSetupApproval.SetRange("Field No.", 0);
        // aprobacion completa a la tabla de items por departamento
        if ItemSetupApproval.FindFirst() then begin
            ActiveAllFields();
            exit;
        end;
        ItemSetupApproval.SetRange("Field No.");
        if ItemSetupApproval.FindFirst() then
            repeat
                // buscamos los campos a los que tiene permiso y editable=true
                AssingFieldActive(ItemSetupApproval."Field No.");

            Until ItemSetupApproval.next() = 0;
    end;

    local procedure AssingFieldActive(FieldNumber: Integer)
    var
        myInt: Integer;
    begin
        case FieldNumber of
            1: // No.
                boolEditNo := true;
            3: //Description:
                boolEditDescription := true;
            6: //"Assembly BOM":
                boolEditAssemblyBOM := true;
            8: //"Base Unit of Measure":
                boolEditBaseUnit := true;
            10: //Type:
                boolEditType := true;
            11: //"Inventory Posting Group":
                boolEditInventoryPostingGroup := true;
            14: //"Item Disc. Group"
                boolEditItemDiscGroup := true;
            18: //"Unit Price"
                boolEditUnitPrice := true;
            21: //"Costing Method"
                boolEditCostingMethod := true;
            22: //"Unit Cost"
                boolEditUnitCost := true;
            31: //"Vendor No."
                boolEditVendorNo := true;
            32: //"Vendor Item No."
                boolEditVendorItemNo := true;
            33: //"Lead Time Calculation"
                boolEditLeadTimeCalculation := true;
            34: //"Reorder Point"
                boolEditReorderPoint := true;
            35: //"Maximum Inventory"
                boolEditMaximumInventory := true;
            36: //"Reorder Quantity"
                boolEditReorderQuantity := true;
            37: //"Alternative Item No.": Code[20])
                boolEditAlternativeItemNo := true;
            41: //"Gross Weight": Decimal)
                boolEditGrossWeight := true;
            42: //"Net Weight": Decimal)
                boolEditNetWeight := true;
            43: //"Units per Parcel": Decimal)
                boolEditUnitsperParcel := true;
            44: //"Unit Volume": Decimal)
                boolEditUnitVolume := true;
            45: //Durability: Code[10])
                boolEditDurability := true;
            46: //"Freight Type": Code[10])
                boolEditFreightType := true;
            47: //"Tariff No.": Code[20])
                boolEditTariffNo := true;
            54: //Blocked: //Boolean)
                boolEditBlocked := true;
            90: //"VAT Bus. Posting Gr. (Price)": //Code[20])
                boolEditVATBusPostingGrPrice := true;
            91: //"Gen. Prod. Posting Group": //Code[20])
                boolEditGenProdPostingGroup := true;
            92: //Picture: //MediaSet)
                boolEditPicture := true;
            97: //"Nos. series": //code[20])
                boolEditNosseries := true;
            99: //"VAT Prod. Posting Group": //Code[20])
                boolEditVATProdPostingGroup := true;
            100: //Reserve: //Option)
                boolEditReserve := true;
            910: //"Assembly Policy": //Option)
                boolEditAssemblyPolicy := true;
            1217: //GTIN: //Code[14])
                boolEditGTIN := true;
            5402: //"Serial Nos.": //Code[20])
                boolEditSerialNos := true;
            5411: //"Minimum Order Quantity": //Decimal)
                boolEditMinimumOrderQuantity := true;
            5412: //"Maximum Order Quantity": //Decimal)
                boolEditMaximumOrderQuantity := true;
            5413: //"Safety Stock Quantity": //Decimal)
                boolEditSafetyStockQuantity := true;
            5414: //"Order Multiple": //Decimal)
                boolEditOrderMultiple := true;
            5415: //"Safety Lead Time": //DateFormula)
                boolEditSafetyLeadTime := true;
            5417: //"Flushing Method": //Option)
                boolEditFlushingMethod := true;
            5419: //"Replenishment System": //Option)
                boolEditReplenishmentSystem := true;
            5422: //"Rounding Precision": //Decimal)
                boolEditRoundingPrecision := true;
            5425: //"Sales Unit of Measure": //Code[10])
                boolEditSalesUnitofMeasure := true;
            5426: //"Purch. Unit of Measure": //Code[10])
                boolEditPurchUnitofMeasure := true;
            5428: //"Time Bucket": //DateFormula)
                boolEditTimeBucket := true;
            5440: //"Reordering Policy": //Option)
                boolEditReorderingPolicy := true;
            5441: //"Include Inventory": //Boolean)
                boolEditIncludeInventory := true;
            5442: //"Manufacturing Policy": //Option)
                boolEditManufacturingPolicy := true;
            5443: //"Rescheduling Period": //DateFormula)
                boolEditReschedulingPeriod := true;
            5701: //"Manufacturer Code": //Code[10])
                boolEditManufacturerCode := true;
            5702: //"Item Category Code": //Code[20])
                boolEditItemCategoryCode := true;
            5900: //"Service Item Group": //Code[10])
                boolEditServiceItemGroup := true;
            6500: //"Item Tracking Code": //Code[10])
                boolEditItemTrackingCode := true;
            6501: //"Lot Nos.": //Code[20])
                boolEditLotNos := true;
            6502: //"Expiration Calculation": //DateFormula)
                boolEditExpirationCalculation := true;
            8003: //"Sales Blocked": //Boolean)
                boolEditSalesBlocked := true;
            8004: //"Purchasing Blocked": //Boolean)
                boolEditPurchasingBlocked := true;
            50014: //selClasVtas_btc: //Code[20])
                boolEditselClasVtas_btc := true;
            50015: //selFamilia_btc: //Code[20])
                boolEditselFamilia_btc := true;
            50016: //selGama_btc: //Code[20])
                boolEditselGama_btc := true;
            50017: //selLineaEconomica_btc: //Code[20])
                boolEditselLineaEconomica_btc := true;
            50018: //"ABC": //Option)
                boolEditABC := true;
            50030: //Canal: //Option)
                boolEditCanal := true;
            50127: //Material: //text[100])
                boolEditMaterial := true;
            50130: //"Purch. Family": //Code[20])
                boolEditPurchFamily := true;
            50132: //"Purch. Category": //Code[20])
                boolEditPurchCategory := true;
            50134: //"Purch. SubCategory": //Code[20])
                boolEditPurchSubCategory := true;
            50156: //Manufacturer: //text[100])
                boolEditManufacturer := true;
            50157: //"Item No. Manufacturer": //code[50])
                boolEditItemNoManufacturer := true;
            50200: //"Plastic Qty. (kg)": //decimal)
                boolEditPlasticQtykg := true;
            50201: //"Recycled plastic Qty. (kg)": //decimal)
                boolEditRecycledplasticQtykg := true;
            50202: //"Recycled plastic %": //decimal)
                boolEditRecycledplastic := true;
            50203: //"Packing Plastic Qty. (kg)": //decimal)
                boolEditPackingPlasticQtykg := true;
            50204: //"Packing Recycled plastic (kg)": //decimal)
                boolEditPackingRecycledplastickg := true;
            50205: //"Packing Recycled plastic %": //decimal)
                boolEditPackingRecycledplastic := true;
            50206: //Steel: //Decimal)
                boolEditSteel := true;
            50207: //Carton: //Decimal)
                boolEditCarton := true;
            50208: //Wood: //Decimal)
                boolEditWood := true;
            50210: //"Show detailed documents": //Boolean)
                boolEditShowdetaileddocuments := true;
            50211: //"Packaging product": //Boolean)
                boolEditPackagingproduct := true;
            50212: //"Vendor Packaging product": //Boolean)
                boolEditVendorPackagingproduct := true;
            50215: //"Vendor Packaging product KG": //Decimal)
                boolEditVendorPackagingproductKG := true;
            50216: //"Vendor Packaging Steel": //Decimal)
                boolEditVendorPackagingSteel := true;
            50217: //"Vendor Packaging Carton": //Decimal)
                boolEditVendorPackagingCarton := true;
            50218: //"Vendor Packaging Wood": //Decimal)
                boolEditVendorPackagingWood := true;
            59001: //Largo: //Decimal)
                boolEditLargo := true;
            59002: //Ancho: //Decimal)
                boolEditAncho := true;
            59003: //Alto: //Decimal)
                boolEditAlto := true;
            50806: //Packaging: //Boolean)
                boolEditPackaging := true;
            50807: //Color: //Boolean)
                boolEditColor := true;
            50822: //Reason: //Blob)
                boolEditReason := true;
            50828: //"Reason Blocked": //text[100])
                boolEditReasonBlocked := true;
            99000750: //"Routing No.": //Code[20])
                boolEditRoutingNo := true;
            99000751: //"Production BOM No."; Code[20])
                boolEditProductionBOMNo := true;
        end;
    end;

    local procedure ActiveAllFields()
    begin
        boolEditNo := true;
        boolEditDescription := true;
        boolEditAssemblyBOM := true;
        boolEditBaseUnit := true;
        boolEditType := true;
        boolEditInventoryPostingGroup := true;
        boolEditItemDiscGroup := true;
        boolEditUnitPrice := true;
        boolEditCostingMethod := true;
        boolEditUnitCost := true;
        boolEditVendorNo := true;
        boolEditVendorItemNo := true;
        boolEditLeadTimeCalculation := true;
        boolEditReorderPoint := true;
        boolEditMaximumInventory := true;
        boolEditReorderQuantity := true;
        boolEditAlternativeItemNo := true;
        boolEditGrossWeight := true;
        boolEditNetWeight := true;
        boolEditUnitsperParcel := true;
        boolEditUnitVolume := true;
        boolEditDurability := true;
        boolEditFreightType := true;
        boolEditTariffNo := true;
        boolEditBlocked := true;
        boolEditVATBusPostingGrPrice := true;
        boolEditGenProdPostingGroup := true;
        boolEditPicture := true;
        boolEditNosseries := true;
        boolEditVATProdPostingGroup := true;
        boolEditReserve := true;
        boolEditAssemblyPolicy := true;
        boolEditGTIN := true;
        boolEditSerialNos := true;
        boolEditMinimumOrderQuantity := true;
        boolEditMaximumOrderQuantity := true;
        boolEditSafetyStockQuantity := true;
        boolEditOrderMultiple := true;
        boolEditSafetyLeadTime := true;
        boolEditFlushingMethod := true;
        boolEditReplenishmentSystem := true;
        boolEditRoundingPrecision := true;
        boolEditSalesUnitofMeasure := true;
        boolEditPurchUnitofMeasure := true;
        boolEditTimeBucket := true;
        boolEditReorderingPolicy := true;
        boolEditIncludeInventory := true;
        boolEditManufacturingPolicy := true;
        boolEditReschedulingPeriod := true;
        boolEditManufacturerCode := true;
        boolEditItemCategoryCode := true;
        boolEditServiceItemGroup := true;
        boolEditItemTrackingCode := true;
        boolEditLotNos := true;
        boolEditExpirationCalculation := true;
        boolEditSalesBlocked := true;
        boolEditPurchasingBlocked := true;
        boolEditselClasVtas_btc := true;
        boolEditselFamilia_btc := true;
        boolEditselGama_btc := true;
        boolEditselLineaEconomica_btc := true;
        boolEditABC := true;
        boolEditCanal := true;
        boolEditMaterial := true;
        boolEditPurchFamily := true;
        boolEditDescPurchFamily := true;
        boolEditPurchCategory := true;
        boolEditDescPurchCategory := true;
        boolEditPurchSubCategory := true;
        boolEditDescPurchSubCategory := true;
        boolEditManufacturer := true;
        boolEditItemNoManufacturer := true;
        boolEditPlasticQtykg := true;
        boolEditRecycledplasticQtykg := true;
        boolEditRecycledplastic := true;
        boolEditPackingPlasticQtykg := true;
        boolEditPackingRecycledplastickg := true;
        boolEditPackingRecycledplastic := true;
        boolEditSteel := true;
        boolEditCarton := true;
        boolEditWood := true;
        boolEditShowdetaileddocuments := true;
        boolEditPackagingproduct := true;
        boolEditVendorPackagingproduct := true;
        boolEditVendorPackagingproductKG := true;
        boolEditVendorPackagingSteel := true;
        boolEditVendorPackagingCarton := true;
        boolEditVendorPackagingWood := true;
        boolEditLargo := true;
        boolEditAncho := true;
        boolEditAlto := true;
        boolEditPackaging := true;
        boolEditColor := true;
        boolEditReason := true;
        boolEditReasonBlocked := true;
        boolEditRoutingNo := true;
        boolEditProductionBOMNo := true;
        boolEditUserCreate := true;
    end;

    local procedure DissableAllFields()
    begin
        boolEditNo := false;
        boolEditDescription := false;
        boolEditAssemblyBOM := false;
        boolEditBaseUnit := false;
        boolEditType := false;
        boolEditInventoryPostingGroup := false;
        boolEditItemDiscGroup := false;
        boolEditUnitPrice := false;
        boolEditCostingMethod := false;
        boolEditUnitCost := false;
        boolEditVendorNo := false;
        boolEditVendorItemNo := false;
        boolEditLeadTimeCalculation := false;
        boolEditReorderPoint := false;
        boolEditMaximumInventory := false;
        boolEditReorderQuantity := false;
        boolEditAlternativeItemNo := false;
        boolEditGrossWeight := false;
        boolEditNetWeight := false;
        boolEditUnitsperParcel := false;
        boolEditUnitVolume := false;
        boolEditDurability := false;
        boolEditFreightType := false;
        boolEditTariffNo := false;
        boolEditBlocked := false;
        boolEditVATBusPostingGrPrice := false;
        boolEditGenProdPostingGroup := false;
        boolEditPicture := false;
        boolEditNosseries := false;
        boolEditVATProdPostingGroup := false;
        boolEditReserve := false;
        boolEditAssemblyPolicy := false;
        boolEditGTIN := false;
        boolEditSerialNos := false;
        boolEditMinimumOrderQuantity := false;
        boolEditMaximumOrderQuantity := false;
        boolEditSafetyStockQuantity := false;
        boolEditOrderMultiple := false;
        boolEditSafetyLeadTime := false;
        boolEditFlushingMethod := false;
        boolEditReplenishmentSystem := false;
        boolEditRoundingPrecision := false;
        boolEditSalesUnitofMeasure := false;
        boolEditPurchUnitofMeasure := false;
        boolEditTimeBucket := false;
        boolEditReorderingPolicy := false;
        boolEditIncludeInventory := false;
        boolEditManufacturingPolicy := false;
        boolEditReschedulingPeriod := false;
        boolEditManufacturerCode := false;
        boolEditItemCategoryCode := false;
        boolEditServiceItemGroup := false;
        boolEditItemTrackingCode := false;
        boolEditLotNos := false;
        boolEditExpirationCalculation := false;
        boolEditSalesBlocked := false;
        boolEditPurchasingBlocked := false;
        boolEditselClasVtas_btc := false;
        boolEditselFamilia_btc := false;
        boolEditselGama_btc := false;
        boolEditselLineaEconomica_btc := false;
        boolEditABC := false;
        boolEditCanal := false;
        boolEditMaterial := false;
        boolEditPurchFamily := false;
        boolEditDescPurchFamily := false;
        boolEditPurchCategory := false;
        boolEditDescPurchCategory := false;
        boolEditPurchSubCategory := false;
        boolEditDescPurchSubCategory := false;
        boolEditManufacturer := false;
        boolEditItemNoManufacturer := false;
        boolEditPlasticQtykg := false;
        boolEditRecycledplasticQtykg := false;
        boolEditRecycledplastic := false;
        boolEditPackingPlasticQtykg := false;
        boolEditPackingRecycledplastickg := false;
        boolEditPackingRecycledplastic := false;
        boolEditSteel := false;
        boolEditCarton := false;
        boolEditWood := false;
        boolEditShowdetaileddocuments := false;
        boolEditPackagingproduct := false;
        boolEditVendorPackagingproduct := false;
        boolEditVendorPackagingproductKG := false;
        boolEditVendorPackagingSteel := false;
        boolEditVendorPackagingCarton := false;
        boolEditVendorPackagingWood := false;
        boolEditLargo := false;
        boolEditAncho := false;
        boolEditAlto := false;
        boolEditPackaging := false;
        boolEditColor := false;
        boolEditReason := false;
        boolEditReasonBlocked := false;
        boolEditRoutingNo := false;
        boolEditProductionBOMNo := false;
        boolEditUserCreate := false;
    end;

    local procedure RefreshUserActions()
    var
        Department: code[20];
    begin
        IsUserApproval := false;
        if Rec."State Creation" in [Rec."State Creation"::" "] then
            exit;
        IsUserApproval := Rec.CheckItemsTemporary(Department);
        IsUserCreateItem := Rec.CheckUserItemsCreate() and (Rec."State Creation" in [Rec."State Creation"::Finished]);
    end;

    local procedure OnAction_CheckItemRequest()
    var
        myInt: Integer;
    begin
        Rec.UpdateItemRequest();
    end;

    local procedure OnAction_CreateItemRequest()
    var
        myInt: Integer;
    begin
        Rec.CreateItemTemporary();
    end;

    local procedure OnAction_UploadExcel()
    var
        myInt: Integer;
    begin
        Rec.UploadExcel();
    end;
}
