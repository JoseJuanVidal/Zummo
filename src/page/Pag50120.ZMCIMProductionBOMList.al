page 50120 "ZM CIM Production BOM List"
{
    Caption = 'CIM Prod. BOM list', Comment = 'ESP="L.M. de producción"';
    PageType = List;
    SourceTable = "ZM CIM Prod. BOM Header";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Description 2"; "Description 2")

                {
                    ApplicationArea = all;
                }
                field("Search Name"; "Search Name")

                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Low-Level Code"; "Low-Level Code")
                {
                    ApplicationArea = all;
                }
                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = all;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = all;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field("Version Nos."; "Version Nos.")
                {
                    ApplicationArea = all;
                }
            }
            part(Lines; "ZM CIM Production BOM Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Production BOM No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }
}
