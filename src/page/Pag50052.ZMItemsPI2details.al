page 50052 "ZM Items PI2 details"
{
    Caption = 'Items PI2 details', comment = 'ESP="Productos PI2 Detalles"';
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Item;
    // SourceTableView = where("CMMF Code" = filter(<> ''));
    CardPageId = "Item Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; "No.") { ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; }
                field("CMMF Type"; "CMMF Type") { ApplicationArea = all; }
                field("CMMF Code"; "CMMF Code") { ApplicationArea = all; }
                field("SEB PI2 Code"; "SEB PI2 Code") { ApplicationArea = all; }
                field("SEB PI2 Description"; "SEB PI2 Description") { ApplicationArea = all; }
                field("SEB PI2 English Description"; "SEB PI2 English Description") { ApplicationArea = all; }
                field("SEB Model"; "SEB Model") { ApplicationArea = all; }
                field("Standard Cost"; "Standard Cost")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = NotEgual;
                }
                field(NotEgual; NotEgual)
                {
                    ApplicationArea = all;
                    Caption = 'Differences', comment = 'ESP="Diferencias"';
                }
                field("Rolled-up Material Cost"; "Rolled-up Material Cost") { ApplicationArea = all; }
                field("Rolled-up Capacity Cost"; "Rolled-up Capacity Cost") { ApplicationArea = all; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CalculateRollUp)
            {
                ApplicationArea = all;
                Caption = 'Calcular Costes', comment = 'ESP="Calcular Costes"';
                Image = CalculateCost;

                trigger OnAction()
                var
                    ItemCostManagement: Codeunit ItemCostManagement;
                    lblConfirm: Label '¿Desea actualizar los costes?', comment = 'ESP="¿Desea actualizar los costes?"';
                begin
                    if not Confirm(lblConfirm) then
                        exit;
                    CurrPage.SetSelectionFilter(Item);
                    CalculalateBomTree();

                    Message('Fin');
                end;

            }
        }
        area(Navigation)
        {
            action("Cost Shares")
            {
                ApplicationArea = all;
                Caption = 'Cost Shares', comment = 'ESP="Partes costes"';
                Image = CostBudget;
                Promoted = true;
                trigger OnAction()
                var
                    BOMCostShares: page "BOM Cost Shares";
                begin
                    BOMCostShares.InitItem(Rec);
                    BOMCostShares.RUN;
                end;
            }
            action("Production BOM")
            {
                ApplicationArea = all;
                Caption = 'Production BOM', comment = 'ESP="L.M. producción"';
                Image = BOM;
                Promoted = true;
                RunObject = page "Production BOM";
                RunPageLink = "No." = field("Production BOM No.");
            }
            action("Where-Used")
            {
                ApplicationArea = all;
                Caption = 'Production BOM', comment = 'ESP="Puntos-de-uso"';
                Image = "Where-Used";
                Promoted = true;
                trigger OnAction()
                var
                    ProdBOMWhereUsed: page "Prod. BOM Where-Used";
                begin
                    ProdBOMWhereUsed.SetItem(Rec, WORKDATE);
                    ProdBOMWhereUsed.RUNMODAL;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        SetFilter("CMMF Code", '<>%1', '');
    end;

    trigger OnAfterGetRecord()
    begin
        NotEgual := round(Rec."Standard Cost", 1) <> round(Rec."Rolled-up Material Cost" + Rec."Rolled-up Capacity Cost" + "Rolled-up Subcontracted Cost", 1);
    end;

    var
        Item: Record Item;
        BOMBuffer: Record "BOM Buffer" temporary;
        CalcBOMTree: Codeunit "Calculate BOM Tree";
        NotEgual: Boolean;
        MaterialCost: decimal;
        CapacityCost: Decimal;

    local procedure CalculalateBomTree()
    var
        ItemCalculate: Record Item;
    begin
        if Item.FindFirst() then
            repeat
                ItemCalculate.SETRANGE("No.", Item."No.");
                ItemCalculate.FindFirst();
                CalcBOMTree.GenerateTreeForItems(ItemCalculate, BOMBuffer, 2);
                BOMBuffer.SETRANGE("No.", Item."No.");
                BOMBuffer.FINDFIRST;
                ItemCalculate."Single-Level Material Cost" := BOMBuffer."Single-Level Material Cost";
                ItemCalculate."Single-Level Capacity Cost" := BOMBuffer."Single-Level Capacity Cost";
                ItemCalculate."Single-Level Subcontrd. Cost" := BOMBuffer."Single-Level Subcontrd. Cost";
                ItemCalculate."Single-Level Cap. Ovhd Cost" := BOMBuffer."Single-Level Cap. Ovhd Cost";
                ItemCalculate."Single-Level Mfg. Ovhd Cost" := BOMBuffer."Single-Level Mfg. Ovhd Cost";
                ItemCalculate."Rolled-up Material Cost" := BOMBuffer."Rolled-up Material Cost";
                ItemCalculate."Rolled-up Capacity Cost" := BOMBuffer."Rolled-up Capacity Cost";
                ItemCalculate."Rolled-up Subcontracted Cost" := BOMBuffer."Rolled-up Subcontracted Cost";
                ItemCalculate."Rolled-up Mfg. Ovhd Cost" := BOMBuffer."Rolled-up Mfg. Ovhd Cost";
                ItemCalculate.Modify();
            Until Item.next() = 0;
    end;
}