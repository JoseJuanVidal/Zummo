table 50404 "STH Hist. Aseguradora"
{

    DataClassification = CustomerContent;
    Caption = 'Hist. Aseguradora', comment = 'ESP="Hist. Aseguradora"';
    DrillDownPageId = "STH Hist. Aseguradora";
    LookupPageId = "STH Hist. Aseguradora";

    fields
    {
        field(1; CustomerNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cód. Cliente', comment = 'ESP="Cód. Cliente"';
            TableRelation = Customer;
        }
        field(9; Name; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name', comment = 'ESP="Nombre"';
        }
        field(10; DateIni; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Inicial', comment = 'ESP="Fecha Inicial"';
        }
        field(20; Aseguradora; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Aseguradora Autorizado Por', comment = 'ESP="Aseguradora Autorizado Por"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Aseguradora), TipoRegistro = const(Tabla));
        }
        field(30; "Credito Maximo Aseguradora_btc"; Integer)
        {
            Caption = 'Crédito Maximo Aseguradora', Comment = 'ESP="Crédito Maximo Aseguradora"';
            DataClassification = CustomerContent;
            Description = 'Bitec';
        }
        field(40; DateFin; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Final', comment = 'ESP="Fecha Final"';
        }
        field(50; Suplemento; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Suplemento', comment = 'ESP="Suplemento"';

        }
    }

    keys
    {
        key(Key1; CustomerNo, DateIni, Aseguradora)
        {
            Clustered = true;
        }
    }

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