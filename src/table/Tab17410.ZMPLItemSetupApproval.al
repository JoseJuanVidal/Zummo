table 17410 "ZM PL Item Setup Approval"
{
    Caption = 'ZM PL Item Setup Approvals ';
    DataClassification = CustomerContent;
    LookupPageId = "ZM PL Item Setup approvals";
    DrillDownPageId = "ZM PL Item Setup approvals";

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.', Comment = 'ESP="Tabla"';
            DataClassification = CustomerContent;
            TableRelation = "Table Metadata";
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.', Comment = 'ESP="Campo"';
            DataClassification = CustomerContent;
            TableRelation = Field."No." where(TableNo = field("Table No."));

            trigger OnValidate()
            begin
                FieldNo_Validate();
            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; Obligatory; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Obligatory', comment = 'ESP="Obligatorio"';
        }
        field(10; "Department"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department', comment = 'ESP="Departamento"';
            TableRelation = "ZM PL Item Setup Department";
        }
        field(20; Rol; Enum "Rol Item Approval")
        {
            DataClassification = CustomerContent;
            Caption = 'Rol', comment = 'ESP="Perfil"';
        }
    }
    keys
    {
        key(PK; "Table No.", "Field No.", Department)
        {
            Clustered = true;
        }
    }
    var
        rField: Record Field;

    local procedure FieldNo_Validate();
    begin
        Description := '';
        if rField.Get(Rec."Table No.", Rec."Field No.") then
            Description := rField.FieldName;
    end;
}
