tableextension 50006 "STH Purchase Price" extends "Purchase Price"
{
    fields
    {
        field(50000; "Process No."; Code[20])
        {
            Caption = 'Process No.', Comment = 'ESP="Cód. proceso"';
            DataClassification = CustomerContent;
        }
        field(50001; "Process Description"; Text[100])
        {
            Caption = 'Process Description', Comment = 'ESP="Descrip. proceso"';
            DataClassification = CustomerContent;
        }

    }
}
