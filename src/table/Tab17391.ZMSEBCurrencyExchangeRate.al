table 17391 "ZM SEB Currency Exchange Rate"
{
    DataClassification = CustomerContent;
    Caption = 'Currency Exchange Rate', comment = 'ESP="SEB Tipo cambio divisa"';
    LookupPageId = "ZM SEB Currency Exchange Rate";
    DrillDownPageId = "ZM SEB Currency Exchange Rate";

    fields
    {
        field(2; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date', comment = 'ESP="Fecha inicial"';
        }
        field(3; "Exchange Rate Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Exchange Rate Amount', comment = 'ESP="Valor tipo cambio divisa"';
            DecimalPlaces = 4 : 4;
        }
        field(4; "G/L Budget Exchange Rate Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Budget Exchange Rate Amount', comment = 'ESP="Valor tipo cambio divisa presupuesto"';
            DecimalPlaces = 4 : 4;
        }
    }

    keys
    {
        key(PK; "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}