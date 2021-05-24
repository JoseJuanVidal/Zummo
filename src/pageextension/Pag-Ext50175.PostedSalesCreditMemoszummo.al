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
                Caption = 'Imprimir Fact. UK', Comment = 'ESP="Imprimir Fact. UK"';
                ToolTip = 'Imprimir Fact. UK', Comment = 'ESP="Imprimir Fact. UK"';

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