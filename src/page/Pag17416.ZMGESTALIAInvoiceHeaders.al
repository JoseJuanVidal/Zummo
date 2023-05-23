page 17416 "ZM GESTALIA Invoice Headers"
{
    PageType = List;
    Caption = 'GESTALIA Invoice Headers', comment = 'ESP="GESTALIA Facturas"';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM GESTALIA Invoice Header";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Id; Id)
                {
                    ApplicationArea = All;
                }
                field(N_Factura; N_Factura)
                {
                    ApplicationArea = All;
                }
                field(N_Pedido; N_Pedido)
                {
                    ApplicationArea = All;
                }
                field(F_Factura; F_Factura)
                {
                    ApplicationArea = All;
                }
                field(Descripcion; Descripcion)
                {
                    ApplicationArea = All;
                }
                field(IdCorp_Sol; IdCorp_Sol)
                {
                    ApplicationArea = All;
                }
                field(Nombre_Sol; Nombre_Sol)
                {
                    ApplicationArea = All;
                }
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = All;
                }
                field(Ref_Ped_Cl; Ref_Ped_Cl)
                {
                    ApplicationArea = All;
                }
                field(Responsable_compra; Responsable_compra)
                {
                    ApplicationArea = All;
                }
                field(Tipo; Tipo)
                {
                    ApplicationArea = All;
                }
                field(FacturaRectificada; FacturaRectificada)
                {
                    ApplicationArea = All;
                }
                field(Total_Base; Total_Base)
                {
                    ApplicationArea = All;
                }
                field(Total_Impuesto; Total_Impuesto)
                {
                    ApplicationArea = All;
                }
                field(Total_Tasas_Exentas; Total_Tasas_Exentas)
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
            action(GESTALIFACTURAS)
            {
                ApplicationArea = all;
                Promoted = true;
                Image = GetSourceDoc;

                trigger OnAction()
                begin
                    GetInvoiceByDate
                end;

            }
        }
    }

    var
        GestaliaFunciones: Codeunit "Zummo Inn. IC Functions";
        lblConfirmGet: Label 'Do you want to update invoices from %1 to %2?', comment = 'ESP="¿Desea actualziar las facturas desde %1 a %2?"';

    local procedure GetInvoiceByDate()
    var
        myInt: Integer;
    begin
        if Confirm(lblConfirmGet, true, CalcDate('-1M', WorkDate()), WorkDate()) then
            GestaliaFunciones.GetInvoicebyDate(CalcDate('-1M', WorkDate()), WorkDate());
    end;
}