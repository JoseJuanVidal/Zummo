page 17417 "ZM BCD Travel Invoice Header"
{
    PageType = card;
    Caption = 'CONSULTIA Invoice Header', comment = 'ESP="CONSULTIA Facturas"';
    UsageCategory = None;
    SourceTable = "ZM BCD Travel Invoice Header";
    // Editable = false;
    DelayedInsert = True;
    InsertAllowed = false;
    // ModifyAllowed = false;
    DataCaptionFields = "Nro_Albarán";

    layout
    {
        area(Content)
        {
            group(General)
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
                    Editable = false;
                }
                field(Total_Impuesto; Total_Impuesto)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Total; Total)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("G/L Account Fair"; "G/L Account Fair")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 code Fair"; "Global Dimension 1 code Fair")
                {
                    ApplicationArea = all;
                }
                // field(Proyecto; Proyecto)
                // {
                //     ApplicationArea = All;
                // }
                field("Dimension Partida Fair"; "Dimension Partida Fair")
                {
                    ApplicationArea = all;
                }
                field("Dimension Detalle Fair"; "Dimension Detalle Fair")
                {
                    ApplicationArea = all;
                }
            }

            part(lines; "ZM BCD Travel Invoice Lines")
            {
                Caption = 'Lines', comment = 'ESP="Líneas"';
                SubPageLink = "Nro_Albarán" = field("Nro_Albarán");
            }
        }
    }
    actions
    {

    }

    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";
        lblConfirmGet: Label 'Do you want to update invoices from %1 to %2?', comment = 'ESP="¿Desea actualziar las facturas desde %1 a %2?"';
        lblConfirmCreate: Label '¿Do you want to create the pre-invoice %1?', comment = 'ESP="¿Desea crear la prefactura %1?"';
        lblConfirmProvisioning: Label '¿You wish to provision invoice %1?', comment = 'ESP="¿Desea provisionar la factura %1?"';
        lblConfirmDesProvisioning: Label '¿You wish to desprovision invoice %1?', comment = 'ESP="¿Desea desprovisionar la factura %1?"';


    local procedure CloseInvoice()
    var
        lblConfirm: Label '¿Do you want to Close the invoice to the history?', comment = 'ESP="¿Desea Cerrar la factura al histórico?"';
    begin
        Rec.TestField(Status, Status::Abierto);
        if Confirm(lblConfirm) then begin
            Rec.Status := Rec.Status::Cerrado;
            Rec.Modify();
        end;

    end;
}