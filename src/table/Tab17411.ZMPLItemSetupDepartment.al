table 17411 "ZM PL Item Setup Department"
{
    DataClassification = CustomerContent;
    Caption = 'Item Setup Department', comment = 'ESP="Config. Departamentos Alta Prod."';
    LookupPageId = "ZM PL Item Setup Depart. List";
    DrillDownPageId = "ZM PL Item Setup Depart. List";

    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(10; Email; text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Email', comment = 'ESP="Email"';
        }
        field(12; "User Id"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User Id', comment = 'ESP="Cód. Usuario"';
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if Rec."User Id" = '' then
                    exit;
                User.SetRange("User Name", Rec."User Id");
                User.FindFirst();
            end;
        }
        field(20; "Notification Purchase Prices"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Notification Purchase Prices', comment = 'ESP="Notificación Precios compra"';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    var
        User: Record User;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}