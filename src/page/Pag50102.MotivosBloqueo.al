page 50102 "MotivosBloqueo"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = MotivosBloqueo;
    Caption = 'Blocking Motives List', comment = 'ESP="Lista Motivos Bloqueo"';
    DataCaptionFields = CodBloqueo_btc, Descripcion_btc;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(CodBloqueo_btc; CodBloqueo_btc)
                {
                    ApplicationArea = All;
                }

                field(Descripcion_btc; Descripcion_btc) { ApplicationArea = All; }
            }
        }
    }
}