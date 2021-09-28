tableextension 50150 "ServiceItemLine" extends "Service Item Line"  //5901
{
    //Clasificación pedido servicio

    fields
    {

        field(50100; CodProdFallo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. with fail', comment = 'ESP="Prod. con fallo"';
            TableRelation = Item."No.";
        }

        field(50110; NumCiclos_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Num Ciclos', comment = 'ESP="Num Ciclos"';
        }
        field(50120; CodAnterior_btc; Code[20])
        {
            Caption = 'Cod.Anterior', comment = 'ESP="Cod.Anterior"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Item".CodAnterior_btc where("No." = field("Service Item No.")));
        }
        field(50200; AmpliacionGarantia_sth; Boolean)
        {
            FieldClass = FlowField;
            Caption = 'Ampliacion Garantia', comment = 'ESP="Ampliación Garantía"';
            //.PeriodoAmplacionGarantica_sth
            CalcFormula = exist("Service Item" where("No." = field("Service Item No."), PeriodoAmplacionGarantica_sth = filter(<> '')));
            Editable = false;
        }
        field(50201; FechaFinGarantia_sth; Date)
        {
            Caption = 'Fecha final Garantia', comment = 'ESP="Fecha final Garantía"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Item"."Warranty Ending Date (Parts)" where("No." = field("Service Item No.")));

        }
        field(50202; "Fallo localizado"; text[80])
        {
            Caption = 'Fallo localizado', comment = 'ESP="Fallo localizado"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(FalloLocalizado), TipoRegistro = const(Tabla));
        }
        field(50203; "Desc. Fallo"; text[100])
        {
            Caption = 'Desc. Fallo localizado', comment = 'ESP="Desc. Fallo localizado"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(FalloLocalizado), NumReg = field("Fallo localizado")));
        }
    }
}