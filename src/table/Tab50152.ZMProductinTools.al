table 50152 "ZM Productión Tools"
{
    Caption = 'ZM Productión Tools';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; Brand; Code[50])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
        }
        field(4; Model; Code[50])
        {
            Caption = 'Model';
            DataClassification = CustomerContent;
        }
        field(5; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(6; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
        }
        field(7; "Work Center"; Code[20])
        {
            Caption = 'Work Center';
            DataClassification = CustomerContent;
        }
        field(8; "Machine Center"; Code[20])
        {
            Caption = 'Machine Center';
            DataClassification = CustomerContent;
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(10; "Purchase Date"; Date)
        {
            Caption = 'Purchase Date';
            DataClassification = CustomerContent;
        }
        field(11; Precision; Decimal)
        {
            Caption = 'Precision';
            DataClassification = CustomerContent;
        }
        field(12; "Value min."; Decimal)
        {
            Caption = 'Value min.';
            DataClassification = CustomerContent;
        }
        field(13; "Value max."; Decimal)
        {
            Caption = 'Value max.';
            DataClassification = CustomerContent;
        }
        field(14; Periodicity; DateFormula)
        {
            Caption = 'Periodicity';
            DataClassification = CustomerContent;
        }
        field(15; "Last date revision"; Date)
        {
            Caption = 'Last date revision';
            DataClassification = CustomerContent;
        }
        field(16; "Next date revision"; Date)
        {
            Caption = 'Next date revision';
            DataClassification = CustomerContent;
        }
        field(17; Obs; Blob)
        {
            Caption = 'Obs';
            DataClassification = CustomerContent;
        }
        field(20; Status; Enum ClasificacionProveedor)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(21; Resolution; Enum ClasificacionProveedor)
        {
            Caption = 'Resolution';
            DataClassification = CustomerContent;
        }
        field(30; "Direct unit cost."; Decimal)
        {
            Caption = 'Direct unit cost.';
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
