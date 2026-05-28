tableextension 50190 "ZM Ext Country/Region" extends "Country/Region"
{
    fields
    {
        field(17200; "Cuota Objetivo"; Decimal)
        {
            Caption = 'Cuota Objetivo';
            DataClassification = ToBeClassified;
        }
        field(17201; "Pais ABC"; Text[3])
        {
            Caption = 'Pais ABC';
            DataClassification = ToBeClassified;
        }
        field(50100; "ID RAES"; Text[100])
        {
            Caption = 'ID RAES';
            DataClassification = ToBeClassified;
        }
        field(50101; "ID PILAS"; Text[100])
        {
            Caption = 'ID PILAS';
            DataClassification = ToBeClassified;
        }
        field(50110; Zona; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Zona', comment = 'ESP="Zona"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Zona), TipoRegistro = const(Tabla));
        }

        field(50112; "Gen. Bus. Posting Group"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Gen. Bus. Posting Group', comment = 'ESP="Grupo registro neg. gen."';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50114; "VAT Bus. Posting Group"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Bus. Posting Group', comment = 'ESP="Grupo registro IVA neg."';
            TableRelation = "VAT Business Posting Group";
        }
        field(50115; "Customer Posting Group"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Posting Group', comment = 'ESP="Grupo registro cliente"';
            TableRelation = "Customer Posting Group";
        }
        field(50116; "Vendor Posting Group"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Posting Group', comment = 'ESP="Grupo registro proveedor"';
            TableRelation = "Vendor Posting Group";
        }
    }
}
