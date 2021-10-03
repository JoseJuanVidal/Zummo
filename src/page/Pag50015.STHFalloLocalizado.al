page 50015 "STH Fallo Localizado"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "STH Fallo Localizado";

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