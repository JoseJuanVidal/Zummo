tableextension 50124 "ProdOrderLine" extends "Prod. Order Line"  //5406
{
    fields
    {
        field(50100; FechaInicial_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date', comment = 'ESP="Fecha Inicial"';
            trigger OnValidate()
            var
                ProductionOrder: Record "Production Order";
            begin
                Rec."Starting Date" := Rec.FechaInicial_btc;
                rec."Starting Date-Time" := CreateDateTime(FechaInicial_btc, 0T);
                ProductionOrder.Get(Rec.Status, Rec."Prod. Order No.");
                ProductionOrder."Starting Date-Time" := CreateDateTime(Rec."Starting Date", 0T);
                ProductionOrder."Starting Date" := rec."Starting Date";
                ProductionOrder.Modify();
            end;
        }

        field(50101; CodCentroTrabajo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Solo se usa de forma temporal para filtrar en la matriz de centros de trabajo';
        }

        field(50102; CantidadSeguida_btc; Decimal)
        {
            Caption = 'Amount followed', comment = 'ESP="Cantidad seguida"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum ("Reservation Entry".Quantity where (
                "Item No." = field ("Item No."),
                "Source ID" = field ("Prod. Order No."),
                "Source Prod. Order Line" = field ("Line No.")
            ));
        }

        field(50103; CentroTrabajoCalculado_btc; code[20])
        {
            Editable = false;
            Caption = 'Work Center', comment = 'ESP="Centro Trabajo"';
            FieldClass = FlowField;
            CalcFormula = lookup ("Prod. Order Routing Line"."Work Center No." where ("Routing No." = field ("Routing No."), "Work Center No." = filter (<> '')));
            TableRelation = "Work Center";
        }
        modify("Routing No.")
        {

            trigger OnBeforeValidate()
            begin
                //Error('No se puede cambiar a mano');
            end;
        }
        modify("Production BOM No.")
        {
            trigger OnBeforeValidate()
            begin
                //Error('No se puede cambiar a mano');
            end;
        }
    }

}