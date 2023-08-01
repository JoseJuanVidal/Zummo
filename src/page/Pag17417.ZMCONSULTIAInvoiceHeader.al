page 17417 "ZM CONSULTIA Invoice Header"
{
    PageType = card;
    Caption = 'CONSULTIA Invoice Header', comment = 'ESP="CONSULTIA Facturas"';
    UsageCategory = None;
    SourceTable = "ZM CONSULTIA Invoice Header";
    // Editable = false;
    DelayedInsert = True;
    InsertAllowed = false;
    // ModifyAllowed = false;
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
                    Editable = false;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Id; Id)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(N_Factura; N_Factura)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(N_Pedido; N_Pedido)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(F_Factura; F_Factura)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Descripcion; Descripcion)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(IdCorp_Sol; IdCorp_Sol)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Nombre_Sol; Nombre_Sol)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Ref_Ped_Cl; Ref_Ped_Cl)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Responsable_compra; Responsable_compra)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Tipo; Tipo)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FacturaRectificada; FacturaRectificada)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                field(Total_Tasas_Exentas; Total_Tasas_Exentas)
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
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = All;
                }
                field("Dimension Partida Fair"; "Dimension Partida Fair")
                {
                    ApplicationArea = all;
                }
                field("Dimension Detalle Fair"; "Dimension Detalle Fair")
                {
                    ApplicationArea = all;
                }
            }
            group(Register)
            {
                Caption = 'Register', comment = 'ESP="Registro"';

                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Pre Invoice No."; "Pre Invoice No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Invoice Header No."; "Invoice Header No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Provisioning; Provisioning)
                {
                    ApplicationArea = all;
                }
                field("Provisioning Date"; "Provisioning Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Des Provisioning"; "Des Provisioning")
                {
                    ApplicationArea = all;
                }
                field("Des Provisioning Date"; "Des Provisioning Date")
                {
                    ApplicationArea = all;
                    Editable = false;
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
            action(Provisioning)
            {
                ApplicationArea = all;
                Caption = 'Aprovisionar', comment = 'ESP="Aprovisionar"';
                Image = PrepaymentInvoice;
                Promoted = true;
                trigger OnAction()
                begin
                    CreateProvisioning();
                end;
            }
            action(DesProvisioning)
            {
                ApplicationArea = all;
                Caption = 'Desprovisionar', comment = 'ESP="Desprovisionar"';
                Image = PrepaymentInvoice;
                Promoted = true;
                trigger OnAction()
                begin
                    CreateDesProvisioning();
                end;
            }
        }
    }

    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";
        lblConfirmGet: Label 'Do you want to update invoices from %1 to %2?', comment = 'ESP="¿Desea actualziar las facturas desde %1 a %2?"';
        lblConfirmCreate: Label '¿Do you want to create the pre-invoice %1?', comment = 'ESP="¿Desea crear la prefactura %1?"';
        lblConfirmProvisioning: Label '¿You wish to provision invoice %1?', comment = 'ESP="¿Desea provisionar la factura %1?"';
        lblConfirmDesProvisioning: Label '¿You wish to desprovision invoice %1?', comment = 'ESP="¿Desea desprovisionar la factura %1?"';

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

    local procedure CreateProvisioning()
    begin
        if Confirm(lblConfirmProvisioning, true, Rec.N_Factura) then begin
            CONSULTIAFunciones.CreateJNLAprovisionamiento(Rec, false);
        end;
    end;

    local procedure CreateDesProvisioning()
    begin
        if Confirm(lblConfirmDesProvisioning, true, Rec.N_Factura) then begin
            CONSULTIAFunciones.CreateJNLAprovisionamiento(Rec, true);
        end;
    end;
}