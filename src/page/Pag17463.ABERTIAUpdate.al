page 17463 "ABERTIA Update"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'ABERTIA update', comment = 'ESP="ABERTIA Actualizaciones"';

    layout
    {
        area(Content)
        {
            group(options)
            {
                Caption = 'Options', comment = 'ESP="Opciones"';

                field(TypeUpdate; TypeUpdate)
                {
                    ApplicationArea = all;
                    Caption = 'Tipo Actualización', comment = 'ESP="Tipo Actualizacion"';
                    ToolTip = 'Seleccionamos el tipo de actualización';
                }
                field(EntryNoIni; EntryNoIni)
                {
                    ApplicationArea = all;
                    Caption = 'Nº Movimiento inicial', comment = 'ESP="Nº Movimiento inicial"';
                    ToolTip = 'Si indicamos un numero, siempre se parte desde ese Movimiento';
                }
            }
            group(Estado)
            {
                Editable = false;
                field(GLAccountNo; GLAccountNo)
                {
                    ApplicationArea = all;
                    Caption = 'Nº cuentas contables', comment = 'ESP="Nº cuentas contables"';
                    AutoFormatType = 1;
                    AutoFormatExpression = CurrencyCode;


                }
                field(GLEntryNo; GLEntryNo)
                {
                    Caption = 'Nº mov. contables', comment = 'ESP="Nº mov. "';
                    AutoFormatType = 2;
                    AutoFormatExpression = CurrencyCode;
                }
                field(GLBudgetNo; GLBudgetNo)
                {
                    Caption = 'Nº mov. Presupuesto', comment = 'ESP="Nº mov. Presupuesto"';
                    AutoFormatType = 2;
                    AutoFormatExpression = CurrencyCode;
                }
                field(SalesCustomer; SalesCustomer)
                {
                    Caption = 'Nº Clientes', comment = 'ESP="Nº Clientes"';
                    AutoFormatType = 2;
                    AutoFormatExpression = CurrencyCode;
                }
                field(SalesItem; SalesItem)
                {
                    Caption = 'Nº Productos', comment = 'ESP="Nº Productos"';
                    AutoFormatType = 2;
                    AutoFormatExpression = CurrencyCode;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(Refresh)
            {
                ApplicationArea = all;
                Caption = 'Update Counter', comment = 'ESP="Act. contador"';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = New;
                trigger OnAction()
                begin
                    UpdateEntryNos();
                end;
            }
            action(UpdateGLAccount)
            {
                ApplicationArea = all;
                Caption = 'Update GL Account', comment = 'ESP="Actualizar cuentas contables"';
                Image = Accounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea actualizar las cuentas contables?', comment = 'ESP="¿Desea actualizar las cuentas contables?"';
                begin
                    if Confirm(lblConfirm) then
                        AbertiaGLAccount.CreateGLAccount();
                    UpdateEntryNos();
                end;
            }
            action(UpdateGLEntry)
            {
                ApplicationArea = all;
                Caption = 'Update GL Entry', comment = 'ESP="Actualizar movs. contabiladad"';
                Image = PostingEntries;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea actualizar los movimientos contabilidad?', comment = 'ESP="¿Desea actualizar los movimientos contabilidad?"';
                begin
                    if Confirm(lblConfirm) then
                        AbertiaGLEntry.CreateGLEntry(EntryNoIni, TypeUpdate);
                    UpdateEntryNos();
                end;
            }
            action(UpdateSalesCustomer)
            {
                ApplicationArea = all;
                Caption = 'Update Customer', comment = 'ESP="Actualizar Clientes"';
                Image = CustomerList;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea actualizar los Clientes?', comment = 'ESP="¿Desea actualizar los Clientes?"';
                begin
                    if Confirm(lblConfirm) then
                        AbertiaSalesCustomer.CreateSalesCustomer();
                    UpdateEntryNos();
                end;
            }
            action(UpdateItems)
            {
                ApplicationArea = all;
                Caption = 'Update Items', comment = 'ESP="Actualizar Productos"';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea actualizar los Productos?', comment = 'ESP="¿Desea actualizar los Productos?"';
                begin
                    if Confirm(lblConfirm) then
                        ABERTIASalesItem.CreateSalesItem();
                    UpdateEntryNos();
                end;
            }
        }
        area(Navigation)
        {
            action(GLAccount)
            {
                ApplicationArea = all;
                Caption = 'GL Account', comment = 'ESP="Cuentas contables"';
                Image = Account;
                RunObject = page "ABERTIA GL Account";
            }
            action(GLEntry)
            {
                ApplicationArea = all;
                Caption = 'GL Entry', comment = 'ESP="Movs. Contabilidad"';
                Image = Entries;
                RunObject = page "ABERTIA GL Entry";
            }
            action(GLBidgetEntry)
            {
                ApplicationArea = all;
                Caption = 'GL Budget Entry', comment = 'ESP="Movs. presupuesto Contabilidad"';
                Image = LedgerBudget;
                RunObject = page "ABERTIA GL Budget Entry";
            }
        }
    }
    trigger OnInit()
    begin
        OpenTableConnection();
    end;

    trigger OnOpenPage()
    begin
        UpdateEntryNos();
    end;

    var
        GenLedgerSetup: Record "General Ledger Setup";
        AbertiaGLAccount: Record "ABERTIA GL Account";
        AbertiaGLEntry: Record "ABERTIA GL Entry";
        AbertiaGLEntryBudget: Record "ABERTIA GL Budget";
        AbertiaSalesCustomer: Record "ABERTIA SalesCustomer";
        ABERTIASalesItem: Record "ABERTIA SalesItem";
        CurrencyCode: Code[10];
        GLEntryNo: Integer;
        GLBudgetNo: Integer;
        GLAccountNo: Integer;
        SalesCustomer: Integer;
        SalesItem: Integer;
        TypeUpdate: Option Nuevo,Periodo,Todo;
        EntryNoIni: Integer;

    procedure OpenTableConnection()
    begin
        GenLedgerSetup.Get();
        CurrencyCode := GenLedgerSetup."LCY Code";
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI', GenLedgerSetup.AbertiaTABLECONNECTION());
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;

    local procedure UpdateEntryNos()
    var
        myInt: Integer;
    begin
        AbertiaGLAccount.Reset();
        AbertiaGLEntry.Reset();
        AbertiaGLEntryBudget.Reset();
        AbertiaSalesCustomer.Reset();
        ABERTIASalesItem.Reset();
        GLAccountNo := AbertiaGLAccount.Count;
        GLEntryNo := AbertiaGLEntry.Count;
        GLBudgetNo := AbertiaGLEntryBudget.Count;
        SalesCustomer := AbertiaSalesCustomer.Count;
        SalesItem := ABERTIASalesItem.Count;
    end;
}