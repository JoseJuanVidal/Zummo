page 50009 "STH Fallo Localizado Card"
{

    Caption = 'Fallo Localizado Card';
    PageType = Card;
    SourceTable = "STH Fallo Localizado";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Fallo; Fallo)
                {
                    ApplicationArea = all;
                }
                field(FalloLocalizado; Rec.FalloLocalizado)
                {
                    ToolTip = 'Specifies the value of the Fallo Localizado field.', Comment = 'ESP="Fallo Localizado"';
                    ApplicationArea = All;
                }
                field("Descripción"; Rec."Descripción")
                {
                    ToolTip = 'Specifies the value of the Descripción field.', Comment = 'ESP="Descripción"';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(InformeMejora; Rec.InformeMejora)
                {
                    ToolTip = 'Specifies the value of the Informe Mejora field.', Comment = 'ESP="Informe Mejora"';
                    ApplicationArea = All;
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
