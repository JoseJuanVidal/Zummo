page 17416 "ZM BCD Travel Invoice Headers"
{
    PageType = List;
    Caption = 'BCD Travel Invoice Headers', comment = 'ESP="BCD Travel Facturas"';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM BCD Travel Invoice Header";
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
                field("Receipt created"; "Receipt created")
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
            action(ImportarAlbaranes)
            {
                Caption = 'Importar Albaranes', comment = 'ESP="Importar Albaranes"';
                ApplicationArea = all;
                Promoted = true;
                Image = GetSourceDoc;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ImportExcelBCDTravelCon07();
                end;
            }
            action(CreatePurchaseHeaderReceipt)
            {
                Caption = 'Crear Recepciones Compra', comment = 'ESP="Crear Recepciones Compra"';
                ApplicationArea = all;
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnCreatePurchaseHeaderReceipt();
                end;

            }
        }

    }


    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";


    local procedure ImportExcelBCDTravelCon07()
    var
        lblConfirmGet: Label '¿Do you want to update Shipments?', comment = 'ESP="¿Desea importar los albaranes?"';
    begin
        Clear(CONSULTIAFunciones);
        if Confirm(lblConfirmGet) then
            CONSULTIAFunciones.ImportExcelBCDTravelCon07();
    end;

    local procedure OnCreatePurchaseHeaderReceipt()
    var
        lblConfirm: Label '¿Do you want to create the purchase order and delivery notes for the pending lines?',
            comment = 'ESP="¿Desea crear el pedido de compra y albaranes de las líneas pendientes?"';
    begin
        Clear(CONSULTIAFunciones);
        if Confirm(lblConfirm) then
            CONSULTIAFunciones.CrearPedidoCompraDesdeBCDTravel();
    end;
}