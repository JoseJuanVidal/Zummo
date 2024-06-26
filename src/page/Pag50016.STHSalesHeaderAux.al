page 50016 "STH Sales Header Aux"
{
    ApplicationArea = All;
    Caption = 'Sales Header Aux', Comment = 'ESP="Ofertas SALES"';
    PageType = List;
    SourceTable = "STH Sales Header Aux";
    UsageCategory = Lists;
    CardPageId = "STH Sales Header Aux Card";
    Editable = false;
    layout
    {
        area(content)
        {
            group("Conexión CRM")
            {
                field(Connected; CRMConnectionSetup.get())
                {
                    ApplicationArea = all;
                    Caption = 'Estado', comment = 'ESP="Estado"';
                    Editable = false;
                }
            }
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field(Created; Created)
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer Name field.';
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer Name 2 field.';
                    ApplicationArea = All;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ToolTip = 'Specifies the value of the Sell-to Address field.';
                    ApplicationArea = All;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ToolTip = 'Specifies the value of the Sell-to Address 2 field.';
                    ApplicationArea = All;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ToolTip = 'Specifies the value of the Sell-to City field.';
                    ApplicationArea = All;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ToolTip = 'Specifies the value of the Sell-to Contact field.';
                    ApplicationArea = All;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ToolTip = 'Specifies the value of the Sell-to Post Code field.';
                    ApplicationArea = All;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ToolTip = 'Specifies the value of the Sell-to County field.';
                    ApplicationArea = All;
                }
                field(Probability; Rec.Probability)
                {
                    ToolTip = 'Specifies the value of the Probability field.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ApplicationArea = All;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ToolTip = 'Specifies the value of the Ship-to Name field.';
                    ApplicationArea = All;
                }
                field("Ship-to Name 2"; Rec."Ship-to Name 2")
                {
                    ToolTip = 'Specifies the value of the Ship-to Name 2 field.';
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ToolTip = 'Specifies the value of the Ship-to Address field.';
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ToolTip = 'Specifies the value of the Ship-to Address 2 field.';
                    ApplicationArea = All;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the value of the Ship-to City field.';
                    ApplicationArea = All;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Country/Region Code field.';
                    ApplicationArea = All;
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ToolTip = 'Specifies the value of the Ship-to County field.';
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Post Code field.';
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Specifies the value of the Payment Terms Code field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ToolTip = 'Specifies the value of the Amount Including VAT field.';
                    ApplicationArea = All;
                }
                field("Invoice Discount Amount"; Rec."Invoice Discount Amount")
                {
                    ToolTip = 'Specifies the value of the Invoice Discount Amount field.';
                    ApplicationArea = All;
                }
                field("Invoice Discount"; "Invoice Discount")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ToolTip = 'Specifies the value of the Bill-to Name field.';
                    ApplicationArea = All;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ToolTip = 'Specifies the value of the Bill-to Address field.';
                    ApplicationArea = All;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ToolTip = 'Specifies the value of the Bill-to Address 2 field.';
                    ApplicationArea = All;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ToolTip = 'Specifies the value of the Bill-to City field.';
                    ApplicationArea = All;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Bill-to Country/Region Code field.';
                    ApplicationArea = All;
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ToolTip = 'Specifies the value of the Bill-to County field.';
                    ApplicationArea = All;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ToolTip = 'Specifies the value of the Bill-to Post Code field.';
                    ApplicationArea = All;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ToolTip = 'Specifies the value of the Requested Delivery Date field.';
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ToolTip = 'Specifies the value of the Shipping Agent Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(STHAcciones)
            {
                action("Activar Cola")
                {
                    ApplicationArea = All;
                    Caption = 'Activar Conexión CRM';
                    Image = MarketingSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        testCRMConnection;
                    end;
                }
                action("Refrescar Ofertas")
                {
                    ApplicationArea = All;
                    Caption = 'Refrescar Ofertas';
                    Image = RefreshRegister;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;


                    trigger OnAction()
                    begin
                        RefreshCRMConnection;
                    end;
                }
                action("Crear Oferta")
                {
                    ApplicationArea = All;
                    Caption = 'Crear Oferta';
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        zummoFunctions: Codeunit Funciones;
                    begin
                        zummoFunctions.CrearOferta(Rec);
                    end;
                }
                action("Crear Oferta Lotes")
                {
                    ApplicationArea = All;
                    Caption = 'Crear Oferta Lotes';
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesQuoteAux: Record "STH Sales Header Aux";
                        zummoFunctions: Codeunit Funciones;
                        lblConfirm: Label '¿Desea crear las ofertas de los registros seleccionados %1?', comment = 'ESP="¿Desea crear las ofertas de los registros seleccionados %1?"';
                    begin
                        CurrPage.SetSelectionFilter(SalesQuoteAux);
                        if not Confirm(lblConfirm, false, SalesQuoteAux.Count) then
                            exit;
                        if SalesQuoteAux.findset() then
                            repeat
                                if SalesQuoteAux.Status in [SalesQuoteAux.Status::" "] then
                                    zummoFunctions.CrearOferta(SalesQuoteAux);
                            Until SalesQuoteAux.next() = 0;
                    end;
                }
            }
        }
        area(Navigation)
        {
            action(SalesQuote)
            {
                Caption = 'Sales Quote', comment = 'ESP="Oferta Venta"';
                ApplicationArea = all;
                Image = Quote;

                trigger OnAction()
                var
                    SalesQuote: record "Sales Header";
                begin
                    SalesQuote.SetRange("Document Type", SalesQuote."Document Type"::Quote);
                    SalesQuote.SetRange("No.", Rec."No.");
                    page.Run(0, SalesQuote);
                end;

            }
        }
    }

    trigger OnOpenPage()
    begin
        CRMConnectionSetup.get();
    end;

    var
        CRMConnectionSetup: record "CRM Connection Setup";
        JobQueueEntry: record "Job Queue Entry";

    local procedure testCRMConnection()

    begin
        CRMConnectionSetup.get();
        if not CRMConnectionSetup.IsEnabled() then
            CRMConnectionSetup.Validate("Is Enabled", true);

        JobQueueEntry.Reset();
        JobQueueEntry.SetRange("Object ID to Run", 5339);
        if JobQueueEntry.FindFirst() then
            repeat
                if JobQueueEntry.Status <> JobQueueEntry.Status::Ready then begin
                    JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                end;
            Until JobQueueEntry.next() = 0;
    end;

    local procedure RefreshCRMConnection()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        Window: Dialog;
        lblWindow: Label 'Synchronization: %1', comment = 'ESP="Sincronización: %1"';
        lblConfirm: Label '¿Do you want to refresh the CRM offers?\(This process may take a few minutes).', comment = 'ESP="¿Desea refrescar las ofertas del CRM?\(Este proceso puede tardar algunos minutos)"';
        lblFinalice: Label 'Synchronization completed', comment = 'ESP="Sincronización finalizada"';
    begin
        IntegrationTableMapping.Reset();
        if not Confirm(lblConfirm) then
            exit;
        Window.Open(lblWindow);
        // OFERTASSALES: trabajo de sincronización de Dynamics 365 for Sales.
        Window.Update(1, 'OFERTASSALES');
        IntegrationTableMapping.Get('OFERTASSALES');
        IntegrationTableMapping.SynchronizeNow((true));
        // OFERTASSALESLIN: trabajo de sincronización de Dynamics 365 for Sales.
        Window.Update(1, 'OFERTASSALESLIN');
        IntegrationTableMapping.Get('OFERTASSALESLIN');
        IntegrationTableMapping.SynchronizeNow((true));
        Window.Close();
        Message(lblFinalice);
    end;
}
