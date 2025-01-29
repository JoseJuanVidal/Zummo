page 17208 "ZM BCD Travel Invoice Lines"
{
    Caption = 'CONSULTIA BCD Travel Lines', Comment = 'ESP="BCD Travel Líneas de facturas"';
    PageType = ListPart;
    SourceTable = "ZM BCD travel Invoice Line";
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                }
                field("Fecha Albarán"; "Fecha Albarán")
                {
                    ApplicationArea = all;
                }
                field("Descripcion"; Descripcion)
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
                field("Tipo Servicio"; "Tipo Servicio")
                {
                    ApplicationArea = all;
                }
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = all;
                }
                field("Nº Billete o Bono"; "Nº Billete o Bono")
                {
                    ApplicationArea = all;
                }
                field("%Impuesto"; "%Impuesto")
                {
                    ApplicationArea = all;
                }
                field("Imp Base Imponible"; "Imp Base Imponible")
                {
                    ApplicationArea = all;
                }
                field("Imp Cuota Impuesto"; "Imp Cuota Impuesto")
                {
                    ApplicationArea = all;
                }
                field("Imp Total"; "Imp Total")
                {
                    ApplicationArea = all;
                }
                field("Trayecto Servicio"; "Trayecto Servicio")
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

                // field(50; "Proyecto"; code[50])
                // {
                //     Caption = 'Proyecto', comment = 'ESP="Proyecto"';
                //     FieldClass = FlowField;
                //     CalcFormula = lookup("ZM CONSULTIA Producto-Proyecto".Proyecto where(CodigoProducto = field(CodigoProducto)));
                // }              
                field(Partida; Partida)
                {
                    ApplicationArea = all;
                }
                field(Detalle; Detalle)
                {
                    ApplicationArea = all;
                }
                field(DEPART; DEPART)
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
            group(line)
            {
                Caption = 'Line', comment = 'ESP="Líneas"';
                action(AssingEmployee)
                {
                    ApplicationArea = all;
                    Caption = 'Assign Employee', comment = 'ESP="Asignar Empleado"';
                    Image = Employee;

                    trigger OnAction()
                    begin
                        AssingEmployeeIdCorp();
                    end;
                }

            }
        }
    }
    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";

    local procedure AssingEmployeeIdCorp()
    var
    begin
        CONSULTIAFunciones.BCDTravelAssingEmployee(Rec);

        CurrPage.Update();
    end;

    local procedure AssingProject()
    begin
        CONSULTIAFunciones.UpdateProyectoNroalbaran(Rec."Nro_Albarán");
        CurrPage.Update();
    end;

    // local procedure UpdateDimensions()
    // var
    //     CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
    //     lblConfirm: Label '¿Desea actualizar las dimensiones de las líneas seleccionadas?\(%1)', comment = 'ESP="¿Desea actualizar las dimensiones de las líneas seleccionadas?\(%1)"';
    // begin
    //     CurrPage.SetSelectionFilter(CONSULTIAInvoiceLine);
    //     if not Confirm(lblConfirm, true, CONSULTIAInvoiceLine.Count) then
    //         exit;
    //     if CONSULTIAInvoiceLine.FindFirst() then
    //         repeat
    //             CONSULTIAFunciones.UpdateDimensions(CONSULTIAInvoiceLine);
    //         Until CONSULTIAInvoiceLine.next() = 0;

    //     CurrPage.Update();
    // end;
}
