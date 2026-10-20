table 17302 "ZM PDM Item Link"
{
    // Relación producto BC <-> documento PDM. Se calcula en la sincronización con los códigos
    // de cada aprobación del documento (código exacto, o base + "-X" para las variantes de color)
    Caption = 'PDM Item Link', comment = 'ESP="Relación producto PDM"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.', comment = 'ESP="Nº producto"';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(2; "Document ID"; Integer)
        {
            Caption = 'Document ID', comment = 'ESP="ID Documento"';
            DataClassification = CustomerContent;
            TableRelation = "ZM PDM Document";
        }
        field(10; "PDM Code"; Text[100])
        {
            Caption = 'PDM Code', comment = 'ESP="Código PDM"';
            DataClassification = CustomerContent;
        }
        field(11; "Approved Version"; Integer)
        {
            Caption = 'Approved Version', comment = 'ESP="Versión aprobada"';
            DataClassification = CustomerContent;
        }
        field(12; Revision; Text[10])
        {
            Caption = 'Revision', comment = 'ESP="Revisión"';
            DataClassification = CustomerContent;
        }
        field(13; "Approval Date"; DateTime)
        {
            Caption = 'Approval Date', comment = 'ESP="Fecha aprobación"';
            DataClassification = CustomerContent;
        }
        field(14; "Approved By"; Text[50])
        {
            Caption = 'Approved By', comment = 'ESP="Aprobado por"';
            DataClassification = CustomerContent;
        }
        field(15; Extension; Text[20])
        {
            Caption = 'Extension', comment = 'ESP="Extensión"';
            DataClassification = CustomerContent;
        }
        field(16; "Current"; Boolean)
        {
            // el código sigue siendo el vigente del documento (si no, ha sido sustituido por otra revisión)
            Caption = 'Current', comment = 'ESP="Vigente"';
            DataClassification = CustomerContent;
        }
        field(17; "In Modification"; Boolean)
        {
            Caption = 'In Modification', comment = 'ESP="En modificación"';
            DataClassification = CustomerContent;
        }
        field(18; Main; Boolean)
        {
            // documento que se muestra en la ficha del producto (plano > ensamblaje > pieza > resto)
            Caption = 'Main', comment = 'ESP="Principal"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Document ID")
        {
            Clustered = true;
        }
        key(Key2; "Document ID") { }
    }
}
