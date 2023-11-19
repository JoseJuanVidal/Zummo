page 17445 "ZM Daily Time AF"
{
    Caption = 'AF Partes Diario', comment = 'ESP="AF Partes Diario"';
    PageType = List;
    SourceTable = "ZM Daily Time Activo Fjjo";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
