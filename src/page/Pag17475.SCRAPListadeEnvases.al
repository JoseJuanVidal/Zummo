page 17475 "SCRAP Lista de Envases"
{
    Caption = 'Lista de Envases', comment = 'ESP="Lista de Envases"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SCRAP Tipo de Envases";

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
                field(Rigidez; Rigidez)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}