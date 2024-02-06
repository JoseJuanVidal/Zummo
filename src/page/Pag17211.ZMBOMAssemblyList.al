page 17211 "ZM BOM Assembly List"
{
    Caption = 'BOM Componente', comment = 'ESP="Componetes ensamblado"';
    PageType = List;
    ApplicationArea = none;
    UsageCategory = Administration;
    SourceTable = "BOM Component";


    layout
    {
        area(Content)
        {
            repeater("BOM Component")
            {
                Caption = 'BOM Componente', comment = 'ESP="Componetes ensamblado"';
                field("Parent Item No."; "Parent Item No.")
                {
                    ApplicationArea = all;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Quantity per"; "Quantity per")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}