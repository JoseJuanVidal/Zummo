page 17206 "ZM Hist. BOM Costs list"
{
    ApplicationArea = All;
    Caption = 'Hist. BOM Costs list', Comment = 'ESP="Lista Hist. BOM Costes"';
    PageType = List;
    SourceTable = "ZM Hist. BOM Costs";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("BOM Item No."; Rec."BOM Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Nº"; Rec."Item Nº")
                {
                    ApplicationArea = All;
                }
                field(Periodo; Rec.Periodo)
                {
                    ApplicationArea = All;
                }
                field("Period Start"; "Period Start")
                {
                    ApplicationArea = all;
                }
                field(Descripcion; Rec.Descripcion)
                {
                    ApplicationArea = All;
                }
                field("Cantidad en BOM"; Rec."Cantidad en BOM")
                {
                    ApplicationArea = All;
                }
                field("Coste Periodo"; Rec."Coste Periodo")
                {
                    ApplicationArea = All;
                }
                field("Importe por maquina"; Rec."Importe por maquina")
                {
                    ApplicationArea = All;
                }
                field("Tipo coste"; Rec."Tipo coste")
                {
                    ApplicationArea = All;
                }
                field("Coste estandar"; Rec."Coste estandar")
                {
                    ApplicationArea = All;
                }
                field("Coste unitario"; Rec."Coste unitario")
                {
                    ApplicationArea = All;
                }
                field(Proveedor; Rec.Proveedor)
                {
                    ApplicationArea = All;
                }
                field("Nombre Proveedor"; Rec."Nombre Proveedor")
                {
                    ApplicationArea = All;
                }
                field("Ultimo proveedor"; Rec."Ultimo proveedor")
                {
                    ApplicationArea = All;
                }
                field("Nombre Ult. Proveedor"; Rec."Nombre Ult. Proveedor")
                {
                    ApplicationArea = All;
                }
                field("Ultima Fecha de compra"; Rec."Ultima Fecha de compra")
                {
                    ApplicationArea = All;
                }
                field("Ultimo pedido"; Rec."Ultimo pedido")
                {
                    ApplicationArea = All;
                }
                field("Ultimo precio de compra"; Rec."Ultimo precio de compra")
                {
                    ApplicationArea = All;
                }

                field(Familia; Rec.Familia)
                {
                    ApplicationArea = All;
                }
                field(Categoria; Rec.Categoria)
                {
                    ApplicationArea = All;
                }
                field(SubCategoria; Rec.SubCategoria)
                {
                    ApplicationArea = All;
                }
                field("Parent BOM No."; "Parent BOM No.")
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
            action(Cargar)
            {
                ApplicationArea = All;
                Caption = 'Cargar', comment = 'ESP="Cargar"';
                Image = ImportCodes;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.UpdateTableBOMCosts();
                end;
            }
            action(CargarLM)
            {
                ApplicationArea = All;
                Caption = 'Cargar L.M. Producción', comment = 'ESP="Cargar L.M. Producción"';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    HISTBOMProduction: Record "ZM HIST BOM Production";
                begin
                    HISTBOMProduction.UpdateBomHist();
                end;
            }
            action(ActualizarItem)
            {
                ApplicationArea = All;
                Caption = 'Actualizar datos productos', comment = 'ESP="Actualizar datos productos"';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    HISTBOMProduction: Record "ZM HIST BOM Production";
                begin
                    Rec.UpdateTableBOMCosts();
                end;
            }
        }
        area(Navigation)
        {
            action(LMProduction)
            {
                ApplicationArea = All;
                Caption = 'L.M. Producción', comment = 'ESP="L.M. Producción"';
                Image = BOMLedger;
                RunObject = page "ZM HIST BOM Productions";

            }
        }

    }
}
