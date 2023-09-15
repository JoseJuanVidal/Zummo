page 17548 "ZM CIM Items BOM"
{
    Caption = 'Estructura de L.M.', comment = 'ESP="Estructura de L.M."';
    PageType = Worksheet;
    UsageCategory = None;
    SourceTable = "BOM Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                Caption = 'Lines', comment = 'ESP="Líneas"';
                ShowAsTree = true;
                IndentationColumn = Rec.Indentation;

                field(Indentation; Indentation)
                {
                    ApplicationArea = all;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = IsParentExpr;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = IsParentExpr;
                }
                field("Low-Level Code"; "Low-Level Code")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = All;
                }
                field("Qty. per Parent"; "Qty. per Parent")
                {
                    ApplicationArea = All;
                }
                field("Qty. per Top Item"; "Qty. per Top Item")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Replenishment System"; "Replenishment System")
                {
                    ApplicationArea = All;
                }
                field("Lead-Time Offset"; "Lead-Time Offset")
                {
                    ApplicationArea = All;
                }
                field("Safety Lead Time"; "Safety Lead Time")
                {
                    ApplicationArea = All;
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        clear(FuncionesFabricacion);
        FuncionesFabricacion.InitBomItem(Rec, ItemFilter);
        CurrPage.Update();

    end;

    trigger OnAfterGetRecord()
    begin
        IsParentExpr := NOT Rec."Is Leaf";
    end;

    var
        FuncionesFabricacion: Codeunit FuncionesFabricacion;
        ItemFilter: code[20];
        IsParentExpr: Boolean;

    procedure InitItem(ItemNo: code[20])
    begin
        ItemFilter := ItemNo;
    end;
}