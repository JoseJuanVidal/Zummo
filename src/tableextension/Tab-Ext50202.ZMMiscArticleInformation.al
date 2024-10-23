tableextension 50202 "ZM Misc. Article Information" extends "Misc. Article Information"
{
    fields
    {

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