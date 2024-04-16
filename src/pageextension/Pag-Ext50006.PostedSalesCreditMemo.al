pageextension 50006 "PostedSalesCreditMemo" extends "Posted Sales Credit Memo"
{
    //Guardar Nº asiento y Nº documento

    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Search Name"; "Sell-to Search Name")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addafter("Corrected Invoice No.")
        {
            field(CurrencyChange; CurrencyChange)
            {
                ApplicationArea = all;
                ToolTip = 'Indicar el cambio para la impresión de los documentos.', comment = 'ESP="Indicar el cambio para la impresión de los documentos."';
            }
            field(CorreoEnviado_btc; CorreoEnviado_btc) { }
            field(FacturacionElec_btc; FacturacionElec_btc) { }
            field("ABC Cliente"; "ABC Cliente") { }
        }

    }
    actions
    {
        addfirst(Processing)
        {
            action("Cambiar Doc. Externo")
            {
                ApplicationArea = all;
                Caption = 'Cambiar Doc. Externo', comment = 'ESP="Cambiar Doc. Externo"';
                ToolTip = 'Cambiar Doc. Externo',
                    comment = 'ESP="Cambiar Doc. Externo"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Balance;

                trigger OnAction()
                var
                    PediDatos: Page "Posted Sales Invoice Change";
                    Funciones: Codeunit Funciones;
                    ExtDocNo: Text[35];
                    WorkDescription: text;
                    AreaManager: Code[20];
                    InsideSales: Code[20];
                    ClienteReporting: Code[20];
                    CurrChange: Decimal;
                    PackageTrackingNo: text[30];
                    Delegado: code[20];
                    CampaignNo: code[20];
                begin
                    PediDatos.LookupMode := true;
                    PediDatos.SetDatosCRMemo(rec);
                    if PediDatos.RunModal() = Action::LookupOK then begin
                        PediDatos.GetDatos(ExtDocNo, WorkDescription, AreaManager, ClienteReporting, CurrChange, PackageTrackingNo, InsideSales, Delegado, CampaignNo);
                        Funciones.ChangeExtDocNoPostedSalesInvoice("No.", true, ExtDocNo, WorkDescription, AreaManager, ClienteReporting, CurrChange,
                            PackageTrackingNo, InsideSales, Delegado, CampaignNo);
                    end;
                end;

            }
        }
        addafter(SendCustom)
        {
            action(Email_btc)
            {
                ApplicationArea = All;
                Image = Email;
                Promoted = true;
                PromotedCategory = Category6;
                Caption = '&Email', comment = 'ESP="&Correo electrónico"';
                trigger onAction()
                var
                    cduCron: Codeunit CU_Cron;
                begin
                    cduCron.EnvioPersonalizado(Rec);
                end;
            }

        }
        modify("Send by &Email")
        {
            Visible = false;
        }

        modify(SendCustom)
        {
            Visible = false;
        }

        addfirst(Reporting)
        {
            action("Imprimir Fact UK")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                Caption = 'Imprimir Abono UK', Comment = 'ESP="Imprimir Abono UK"';
                ToolTip = 'Imprimir Abono UK', Comment = 'ESP="Imprimir Abono UK"';

                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    reportFacturaUK: Report AbonoVentaUKRegistrado;

                    Selection: Integer;
                begin
                    // Message(Format(Selection));
                    SalesCrMemoHeader.Reset();

                    SalesCrMemoHeader.SetRange("No.", Rec."No.");
                    if SalesCrMemoHeader.FindFirst() then begin
                        clear(reportFacturaUK);
                        reportFacturaUK.EsExportacion();
                        reportFacturaUK.SetTableView(SalesCrMemoHeader);
                        reportFacturaUK.Run();
                    end;
                end;
            }
        }
    }
}