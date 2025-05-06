tableextension 50202 "ZM Misc. Article Information" extends "Misc. Article Information"
{
    fields
    {
        field(50105; "Marca"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Brand', comment = 'ESP="Marca"';
        }

        field(50100; Model; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Model', comment = 'ESP="Modelo"';
        }
        field(50110; "Employee Name"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Name', comment = 'ESP="Nombre empleado"';
        }
        field(50120; "Device Type"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Type', comment = 'ESP="Tipo dispositivo"';
            TableRelation = "ZM Misc. Article Device Type".Code where("Misc. Article Code" = field("Misc. Article Code"));
        }
        field(50130; "Sistema Operativo"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Operation System', comment = 'ESP="Sistema Operativo"';
        }
        field(50135; "Procesador"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Processor', comment = 'ESP="Procesador"';
        }
        field(50140; "HDD"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'HDD', comment = 'ESP="HDD"';
        }
        field(50145; "RAM"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'RAM', comment = 'ESP="Memoria RAM"';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }


    trigger OnAfterInsert()
    begin
        UpdateEmployeeName();
    end;

    trigger OnAfterModify()
    begin
        UpdateEmployeeName();
    end;

    trigger OnAfterRename()
    begin
        UpdateEmployeeName();
    end;

    var
        Employee: Record Employee;

    local procedure UpdateEmployeeName()

    begin
        if Employee.Get(Rec."Employee No.") then
            Rec."Employee Name" := Employee.FullName()
    end;
}