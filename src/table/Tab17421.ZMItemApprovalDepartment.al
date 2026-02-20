table 17421 "ZM Item Approval Department"
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
        field(2; "Request No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Request No.', Comment = 'ESP="Nº Solicitud"';
            Editable = false;
            TableRelation = "ZM PL Items Temporary";
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
        field(30; Name; text[250])
        {
            Caption = 'Name', comment = 'ESP="Nombre"';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("Codigo Empleado")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Table No.", Department, "Request No.")
        {
            Clustered = true;
        }
    }
    var
        ItemApprovalDepartment: Record "ZM Item Approval Department";
        ItemSetupApproval: Record "ZM PL Item Setup Approval";

    procedure CreateRequestDepartment(ItemsTemporary: Record "ZM PL Items Temporary")
    var
        RefRecord: RecordRef;
    begin
        RefRecord.GetTable(ItemsTemporary);
        DeleteAllItemApprovalDepartment(ItemsTemporary, RefRecord);
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetRange(Requester, false);
        // ItemSetupApproval.SetRange("Field No.", 0);
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Approval, ItemSetupApproval.Rol::Both);
        if ItemSetupApproval.FindFirst() then
            repeat
                ItemApprovalDepartment.Reset();
                ItemApprovalDepartment.SetRange("Table No.", RefRecord.Number);
                ItemApprovalDepartment.SetRange(Department, ItemSetupApproval.Department);
                ItemApprovalDepartment.SetRange("Request No.", ItemsTemporary."No.");
                if not ItemApprovalDepartment.FindFirst() then begin
                    ItemApprovalDepartment.Init();
                    ItemApprovalDepartment."Table No." := RefRecord.Number;
                    ItemApprovalDepartment.Department := ItemSetupApproval.Department;
                    ItemApprovalDepartment."Request No." := ItemsTemporary."No.";
                    ItemApprovalDepartment.Insert();
                end;
            until ItemSetupApproval.Next() = 0;
    end;

    local procedure DeleteAllItemApprovalDepartment(ItemsTemporary: Record "ZM PL Items Temporary"; RefRecord: RecordRef)
    var
        myInt: Integer;
    begin
        ItemApprovalDepartment.Reset();
        ItemApprovalDepartment.SetRange("Table No.", RefRecord.Number);
        ItemApprovalDepartment.SetRange("Request No.", ItemsTemporary."No.");
        ItemApprovalDepartment.DeleteAll();
    end;
}
