page 17428 "Item Approval Departments"
{
    PageType = List;
    Caption = 'Item Approval Departments', comment = 'ESP="Aprobaciones departamento"';
    UsageCategory = None;
    SourceTable = "ZM Item Approval Department";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lista)
            {
                field(Department; Department)
                {
                    ApplicationArea = All;
                    Style = Attention;
                    StyleExpr = ApplyStyle;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = all;
                    Style = Attention;
                    StyleExpr = ApplyStyle;
                }
                field("Codigo Empleado"; "Codigo Empleado")
                {
                    ApplicationArea = all;
                }
                field("Table No."; "Table No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Style = Attention;
                    StyleExpr = ApplyStyle;
                }
                field("GUID Creation"; "GUID Creation")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Style = Attention;
                    StyleExpr = ApplyStyle;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ApplyStyle := Rec."Request Date" = 0D;
    end;

    var
        ApplyStyle: Boolean;


}