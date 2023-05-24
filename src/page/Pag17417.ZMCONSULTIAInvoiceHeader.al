page 17417 "ZM CONSULTIA Invoice Header"
{
    PageType = card;
    Caption = 'CONSULTIA Invoice Header', comment = 'ESP="CONSULTIA Facturas"';
    UsageCategory = None;
    SourceTable = "ZM CONSULTIA Invoice Header";
    // Editable = false;
    DelayedInsert = True;
    InsertAllowed = false;
    ModifyAllowed = false;
    DataCaptionFields = N_Factura;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = all;
                }
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
            group(Register)
            {
                Caption = 'Register', comment = 'ESP="Registro"';

                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Pre Invoice No."; "Pre Invoice No.")
                {
                    ApplicationArea = all;
                }
                field("Invoice Header No."; "Invoice Header No.")
                {
                    ApplicationArea = all;
                }
            }
            part(lines; "ZM CONSULTIA Invoice Lines")
            {
                Caption = 'Lines', comment = 'ESP="Líneas"';
                SubPageLink = Id = field(Id);
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
            action(CreatingInvoice)
            {
                ApplicationArea = all;
                Caption = 'Create invoice', comment = 'ESP="Crear Factura"';
                Image = CreateDocument;
                Promoted = true;

                trigger OnAction()
                begin
                    Createinvoice();
                end;
            }
        }
    }

    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";
        lblConfirmGet: Label 'Do you want to update invoices from %1 to %2?', comment = 'ESP="¿Desea actualziar las facturas desde %1 a %2?"';
        lblConfirmCreate: Label '¿Do you want to create the pre-invoice %1?', comment = 'ESP="¿Desea crear la prefactura %1?"';

    local procedure GetInvoiceByDate()
    begin
        if Confirm(lblConfirmGet, true, CalcDate('-1M', WorkDate()), WorkDate()) then
            CONSULTIAFunciones.GetInvoicebyDate(CalcDate('-1M', WorkDate()), WorkDate());
    end;

    local procedure Createinvoice()
    begin
        if Confirm(lblConfirmCreate, true, Rec.N_Factura) then
            CONSULTIAFunciones.CreatePurchaseInvoice(Rec);
    end;
}