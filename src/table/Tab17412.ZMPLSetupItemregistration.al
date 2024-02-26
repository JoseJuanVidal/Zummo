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

}