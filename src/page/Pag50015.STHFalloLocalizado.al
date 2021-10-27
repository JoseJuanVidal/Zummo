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
}