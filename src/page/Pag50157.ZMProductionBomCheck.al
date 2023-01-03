page 50157 "ZM Production Bom Check"
{
    PageType = ListPart;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Item Tracing Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                Caption = 'Lines', comment = 'ESP="Líneas"';
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Production Bom No.', comment = 'ESP="Nº Lista materiales"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupDownBom;
                    end;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = all;
                    Caption = 'Description', comment = 'ESP="Descripción"';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    Caption = 'Quantity per', comment = 'ESP="Cantidad por"';
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = all;
                    Caption = 'Unit of Measure Code', comment = 'ESP="Cód. Unidad medida"';
                }
            }
        }
    }

    var
        ProductionBomHeader: Record "Production BOM Header";
        ProductionBomLine: Record "Production BOM Line";

    procedure UpdateBom(ItemNo: code[20])
    var
        LineNo: Integer;
    begin
        Rec.DeleteAll();
        ProductionBomLine.Reset();
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        ProductionBomLine.SetRange("No.", ItemNo);
        if ProductionBomLine.FindFirst() then
            repeat
                LineNo += 1;
                ProductionBomHeader.Get(ProductionBomLine."Production BOM No.");
                Rec.Init();
                Rec."Line No." := LineNo;
                Rec."Item No." := ProductionBomLine."Production BOM No.";
                Rec."Item Description" := ProductionBomHeader.Description;
                Rec.Quantity := ProductionBomLine."Quantity per";
                Rec."Source No." := ProductionBomLine."Unit of Measure Code";
                Rec.Insert();
            Until ProductionBomLine.next() = 0;

        Rec.FindFirst();
    end;

    local procedure LookupDownBom()
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOM: page "Production BOM";
    begin
        ProductionBOMHeader.Reset();
        ProductionBOMHeader.SetRange("No.", Rec."Item No.");
        ProductionBOM.SetTableView(ProductionBOMHeader);
        ProductionBOM.RunModal();
    end;
}