page 50015 "STH Fallo Localizado"
{
    Caption = 'Fallo Localizado', comment = 'ESP="Fallo Localizado"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "STH Fallo Localizado";
    CardPageId = "STH Fallo Localizado Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Fallo; Fallo)
                {
                    ApplicationArea = all;
                }
                field(FalloLocalizado; FalloLocalizado)
                {
                    ApplicationArea = All;
                }
                field(InformeMejora; InformeMejora)
                {
                    ApplicationArea = all;
                }
                field("Descripción"; "Descripción")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ServiceItemLine)
            {
                ApplicationArea = all;
                Caption = 'Líneas pedido servicio', comment = 'ESP="Líneas pedido servicio"';
                Image = ServiceLines;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.NavigateServiceItemLine;
                end;
            }
        }
    }
}