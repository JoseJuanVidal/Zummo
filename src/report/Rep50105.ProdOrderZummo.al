report 50105 "Prod. Order Zummo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50105.OrdenProduccion.rdlc';
    ApplicationArea = Manufacturing;
    Caption = 'Prod. Order Comp. and Routing';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.");
            RequestFilterFields = Status, "No.";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {

            }
            column(lblFO01; lblFO01)
            { }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(Status_ProductionOrder; Status)
            {
                IncludeCaption = true;
            }
            column(No_ProductionOrder; "No.")
            {
                IncludeCaption = true;
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            column(PrdOdrCmptsandRtngLinsCpt; PrdOdrCmptsandRtngLinsCptLbl)
            {
            }
            column(ProductionOrderDescCapt; ProductionOrderDescCaptLbl)
            {
            }
            column(CabQuantiy; CantidadCab)
            {
            }
            column(CabQuantiyLbl; CabQuantiyLbl)
            {
            }
            column(CabDescripcion; "Production Order".Description)
            {
            }
            column(CabDescripcionLbl; CabDescripcionLbl)
            {
            }
            column(PedidoLbl; PedidoLbl)
            {
            }
            column(RefPedidoLbl; RefPedidoLbl)
            {
            }
            column(LisRutaFabricLbl; LisRutaFabricLbl)
            {
            }
            column(LisNeceLbl; LisNeceLbl)
            {
            }
            column(OrdenLbl; OrdenLbl)
            {
            }
            column(ArticuloLbl; ArticuloLbl)
            {
            }
            column(RevisionLbl; RevisionLbl)
            {
            }
            column(FVtoLbl; FVtoLbl)
            {
            }
            column(TituloLisFabricaLbl; TituloLisFabricaLbl)
            {
            }
            column(UnidadLbl; UnidadLbl)
            {
            }
            column(InicioLbl; InicioLbl)
            {
            }
            column(FinLbl; FinLbl)
            {
            }
            column(FVtoLineLbl; FVtoLineLbl)
            {
            }
            column(LineaLbl; LineaLbl)
            {
            }
            column(FasesLbl; FasesLbl)
            {
            }
            column(ArticuloLineLbl; ArticuloLineLbl)
            {
            }
            column(DescripcionLbl; DescripcionLbl)
            {
            }
            column(CantidadLineLbl; CantidadLineLbl)
            {
            }
            column(CabdueDate; "Production Order"."Due Date")
            {
            }
            column(OrderReplanRefNo; "Production Order"."Replan Ref. No.")
            {
            }
            column(Item; "Production Order"."Source No.")
            {
            }
            column(UbicacionLbl; UbicacionLbl)
            {
            }
            dataitem(Ruta; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                RequestFilterFields = "Item No.", "Line No.";
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = "Routing No." = FIELD("Routing No."), "Routing Reference No." = FIELD("Routing Reference No."), "Prod. Order No." = FIELD("Prod. Order No."), Status = FIELD(Status);
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                    column(OprNo_ProdOrderRtngLine; "Operation No.")
                    {
                    }
                    column(OprNo_ProdOrderRtngLineCaption; FieldCaption("Operation No."))
                    {
                    }
                    column(Type_PrdOrdRtngLin; Type)
                    {
                        IncludeCaption = true;
                    }
                    column(No_ProdOrderRoutingLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(LinDesc_ProdOrderRtngLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(StrgDt_ProdOrderRtngLine; Format("Starting Date"))
                    {
                    }
                    column(LinStrgTime_PrdOrdRtngLin; "Starting Time")
                    {
                        IncludeCaption = true;
                    }
                    column(EndgDte_ProdOrdrRtngLine; Format("Ending Date"))
                    {
                    }
                    column(EndgTime_ProdOrdrRtngLin; "Ending Time")
                    {
                        IncludeCaption = true;
                    }
                    column(RoutgNo_ProdOrdrRtngLine; "Routing No.")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if EsPrimeraLineaProduccion then
                        EsPrimeraLineaProduccion := false
                    else
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    EsPrimeraLineaProduccion := true;
                end;
            }
            dataitem(componentes; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                RequestFilterFields = "Item No.", "Line No.";
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No.");
                    DataItemLinkReference = componentes;
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(ItemNo_PrdOrdrComp; "Item No.")
                    {
                    }
                    column(ItemNo_PrdOrdrCompCaption; FieldCaption("Item No."))
                    {
                    }
                    column(Description_ProdOrderComp; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantityper_ProdOrderComp; "Quantity per")
                    {
                        IncludeCaption = true;
                    }
                    column(UntofMesrCode_PrdOrdrComp; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(RemainingQty_PrdOrdrComp; "Remaining Quantity")
                    {
                        IncludeCaption = true;
                    }
                    column(DueDate_PrdOrdrComp; Format("Due Date"))
                    {
                    }
                    column(ProdOrdrLinNo_PrdOrdrComp; "Prod. Order Line No.")
                    {
                    }
                    column(LineNo_PrdOrdrComp; "Line No.")
                    {
                    }
                    column(BinCode; "Prod. Order Component"."Bin Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        //"Quantity per":=ROUND("Quantity per"*"Production Order".Quantity,0.001); // siempre serán las lineas del mismo producto según especificación
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if EsPrimeraLineaProduccion then
                        EsPrimeraLineaProduccion := false
                    else
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    EsPrimeraLineaProduccion := true;
                end;
            }
            dataitem(Lineas; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                RequestFilterFields = "Item No.", "Line No.";
                column(No1_ProductionOrder; "Production Order"."No.")
                {
                }
                column(Desc_ProductionOrder; "Production Order".Description)
                {
                }
                column(Desc_ProdOrderLine; Description)
                {
                }
                column(Quantity_ProdOrderLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(ItemNo_ProdOrderLine; "Item No.")
                {
                }
                column(StartgDate_ProdOrderLine; Format("Starting Date"))
                {
                }
                column(StartgTime_ProdOrderLine; "Starting Time")
                {
                    IncludeCaption = true;
                }
                column(EndingDate_ProdOrderLine; Format("Ending Date"))
                {
                }
                column(EndingTime_ProdOrderLine; "Ending Time")
                {
                    IncludeCaption = true;
                }
                column(DueDate_ProdOrderLine; Format("Due Date"))
                {
                }
                column(LineNo_ProdOrderLine; "Line No.")
                {
                }
                column(ProdOdrLineStrtngDteCapt; ProdOdrLineStrtngDteCaptLbl)
                {
                }
                column(ProdOrderLineEndgDteCapt; ProdOrderLineEndgDteCaptLbl)
                {
                }
                column(ProdOrderLineDueDateCapt; ProdOrderLineDueDateCaptLbl)
                {
                }
                column(barcode; Barcode)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Barcode := '*' + Lineas."Prod. Order No." + '$' + Format(Lineas."Line No.") + '*';
                end;
            }

            trigger OnAfterGetRecord()
            var
                ProdOrderLine: Record "Prod. Order Line";
            begin
                CantidadCab := 0;
                ProdOrderLine.Reset;
                ProdOrderLine.SetRange("Prod. Order No.", "Production Order"."No.");
                if ProdOrderLine.FindSet then
                    repeat
                        CantidadCab += ProdOrderLine.Quantity;
                    until ProdOrderLine.Next = 0;
            end;
        }
    }


    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.Calcfields(Picture)
    end;

    var
        CompanyInfo: Record "Company Information";
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        CurrReportPageNoCaptLbl: Label 'Page';
        PrdOdrCmptsandRtngLinsCptLbl: Label 'PROD. ORDER ZUMMO';
        ProductionOrderDescCaptLbl: Label 'Description:';
        ProdOdrLineStrtngDteCaptLbl: Label 'Starting Date';
        ProdOrderLineEndgDteCaptLbl: Label 'Ending Date';
        ProdOrderLineDueDateCaptLbl: Label 'Due Date';
        CabQuantiyLbl: Label 'Quantity:';
        CabDescripcionLbl: Label 'Description:';
        RevisionLbl: Label 'Revision:';
        PedidoLbl: Label 'Order:';
        RefPedidoLbl: Label 'Ref.Order:';
        LisRutaFabricLbl: Label 'LISTADO DE RUTAS DE FABRICACIÓN';
        LisNeceLbl: Label 'LISTADO DE NECESIDADES';
        OrdenLbl: Label 'Order:';
        ArticuloLbl: Label 'Item:';
        FVtoLbl: Label 'F.Vto:';
        EsPrimeraLineaProduccion: Boolean;
        TituloLisFabricaLbl: Label 'LISTADO DE LINEAS DE FABRICACIÓN';
        UnidadLbl: Label 'Unit';
        UbicacionLbl: Label 'Bin Code';
        DescripcionLbl: Label 'Description';
        ArticuloLineLbl: Label 'Item';
        FasesLbl: Label 'Phases';
        InicioLbl: Label 'Start';
        FinLbl: Label 'End';
        FVtoLineLbl: Label 'F.Vto';
        LineaLbl: Label 'Line';
        CantidadLineLbl: Label 'Quantity';
        Barcode: Text[60];
        CantidadCab: Decimal;
        lblFO01: Label 'FO.01_C6.03_V09', comment = 'ESP="FO.01_C6.03_V09"';
}

