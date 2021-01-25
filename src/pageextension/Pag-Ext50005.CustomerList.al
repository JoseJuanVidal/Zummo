pageextension 50005 "CustomerList" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
                ApplicationArea = All;
            }
            field("Payment Method Code"; "Payment Method Code") { }
            field("Net Change"; "Net Change")
            {
                ApplicationArea = All;
            }
            field(PermiteEnvioMail_btc; PermiteEnvioMail_btc)
            {
                ApplicationArea = all;
            }
            field(TipoFormarto_btc; TipoFormarto_btc)
            {
                ApplicationArea = all;
            }
            field("Net Change (LCY)"; "Net Change (LCY)")
            {
                ApplicationArea = all;
            }
            field(AreaManager_btc; AreaManager_btc)
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Cred_ Max_ Aseg. Autorizado Por_btc"; "Cred_ Max_ Aseg. Autorizado Por_btc")
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field(Suplemento_aseguradora; Suplemento_aseguradora)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field(FechaVto; FechaVto)
            {
                ApplicationArea = all;
                Caption = 'Due Date', comment = 'ESP="Fecha Vto."';
                Editable = false;
                StyleExpr = StyleExp;
            }
            field(FechaVtoAseguradora; FechaVtoAsegurador)
            {
                ApplicationArea = all;
                Caption = 'Fecha Vto. Aseguradora', comment = 'ESP="Fecha Vto. Aseguradora"';
                StyleExpr = StyleExp;

                trigger OnDrillDown()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgerEntry.SetCurrentKey("Due Date");
                    CustLedgerEntry.SetRange("Customer No.", "No.");
                    CustLedgerEntry.SetRange(Open, true);
                    CustLedgerEntry.SetFilter("Due Date", '..%1', CalcDate('+2M', WorkDate()));
                    page.run(0, CustLedgerEntry);
                end;
            }
            field("Credito Maximo Interno_btc"; "Credito Maximo Interno_btc")
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }

        }
    }

    actions
    {
        modify("Co&mments")
        {
            Visible = false;
        }
        addbefore(ReportCustomerTrialBalance)
        {
            action("Imprimir Extracto")
            {
                ApplicationArea = All;
                Caption = 'Imprimir Extracto', comment = 'NLB="Imprimir Extracto"';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintForm;
                trigger OnAction()
                var
                    Cliente: Record Customer;
                begin
                    Cliente.SetRange("No.", Rec."No.");
                    if (Cliente.FindFirst()) then
                        Report.Run(Report::"Extracto Cliente", true, false, Cliente);
                end;
            }
        }
        addbefore("Co&mments")
        {
            action(Coment1)
            {
                ApplicationArea = All;
                Caption = 'Comments', comment = 'ESP="Comentarios"';
                ToolTip = 'View or add comments for the record', comment = 'ESP="Permite ver o agregar comentarios para el registro."';
                Image = ViewComments;
                PromotedCategory = Category7;
                Promoted = true;
                RunObject = page "Comentarios Cliente";
                RunPageLink = "Table Name" = CONST(Customer), "No." = FIELD("No.");
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        CalcVtoAseguradora();
    end;

    var
        FechaVto: Date;
        FechaVtoAsegurador: date;
        StyleExp: text;


    local procedure CalcVtoAseguradora()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FechaVto := 0D;
        FechaVtoAsegurador := 0D;
        if CustLedgerEntry."Due Date" <> 0D then
            FechaVtoAsegurador := CalcDate('+60D', CustLedgerEntry."Due Date");
        StyleExp := '';
        if "Cred_ Max_ Aseg. Autorizado Por_btc" = '' then
            exit;
        CustLedgerEntry.SetCurrentKey("Due Date");
        CustLedgerEntry.SetRange("Customer No.", "No.");
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetRange(Positive, true);
        CustLedgerEntry.SetFilter("Due Date", '..%1', CalcDate('+60D', WorkDate()));
        if CustLedgerEntry.FindSet() then begin
            FechaVto := CustLedgerEntry."Due Date";
            FechaVtoAsegurador := CalcDate('+60D', CustLedgerEntry."Due Date");

            if CalcDate('-15D', FechaVtoAsegurador) <= WorkDate() then
                StyleExp := 'UnFavorable'
            else
                StyleExp := 'Ambiguous';
        end;
    end;
}