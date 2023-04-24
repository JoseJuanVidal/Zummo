pageextension 50101 "CustomerCard" extends "Customer Card"
{

    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("Credito Maximo Interno_btc"; "Credito Maximo Interno_btc")
            {
                ApplicationArea = all;
                AutoFormatType = 1;
            }
            field("Cred_ Max_ Int_ Autorizado Por_btc"; "Cred_ Max_ Int_ Autorizado Por_btc")
            {
                ApplicationArea = all;
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
                AutoFormatType = 1;
                Editable = false;
            }
            field("Cred_ Max_ Aseg. Autorizado Por_btc"; "Cred_ Max_ Aseg. Autorizado Por_btc")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Suplemento_aseguradora; Suplemento_aseguradora)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(clasificacion_aseguradora; clasificacion_aseguradora)
            {
                ApplicationArea = all;
            }
        }
        addafter("Prices Including VAT")
        {
            field(Descuento1_btc; Descuento1_btc)
            {
                ApplicationArea = all;
            }
            field(Descuento2_btc; Descuento2_btc)
            {
                ApplicationArea = all;
            }
        }
        addlast(Invoicing)
        {
            group("Clasificación Ventas")
            {
                field(CentralCompras_btc; CentralCompras_btc)
                {
                    ApplicationArea = all;
                }
                field(ClienteCorporativo_btc; ClienteCorporativo_btc)
                {
                    ApplicationArea = all;
                }
                field(Perfil_btc; Perfil_btc)
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
                }
                field(Canal_btc; Canal_btc)
                {
                    ApplicationArea = all;
                }
                field(Mercado_btc; Mercado_btc)
                {
                    ApplicationArea = all;
                }
                field(Delegado_btc; Delegado_btc)
                {
                    ApplicationArea = all;
                }

                field(GrupoCliente_btc; GrupoCliente_btc)
                {
                    ApplicationArea = all;
                }
                field(ClienteActividad_btc; ClienteActividad_btc)
                {
                    ApplicationArea = All;
                }

                field(SubCliente_btc; SubCliente_btc)
                {
                    ApplicationArea = all;
                }
                field(ClienteReporting_btc; ClienteReporting_btc)
                {
                    ApplicationArea = all;
                }
                field(Formadepagosolicitada; Formadepagosolicitada)
                {
                    ApplicationArea = all;
                }
                field("ABC Cliente"; "ABC Cliente")
                {
                    ApplicationArea = all;
                }
                field("Mostrar Documentos Netos"; "Mostrar Documentos Netos")
                {
                    ApplicationArea = all;
                }
            }
        }
        addlast(Invoicing)
        {
            Group(DtosFamilia)
            {
                Caption = 'Descuentos', comment = 'ESP="Descuentos"';

                field("Dto. Exprimidores"; "Dto. Exprimidores")
                {
                    ApplicationArea = All;
                }
                field("Dto. Isla"; "Dto. Isla")
                {
                    ApplicationArea = All;
                }
                field("Dto. Viva"; "Dto. Viva")
                {
                    ApplicationArea = All;
                }
                field("Dto. Repuestos"; "Dto. Repuestos")
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter("VAT Registration No.")
        {
            field(EORI; EORI)
            {
                ApplicationArea = all;
            }
        }
        //S20/00375
        addafter("E-Mail")
        {
            field(PermiteEnvioMail_btc; PermiteEnvioMail_btc)
            {
                ApplicationArea = all;
            }
            field(CorreoFactElec_btc; CorreoFactElec_btc)
            {
                ApplicationArea = all;
            }
            field(TipoFormarto_btc; TipoFormarto_btc)
            {
                ApplicationArea = all;
            }

        }
        //FIN S20/00375

        addlast(FactBoxes)
        {
            part(CommCust; FactboxComments)
            {
                ApplicationArea = All;
                SubPageLink = "Table Name" = const(Customer), "No." = field("No.");
            }
        }

        addafter(Blocked)
        {
            field(CodMotivoBloqueo_btc; CodMotivoBloqueo_btc)
            {
                ApplicationArea = All;
                ToolTip = 'It allows to indicate the reason for which it has been blocked', comment = 'ESP="Permite indicar el motivo por el cual ha sido bloqueado"';
                Enabled = MotivoBloqueoEnabled;
            }
        }
        addafter("Shipment Method Code")
        {
            field("Transaction Specification"; "Transaction Specification") { }
            field("Transaction Type"; "Transaction Type") { }
            field("Transport Method"; "Transport Method") { }
            field("Exit Point"; "Exit Point") { }
        }

        addafter("Phone No.")
        {
            field("Telex No."; "Telex No.")
            {
                Caption = 'Telefono Movil';
            }
            field(AlertaMaquina; AlertaMaquina)
            {
                ApplicationArea = all;
            }
            field(AlertaPedidoServicio; AlertaPedidoServicio)
            {
                ApplicationArea = all;
            }
        }

        modify(Name) { ShowMandatory = true; }
        modify("VAT Registration No.") { ShowMandatory = true; }
        modify("Gen. Bus. Posting Group") { ShowMandatory = true; }
        modify("VAT Bus. Posting Group") { ShowMandatory = true; }
        modify("Customer Posting Group") { ShowMandatory = true; }
        modify(Address) { ShowMandatory = true; }
        modify(City) { ShowMandatory = true; }
        modify("Post Code") { ShowMandatory = true; }
        modify("Country/Region Code") { ShowMandatory = true; }
        modify("Payment Method Code") { ShowMandatory = true; }
        modify("Payment Terms Code") { ShowMandatory = true; }
        modify("Search Name") { Visible = true; }
        moveafter(Name; "Country/Region Code")


        modify("Credit Limit (LCY)")
        {
            Editable = false;
            ToolTip = 'This field is not editable because it is filled in with the sum of the Maximum Insurance Credit and the Maximum Internal Credit', comment = 'ESP="Este campo no es editable porque se rellena con la suma del Credito Maximo Aseguradora y el Credito Maximo Interno"';
        }

        modify(Blocked)
        {
            trigger OnAfterValidate()
            begin
                CompruebaMotivoBloqueoEnabled();
            end;
        }

        // 161219 S19/01406 Ocultar notas
        modify(Control1905767507)
        {
            Visible = false;
        }
    }

    actions
    {
        /*addafter("Co&mments")
        {
            action(ComentariosBloqueo)
            {
                ApplicationArea = All;
                Image = Compress;
                Caption = 'Lock Comments', comment = 'ESP="Comentarios bloqueo"';
                ToolTip = 'Show comments on blocking reason', comment = 'ESP="Musestra los comentarios del motivo de bloqueo"';
                Visible = false;  //161219 S19/01177 Se usará la tabla estándar

                trigger OnAction()
                var
                    recComentVarios: Record ComentariosVarios;
                    pageComentarios: page ComentariosVarios;
                begin
                    recComentVarios.Reset();
                    recComentVarios.SetRange(TablaOrigen_btc, Database::Customer);
                    recComentVarios.SetRange(No_btc, "No.");
                    recComentVarios.SetRange(TipoComentario_btc, recComentVarios.TipoComentario_btc::"Lock Comment");

                    clear(pageComentarios);
                    pageComentarios.SetTableView(recComentVarios);
                    pageComentarios.RunModal();
                end;
            }
        }*/

        modify("Co&mments")
        {
            Visible = false;
        }
        addbefore("Report Customer - Balance to Date")
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
                PromotedCategory = Category9;
                Promoted = true;
                RunObject = page "Comentarios Cliente";
                RunPageLink = "Table Name" = CONST(Customer), "No." = FIELD("No.");
            }
        }
        addafter(ApprovalEntries)
        {
            action(HistAseguradora)
            {
                ApplicationArea = all;
                Caption = 'Hist. Aseguradora', comment = 'ESP="Hist. Aseguradora"';
                Image = History;
                PromotedCategory = Category7;
                Promoted = true;

                RunObject = page "STH Hist. Aseguradora";
                RunPageLink = CustomerNo = field("No.");

            }
        }
        addafter(MergeDuplicate)
        {
            action(darCredito)
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
                        if Customer.Get(rec."No.") then begin
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
                            CurrPage.Update();
                        end;
                    end
                end;
            }
            action(FinCredito)
            {
                ApplicationArea = all;
                Caption = 'Finalizar Credito', comment = 'ESP="Finalizar Credito"';
                Image = EndingText;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                begin
                    Funciones.FinAseguradora(Rec);
                end;

            }
        }
        addafter(ShowLog)
        {
            action(UpdateOWnerID)
            {
                ApplicationArea = all;
                Caption = 'Update Owner ID CRM', comment = 'ESP="Actualiza Propietario Cuentas CRM"';
                Image = Refresh;

                trigger OnAction()
                var
                    Funciones: Codeunit Integracion_crm_btc;
                begin
                    Funciones.UpdateCustomerAccountAreaManager(Rec);
                end;

            }
            action(SincronizeDto)
            {
                ApplicationArea = all;
                Caption = 'Sincronize Dto SALES', comment = 'ESP="Actualiza Dtos. familia"';
                Image = Discount;

                trigger OnAction()
                var
                    Funciones: Codeunit Integracion_crm_btc;
                    lblconfirm: Label '¿Desea actualizar los descuentos de Familia BC-CRM?', comment = 'ESP="¿Desea actualizar los descuentos de Familia BC-CRM?"';
                begin
                    if Confirm(lblconfirm) then
                        Funciones.UpdateDtoAccountCRM(Rec."No.");
                end;

            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CheckMandatoryFields();
    end;

    local procedure CheckMandatoryFields()
    var
        boolMostrarError: Boolean;
        lbConfirm: Label 'Customer: %1 has one or more of the required fields empty\Are you sure you want to exit?', comment = 'ESP="El cliente: %1 tiene vacíos uno o más de los campos obligatorios\¿Está seguro/a de que desea salir?"';
    begin
        boolMostrarError := false;

        if Name = '' then
            boolMostrarError := true;

        if "VAT Registration No." = '' then
            boolMostrarError := true;

        if "Gen. Bus. Posting Group" = '' then
            boolMostrarError := true;

        if "VAT Bus. Posting Group" = '' then
            boolMostrarError := true;

        if "Customer Posting Group" = '' then
            boolMostrarError := true;

        if Address = '' then
            boolMostrarError := true;
        if City = '' then
            boolMostrarError := true;

        if "Post Code" = '' then
            boolMostrarError := true;

        if "Country/Region Code" = '' then
            boolMostrarError := true;

        if "Payment Method Code" = '' then
            boolMostrarError := true;

        if "Payment Terms Code" = '' then
            boolMostrarError := true;

        if boolMostrarError then
            if not Confirm(StrSubstNo(lbConfirm, "No.")) then
                error('');
    end;

    trigger OnAfterGetRecord()
    begin
        CompruebaMotivoBloqueoEnabled();
    end;

    local procedure CompruebaMotivoBloqueoEnabled()
    var
        myInt: Integer;
    begin
        MotivoBloqueoEnabled := false;

        if Blocked = Blocked::" " then
            MotivoBloqueoEnabled := false
        else
            MotivoBloqueoEnabled := true;
    end;

    var
        MotivoBloqueoEnabled: Boolean;
}