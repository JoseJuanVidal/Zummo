table 50123 "STH Sales Header Aux"
{
    Caption = 'STH Sales Header Aux';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.', Comment = 'ESP="Venta-a Nº"';
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            DataClassification = CustomerContent;
        }
        field(3; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name', Comment = 'ESP="Venta-a Nombre"';
            DataClassification = CustomerContent;
        }
        field(4; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2', Comment = 'ESP="Venta-a Nombre 2"';
            DataClassification = CustomerContent;
        }
        field(5; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address', Comment = 'ESP="Venta-a Dirección"';
            DataClassification = CustomerContent;
        }
        field(6; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2', Comment = 'ESP="Venta-a Dirección 2"';
            DataClassification = CustomerContent;
        }
        field(7; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City', Comment = 'ESP="Venta-a Ciudad"';
            DataClassification = CustomerContent;
        }
        field(8; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact', Comment = 'ESP="Venta-a Contacto"';
            DataClassification = CustomerContent;
        }
        field(9; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code', Comment = 'ESP="Venta-a Código Postal"';
            DataClassification = CustomerContent;
        }
        field(10; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County', Comment = 'ESP="Venta-a País"';
            DataClassification = CustomerContent;
        }
        field(11; "Probability"; Option)
        {
            Caption = 'Probability', Comment = 'ESP="Probabilidad"';
            // DataClassification = CustomerContent;
            OptionCaption = ' ,Baja,Media,Alta';
            OptionMembers = " ","Baja","Media","Alta";
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code', Comment = 'ESP="Cód. Divisa"';
            DataClassification = CustomerContent;
        }
        field(13; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name', Comment = 'ESP="Nombre dirección de envío"';
            DataClassification = CustomerContent;
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2', Comment = 'ESP="Nombre dirección de envío 2"';
            DataClassification = CustomerContent;
        }
        field(15; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address', Comment = 'ESP="Dirección de envío"';
            DataClassification = CustomerContent;
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2', Comment = 'ESP="Dirección de envío 2"';
            DataClassification = CustomerContent;
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City', Comment = 'ESP="Población dirección de envío"';
            DataClassification = CustomerContent;
        }
        field(18; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code', Comment = 'ESP="Cód. términos de pago"';
            DataClassification = CustomerContent;
        }
        field(19; Amount; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
            DataClassification = CustomerContent;
        }
        field(20; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT', Comment = 'ESP="Importe IVA incl."';
            DataClassification = CustomerContent;
        }
        field(21; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code', Comment = 'ESP="Fact. a-C.P."';
            DataClassification = CustomerContent;
        }
        field(22; "Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County', Comment = 'ESP="Fact. a-Provincia"';
            DataClassification = CustomerContent;
        }
        field(23; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code', Comment = 'ESP="Fact. a-Cód. país/región"';
            DataClassification = CustomerContent;
        }
        field(24; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code', Comment = 'ESP="C.P. dirección de envío"';
            DataClassification = CustomerContent;
        }
        field(25; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County', Comment = 'ESP="Provincia dirección de envío"';
            DataClassification = CustomerContent;
        }
        field(26; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code', Comment = 'ESP="Cód. país/región dirección de envío"';
            DataClassification = CustomerContent;
        }
        field(27; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code', Comment = 'ESP="Cód. transportista"';
            DataClassification = CustomerContent;
        }
        field(28; "Invoice Discount Amount"; Decimal)
        {
            Caption = 'Invoice Discount Amount', Comment = 'ESP="Importe descuento factura"';
            DataClassification = CustomerContent;
        }
        field(29; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date', Comment = 'ESP="Fecha entrega requerida"';
            DataClassification = CustomerContent;
        }
        field(30; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name', Comment = 'ESP="Fact. a-Nombre"';
            DataClassification = CustomerContent;
        }
        field(31; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address', Comment = 'ESP="Fact. a-Dirección"';
            DataClassification = CustomerContent;
        }
        field(32; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2', Comment = 'ESP="Fact. a-Dirección 2"';
            DataClassification = CustomerContent;
        }
        field(33; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City', Comment = 'ESP="Fact. a-Población"';
            DataClassification = CustomerContent;
        }
        field(34; "Invoice Discount"; Decimal)
        {
            Caption = 'Invoice Discount', Comment = 'ESP="Importe descuento"';
            DataClassification = CustomerContent;
        }
        field(50; "Status"; Option)
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
            // DataClassification = CustomerContent;
            OptionCaption = ' ,Finalizad,Error';
            OptionMembers = " ","Finalizada","Error";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
