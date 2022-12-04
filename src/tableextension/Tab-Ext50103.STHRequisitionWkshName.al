tableextension 50103 "STHRequisitionWkshName" extends "Requisition Wksh. Name"
{
    fields
    {
        Field(50100; "STHUseCalcPersonalizado"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Usar Calculo Balance', comment = 'ESP="Usar Calculo Balance"';
        }
        Field(50101; "STHUseLocationGroup"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Usar Agrup. Almacenes', comment = 'ESP="Usar Agrup. Almacenes"';
        }
        field(50102; STHNoEvaluarPurchase; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'No Contemplar Ped. Compra', comment = 'ESP="No Contemplar Ped. Compra"';
        }
        field(50104; ZMQuoteAssemblyLine; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Contemplar lineas emsamblado ofertas', comment = 'ESP="Contemplar lineas emsamblado ofertas"';
        }
    }
}