table 17372 "ZM HIST BOM Production"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Production BOM No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Production BOM No.', comment = 'ESP="Nº L.M. producción"';
        }
        field(2; "Period Start"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period Start', comment = 'ESP=""';
        }
        field(4; "No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.', comment = 'ESP="Nº"';
        }
        field(5; "Description"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(6; "Unit of Measure Code"; code[10]
        )
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure Code', comment = 'ESP="Cód. unidad medida"';
        }
        field(7; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity', comment = 'ESP="Cantidad"';
        }
        field(8; "Routing Link Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Routing Link Code', comment = 'ESP="Cód. conexión ruta"';
        }
        field(9; "Quantity per"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
    }

    keys
    {
        key(Key1; "Production BOM No.", "Period Start", "No.")
        {
            Clustered = true;
        }
    }

    var
        ProdBomHeader: Record "Production BOM Header";
        ProdBomLine: Record "Production BOM Line";
        Dates: Record Date;

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