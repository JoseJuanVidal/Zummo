page 17416 "ZM CONSULTIA Invoice Headers"
{
    PageType = List;
    Caption = 'CONSULTIA Invoice Headers', comment = 'ESP="CONSULTIA Facturas"';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM CONSULTIA Invoice Header";
    CardPageId = "ZM CONSULTIA Invoice Header";
    Editable = false;
    InsertAllowed = false;

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
        area(factboxes)
        {
            part("Attachment Document"; "ZM Document Attachment Factbox")
            {
                ApplicationArea = all;
                Caption = 'Attachment Document', comment = 'ESP="Documentos adjuntos"';
                SubPageLink = "Table ID" = const(17414), "No." = field(N_Factura);
            }
            // systempart(Links; Links)
            // {
            //     ApplicationArea = RecordLinks;
            //     Visible = false;
            // }
            // systempart(Notes; Notes)
            // {
            //     ApplicationArea = Notes;
            //     Visible = false;
            // }
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
    trigger OnAfterGetRecord()
    begin

        CurrPage."Attachment Document".Page.SetTableNo(17414, Rec.N_Factura, 0);

    end;

    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";
        lblConfirmGet: Label 'Do you want to update invoices from %1 to %2?', comment = 'ESP="¿Desea actualziar las facturas desde %1 a %2?"';

    local procedure GetInvoiceByDate()
    var
        myInt: Integer;
    begin
        if Confirm(lblConfirmGet, true, CalcDate('-30D', WorkDate()), WorkDate()) then
            CONSULTIAFunciones.GetInvoicebyDate(CalcDate('-30D', WorkDate()), WorkDate());
    end;
}