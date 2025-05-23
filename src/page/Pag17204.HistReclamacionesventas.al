page 17204 "Hist. Reclamaciones ventas"
{
    ApplicationArea = All;
    Caption = 'Hist. Reclamaciones ventas';
    PageType = List;
    SourceTable = "ZM Hist. Reclamaciones ventas";
    UsageCategory = Lists;
    //Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;

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
                field("Sales Date"; "Sales Date")
                {
                    ApplicationArea = all;
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
                field("Clasif Ventas"; "Clasif Ventas")
                {
                    ApplicationArea = all;
                }
                field("Des Clasif Ventas"; "Des Clasif Ventas")
                {
                    ApplicationArea = all;
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
                field(Fallo; Fallo)
                {
                    ApplicationArea = all;
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
    actions
    {
        area(Processing)
        {
            action(cargarhojafallos)
            {
                ApplicationArea = all;
                Caption = 'Actualizar Reclamacion BI', comment = 'ESP="Actualizar Reclamacion BI"';
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;

                trigger OnAction()
                var
                    HistFallos: Record "ZM Hist. Reclamaciones ventas";
                begin
                    HistFallos.CreateHistReclamaciones(0D);
                end;
            }
            action(UpdateDocument)
            {
                ApplicationArea = all;
                Caption = 'Actualizar Documento', comment = 'ESP="Actualizar Documento"';
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;

                trigger OnAction()
                var
                    HistFallos: Record "ZM Hist. Reclamaciones ventas";
                    ServiceHeader: Record "Service Header";
                begin
                    case HistFallos.Type of
                        HistFallos.Type::"Pedidos Servicio":
                            begin
                                if ServiceHeader.Get(ServiceHeader."Document Type"::Order, HistFallos."Document No.") then
                                    HistFallos.UpdateServiceOrder(ServiceHeader);
                            end;

                    end;
                end;
            }
        }
    }
}
