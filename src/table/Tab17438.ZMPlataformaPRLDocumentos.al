table 17438 "ZM Plataforma PRL Documentos"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(2; Description; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(3; type; Option)
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
            OptionMembers = " ",Employee;
            OptionCaption = ' ,Employee', comment = 'ESP="Personas"';
        }
        field(4; "Department"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department', comment = 'ESP="Departamento"';
            TableRelation = MultiRRHH_zum.Codigo where(tabla = const(Departamentos));
        }
        field(5; "Owner User"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Owner User', comment = 'ESP="Usuario propietario"';
            TableRelation = User."User Name";
        }
        field(6; Origin; Option)
        {
            Caption = 'Origin', comment = 'ESP="Origen"';
            OptionMembers = Customer,Vendor;
            OptionCaption = 'Customer,Vendor', comment = 'ESP="Clientes,Proveedor"';
        }
        field(7; Mandatory; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Mandatory', comment = 'ESP="Obligatorio"';
        }
        field(8; "Number of employees"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of employees', comment = 'ESP="Nº Empleados"';
        }
        field(9; "Expired Doc. Nos."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Expired Doc. Nos.', comment = 'ESP="Nº Doc. caducados"';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {

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