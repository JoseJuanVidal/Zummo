tableextension 50204 "ZM Service Order Type" extends "Service Order Type"
{
    fields
    {
        field(50100; "Exportar BI Reclamaciones"; Boolean)
        {
            Caption = 'Exportar BI Reclamaciones';
            DataClassification = ToBeClassified;
        }
        field(50110; "Solucionado primera visista"; Boolean)
        {
            Caption = 'Solucionado primera visista';
            DataClassification = ToBeClassified;
        }
    }
}
