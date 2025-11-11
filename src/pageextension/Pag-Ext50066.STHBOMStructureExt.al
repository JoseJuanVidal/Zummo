pageextension 50066 "STH BOM StructureExt" extends "BOM Structure"
{
    layout
    {
        addafter(ItemFilter)
        {
            field(LanguageFilter; LanguageFilter)
            {
                Caption = 'Language Filter', comment = 'Filtro Idioma';
                TableRelation = Language;

                trigger OnValidate()
                begin
                    Rec.SetRange("Language Filter", LanguageFilter);
                    CurrPage.Update();
                end;
            }
        }
        addafter(Description)
        {
            field("Description Language"; "Description Language")
            {
                ApplicationArea = all;
            }
            field(GTIN; GTIN)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("CMMF Code"; "CMMF Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Recycled plastic %"; "Recycled plastic %")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Packing Plastic Qty. (kg)"; "Packing Plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Packing Recycled plastic (kg)"; "Packing Recycled plastic (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Packing Recycled plastic %"; "Packing Recycled plastic %")
            {
                ApplicationArea = all;
                Visible = false;
            }

            field(Steel; Steel)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Carton; Carton)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Wood; Wood)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Costing Method"; "Costing Method")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Item Unit Cost"; "Item Unit Cost")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Standar Cost"; "Standar Cost")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Average cost last year"; "Average cost last year")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("SubCategory Code"; "SubCategory Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("Show Warnings")
        {
            action(ExportExcel)
            {
                ApplicationArea = all;
                Caption = 'Exportar EXCEL', comment = 'ESP="Exportar EXCEL"';
                Image = Excel;
                // Promoted = true;
                // PromotedCategory = New;

                trigger OnAction()
                begin
                    ExportExcel;
                end;

            }
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
    }
    var
        xlBuf: Record "Excel Buffer" temporary;
        LanguageFilter: code[10];

    local procedure CalculatePlastic()
    var
        Item: Record Item;
        Funciones: Codeunit Funciones;
        lblConfirm: Label '¿Desea calcular la cantidad del plastico de la L.M. del producto %1?', comment = '¿Desea calcular la cantidad del plastico de la L.M. del producto %1?';
    begin
        if Rec.Type in [Rec.Type::Item] then
            if Item.Get(Rec."No.") then
                if Confirm(lblConfirm, false, Rec."No.") then
                    Funciones.PlasticCalculateItem(Item);
    end;

    local procedure ExportExcel()
    var
        Bold: Boolean;
        Space: text;
        CosteEstandar: Decimal;
        Costeavg: Decimal;
        CosteUnit: Decimal;
        CosteLM: Decimal;
    begin
        Rec.FindFirst();
        xlBuf.AddColumn('Estructura de productos', FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.NewRow;
        xlBuf.AddColumn(COMPANYNAME, FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.NewRow;

        xlBuf.AddColumn(Rec.FIELDCAPTION(Indentation), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION(Type), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION("No."), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION(Description), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION("Qty. per Top Item"), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION("Unit of Measure Code"), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION("Replenishment System"), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION("Standar Cost"), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION("Average cost last year"), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION("Unit Cost"), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn('Coste de LM', FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION(GTIN), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
        xlBuf.AddColumn(Rec.FIELDCAPTION("CMMF Code"), FALSE, '', TRUE, FALSE, FALSE, '', xlBuf."Cell Type"::Text);

        xlBuf.NewRow;
        IF Rec.FINDFIRST THEN
            REPEAT
                Rec.CalcFields("Standar Cost", "Item Unit Cost");
                CosteEstandar := 0;
                Costeavg := 0;
                CosteUnit := 0;
                CosteLM := 0;
                case Rec."Replenishment System" of
                    Rec."Replenishment System"::Purchase, Rec."Replenishment System"::Transfer:
                        begin
                            CosteEstandar := Rec."Standar Cost";
                            Costeavg := Rec."Average cost last year";
                            CosteUnit := Rec."Item Unit Cost";
                            Bold := false;
                        end;
                    else begin
                        CosteLM := Rec."Standar Cost";
                        Bold := true;
                    end;
                end;
                Space := PadStr(' ', Rec.Indentation * 4);
                xlBuf.AddColumn(Rec.Indentation, FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Number);
                xlBuf.AddColumn(StrSubstNo('%1%2', Space, Rec.Type), FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
                xlBuf.AddColumn(StrSubstNo('%1%2', Space, Rec."No."), FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
                xlBuf.AddColumn(Rec.Description, FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
                xlBuf.AddColumn(Rec."Qty. per Top Item", FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Number);
                xlBuf.AddColumn(Rec."Unit of Measure Code", FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
                xlBuf.AddColumn(Rec."Replenishment System", FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
                xlBuf.AddColumn(CosteEstandar, FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Number);
                xlBuf.AddColumn(Costeavg, FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Number);
                xlBuf.AddColumn(CosteUnit, FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Number);
                xlBuf.AddColumn(CosteLM, FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Number);
                xlBuf.AddColumn(Rec.GTIN, FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
                xlBuf.AddColumn(Rec."CMMF Code", FALSE, '', Bold, FALSE, FALSE, '', xlBuf."Cell Type"::Text);
                xlBuf.NewRow;
            UNTIL Rec.NEXT = 0;
        xlBuf.CreateBook('', 'Estructura');
        xlBuf.WriteSheet('', '', '');
        xlBuf.CloseBook;
        xlBuf.DownloadAndOpenExcel;
    end;
}
