table 17426 "SCRAP SUBMATERIAL"
{
    DataClassification = CustomerContent;
    Caption = 'SUBMATERIAL', comment = 'ESP="SUBMATERIAL"';
    LookupPageId = "SCRAP SUBMATERIAL List";
    DrillDownPageId = "SCRAP SUBMATERIAL List";

    fields
    {
        field(1; Code; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Código', comment = 'ESP="Código"';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}