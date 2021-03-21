page 50013 "STH Movs Conta-Presup"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Movs. Conta-Presup', comment = 'ESP="Movs. Conta-Presup"';
    UsageCategory = Administration;
    SourceTable = "STH Movs Conta-Presup";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lineas)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 3 Code"; "Global Dimension 3 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 8 Code"; "Global Dimension 8 Code")
                {
                    ApplicationArea = all;
                }
                field(Importe; Importe)
                {
                    ApplicationArea = all;
                }
                field("Importe Presupuesto"; "Importe Presupuesto")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Carga)
            {
                ApplicationArea = All;
                Image = CreateMovement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CargarDatos();
                    Message('Carga realizada');
                end;
            }
        }
    }

    var
        myInt: Integer;
}