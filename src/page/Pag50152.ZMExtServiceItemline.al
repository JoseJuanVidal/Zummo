page 50152 "ZM Ext Service Item line"
{
    PageType = List;
    Caption = 'Service Item line', comment = 'ESP="Líneas Pedido Servicio"';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Service Item Line";
    SourceTableView = where("Document Type" = const(Order));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Service Item No."; "Service Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("Service Item Group Code"; "Service Item Group Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = all;
                }
                field(CodAnterior_btc; CodAnterior_btc)
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
                    Visible = false;
                }
                field("Repair Status Code"; "Repair Status Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Warranty; Warranty)
                {
                    ApplicationArea = all;
                }
                field(AmpliacionGarantia_sth; AmpliacionGarantia_sth)
                {
                    ApplicationArea = all;
                }
                field(FechaFinGarantia_sth; FechaFinGarantia_sth)
                {
                    ApplicationArea = all;
                }
                field(Fecharecepaviso_sth; Fecharecepaviso_sth)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Resolution Code"; "Resolution Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Response Time (Hours)"; "Response Time (Hours)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Response Date"; "Response Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Fault Code"; "Fault Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Fallo; Fallo)
                {
                    ApplicationArea = all;
                }
                field("Fallo localizado"; "Fallo localizado")
                {
                    ApplicationArea = all;
                }
                field("Fault Reason Code"; "Fault Reason Code")
                {
                    ApplicationArea = all;
                }
                field("Informe Mejora"; "Informe Mejora")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Description Header"; "Description Header")
                {
                    ApplicationArea = all;
                }
                field("Responsability Center"; "Responsability Center")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = all;
                }
                field("Ship-to City"; "Ship-to City")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}