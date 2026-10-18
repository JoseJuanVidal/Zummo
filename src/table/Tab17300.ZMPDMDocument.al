table 17300 "ZM PDM Document"
{
    // Documento aprobado del PDM SolidWorks (copia de lectura, se rellena desde la sincronización)
    Caption = 'PDM Document', comment = 'ESP="Documento PDM"';
    DataClassification = CustomerContent;
    LookupPageId = "ZM PDM Documents";
    DrillDownPageId = "ZM PDM Documents";

    fields
    {
        field(1; "Document ID"; Integer)
        {
            Caption = 'Document ID', comment = 'ESP="ID Documento"';
            DataClassification = CustomerContent;
        }
        field(2; "File Name"; Text[250])
        {
            Caption = 'File Name', comment = 'ESP="Nombre fichero"';
            DataClassification = CustomerContent;
        }
        field(3; Extension; Text[20])
        {
            Caption = 'Extension', comment = 'ESP="Extensión"';
            DataClassification = CustomerContent;
        }
        field(4; Folder; Text[250])
        {
            Caption = 'Folder', comment = 'ESP="Carpeta"';
            DataClassification = CustomerContent;
        }
        field(10; "PDM Code"; Text[100])
        {
            Caption = 'PDM Code', comment = 'ESP="Código PDM"';
            DataClassification = CustomerContent;
        }
        field(11; Description; Text[250])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(12; "Description ENG"; Text[250])
        {
            Caption = 'Description ENG', comment = 'ESP="Descripción inglés"';
            DataClassification = CustomerContent;
        }
        field(13; "Description FRA"; Text[250])
        {
            Caption = 'Description FRA', comment = 'ESP="Descripción francés"';
            DataClassification = CustomerContent;
        }
        field(14; Revision; Text[10])
        {
            Caption = 'Revision', comment = 'ESP="Revisión"';
            DataClassification = CustomerContent;
        }
        field(15; Machine; Text[50])
        {
            Caption = 'Machine', comment = 'ESP="Máquina"';
            DataClassification = CustomerContent;
        }
        field(16; Material; Text[100])
        {
            Caption = 'Material', comment = 'ESP="Material"';
            DataClassification = CustomerContent;
        }
        field(17; Weight; Text[30])
        {
            Caption = 'Weight', comment = 'ESP="Peso"';
            DataClassification = CustomerContent;
        }
        field(18; Modification; Text[250])
        {
            Caption = 'Modification', comment = 'ESP="Modificación"';
            DataClassification = CustomerContent;
        }
        field(20; "Approved Version"; Integer)
        {
            Caption = 'Approved Version', comment = 'ESP="Versión aprobada"';
            DataClassification = CustomerContent;
        }
        field(21; "Approval Date"; DateTime)
        {
            Caption = 'Approval Date', comment = 'ESP="Fecha aprobación"';
            DataClassification = CustomerContent;
        }
        field(22; "Approval User"; Text[50])
        {
            Caption = 'Approval User', comment = 'ESP="Usuario aprobación"';
            DataClassification = CustomerContent;
        }
        field(23; "Approved By"; Text[50])
        {
            Caption = 'Approved By', comment = 'ESP="Aprobado por"';
            DataClassification = CustomerContent;
        }
        field(24; "Latest Version"; Integer)
        {
            Caption = 'Latest Version', comment = 'ESP="Última versión"';
            DataClassification = CustomerContent;
        }
        field(25; "Current Status"; Text[50])
        {
            Caption = 'Current Status', comment = 'ESP="Estado actual"';
            DataClassification = CustomerContent;
        }
        field(26; "In Modification"; Boolean)
        {
            Caption = 'In Modification', comment = 'ESP="En modificación"';
            DataClassification = CustomerContent;
        }
        field(27; Obsolete; Boolean)
        {
            Caption = 'Obsolete', comment = 'ESP="Obsoleto"';
            DataClassification = CustomerContent;
        }
        field(30; "Last Sync"; DateTime)
        {
            Caption = 'Last Sync', comment = 'ESP="Última sincronización"';
            DataClassification = CustomerContent;
        }
        field(40; "No. of Items"; Integer)
        {
            Caption = 'No. of Items', comment = 'ESP="Nº productos"';
            FieldClass = FlowField;
            CalcFormula = count("ZM PDM Item Link" where("Document ID" = field("Document ID")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document ID")
        {
            Clustered = true;
        }
        key(Key2; "PDM Code") { }
    }

    trigger OnDelete()
    var
        PDMHistory: Record "ZM PDM History";
        PDMItemLink: Record "ZM PDM Item Link";
    begin
        PDMHistory.SetRange("Document ID", "Document ID");
        PDMHistory.DeleteAll();
        PDMItemLink.SetCurrentKey("Document ID");
        PDMItemLink.SetRange("Document ID", "Document ID");
        PDMItemLink.DeleteAll();
    end;
}
