page 17419 "ZM BCD Travel Posted Inv Head."
{
    PageType = List;
    Caption = 'BCD Travel Posted Invoice Headers', comment = 'ESP="BCD Travel Hist. Facturas"';
    // ApplicationArea = All;
    UsageCategory = none;
    SourceTable = "ZM BCD Travel Invoice Header";
    SourceTableView = where(Status = const(Cerrado));
    CardPageId = "ZM BCD Travel Invoice Header";
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Nro_Albarán"; "Nro_Albarán")
                {
                    ApplicationArea = All;
                }
                field("Fecha Albarán"; "Fecha Albarán")
                {
                    ApplicationArea = all;
                }
                field(Descripcion; Descripcion)
                {
                    ApplicationArea = all;
                }
                field("Cod. Centro Coste"; "Cod. Centro Coste")
                {
                    ApplicationArea = all;
                }
                field("Fec Inicio Srv"; "Fec Inicio Srv")
                {
                    ApplicationArea = all;
                }
                field("Fec Fin Srv"; "Fec Fin Srv")
                {
                    ApplicationArea = all;
                }
                field("Ciudad Destino"; "Ciudad Destino")
                {
                    ApplicationArea = all;
                }

                field("Cod Empleado"; "Cod Empleado")
                {
                    ApplicationArea = all;
                }
                field("Nombre Empleado"; "Nombre Empleado")
                {
                    ApplicationArea = all;
                }
                field(Total_Base; Total_Base)
                {
                    ApplicationArea = All;
                }
                field(Total_Impuesto; Total_Impuesto)
                {
                    ApplicationArea = All;
                }
                field(Total; Total)
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
            action(Close)
            {
                ApplicationArea = all;
                Caption = 'Abrir Factura', comment = 'ESP="Abrir Factura"';
                Image = Close;
                Promoted = true;
                trigger OnAction()
                begin
                    CloseInvoice();
                end;
            }
        }
    }


    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";
        lblConfirmGet: Label 'Do you want to update invoices from %1 to %2?', comment = 'ESP="¿Desea actualziar las facturas desde %1 a %2?"';


    local procedure CloseInvoice()
    var
        lblConfirm: Label '¿Do you want to Open the invoice to the history?', comment = 'ESP="¿Desea Abrir la factura al histórico?"';
    begin
        Rec.TestField(Status, Status::Cerrado);
        if Confirm(lblConfirm) then begin
            Rec.Status := Rec.Status::Abierto;
            Rec.Modify();
        end;

    end;
}