pageextension 50116 "PurchaseOrderList" extends "Purchase Order List"
{
    layout
    {
        addafter(Status)
        {
            field(Pendiente_btc; Pendiente_btc)
            {
                ApplicationArea = All;
            }
            field("Motivo rechazo"; "Motivo rechazo")
            {
                Caption = 'Comentario';
            }
            field("Fecha Mas Temprana"; "Fecha Mas Temprana") { }
        }
    }
}