table 50152 "ZM Productión Tools"
{
    Caption = 'ZM Productión Tools';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(3; Brand; Code[50])
        {
            Caption = 'Brand', Comment = 'ESP="Marca"';
            DataClassification = CustomerContent;
        }
        field(4; Model; Code[50])
        {
            Caption = 'Model', Comment = 'ESP="Modelo"';
            DataClassification = CustomerContent;
        }
        field(5; "Serial No."; Code[50])
        {
            Caption = 'Serial No.', Comment = 'ESP="Nº Serie"';
            DataClassification = CustomerContent;
        }
        field(6; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.', Comment = 'ESP="Cód. proveedor"';
            DataClassification = CustomerContent;
        }
        field(7; "Work Center"; Code[20])
        {
            Caption = 'Work Center', Comment = 'ESP="Centro trabajo"';
            DataClassification = CustomerContent;
            TableRelation = "Work Center";
        }
        field(8; "Machine Center"; Code[20])
        {
            Caption = 'Machine Center', Comment = 'ESP="Centro maquina"';
            DataClassification = CustomerContent;
            TableRelation = "Machine Center";
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
            DataClassification = CustomerContent;
        }
        field(10; "Purchase Date"; Date)
        {
            Caption = 'Purchase Date', Comment = 'ESP="Fecha compra"';
            DataClassification = CustomerContent;
        }
        field(11; Precision; Decimal)
        {
            Caption = 'Precision', Comment = 'ESP="Precisión"';
            DataClassification = CustomerContent;
        }
        field(12; "Value min."; Decimal)
        {
            Caption = 'Value min.', Comment = 'ESP="Valor min."';
            DataClassification = CustomerContent;
        }
        field(13; "Value max."; Decimal)
        {
            Caption = 'Value max.', Comment = 'ESP="Valor max."';
            DataClassification = CustomerContent;
        }
        field(14; Periodicity; DateFormula)
        {
            Caption = 'Periodicity', Comment = 'ESP="Periodicidad"';
            DataClassification = CustomerContent;
        }
        field(15; "Last date revision"; Date)
        {
            Caption = 'Last date revision', Comment = 'ESP="Ult. fecha revisión"';
            DataClassification = CustomerContent;
        }
        field(16; "Next date revision"; Date)
        {
            Caption = 'Next date revision', Comment = 'ESP="Fecha siguiente revisión"';
            DataClassification = CustomerContent;
        }
        field(17; Comments; Blob)
        {
            Caption = 'Commments', Comment = 'ESP="Comentarios"';
            DataClassification = CustomerContent;
        }
        field(20; Status; Enum "ZM State production tools")
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
            DataClassification = CustomerContent;
        }
        field(21; Resolution; Enum "ZM Production tools resolution")
        {
            Caption = 'Resolution', Comment = 'ESP="Resolución"';
            DataClassification = CustomerContent;
        }
        field(30; "Direct unit cost."; Decimal)
        {
            Caption = 'Direct unit cost.', Comment = 'ESP="Coste Directo"';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
