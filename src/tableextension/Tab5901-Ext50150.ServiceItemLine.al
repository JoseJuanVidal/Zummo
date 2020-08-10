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
            CalcFormula = lookup ("Service Item".CodAnterior_btc where("No." = field("Service Item No.")));
        }

    }
}