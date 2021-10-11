pageextension 50175 "PostedSalesCreditMemos_zummo" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Location Code")
        {
            field(CorreoEnviado_btc; CorreoEnviado_btc) { }
            field(FacturacionElec_btc; FacturacionElec_btc) { }
            field("Corrected Invoice No."; "Corrected Invoice No.")
            {
                ApplicationArea = All;
            }
            field("ABC Cliente"; "ABC Cliente") { }
        }
        addafter("Amount Including VAT")
        {
            field("Importe (DL)"; BaseImpDL)
            {
                ApplicationArea = all;
            }
            field("Importe IVA Incl. (DL)"; -ImpTotalDL)
            {
                ApplicationArea = all;
            }
            field("Payment Method Code"; "Payment Method Code")
            {
                ApplicationArea = all;
            }
            field("Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Cred_ Max_ Aseg. AutorizadoPor"; "Cred_ Max_ Aseg. AutorizadoPor")
            {
                ApplicationArea = all;
            }
            field(Suplemento_aseguradora; Suplemento_aseguradora)
            {
                ApplicationArea = all;
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
            }
            field(clasificacion_aseguradora; clasificacion_aseguradora)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

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

    trigger OnAfterGetRecord()
    begin
        ImpTotalDL := 0;
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Document No.", "No.");
        CustLedgerEntry.SetRange("Customer No.", "Sell-to Customer No.");
        if CustLedgerEntry.FindSet() then begin
            CustLedgerEntry.CalcFields("Amount (LCY)");
            ImpTotalDL := CustLedgerEntry."Amount (LCY)";
        end;

        BaseImpDL := 0;
        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetRange("Document No.", Rec."No.");
        if SalesCrMemoLine.FindSet() then begin
            SalesCrMemoLine.CalcSums(Amount);
            if rec."Currency Factor" = 0 then
                BaseImpDL := SalesCrMemoLine.Amount
            else
                BaseImpDL := SalesCrMemoLine.Amount / rec."Currency Factor";
        end;
    end;

    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ImpTotalDL: Decimal;
        BaseImpDL: Decimal;
}