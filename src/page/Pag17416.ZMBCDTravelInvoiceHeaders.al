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
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';

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
                field("Purchase Order"; "Purchase Order")
                {
                    ApplicationArea = all;
                    Visible = False;
                }
                field("Purch. Rcpt. Order"; "Purch. Rcpt. Order")
                {
                    ApplicationArea = all;
                    Visible = false;
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
            action(CheckDimensionsValue)
            {
                ApplicationArea = all;
                Caption = 'Check Dimensions', comment = 'ESP="Comprobar Dimensiones"';
                Image = CheckLedger;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    CheckRegisterReceive();
                end;
            }
            group(Related)
            {
                Caption = 'Related', comment = 'ESP="Relacionado"';
                action(CreatePurchaseHeaderReceipt)
                {
                    Caption = 'Crear Recepciones Compra', comment = 'ESP="Crear Recepciones Compra"';
                    ApplicationArea = all;
                    Image = Purchasing;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        OnCreatePurchaseHeaderReceipt();
                    end;

                }
                action(Employee)
                {
                    ApplicationArea = all;
                    Caption = 'Employee', comment = 'ESP="Empleado"';
                    Image = Employee;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Employee: Record Employee;
                        BCDTravelEmpleado: Record "ZM BCD Travel Empleado";
                        EmployeeCard: page "Employee Card";
                    begin
                        BCDTravelEmpleado.SetRange(Codigo, Rec."Cod Empleado");
                        if BCDTravelEmpleado.FindFirst() then begin
                            Employee.SetRange("No.", BCDTravelEmpleado."Employee Code");
                            EmployeeCard.SetTableView(Employee);
                            EmployeeCard.Run();
                        end else
                            Page.Run(page::"ZM BCD Travel Empleado");
                    end;
                }
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
        BCDTravelInvoiceHeader: record "ZM BCD Travel Invoice Header";
        lblConfirm: Label '¿Do you want to create the purchase order and delivery notes for %1 selected lines?',
            comment = 'ESP="¿Desea crear el pedido de compra y albaranes de %1 líneas seleccionadas?"';
    begin
        CurrPage.SetSelectionFilter(BCDTravelInvoiceHeader);
        Clear(CONSULTIAFunciones);
        if Confirm(lblConfirm, false, BCDTravelInvoiceHeader.Count) then
            CONSULTIAFunciones.CrearPedidoCompraDesdeBCDTravel(BCDTravelInvoiceHeader);
    end;

    local procedure CheckRegisterReceive()
    var
        BCDTravelHeader: record "ZM BCD Travel Invoice Header";
        lblConfirm: Label '¿Desea revisar y asignar las dimensiones a %1 albaranes seleccionados?', comment = 'ESP="¿Desea revisar y asignar las dimensiones a %1 albaranes seleccionados?"';
    begin
        CurrPage.SetSelectionFilter(BCDTravelHeader);
        if not Confirm(lblConfirm, false, BCDTravelHeader.Count) then
            exit;
        Clear(CONSULTIAFunciones);
        if BCDTravelHeader.FindFirst() then
            repeat
                if not BCDTravelHeader."Receipt created" then
                    CONSULTIAFunciones.CheckBCDTravelHeaderDimensions(BCDTravelHeader);
            Until BCDTravelHeader.next() = 0;

    end;
}