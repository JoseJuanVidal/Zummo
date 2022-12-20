tableextension 50139 "PurchInvHeader" extends "Purch. Inv. Header"  //122
{
    fields
    {
        //Guardar Nº asiento y Nº documento
        field(50100; NumAsiento_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction No.', comment = 'ESP="Nº asiento"';
        }
        //+  NORMATIVA MEDIO AMBIENTAL
        Field(50200; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic (kg)', comment = 'ESP="Plástico (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50201; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Recycled (kg)', comment = 'ESP="Plástico reciclado (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        //-  NORMATIVA MEDIO AMBIENTAL
    }
}