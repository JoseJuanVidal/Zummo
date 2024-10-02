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
            field(Canal_btc; Canal_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
        }

        addlast(Control1)
        {
            field(Delegado_btc; Delegado_btc)
            {
                ApplicationArea = all;
            }
            field("Cred_ Max_ Aseg. Autorizado Por_btc"; "Cred_ Max_ Aseg. Autorizado Por_btc")
            {
                ApplicationArea = all;
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
            }
            field(Suplemento_aseguradora; Suplemento_aseguradora)
            {
                ApplicationArea = all;
            }
            field(clasificacion_aseguradora; clasificacion_aseguradora)
            {
                ApplicationArea = all;
            }
            field(FechaVto; rec.FechaVto)
            {
                ApplicationArea = all;
                Caption = 'Due Date', comment = 'ESP="Fecha Vto."';
                Editable = false;
                StyleExpr = StyleExp;
            }
            /*field(FechaVtoAseg; FechaVtoAseg)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
                Editable = false;
            }*/
            /*field(FechaVtoAsegurador; FechaVtoAsegurador)
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
            }*/
            field("Credito Maximo Interno_btc"; "Credito Maximo Interno_btc")
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field(AseguradoraenFiltro; AseguradoraenFiltro)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field(ImpCreditoAsegaenFiltro; ImpCreditoAsegaenFiltro)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field("Saldo Vencido Aseguradora"; "Saldo Vencido Aseguradora")
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;

                trigger OnDrillDown()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.RESET;
                    CustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
                    CustLedgEntry.SetRange("Customer No.", "No.");
                    Rec.CopyFilter("Date Filter", CustLedgEntry."Due Date");
                    Rec.CopyFilter(FiltroFechaAseg, CustLedgEntry."Posting Date");
                    CustLedgEntry.SETRANGE(Open, TRUE);
                    PAGE.RUN(0, CustLedgEntry);
                end;
            }
            field(FechaVtoAseguradora; FechaVtoAseguradora)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field(ShortcutDimCode1; ShortcutDimCode[1])
            {
                CaptionClass = '1,2,1';
                Visible = false;
            }
            field(ShortcutDimCode2; ShortcutDimCode[2])
            {
                CaptionClass = '1,2,2';
                Visible = false;
            }
            field(ShortcutDimCode3; ShortcutDimCode[3])
            {
                CaptionClass = '1,2,3';
                Visible = false;
            }
            field(ShortcutDimCode4; ShortcutDimCode[4])
            {
                CaptionClass = '1,2,4';
                Visible = false;
            }
            field(ShortcutDimCode5; ShortcutDimCode[5])
            {
                CaptionClass = '1,2,5';
                Visible = false;
            }

            field(ShortcutDimCode6; ShortcutDimCode[6])
            {
                CaptionClass = '1,2,6';
                Visible = false;
            }

            field(ShortcutDimCode7; ShortcutDimCode[7])
            {
                CaptionClass = '1,2,7';
                Visible = false;
            }

            field(ShortcutDimCode8; ShortcutDimCode[8])
            {
                CaptionClass = '1,2,8';
                Visible = false;
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
            action(DarCredito)
            {
                ApplicationArea = all;
                Caption = 'Asig. Credito Aseguradora', comment = 'ESP="Asig. Credito Aseguradora"';
                Image = Calculate;
                PromotedCategory = Category8;
                Promoted = true;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    Input: page "STH Input Hist Aseguradora";
                    Funciones: Codeunit Funciones;
                    FechaIni: date;
                    Aseguradora: code[20];
                    Suplemento: code[20];
                    Importe: Decimal;
                    lblConfirm: Label 'Se tiene que finalizar el crédito actual, %1 %2\¿Desea Continuar?', Comment = 'ESP="Se tiene que finalizar el crédito actual, %1 %2\¿Desea Continuar?"';
                begin
                    // pedimos los datos de Fecha Ini
                    Input.SetShowIni();
                    //Input.SetDatos(Customer);
                    Input.LookupMode := true;
                    if Input.RunModal() = Action::LookupOK then begin

                        // Confirmamos Cerrar el credito
                        Input.GetDatos(Aseguradora, Importe, FechaIni, Suplemento);
                        CurrPage.SetSelectionFilter(Customer);
                        if Customer.FindFirst() then
                            repeat
                                // si tiene credito lo finalizamos
                                if Customer."Cred_ Max_ Aseg. Autorizado Por_btc" <> '' then begin
                                    if not Confirm(lblConfirm, false, Customer."Cred_ Max_ Aseg. Autorizado Por_btc", customer."Credito Maximo Aseguradora_btc") then
                                        Exit;
                                    Funciones.FinCustomerCredit(Customer, CalcDate('-1D', FechaIni));
                                    Customer.Get(rec."No.");
                                end;

                                Funciones.AsigCreditoAeguradora(Customer."No.", Customer.Name, Aseguradora, Importe, Suplemento, FechaIni);

                                Customer."Cred_ Max_ Aseg. Autorizado Por_btc" := Aseguradora;
                                Customer."Credito Maximo Aseguradora_btc" := Importe;
                                Customer.Suplemento_aseguradora := Suplemento;
                                Customer.validate("Credit Limit (LCY)", Customer."Credito Maximo Aseguradora_btc" + Customer."Credito Maximo Interno_btc");
                                Customer.Modify();
                            until Customer.Next() = 0;
                        CurrPage.Update();
                    end;
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
                    lblConfirm: Label '¿Desea eliminar el credito a %1 %2 seleccionados?', comment = 'ESP="¿Desea eliminar el credito a %1 %2 seleccionados?"';
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
                    end;
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
        addafter(ShowLog)
        {
            action(UpdateBloqueados)
            {
                ApplicationArea = all;
                Caption = 'Dyn 365 Sales Sync Status', comment = 'ESP="Dyn 365 Sales Sync. Estado"';
                Image = RefreshText;

                trigger OnAction()
                var
                    IntegracionCRM: codeunit Integracion_crm_btc;
                    lblConfirm: Label '¿Do you want to upgrade Dyn 365 Sales accounts?', comment = 'ESP="¿Desea actualizar las cuentas de Dyn 365 Sales?"';
                begin
                    if Confirm(lblConfirm) then
                        IntegracionCRM.CRMUpdateCustomers();
                end;

            }
            action(SincronizeDto)
            {
                ApplicationArea = all;
                Caption = 'Sincronize Dto SALES', comment = 'ESP="Actualiza Dtos. familia"';
                Image = Discount;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    Funciones: Codeunit Integracion_crm_btc;
                    lblconfirm: Label '¿Desea actualizar los descuentos de Familia BC-CRM a los registros seleccionados?', comment = 'ESP="¿Desea actualizar los descuentos de Familia BC-CRM a los registros seleccionados?"';
                begin
                    if Confirm(lblconfirm) then begin
                        CurrPage.SetSelectionFilter(Customer);
                        Funciones.UpdateDtoAccountsCRM(Customer);
                    end;
                end;

            }
        }
        addafter(ApplyTemplate)
        {
            action(ChangeClasification)
            {
                ApplicationArea = all;
                Caption = 'Change Clasification', comment = 'ESP="Cambiar datos clasificación"';
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActionChangeClasification();
                end;
            }

        }
    }



    trigger OnAfterGetRecord()
    begin
        CalcVtoAseguradora();
        ShowShortcutDimCode();
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        DefaulDimension: Record "Default Dimension";
        ShortcutDimCode: array[8] of Code[20];
        StyleExp: text;
        Text000: Label '¿Desea calcular la fecha de vencimiento Aseguradora?';

    local procedure CalcVtoAseguradora()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        StyleExp := '';
        if "Cred_ Max_ Aseg. Autorizado Por_btc" = '' then
            exit;
        rec.CalcFields(FechaVtoAseguradora);
        if rec.FechaVtoAseguradora <> 0D then
            if CalcDate('-15D', rec.FechaVtoAseguradora) <= WorkDate() then
                StyleExp := 'UnFavorable'
            else
                StyleExp := 'Ambiguous';
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

    local procedure ActionChangeClasification()
    var
        Customer: Record Customer;
        Functions: Codeunit Funciones;
    begin
        // llamamos a función de cambiar datos, con la selección de clientes de la PAGE
        Customer.Reset();
        CurrPage.SetSelectionFilter(Customer);
        Functions.CustomerChangeClasification(Customer);

    end;

    local procedure ShowShortcutDimCode()
    begin
        GeneralLedgerSetup.Get();
        Clear(ShortcutDimCode);
        DefaulDimension.Reset();
        DefaulDimension.SetRange("Table ID", Database::Customer);
        DefaulDimension.SetRange("No.", Rec."No.");
        if DefaulDimension.FindFirst() then
            repeat
                case DefaulDimension."Dimension Code" of
                    GeneralLedgerSetup."Shortcut Dimension 1 Code":
                        ShortcutDimCode[1] := DefaulDimension."Dimension Value Code";
                    GeneralLedgerSetup."Shortcut Dimension 2 Code":
                        ShortcutDimCode[2] := DefaulDimension."Dimension Value Code";
                    GeneralLedgerSetup."Shortcut Dimension 3 Code":
                        ShortcutDimCode[3] := DefaulDimension."Dimension Value Code";
                    GeneralLedgerSetup."Shortcut Dimension 4 Code":
                        ShortcutDimCode[4] := DefaulDimension."Dimension Value Code";
                    GeneralLedgerSetup."Shortcut Dimension 5 Code":
                        ShortcutDimCode[5] := DefaulDimension."Dimension Value Code";
                    GeneralLedgerSetup."Shortcut Dimension 6 Code":
                        ShortcutDimCode[6] := DefaulDimension."Dimension Value Code";
                    GeneralLedgerSetup."Shortcut Dimension 7 Code":
                        ShortcutDimCode[7] := DefaulDimension."Dimension Value Code";
                    GeneralLedgerSetup."Shortcut Dimension 8 Code":
                        ShortcutDimCode[8] := DefaulDimension."Dimension Value Code";

                end;
            Until DefaulDimension.next() = 0;
    end;

}