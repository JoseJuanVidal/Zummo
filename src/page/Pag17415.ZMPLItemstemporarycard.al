page 17415 "ZM PL Items temporary card"
{
    Caption = 'Items registration', Comment = 'ESP="Alta de productos"';
    PageType = card;
    SourceTable = "ZM PL Items temporary";
    SourceTableView = where("State Creation" = filter(" " | Requested | Released));
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

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;


                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
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
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Especifica si la ficha de producto representa una unidad de inventario físico (Inventario), una unidad de tiempo de mano de obra (Servicio) o una unidad física sin seguimiento en el inventario (Fuera de inventario).'
                        , comment = 'ESP="Especifica si la ficha de producto representa una unidad de inventario físico (Inventario), una unidad de tiempo de mano de obra (Servicio) o una unidad física sin seguimiento en el inventario (Fuera de inventario)."';
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
                        Editable = false;
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
                }
                field("Reason Blocked"; "Reason Blocked")
                {
                    ApplicationArea = all;
                    ToolTip = 'Especifica el motivo para el cambio del estado de Bloqueado o Desbloqueado.'
                    , comment = 'ESP="Especifica el motivo para el cambio del estado de Bloqueado o Desbloqueado."';
                }
            }
            group(Applicant)
            {
                Caption = 'Applicant', comment = 'ESP="Solicitante"';
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
                }
                field(Alto; Rec.Alto)
                {
                    ApplicationArea = All;
                }
                field(Ancho; Rec.Ancho)
                {
                    ApplicationArea = All;
                }
                field(Largo; Rec.Largo)
                {
                    ApplicationArea = All;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                }
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                }
                field(Packaging; Rec.Packaging)
                {
                    ApplicationArea = All;
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
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = all;
                }
                group("Posting Details")
                {
                    Caption = 'Posting Details', comment = 'ESP="Detalles del registro"';
                    field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                    {
                        ApplicationArea = all;
                    }
                    field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                    {
                        ApplicationArea = all;
                    }
                }
                group(ForeignTrade)
                {
                    Caption = 'ForeignTrade', comment = 'ESP="Comercio Exterior"';
                    field("Tariff No."; "Tariff No.")
                    {
                        ApplicationArea = all;
                    }
                }
            }
            group("Prices & Sales")
            {
                Caption = 'Prices & Sales', comment = 'ESP="Precios y ventas"';
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Item Disc. Group"; "Item Disc. Group")
                {
                    ApplicationArea = all;
                }
                field("Sales Unit of Measure"; "Sales Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Sales Blocked"; "Sales Blocked")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = all;
                }
            }
            group(Reposición)
            {
                field("Replenishment System"; "Replenishment System")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(Manufacturer; Manufacturer)
                {
                    ApplicationArea = all;
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    ApplicationArea = all;
                }
                group(Produccion)
                {
                    field("Manufacturing Policy"; "Manufacturing Policy")
                    {
                        ApplicationArea = all;
                    }
                    field("Routing No."; "Routing No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Production BOM No."; "Production BOM No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Rounding Precision"; "Rounding Precision")
                    {
                        ApplicationArea = all;
                    }
                    field("Flushing Method"; "Flushing Method")
                    {
                        ApplicationArea = all;
                    }
                }
                group(Ensamblado)
                {
                    field("Assembly Policy"; "Assembly Policy")
                    {
                        ApplicationArea = all;
                    }
                    field("Assembly BOM"; "Assembly BOM")
                    {
                        ApplicationArea = all;
                    }
                }
            }
            group(Planificacion)
            {
                field("Reordering Policy"; "Reordering Policy")
                {
                    ApplicationArea = all;
                }
                field(Reserve; Reserve)
                {
                    ApplicationArea = all;
                }
                field("Safety Lead Time"; "Safety Lead Time")
                {
                    ApplicationArea = all;
                }
                field("Safety Stock Quantity"; "Safety Stock Quantity")
                {
                    ApplicationArea = all;
                }
                group("Parámetros de lote a lote")
                {
                    field("Include Inventory"; "Include Inventory")
                    {
                        ApplicationArea = all;
                    }
                    field("Rescheduling Period"; "Rescheduling Period")
                    {
                        ApplicationArea = all;
                    }
                }
                group("Parámetros de punto de pedido")
                {
                    field("Reorder Point"; "Reorder Point")
                    {
                        ApplicationArea = all;
                    }
                    field("Reorder Quantity"; "Reorder Quantity")
                    {
                        ApplicationArea = all;
                    }
                    field("Maximum Inventory"; "Maximum Inventory")
                    {
                        ApplicationArea = all;
                    }
                }
                group("Modificadores de pedido")
                {
                    field("Minimum Order Quantity"; "Minimum Order Quantity")
                    {
                        ApplicationArea = all;
                    }
                    field("Maximum Order Quantity"; "Maximum Order Quantity")
                    {
                        ApplicationArea = all;
                    }
                    field("Order Multiple"; "Order Multiple")
                    {
                        ApplicationArea = all;
                    }
                }
                group("Seguim. prod.")
                {
                    field("Item Tracking Code"; "Item Tracking Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Serial Nos."; "Serial Nos.")
                    {
                        ApplicationArea = all;
                    }
                    field("Lot Nos."; "Lot Nos.")
                    {
                        ApplicationArea = all;
                    }
                    field("Expiration Calculation"; "Expiration Calculation")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release', comment = 'ESP="Lanzar"';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_Release();
                end;
            }
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
            Group("Lista de materiales")
            {
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
        }
    }

    trigger OnAfterGetRecord()
    begin
        WorkDescription := GetWorkDescription;
    end;

    var
        ItemsRegisterAprovals: Codeunit "ZM PL Items Regist. aprovals";
        WorkDescription: text;
        ShowField: array[100] of Integer;
        lblRelease: Label '¿Do you want to send the request for Item Registration %1 %2?', comment = 'ESP="¿Desea enviar la solicitud de Alta del producto %1 %2?"';
        lblConfirmUpdateITBID: Label '¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?', comment = 'ESP="¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?"';

    local procedure OnAction_Release()
    begin
        Rec.TestField("State Creation", Rec."State Creation"::" ");
        if Confirm(lblRelease, true, Rec."No.", Rec.Description) then
            ItemsRegisterAprovals.ItemRegistrationChangeState(Rec);
    end;

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
}
