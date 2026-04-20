table 17412 "ZM PL Setup Item registration"
{
    DataClassification = CustomerContent;
    Caption = 'Product registration Setup', comment = 'ESP="Configuración Alta de productos"';

    fields
    {
        field(1; "Primary Key"; code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Active email queue"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active email queue', comment = 'ESP="Activar cola envío email"';
        }
        field(3; "Frequency of reminders"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Frequency of reminders', comment = 'ESP="Periodicidad recordatorios"';
        }
        field(10; "Temporary Nos."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Temporary Nos.', comment = 'ESP="Nº serie temporal"';
            TableRelation = "No. Series";
        }
        field(15; "Last process date"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Last process date', comment = 'ESP="Ultima fecha proceso"';
            Editable = false;
        }
        field(20; "Enabled Approval Price List"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enabled Approval Price List', comment = 'ESP="Aprobación Lista de precios activada"';
        }
        field(30; "Max. Digits Item No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. Digits Item No.', comment = 'ESP="Max. Digitos Cód. producto"';
        }
        field(40; "Max. Digits Item Desc."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. Digits Item Desc.', comment = 'ESP="Max. Digitos Desc. producto"';
        }
        field(100; "First Department"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Primer Departamento lanzamiento', comment = 'ESP="Primer Departamento lanzamiento"';
            TableRelation = "ZM PL Item Setup Department".Code;
        }
        field(110; "Last Department"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ultimo Departamento lanzamiento', comment = 'ESP="Ultimo Departamento lanzamiento"';
            TableRelation = "ZM PL Item Setup Department".Code;
        }
        field(200; "OAuth Request Archive"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'OAuth Request Archive', comment = 'ESP="OAuth Archivo Solicitud"';
            TableRelation = "ZM OAuth 2.0 Application".Code;
        }
        field(210; "OAuth Request Arch. Folder"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'OAuth Request Archive Folder', comment = 'ESP="OAuth Carpeta Archivo Solicitud"';
            TableRelation = "ZM OAuth20Application Folders".Code where("Application Code" = field("OAuth Request Archive"));
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

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

    var
        Item: Record Item;
        lblMaxLength: Label 'Custom settings do not allow more than %1 characters.', comment = 'ESP="Por Configuración personalizada no está permitido mas de %1 Caracteres."';

    procedure ProcessSendNoticeEmailPendingdata()
    var
        SetupItemReg: Record "ZM PL Setup Item registration";
    begin
        // enviar aviso por email de los datos pendientes
        SetupItemReg.Get();
        if CreateDateTime(workdate(), time()) > SetupItemReg."Last process date" then begin
            SetupItemReg."Last process date" := CreateDateTime(workdate(), time());
            SetupItemReg.Modify();
        end;

    end;

    procedure GetSetupRegActiveApproval(): Boolean;
    var
        myInt: Integer;
    begin
        if Rec.Get() then
            exit(Rec."Enabled Approval Price List");
    end;


    procedure CheckMaxLengthItemNo(ItemNo: code[20])
    begin
        if not Rec.Get() then
            exit;
        if Rec."Max. Digits Item No." = 0 then
            exit;
        if StrLen(ItemNo) > Rec."Max. Digits Item No." then
            Error(lblMaxLength, Rec."Max. Digits Item No.");
    end;

    procedure CheckMaxLengthItemDescription(ItemDesc: text)
    begin
        if not Rec.Get() then
            exit;
        if Rec."Max. Digits Item Desc." = 0 then
            exit;
        if StrLen(ItemDesc) > Rec."Max. Digits Item Desc." then
            Error(lblMaxLength, Rec."Max. Digits Item Desc.");
    end;
}