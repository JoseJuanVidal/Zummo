page 17470 "ZM Service Item Lines Prod."
{
    Caption = 'Líneas Ped. Servicios (Prod.)', comment = 'ESP="Líneas Ped. Servicios (Prod.)"';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Service Item Line";
    SourceTableView = where("Document Type" = const(order), "Tipo Fallo localizado" = const(Manufacturing));
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Service Item Group Code"; "Service Item Group Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Service Item No."; "Service Item No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Warranty; Warranty)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Contract No."; "Contract No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Fault Reason Code"; "Fault Reason Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Fault Area Code"; "Fault Area Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Resolution Code"; "Resolution Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Fault Code"; "Fault Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Fallo; Fallo)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Fallo localizado"; "Fallo localizado")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Tipo Fallo localizado"; "Tipo Fallo localizado")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("N. Empleado Fallo"; "N. Empleado Fallo")
                {
                    ApplicationArea = all;
                }
                field("Nombre Empleado Fallo"; "Nombre Empleado Fallo")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Ficha)
            {
                ApplicationArea = all;
                Caption = 'Ficha', comment = 'ESP="Ficha"';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                ShortcutKey = 'Mayús+F7';
                trigger OnAction()
                var
                    ServiceOrder: page "Service Order";
                begin
                    ServiceHeader.SetRange("Document Type", Rec."Document Type");
                    ServiceHeader.SetRange("No.", Rec."Document No.");
                    ServiceOrder.SetTableView(ServiceHeader);
                    ServiceOrder.RunModal();

                end;
            }
        }
    }

    var
        ServiceHeader: Record "Service Header";
}