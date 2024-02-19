table 50134 "ZM CIM Prod. BOM Header"
{
    Caption = 'CIM Production BOM List', comment = 'ESP="CIM L.M. de producción"';
    LookupPageId = "ZM CIM Production BOM List";
    DrillDownPageId = "ZM CIM Production BOM List";
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';

            trigger OnValidate()
            begin
                "Search Name" := Description;
            end;
        }
        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2', Comment = 'ESP="Descripción 2"';
        }
        field(12; "Search Name"; Code[100])
        {
            Caption = 'Search Name', Comment = 'ESP="Alias"';
        }
        field(21; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code', Comment = 'ESP="Cód. unidad medida"';
        }
        field(22; "Low-Level Code"; Integer)
        {
            Caption = 'Low-Level Code', Comment = 'ESP="Cód. nivel más bajo"';
        }
        field(40; "Creation Date"; Date)
        {
            Caption = 'Creation Date', Comment = 'ESP="Fecha creación"';
        }
        field(43; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified', Comment = 'ESP="Fecha últ. modificación"';
        }
        field(45; Status; Option)
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
            OptionCaption = 'New,Certified,Under Development,Closed', Comment = 'ESP="Nueva,Certificada,En desarrollo,Cerrada"';
            OptionMembers = New,Certified,"Under Development",Closed;

        }
        field(50; "Version Nos."; Code[20])
        {
            Caption = 'Version Nos.', Comment = 'ESP="Nos. versión"';
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; Description)
        {
        }
        key(Key4; Status)
        {
        }
    }
    trigger OnDelete()
    begin
        ZMCIMProdBOMLine.Reset();
        ZMCIMProdBOMLine.SetRange("Production BOM No.", Rec."No.");
        ZMCIMProdBOMLine.DeleteAll();
    end;

    var
        ZMCIMProdBOMLine: Record "ZM CIM Prod. BOM Line";
}