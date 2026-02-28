table 20350 "ZM Document Register Platforms"
{
    DataClassification = CustomerContent;
    Caption = 'Document Registration Platforms', comment = 'ESP="Registro Documentos Plataformas"';
    DrillDownPageId = "ZM Document Register Platforms";
    LookupPageId = "ZM Document Register Platforms";


    fields
    {
        field(1; "Customer No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.', comment = 'ESP="Cód. Cliente"';
            TableRelation = Customer;
        }
        field(2; "Document Code"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document Code', comment = 'ESP="Codigo Documento"';
            TableRelation = "ZM Documents for Platforms";
        }
        field(3; "Employee No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.', comment = 'ESP="Nº Empleado"';
            TableRelation = Employee;
        }
        field(10; "Platform PRL"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Platform PRL', comment = 'ESP="Plataforma PRL"';
        }
        field(11; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha Registro"';
        }
        field(12; "Last Modified Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Modified Date', comment = 'ESP="Fecha ult. actulización"';
        }
        field(13; "First Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'First Due Date', comment = 'ESP="Primera fecha Vencimiento"';
        }
        field(15; "Expiration Warning"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Expiration Warning', comment = 'ESP="Aviso Caducidad"';
        }
        field(50; "Customer Name"; text[100])
        {
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup(customer.Name where("No." = field("Customer No.")));
            Editable = false;
        }
        field(60; Description; text[100])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM Documents for Platforms".Name where(Code = field("Document Code")));
            Editable = false;
        }
        field(70; "Employee Name"; text[250])
        {
            Caption = 'Employee Name', comment = 'ESP="Nombre empleado"';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("Employee No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Customer No.", "Document Code", "Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

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