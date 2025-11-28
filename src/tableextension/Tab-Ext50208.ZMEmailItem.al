tableextension 50208 "ZM Email Item" extends "Email Item"
{
    fields
    {
        Field(50010; "Order No"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.', comment = 'ESP="Nº Pedido"';
        }
        Field(50020; "Language Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Language code', comment = 'ESP="Cód. Divisa"';
            TableRelation = Language;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}