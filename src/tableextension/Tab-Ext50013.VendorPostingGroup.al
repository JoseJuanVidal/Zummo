tableextension 50013 "Vendor Posting Group" extends "Vendor Posting Group"
{
    fields
    {
        field(50000; "Gen. Business Posting Group"; Code[20])
        {
            Caption = 'Gen. Business Posting Group', Comment = 'ESP="Grupo registro negocio gen."';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
        }
    }
}
