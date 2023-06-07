tableextension 50020 "ZM Ext Return Receipt Header" extends "Return Receipt Header"  //6660
{
    fields
    {
        field(65110; "Requiere acciones correctivas"; Boolean)
        {
            Caption = 'Requiere acciones correctivas', Comment = 'ESP="Requiere acciones correctivas"';
            DataClassification = CustomerContent;
        }
        field(50105; "Sell-to Search Name"; code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Search Name', comment = 'ESP="Venta a-Alias"';
            Editable = false;
        }
        //+  NORMATIVA MEDIO AMBIENTAL
        Field(50250; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic (kg)', comment = 'ESP="Plástico (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50251; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Recycled (kg)', comment = 'ESP="Plástico reciclado (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50252; "Plastic Date Declaration"; Date)
        {
            Caption = 'Plastic Date Declaration', comment = 'ESP="Fecha Declaración plástico"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //-  NORMATIVA MEDIO AMBIENTAL
    }
}
