table 17418 "ZM Item Approval Department"
{
    Caption = 'Item Approval Department';
    DataClassification = CustomerContent;
    LookupPageId = "Item Approval Departments";
    DrillDownPageId = "Item Approval Departments";

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.', Comment = 'ESP="Tabla"';
            DataClassification = CustomerContent;
            TableRelation = "Table Metadata";
        }
        field(2; "GUID Creation"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'State Creation', comment = 'ESP="Estado Alta"';
            Editable = false;
        }

        field(3; "Request Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Request Date', comment = 'ESP="Fecha Respuesta"';
            Editable = false;
        }
        field(10; "Department"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department', comment = 'ESP="Departamento"';
            TableRelation = "ZM PL Item Setup Department";
        }
        field(20; "Codigo Empleado"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Codigo Empleado', comment = 'ESP="Codigo Empleado"';
        }
    }
    keys
    {
        key(PK; "Table No.", Department, "GUID Creation")
        {
            Clustered = true;
        }
    }
}
