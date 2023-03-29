page 17204 "Hist. Reclamaciones ventas"
{
    ApplicationArea = All;
    Caption = 'Hist. Reclamaciones ventas';
    PageType = List;
    SourceTable = "ZM Hist. Reclamaciones ventas";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Cod. Categoria"; Rec."Cod. Categoria")
                {
                    ApplicationArea = All;
                }
                field(Familia; Rec.Familia)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                }
                field("Grupo Clientes"; Rec."Grupo Clientes")
                {
                    ApplicationArea = All;
                }
                field("Cantidad Ventas"; Rec."Cantidad Ventas")
                {
                    ApplicationArea = All;
                }
                field("Fallo localizado"; Rec."Fallo localizado")
                {
                    ApplicationArea = All;
                }
                field(Incidencia; Rec.Incidencia)
                {
                    ApplicationArea = All;
                }

                field("Tipo Reclamaciones"; Rec."Tipo Reclamaciones")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
