table 17392 "ZM Order mail Register"
{
    DataClassification = CustomerContent;
    Caption = 'Order mail Register', comment = 'ESP="Registro envío Pedido"';
    LookupPageId = "ZM Order mail Registers";
    DrillDownPageId = "ZM Order mail Registers";


    fields
    {
        field(1; "Order No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.', comment = 'ESP="Nª Pedido"';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', comment = 'ESP="Nº Línea"';
        }
        field(5; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha Registro"';
        }
        field(10; "User ID"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID', comment = 'ESP="ID Usuario"';
        }
        field(12; "Employee No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.', comment = 'ESP="Cód. Empleado"';
            TableRelation = Employee;
        }
        field(20; "Date-Time Sent"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date-Time Sent', comment = 'ESP="Fecha-Hora envío"';
        }
        field(30; Subject; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Subject', comment = 'ESP="Asunto"';
        }
        field(40; Receipts; text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Receipts', comment = 'ESP="Para"';
        }
    }

    keys
    {
        key(PK; "Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        PurchOrdermailRegister: Record "ZM Order mail Register";
        AutLoginMgt: Codeunit "AUT Login Mgt.";

    trigger OnInsert()
    begin
        Rec."Employee No." := AutLoginMgt.GetEmpleado();
        Rec."User ID" := copystr(UserId, 1, MaxStrLen(Rec."User ID"));
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


    procedure AddSentRegister(PurchaseHeader: Record "Purchase Header"; Receipts: text; Subject: Text)
    var
        LineNo: Integer;
    begin
        PurchOrdermailRegister.Reset();
        PurchOrdermailRegister.SetRange("Order No.", PurchaseHeader."No.");
        if PurchOrdermailRegister.FindLast() then
            LineNo := PurchOrdermailRegister."Line No." + 10000
        else
            LineNo := 10000;
        PurchOrdermailRegister.Init();
        PurchOrdermailRegister."Order No." := PurchaseHeader."No.";
        PurchOrdermailRegister."Line No." := LineNo;
        PurchOrdermailRegister."Posting Date" := WorkDate();
        PurchOrdermailRegister."Date-Time Sent" := CurrentDateTime();
        PurchOrdermailRegister.Subject := CopyStr(Subject, 1, MaxStrLen(PurchOrdermailRegister.Subject));
        PurchOrdermailRegister.Receipts := CopyStr(Receipts, 1, MaxStrLen(PurchOrdermailRegister.Receipts));
        PurchOrdermailRegister.Insert(true);
    end;
}