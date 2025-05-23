pageextension 50109 "ItemCard" extends "Item Card"
{
    layout
    {
        modify(GTIN)
        {
            trigger OnAssistEdit()
            begin
                OnAssistEdit_GTIN();
            end;
        }
        addafter("Qty. on Sales Order")
        {
            field(QtyonQuotesOrder; QtyonQuotesOrder) { }
            field("Cant_ componentes Oferta"; "Cant_ componentes Oferta") { }
        }
        addafter(InventoryGrp)
        {

            part(StockPerAlmacen; StockPerAlmacen)
            {
                Caption = 'Stock por Almacén', comment = 'ESP="Stock por Almacén"';
                SubPageLink = "Item No." = field("No.");
                Editable = false;
            }
            group(Clasificacion)
            {
                Caption = 'Classification', comment = 'ESP="Clasificación"';

                field(ClasVtas_btc; selClasVtas_btc)
                {
                    Caption = 'Sales Clas.', comment = 'ESP="Clasif.Ventas"';
                    ApplicationArea = All;
                }
                field(DescClasVtas_btc; desClasVtas_btc)
                {
                    Caption = 'Sales Clas.Desc', comment = 'ESP="Desc.Clasif.Ventas"';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Familia_btc; selFamilia_btc)
                {
                    Caption = 'Family', comment = 'ESP="Familia"';
                    ApplicationArea = All;
                }
                field(DescFamilia_btc; desFamilia_btc)
                {
                    Caption = 'Family Desc', comment = 'ESP="Desc.Familia"';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Gama_btc; selGama_btc)
                {
                    Caption = 'Gama', comment = 'ESP="Gama"';
                    ApplicationArea = All;
                }
                field(DescGama_btc; desGama_btc)
                {
                    Caption = 'Gama Desc', comment = 'ESP="Desc.Gama"';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(LineaEconomica; selLineaEconomica_btc)
                {
                    Caption = 'Linea Economica', comment = 'ESP="Linea Economica"';
                    ApplicationArea = All;
                }
                field(DescLineaEconomica; desLineaEconomica_btc)
                {
                    Caption = 'Linea Economica Desc', comment = 'ESP="Desc.Linea Economica"';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Canal; Canal)
                {
                    ApplicationArea = all;
                }
                field(CentroTrabajp_btc; CentroTrabajp_btc)
                {
                    ApplicationArea = All;
                }

                field(Ordenacion_btc; Ordenacion_btc)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field(TasaRAEE; TasaRAEE)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
            }
        }
        addafter("Purchasing Blocked")
        {
            field("Purch. Request minor 200"; "Purch. Request minor 200")
            {
                ApplicationArea = all;
            }
            field(Manufacturer; Manufacturer)
            {
                ApplicationArea = all;
            }
            field("Item No. Manufacturer"; "Item No. Manufacturer")
            {
                ApplicationArea = all;
            }
            field("Obtener Serie Consumo"; "Obtener Serie Consumo")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Routing No.")
        {
            field(Material; Material)
            {
                ApplicationArea = all;
            }
            field("Update BI BOM Costs"; "Update BI BOM Costs")
            {
                ApplicationArea = all;
            }
        }
        addlast(Planning)
        {
            //ContraStockBajoPedido
            group("Bajo pedido / Contra stock")
            {
                Caption = 'Bajo pedido/Contra stock';
                field("ContraStock/BajoPedido"; "ContraStock/BajoPedido") { }
                field(PedidoMaximo; PedidoMaximo) { }
            }
        }
        // Validar productos
        addbefore(Blocked)
        {
            field(ValidadoContabiliad_btc; ValidadoContabiliad_btc)
            {
                ApplicationArea = All;
            }
        }

        addafter("Safety Stock Quantity")
        {
            field(StockSeguridadBase; StockSeguridadBase)
            {
                ApplicationArea = all;
            }

        }
        addafter("Lot Size")
        {
            field("Renovate Plan"; "Renovate Plan")
            {
                ApplicationArea = all;
            }
        }

        addlast(Content)
        {
            group("Packaging Weight data")
            {
                Caption = 'Packaging Weight data', comment = 'ESP="Datos pesos embalajes"';
                field(Steel; Steel)
                {
                    ApplicationArea = all;
                }
                field(Aluminium; Aluminium)
                {
                    ApplicationArea = all;
                }
                field(Carton; Carton)
                {
                    ApplicationArea = all;
                }
                field("PAPER & CARTON (With plastic)"; "PAPER & CARTON (With plastic)")
                {
                    ApplicationArea = all;
                }
                field(Wood; Wood)
                {
                    ApplicationArea = all;
                }
                field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Recycled plastic %"; "Recycled plastic %")
                {
                    ApplicationArea = all;
                }
                field("Packing Plastic Qty. (kg)"; "Packing Plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Vendor Packaging product KG"; "Vendor Packaging product KG")
                {
                    ApplicationArea = all;
                }
                field("Vendor Packaging Carton"; "Vendor Packaging Carton")
                {
                    ApplicationArea = all;
                }
                field("Vendor Packaging Wood"; "Vendor Packaging Wood")
                {
                    ApplicationArea = all;
                }
                field("Vendor Packaging Steel"; "Vendor Packaging Steel")
                {
                    ApplicationArea = all;
                }
                field("Show detailed documents"; "Show detailed documents")
                {
                    ApplicationArea = all;
                }
                field("Packaging product"; "Packaging product")
                {
                    ApplicationArea = all;
                }
                group(detail)
                {
                    Caption = 'Plastic Detail', comment = 'ESP="Detalle Plasticos"';

                    field("PLASTICS EPS Flexible"; "PLASTICS EPS Flexible")
                    {
                        ApplicationArea = all;
                    }
                    field("PLASTICS OTHERS"; "PLASTICS OTHERS")
                    {
                        ApplicationArea = all;
                    }
                    field("PLASTICS PET FLEXIBLE"; "PLASTICS PET FLEXIBLE")
                    {
                        ApplicationArea = all;
                    }
                    field("PLASTICS PET OTHER"; "PLASTICS PET OTHER")
                    {
                        ApplicationArea = all;
                    }
                    field("PLASTICS PP FLEXIBLE"; "PLASTICS PP FLEXIBLE")
                    {
                        ApplicationArea = all;
                    }
                    field("PLASTICS PVC FLEXIBLE"; "PLASTICS PVC FLEXIBLE")
                    {
                        ApplicationArea = all;
                    }
                    field("PLASTICS PVC OTHER"; "PLASTICS PVC OTHER")
                    {
                        ApplicationArea = all;
                    }
                    field("RUBBER/SILICON Flexibles"; "RUBBER/SILICON Flexibles")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }

        modify("Reordering Policy")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Reordering Policy", "Reordering Policy");
            end;
        }
        modify("Replenishment System")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Replenishment System", "Replenishment System");
            end;
        }
        modify("Reorder Point")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Reorder Point", "Reorder Point");
            end;
        }
        modify("Unit Cost")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Unit Cost", "Unit Cost");
            end;
        }
        modify("Standard Cost")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Standard Cost", "Standard Cost");
            end;
        }
        modify("Last Direct Cost")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Last Direct Cost", "Last Direct Cost");
            end;
        }
        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Vendor No.", "Vendor No.");
            end;
        }
        modify("Vendor Item No.")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Vendor Item No.", "Vendor Item No.");
            end;
        }
        modify("Lead Time Calculation")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Lead Time Calculation", "Lead Time Calculation");
            end;
        }
        modify("Maximum Inventory")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Maximum Inventory", "Maximum Inventory");
            end;
        }
        modify("Reorder Quantity")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Reorder Quantity", "Reorder Quantity");
            end;
        }
        modify("Lot Size")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Lot Size", "Lot Size");
            end;
        }
        modify("Minimum Order Quantity")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Minimum Order Quantity", "Minimum Order Quantity");
            end;
        }
        modify("Maximum Order Quantity")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Maximum Order Quantity", "Maximum Order Quantity");
            end;
        }
        modify("Safety Stock Quantity")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Safety Stock Quantity", "Safety Stock Quantity");
            end;
        }
        modify("Order Multiple")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Order Multiple", "Order Multiple");
            end;
        }
        modify("Safety Lead Time")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Safety Lead Time", "Safety Lead Time");
            end;
        }
        modify("Flushing Method")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Flushing Method", "Flushing Method");
            end;
        }
        modify("Time Bucket")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Time Bucket", "Time Bucket");
            end;
        }
        modify("Manufacturing Policy")
        {
            trigger OnAfterValidate()
            var
                Stock: Record "Stockkeeping Unit";
            begin
                Stock.reset;
                Stock.SetRange("Item No.", Rec."No.");
                Stock.ModifyAll("Manufacturing Policy", "Manufacturing Policy");
            end;
        }
        addafter(Inventory)
        {
            field("Inventory to date"; "Inventory to date")
            {
                ApplicationArea = all;
            }
        }

        addlast(Content)
        {
            group(PurchaseCategory)
            {
                Caption = 'Purchase Category', comment = 'ESP="Categorías de Compra"';

                field("Purch. Family"; "Purch. Family")
                {
                    ApplicationArea = all;
                }
                field("Desc. Purch. Family"; "Desc. Purch. Family")
                {
                    ApplicationArea = all;
                }
                field("Purch. Category"; "Purch. Category")
                {
                    ApplicationArea = all;
                }
                field("Desc. Purch. Category"; "Desc. Purch. Category")
                {
                    ApplicationArea = all;
                }
                field("Purch. SubCategory"; "Purch. SubCategory")
                {
                    ApplicationArea = all;
                }
                field("Desc. Purch. SubCategory"; "Desc. Purch. SubCategory")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        addafter(AdjustInventory)
        {
            //131219 S19/01405 Copiar producto
            action(CopiarProducto)
            {
                ApplicationArea = All;
                Caption = 'Copy Item', comment = 'ESP="Copiar producto"';
                ToolTip = 'Open a window that allows you to create a new item by copying the data of the current item',
                    comment = 'ESP="Abre una ventana que permite crear un nuevo producto copiando los datos del producto actual"';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Image = NewRow;

                trigger OnAction()
                var
                    recNewItem: Record Item;
                    cduFuncFab: Codeunit FuncionesFabricacion;
                    pageCopiar: Page CopiarProducto;
                    codProducto: code[20];
                    descProducto: Text[100];
                    crearListaMateriales: Boolean;
                    lbProductoCreadoMsg: Label 'Item: %1 created successfully', comment = 'ESP="Producto: %1 creado correctamente"';
                begin
                    Clear(pageCopiar);
                    pageCopiar.LookupMode(true);
                    pageCopiar.SetProductoOrigen("No.");

                    if pageCopiar.RunModal() = Action::LookupOK then begin
                        pageCopiar.GetDatos(codProducto, descProducto, crearListaMateriales);

                        Clear(cduFuncFab);
                        cduFuncFab.CopiarProducto("No.", codProducto, descProducto, crearListaMateriales);

                        Commit();

                        Message(StrSubstNo(lbProductoCreadoMsg, codProducto));

                        recNewItem.reset();
                        recNewItem.SetRange("No.", codProducto);

                        page.RunModal(page::"Item Card", recNewItem);
                    end;
                end;
            }
        }
        addafter(CalculateCountingPeriod)
        {
            action(CalculatePlastic)
            {
                ApplicationArea = all;
                Caption = 'Calculate Plastic BOM', comment = 'ESP="Calcular peso plastico L.M."';
                Image = CalculateHierarchy;
                ToolTip = 'Review the entire structure and update data at all levels.', comment = 'ESP="Revisa toda la estructura y actualiza los datos a todos los niveles"';
                // Promoted = true;
                // PromotedCategory = New;

                trigger OnAction()
                begin
                    CalculatePlastic;
                end;

            }
            action(CalculatePlasticLevels)
            {
                ApplicationArea = all;
                Caption = 'Calculate Plastic Level', comment = 'ESP="Calcular peso plastico Niveles superior"';
                Image = CalculateRegenerativePlan;
                ToolTip = 'Will update all BOM containing this product, recalculate all higher levels',
                            comment = 'ESP="Actualizará todos las listas de materiales que contienen este producto, volvera a calcular todos los niveles superiores"';
                // Promoted = true;
                // PromotedCategory = New;

                trigger OnAction()
                begin
                    CalculatePlasticFrom();
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
        addlast(Navigation)
        {
            action(SerialInformation)
            {
                Caption = 'Serial No. information', comment = 'ESP="Información Nº. Serie"';
                Image = SerialNoProperties;

                trigger OnAction()
                begin
                    ShowNavigateSerialNoInfo();
                end;

            }
        }
    }


    var
        IsITeminventory: Boolean;

    procedure CalcularUA()
    var
        CreatestockkepingUnit: report "Create Stockkeeping Unit";
        Item: Record Item;
    begin
        commit;
        SelectLatestVersion();
        Item.reset;
        Item.SetRange("No.", Rec."No.");
        Item.FindFirst();
        Clear(CreatestockkepingUnit);
        CreatestockkepingUnit.SetTableView(Item);
        CreatestockkepingUnit.InitializeRequest(0, false, true);
        CreatestockkepingUnit.UseRequestPage(false);
        CreatestockkepingUnit.Run();
    end;


    local procedure CalculatePlastic()
    var
        Item: Record Item;
        Funciones: Codeunit Funciones;
        lblConfirm: Label '¿Desea calcular la cantidad del plastico de la L.M. del producto %1?', comment = '¿Desea calcular la cantidad del plastico de la L.M. del producto %1?';
    begin
        if Confirm(lblConfirm, false, Rec."No.") then
            Funciones.PlasticCalculateItem(Rec);
    end;

    local procedure CalculatePlasticFrom()
    var
        Item: Record Item;
        Funciones: Codeunit Funciones;
        lblConfirm: Label '¿Desea calcular la cantidad del plastico de los niveles superiores del producto %1?', comment = '¿Desea calcular la cantidad del plastico de los niveles superiores del producto %1?';
    begin
        if Confirm(lblConfirm, false, Rec."No.") then
            Funciones.PlasticCalculateFromItem(Rec);
    end;

    local procedure OnAssistEdit_GTIN()
    var
        Item: Record Item;
        Funciones: Codeunit FuncionesFabricacion;
        BarCodeType: enum "Bar Code Type";
        lblConfirmAssing: Label '¿Desea Asignar un nuevo codigo EAN13 a %1 %2?', comment = 'ESP="¿Desea Asignar un nuevo codigo EAN13 a %1 %2?"';
        lblConfirmUpdate: Label '¿Desea Calcular el codigo EAN13 de a %1?', comment = 'ESP="¿Desea Calcular el codigo EAN13 de %1?"';
    begin
        Item.SetRange("No.", Rec."No.");
        Item.FindFirst();
        case item.GTIN of
            '':
                begin
                    if not confirm(lblConfirmAssing, false, Item."No.", Item.Description) then
                        exit;
                    Funciones.CreateGTIN(Item, true, BarCodeType::EAN13);
                end;
            else begin
                if not confirm(lblConfirmUpdate, false, Item.GTIN) then
                    exit;
                Funciones.CreateGTIN(Item, false, BarCodeType::EAN13);
            end;
        end;

    end;

    local procedure ShowNavigateSerialNoInfo()
    var
        SerialNoInfo: Record "Serial No. Information";
    begin
        SerialNoInfo.FilterGroup := 2;
        SerialNoInfo.SetRange("Item No.", Rec."No.");
        SerialNoInfo.FilterGroup := 0;
        Page.Run(0, SerialNoInfo);
    end;

    /*  trigger OnAfterGetCurrRecord()
      var
          TextosAuxiliares: Record TextosAuxiliares;
      begin
          DescClasVtas_btc := '';
          TextosAuxiliares.Reset();
          if TextosAuxiliares.Get(TextosAuxiliares.TipoTabla::ClasificacionVentas, TextosAuxiliares.TipoRegistro::Tabla, REc.selClasVtas_btc) then
              DescClasVtas_btc := TextosAuxiliares.Descripcion;

          DescFamilia_btc := '';
          TextosAuxiliares.Reset();
          if TextosAuxiliares.Get(TextosAuxiliares.TipoTabla::Familia, TextosAuxiliares.TipoRegistro::Tabla, REc.selFamilia_btc) then
              DescFamilia_btc := TextosAuxiliares.Descripcion;

          DescGama_btc := '';
          TextosAuxiliares.Reset();
          if TextosAuxiliares.Get(TextosAuxiliares.TipoTabla::Gamma, TextosAuxiliares.TipoRegistro::Tabla, REc.selGama_btc) then
              DescGama_btc := TextosAuxiliares.Descripcion;

          DescLineaEconomica := '';
          TextosAuxiliares.Reset();
          if TextosAuxiliares.Get(TextosAuxiliares.TipoTabla::LineaEconomica, TextosAuxiliares.TipoRegistro::Tabla, REc.selLineaEconomica_btc) then
              DescLineaEconomica := TextosAuxiliares.Descripcion;
      end;

      var
          DescClasVtas_btc: Text;
          DescFamilia_btc: Text;
          DescGama_btc: Text;
          DescLineaEconomica: Text;*/



}