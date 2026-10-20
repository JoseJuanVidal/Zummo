table 17301 "ZM PDM History"
{
    // Versiones y transiciones de flujo de un documento aprobado del PDM
    Caption = 'PDM History', comment = 'ESP="Histórico PDM"';
    DataClassification = CustomerContent;
    LookupPageId = "ZM PDM History";
    DrillDownPageId = "ZM PDM History";

    fields
    {
        field(1; "Document ID"; Integer)
        {
            Caption = 'Document ID', comment = 'ESP="ID Documento"';
            DataClassification = CustomerContent;
            TableRelation = "ZM PDM Document";
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type', comment = 'ESP="Tipo"';
            DataClassification = CustomerContent;
            OptionMembers = Version,Transition;
            OptionCaption = 'Version,Transition', comment = 'ESP="Versión,Transición"';
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.', comment = 'ESP="Nº"';
            DataClassification = CustomerContent;
        }
        field(10; Version; Integer)
        {
            Caption = 'Version', comment = 'ESP="Versión"';
            DataClassification = CustomerContent;
        }
        field(11; "Date"; DateTime)
        {
            Caption = 'Date', comment = 'ESP="Fecha"';
            DataClassification = CustomerContent;
        }
        field(12; "User Name"; Text[50])
        {
            Caption = 'User Name', comment = 'ESP="Usuario"';
            DataClassification = CustomerContent;
        }
        field(13; Transition; Text[100])
        {
            Caption = 'Transition', comment = 'ESP="Transición"';
            DataClassification = CustomerContent;
        }
        field(14; "To Status"; Text[50])
        {
            Caption = 'To Status', comment = 'ESP="A estado"';
            DataClassification = CustomerContent;
        }
        field(15; Approval; Boolean)
        {
            Caption = 'Approval', comment = 'ESP="Aprobación"';
            DataClassification = CustomerContent;
        }
        field(16; Comment; Text[250])
        {
            Caption = 'Comment', comment = 'ESP="Comentario"';
            DataClassification = CustomerContent;
        }
        field(17; "PDM Code"; Text[100])
        {
            Caption = 'PDM Code', comment = 'ESP="Código PDM"';
            DataClassification = CustomerContent;
        }
        field(18; Revision; Text[10])
        {
            Caption = 'Revision', comment = 'ESP="Revisión"';
            DataClassification = CustomerContent;
        }
        field(20; "File Name"; Text[250])
        {
            Caption = 'File Name', comment = 'ESP="Nombre fichero"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM PDM Document"."File Name" where("Document ID" = field("Document ID")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document ID", "Entry Type", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Date") { }
    }
}
