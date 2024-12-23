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

                trigger OnAction()
                begin
                    ImportExcelBCDTravelCon07();
                end;
            }
        }

    }


    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";
        lblConfirmGet: Label 'Do you want to update Shipments?', comment = 'ESP="¿Desea importar los albaranes?"';

    local procedure ImportExcelBCDTravelCon07()
    begin
        if Confirm(lblConfirmGet) then
            CONSULTIAFunciones.ImportExcelBCDTravelCon07();
    end;
}