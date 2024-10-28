page 17217 "ZM Misc. Article Device Type"
{
    PageType = List;
    Caption = 'Device Type', comment = 'ESP="Tipo Dispositivos"';
    UsageCategory = None;
    SourceTable = "ZM Misc. Article Device Type";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Misc. Article Code"; "Misc. Article Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }
}