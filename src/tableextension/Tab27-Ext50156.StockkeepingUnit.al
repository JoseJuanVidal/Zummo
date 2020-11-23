tableextension 50156 "Stockkeeping Unit" extends "Stockkeeping Unit"  //27
{
    fields
    {
        field(50002; "QtyonQuotesOrder"; Decimal)
        {
            Editable = false;
            Caption = 'Cant. en ofertas de venta', comment = 'ESP="Cant. en ofertas de venta"';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = const(Quote), FechaFinValOferta_btc = filter('>=t'),
            "Location Code" = field("Location Code"), Type = const(Item), "No." = field("Item No.")));
            TableRelation = "Sales Line";
            trigger OnLookup()
            var
                salesLine: Record "Sales Line";
                PSalesLine: Page "Sales Lines";
            begin
                salesLine.reset;
                salesLine.SetRange("Document Type", salesLine."Document Type"::Quote);
                salesLine.SetFilter("Outstanding Quantity", '>0');
                salesLine.SetRange("No.", Rec."Item No.");
                salesLine.SetFilter(FechaFinValOferta_btc, '>=t');
                salesLine.SetFilter("Outstanding Quantity", '<>0');
                PSalesLine.SetTableView(salesLine);
                PSalesLine.Run();
            end;
        }
        field(50001; "Ordenacion"; Integer)
        {
            Editable = false;
            Caption = 'Ordenacion', comment = 'ESP="Ordenacion"';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Ordenacion_btc where("Code" = field("Location Code")));
            TableRelation = "Sales Line";
        }
        field(50013; "Cant_ componentes Oferta"; Decimal)
        {
            Editable = false;
            Caption = 'Cant. componentes Oferta', comment = 'ESP="Cant. componentes Oferta"';
            FieldClass = FlowField;
            CalcFormula = sum("Assembly Line"."Remaining Quantity" where("Document Type" = const(Quote), type = const(Item), "No." = field("Item No."), "Location Code" = field("Location Code"), "Fecha Fin Oferta_btc" = filter('>=t')
            , Type = const(Item), "No." = field("Item No.")));
            TableRelation = "Assembly Line";

            trigger OnLookup()
            var
                AssemblyLine: Record "Assembly Line";
                PAssemblyLine: Page "Assembly Lines";
            begin
                AssemblyLine.reset;
                AssemblyLine.SetRange("Document Type", AssemblyLine."Document Type"::Quote);
                AssemblyLine.SetFilter("Remaining Quantity", '>0');
                AssemblyLine.SetRange("No.", Rec."Item No.");
                AssemblyLine.SetRange("Location Code", Rec."Location Code");
                AssemblyLine.SetFilter("Remaining Quantity", '<>0');
                AssemblyLine.SetFilter("Fecha Fin Oferta_btc", '>=t');
                PAssemblyLine.SetTableView(AssemblyLine);
                PAssemblyLine.Run();
            end;
        }
    }
}