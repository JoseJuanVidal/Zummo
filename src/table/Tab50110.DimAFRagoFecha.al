table 50110 "DimAFRagoFecha"
{
    DataClassification = CustomerContent;
    Caption = 'FA Dimension by Date', comment = 'ESP="Dimensión AF Rango fechas"';
    LookupPageId = "Dimensión AF por fecha";
    DrillDownPageId = "Dimensión AF por fecha";

    fields
    {
        field(1; CodActivo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FA No.', comment = 'ESP="Nº Activo"';
            TableRelation = "Fixed Asset";
        }

        field(2; CodDimension; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Code', comment = 'ESP="Cód. Dimensión"';
            TableRelation = Dimension;
        }

        field(3; FechaInicio; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date', comment = 'ESP="Fecha Inicio"';
        }

        field(4; FechaFin; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date', comment = 'ESP="Fecha Fin"';
        }

        field(5; ValorDimension; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Value Code', comment = 'ESP="Cód. Valor Dimensión"';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD(CodDimension));
        }
    }

    keys
    {
        key(PK; CodActivo, CodDimension, FechaInicio)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestNoSolapamiento();

        TestField(CodDimension);
        testfield(FechaInicio);
        TestField(CodActivo);
    end;

    trigger OnModify()
    begin
        TestNoSolapamiento();
    end;

    local procedure TestNoSolapamiento()
    var
        recDimFecha: record DimAFRagoFecha;
        errorLbl: Label 'You must close the previous interval for this dimension before creating a new interval',
            comment = 'ESP="Debe cerrar el intervalo anterior para esta dimensión antes de crear un nuevo intervalo"';
    begin
        recDimFecha.Reset();
        recDimFecha.SetRange(CodActivo, CodActivo);
        recDimFecha.SetRange(CodDimension, CodDimension);
        recDimFecha.SetFilter(FechaInicio, '<=%1', FechaInicio);
        recDimFecha.SetFilter(FechaFin, '>=%1|%2', FechaInicio, 0D);
        if recDimFecha.FindFirst() and (recDimFecha.RecordId <> RecordId) then
            error(errorLbl);
    end;

    procedure CambiaDimensiones(pFecha: date; var recActivoFijo: Record "Fixed Asset")
    var
        recDimActivoFijo: Record DimAFRagoFecha;
        recDefaultDimension: Record "Default Dimension";
    begin
        recDimActivoFijo.Reset();
        recDimActivoFijo.SetRange(CodActivo, recActivoFijo."No.");
        recDimActivoFijo.SetFilter(FechaInicio, '<=%1', pFecha);
        recDimActivoFijo.SetFilter(FechaFin, '>=%1|%2', pFecha, 0D);
        if not recDimActivoFijo.IsEmpty then begin
            recDefaultDimension.Reset();
            recDefaultDimension.SetRange("Table ID", Database::"Fixed Asset");
            recDefaultDimension.SetRange("No.", recActivoFijo."No.");
            if recDefaultDimension.FindFirst() then
                recDefaultDimension.DeleteAll();

            recDimActivoFijo.Reset();
            recDimActivoFijo.SetRange(CodActivo, recActivoFijo."No.");
            recDimActivoFijo.SetFilter(FechaInicio, '<=%1', pFecha);
            recDimActivoFijo.SetFilter(FechaFin, '>=%1|%2', pFecha, 0D);
            if recDimActivoFijo.FindSet() then
                repeat
                    if not recDefaultDimension.Get(Database::"Fixed Asset", recActivoFijo."No.", recDimActivoFijo.CodDimension) then begin
                        recDefaultDimension.Init();

                        recDefaultDimension.Validate("Table ID", Database::"Fixed Asset");
                        recDefaultDimension.Validate("No.", recActivoFijo."No.");
                        recDefaultDimension.Validate("Dimension Code", recDimActivoFijo.CodDimension);
                        recDefaultDimension.Validate("Dimension Value Code", recDimActivoFijo.ValorDimension);

                        recDefaultDimension.Insert(true);
                    end;
                until recDimActivoFijo.Next() = 0;
        end;

        if recActivoFijo.Next() <> 0 then
            CambiaDimensiones(pFecha, recActivoFijo);
    end;
}