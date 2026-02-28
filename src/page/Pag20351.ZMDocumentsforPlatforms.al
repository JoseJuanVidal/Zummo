page 20351 "ZM Documents for Platforms"
{
    Caption = 'Documents for Platforms', comment = 'ESP="Documentos para plataformas"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM Documents for Platforms";

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
                field(Name; Name)
                {
                    ApplicationArea = all;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field(Department; Department)
                {
                    ApplicationArea = all;
                }
                field(Owner; Owner)
                {
                    ApplicationArea = all;
                }
                field(Origin; Origin)
                {
                    ApplicationArea = all;
                }
                field("Response time"; "Response time")
                {
                    ApplicationArea = all;
                }
                field("Response time Duration"; "Response time Duration")
                {
                    ApplicationArea = all;
                }
                field(State; State)
                {
                    ApplicationArea = all;
                }
                field(Mandatory; Mandatory)
                {
                    ApplicationArea = all;
                }
                field("Employee Nos."; "Employee Nos.")
                {
                    ApplicationArea = all;
                }
                field("Expired Documents"; "Expired Documents")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
