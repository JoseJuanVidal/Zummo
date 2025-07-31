// page 50122 "ClassPedServicio3"
// {
//     //Clasificación pedido servicio

//     PageType = List;
//     SourceTable = ClassPedServicioNivel3;
//     Caption = 'Clasificación pedido servicio';

//     layout
//     {
//         area(Content)
//         {
//             repeater(General)
//             {
//                 field(TipoPedidoNivel1_btc; TipoPedidoNivel1_btc)
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field(TipoPedidoNivel2_btc; TipoPedidoNivel2_btc)
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field(TipoPedidoNivel3_btc; TipoPedidoNivel3_btc)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(DescTipoPedidoNivel3_btc; DescTipoPedidoNivel3_btc)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }
// }
page 50122 "Temporal Cambio nivel 2"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ClassPedServicio;
    SourceTableTemporary = true;


    layout
    {
        area(Content)
        {
            group(General)
            {
                field(TipoPedidoNivel1_btc; TipoPedidoNivel1_btc)
                {
                    ApplicationArea = all;
                }
                field(TipoPedidoNivel2_btc; TipoPedidoNivel2_btc)
                {
                    ApplicationArea = all;
                    TableRelation = ClassPedServicio.TipoPedidoNivel2_btc where(TipoPedidoNivel1_btc = field(TipoPedidoNivel1_btc));
                }
                field(DestTipoPedidoServicio; DestTipoPedidoServicio)
                {
                    Caption = 'Tipo pedido servicio nivel', comment = 'ESP="Tipo pedido servicio nivel"';
                    ApplicationArea = all;
                    TableRelation = "Service Order Type";
                    trigger OnValidate()
                    begin
                        Rec.DescTipoPedidoNivel2_btc := DestTipoPedidoServicio;
                    end;
                }
                field(DestTipoPedidoServicio2; DestTipoPedidoServicio2)
                {
                    Caption = 'Tipo pedido servicio nivel 2', comment = 'ESP="Tipo pedido servicio nivel 2"';
                    ApplicationArea = all;
                    TableRelation = ClassPedServicio.TipoPedidoNivel2_btc where(TipoPedidoNivel1_btc = field(DescTipoPedidoNivel2_btc));
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Cambiar)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Change;

                trigger OnAction()
                begin
                    if not Confirm('Desea cambiar el tipo pedido de servico %1 - %2 a %3 %4', false, Rec.TipoPedidoNivel1_btc, Rec.TipoPedidoNivel2_btc,
                        DestTipoPedidoServicio, DestTipoPedidoServicio2) then
                        exit;
                    ChangeTipoPedidoServicio;
                end;
            }
        }
    }

    var
        ServiceHeader: Record "Service Header";
        ServiceOrderType: Record "Service Order Type";
        ClassPedServicio: Record ClassPedServicio;
        DestTipoPedidoServicio: code[20];
        DestTipoPedidoServicio2: code[20];
        Window: Dialog;

    local procedure ChangeTipoPedidoServicio()
    var
        Contador: Integer;
    begin
        Window.Open('Nº Pedido #1#################\Contador #2###########');
        ClassPedServicio.Get(DestTipoPedidoServicio, DestTipoPedidoServicio2);
        ServiceHeader.SetRange("Service Order Type", Rec.TipoPedidoNivel1_btc);
        ServiceHeader.SetRange(TipoPedidoNivel2_btc, Rec.TipoPedidoNivel2_btc);
        if ServiceHeader.FindFirst() then
            repeat
                Contador += 1;
                Window.Update(1, ServiceHeader."No.");
                Window.Update(2, Contador);
                ServiceHeader."Service Order Type" := DestTipoPedidoServicio;
                ServiceHeader.TipoPedidoNivel2_btc := DestTipoPedidoServicio2;
                ServiceHeader.Modify();
            Until ServiceHeader.next() = 0;
        Window.Close();
        Message('Registros cambiados %1', Contador);
    end;
}