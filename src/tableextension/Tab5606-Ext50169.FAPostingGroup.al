tableextension 50169 "FAPostingGroup" extends "FA Posting Group"  //5606
{
    fields
    {
        field(50100; PorcAmort_btc; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Depreciation %', comment = 'ESP="% Amortización"';
        }
    }
}