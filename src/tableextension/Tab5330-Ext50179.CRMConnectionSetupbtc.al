tableextension 50179 "CRM Connection Setup_btc" extends "CRM Connection Setup"  // 5330
{

    fields
    {
        field(50100; "NºSerie Lead CRM"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Leads CRM Serial No.', comment = 'ESP="NºSerie Lead CRM"';
            TableRelation = "No. Series";
            ValidateTableRelation = true;
        }
        field(50101; "Vendedor Defecto CRM"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Default Salesperson No.', comment = 'ESP="Vendedor defecto CRM"';
            TableRelation = "Salesperson/Purchaser";
            ValidateTableRelation = true;
        }
    }
}