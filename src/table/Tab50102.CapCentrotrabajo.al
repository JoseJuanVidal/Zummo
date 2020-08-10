table 50102 "CapCentrotrabajo"
{
    DataClassification = ToBeClassified;
    Caption = 'Capacity per work center', comment = 'ESP="Capacidad por centro trabajo"';
    DrillDownPageId = CapacidadCentrosTrabajo;
    LookupPageId = CapacidadCentrosTrabajo;

    fields
    {
        field(1; CodCentro; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Center No.', comment = 'ESP="Cód. Centro Trabajo"';
            TableRelation = "Work Center";
        }

        field(2; CodProducto; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. Producto"';
            TableRelation = Item;
        }

        field(3; NumOrdenesFab; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of manufacturing orders', comment = 'ESP="Nº Ordenes fabricación"';
        }

        field(4; NumPersonas; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of persons', comment = 'ESP="Nº Personas"';
        }

        field(5; NombreCentro; Text[50])
        {
            Caption = 'Work Center Name', comment = 'ESP="Nombre centro trabajo"';
            FieldClass = FlowField;
            CalcFormula = lookup ("Work Center".Name where("No." = field(CodCentro)));
            Editable = false;
        }

        field(6; DescProducto; Text[100])
        {
            Caption = 'Item Description', comment = 'ESP="Descripción producto"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup (Item.Description where("No." = field(CodProducto)));
        }
    }

    keys
    {
        key(PK; CodCentro, CodProducto, NumPersonas)
        {
            Clustered = true;
        }
    }
}