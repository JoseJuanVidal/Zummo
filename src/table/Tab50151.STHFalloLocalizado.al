table 50151 "STH Fallo Localizado"
{
    DataClassification = CustomerContent;
    LookupPageId = "STH Fallo Localizado";
    DrillDownPageId = "STH Fallo Localizado";

    fields
    {
        field(1; FalloLocalizado; code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fallo Localizado', comment = 'ESP="Fallo Localizado"';
        }
        field(2; InformeMejora; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Informe Mejora', comment = 'ESP="Informe Mejora"';
        }
        field(3; "Descripción"; text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripción', comment = 'ESP="Descripción"';
        }
        field(10; Fallo; code[20])
        {
            Caption = 'Fallo', comment = 'ESP="Fallo"';
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(Tabla), TipoTabla = const(motivoCalibracion));
        }
    }

    keys
    {
        key(PK; fallo, FalloLocalizado)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; FalloLocalizado, InformeMejora, "Descripción")
        {

        }
        fieldgroup(Brick; FalloLocalizado, InformeMejora, "Descripción")
        { }
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

    procedure NavigateServiceItemLine()
    var
        ServiceItemLine: Record "Service Item Line";
    begin
        ServiceItemLine.Reset();
        ServiceItemLine.SetRange(Fallo, Rec.Fallo);
        ServiceItemLine.SetRange("Fallo localizado", Rec.FalloLocalizado);
        Page.RunModal(0, ServiceItemLine);

    end;

}