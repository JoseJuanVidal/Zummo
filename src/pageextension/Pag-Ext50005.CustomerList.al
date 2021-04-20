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
            field(InsideSales_btc; InsideSales_btc)
            {
                ApplicationArea = all;
                Visible = false;
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
            field(FechaVtoAseg; FechaVtoAseg)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
                Editable = false;
            }
            field(FechaVtoAseguradora; FechaVtoAsegurador)
            {
                ApplicationArea = all;
                Caption = 'Fecha Vto. Aseguradora (real)', comment = 'ESP="Fecha Vto. Aseguradora (real)"';
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
        addafter("Sales Journal")
        {
            action(CalcFechaVto)
            {
                ApplicationArea = all;
                Caption = 'Calcular Fecha Vto. Aseguradora', comment = 'ESP="Calcular Fecha Vto. Aseguradora"';
                Image = Calculate;
                PromotedCategory = Category8;
                Promoted = true;

                trigger OnAction()
                begin
                    if Confirm(Text000) then
                        CalculateFechaVto;
                end;
            }
            action(FinCredito)
            {
                ApplicationArea = all;
                Caption = 'Finalizar Credito', comment = 'ESP="Finalizar Credito"';
                Image = EndingText;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    Input: page "STH Input Hist Aseguradora";
                    Funciones: Codeunit Funciones;
                    Fechafin: date;
                    lblConfirm: Label '¿desea eliminar el credito a %1 %2 seleccionados?', comment = 'ESP="¿desea eliminar el credito a %1 %2 seleccionados?"';
                begin
                    CurrPage.SetSelectionFilter(Customer);

                    // pedimos los datos de Fecha Fin
                    Input.SetShowFin();
                    //Input.SetDatos(Customer);
                    Input.LookupMode := true;
                    if Input.RunModal() = Action::LookupOK then begin

                        // Confirmamos Cerrar el credito
                        if Confirm(lblConfirm, false, Customer.TableCaption, Customer.Count) then begin
                            FechaFin := Input.GetDateFin();
                            if Customer.findset() then
                                repeat
                                    Funciones.FinCustomerCredit(Customer, FechaFin);
                                Until Customer.next() = 0;

                        end;
                    end

                end;

            }
        }
        addafter(ApprovalEntries)
        {
            action(HistAseguradora)
            {
                ApplicationArea = all;
                Caption = 'Hist. Aseguradora', comment = 'ESP="Hist. Aseguradora"';
                Image = History;


                RunObject = page "STH Hist. Aseguradora";
                RunPageLink = CustomerNo = field("No.");

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
        Text000: Label '¿Desea calcular la fecha de vencimiento aseguradora?';

    local procedure CalcVtoAseguradora()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FechaVto := 0D;
        FechaVtoAsegurador := 0D;
        StyleExp := '';
        if "Cred_ Max_ Aseg. Autorizado Por_btc" = '' then
            exit;
        CustLedgerEntry.SetCurrentKey("Due Date");
        CustLedgerEntry.SetRange("Customer No.", "No.");
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetRange(Positive, true);
        if CustLedgerEntry.FindSet() then begin
            FechaVto := CustLedgerEntry."Due Date";
            FechaVtoAsegurador := CalcDate('+60D', CustLedgerEntry."Due Date");
        end;
        CustLedgerEntry.SetFilter("Due Date", '..%1', CalcDate('+60D', WorkDate()));
        if CustLedgerEntry.FindSet() then begin
            if CalcDate('-15D', FechaVtoAsegurador) <= WorkDate() then
                StyleExp := 'UnFavorable'
            else
                StyleExp := 'Ambiguous';
        end;
    end;

    local procedure CalculateFechaVto()
    var
        Funciones: Codeunit Funciones;
    begin
        Funciones.CustomerCalculateFechaVto();
    end;

    local procedure FinMultiSelectAseguradora(var Customer: Record Customer)
    var
        Input: page "STH Input Hist Aseguradora";
        Funciones: Codeunit Funciones;
        Fechafin: date;
        lblConfirm: Label '¿Desea eliminar el credito a %1 %2 seleccionados?', comment = 'ESP="¿Desea eliminar el credito a %1 %2 seleccionados?"';
    begin
        // pedimos los datos de Fecha Fin
        Input.SetShowFin();
        //Input.SetDatos(Customer);
        Input.LookupMode := true;
        if Input.RunModal() = Action::LookupOK then begin

            // Confirmamos Cerrar el credito
            if Confirm(lblConfirm, false, Customer.TableCaption, Customer.Count) then begin
                FechaFin := Input.GetDateFin();
                if Customer.findset() then
                    repeat
                        Funciones.FinCustomerCredit(Customer, FechaFin);
                    Until Customer.next() = 0;

            end;
        end
    end;
}