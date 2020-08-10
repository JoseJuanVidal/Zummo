page 50125 "AccountManagerActivities2"
{
     Caption = 'Activities', Comment = 'ESP="Actividades"';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
            cuegroup(Productos)
            {
                Caption = 'Items', comment = 'ESP="Productos"';

                field(ProdPdteValidar_btc; ProdPdteValidar_btc)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Item List";
                    ToolTip = 'Specify the number of products pending validation by accounting', comment = 'ESP="Especifica el número de productos pendientes de validar por contabilidad"';
                }
            }
            cuegroup(Payments)
            {
                Caption = 'Payments', Comment = 'ESP="Pagos"';
                field("Overdue Sales Documents"; "Overdue Sales Documents")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Customer Ledger Entries";
                    ToolTip = 'Specifies the number of invoices where the customer is late with payment.', Comment = 'ESP="Especifica el número de facturas en las que el cliente tiene un retraso en el pago."';
                }
                field("Purchase Documents Due Today"; "Purchase Documents Due Today")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Vendor Ledger Entries";
                    ToolTip = 'Specifies the number of purchase invoices where you are late with payment.', Comment = 'ESP="Especifica el número de facturas de compra en las que usted tiene un retraso en el pago."';
                }

                actions
                {
                    action("Edit Cash Receipt Journal")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Edit Cash Receipt Journal', Comment = 'ESP="Editar diario de recibos de efectivo"';
                        RunObject = Page "Cash Receipt Journal";
                        ToolTip = 'Register received payments in a cash receipt journal that may already contain journal lines.', Comment = 'ESP="Permite registrar los pagos recibidos en un diario de recibos de cobro que ya puede contener líneas del diario."';
                    }
                    action("New Sales Credit Memo")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Sales Credit Memo', Comment = 'ESP="Nuevo abono venta"';
                        RunObject = Page "Sales Credit Memo";
                        RunPageMode = Create;
                        ToolTip = 'Process a return or refund by creating a new sales credit memo.', Comment = 'ESP="Permite procesar una devolución o un reembolso mediante la creación de un nuevo abono de ventas."';
                    }
                    action("Edit Payment Journal")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Edit Payment Journal', Comment = 'ESP="Editar diario de pagos"';
                        RunObject = Page "Payment Journal";
                        ToolTip = 'Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.', Comment = 'ESP="Permite pagar a los proveedores al rellenar el diario de pagos automáticamente de acuerdo con los pagos vencidos, así como la posibilidad de exportar todos los pagos al banco para su procesamiento automático."';
                    }
                    action("New Purchase Credit Memo")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Purchase Credit Memo', Comment = 'ESP="Nuevo abono compra"';
                        RunObject = Page "Purchase Credit Memo";
                        RunPageMode = Create;
                        ToolTip = 'Specifies a new purchase credit memo so you can manage returned items to a vendor.', Comment = 'ESP="Especifica un nuevo abono de compra para poder administrar los productos devueltos a un proveedor."';
                    }
                }
            }
            cuegroup("Document Approvals")
            {
                Caption = 'Document Approvals', Comment = 'ESP="Aprobación documentos"';
                field("POs Pending Approval"; "POs Pending Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of purchase orders that are pending approval.', Comment = 'ESP="Especifica el número de pedidos de compra pendientes de aprobación."';
                }
                field("SOs Pending Approval"; "SOs Pending Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales orders that are pending approval.', Comment = 'ESP="Especifica el número de pedidos de venta pendientes de aprobación."';
                }

                actions
                {
                    action("Create Reminders...")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Create Reminders...', Comment = 'ESP="Crear recordatorios..."';
                        RunObject = Report "Create Reminders";
                        ToolTip = 'Remind your customers of late payments.', Comment = 'ESP="Permite recordar a los clientes los pagos atrasados."';
                    }
                    action("Create Finance Charge Memos...")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Create Finance Charge Memos...', Comment = 'ESP="Crear documentos interés..."';
                        RunObject = Report "Create Finance Charge Memos";
                        ToolTip = 'Issue finance charge memos to your customers as a consequence of late payment.', Comment = 'ESP="Permite emitir documentos de interés para los clientes como resultado de un pago atrasado."';
                    }
                }
            }
            cuegroup(Cartera)
            {
                Caption = 'Cartera', Comment = 'ESP="Cartera"';
                field("Receivable Documents"; "Receivable Documents")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Receivables Cartera Docs";
                    ToolTip = 'Specifies the receivables document that is associated with the bill group.', Comment = 'ESP="Especifica el documento a cobrar asociado a la remesa."';
                }
                field("Payable Documents"; "Payable Documents")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Payables Cartera Docs";
                    ToolTip = 'Specifies the payables document that is associated with the bill group.', Comment = 'ESP="Especifica el documento a pagar asociado a la remesa."';
                }

                actions
                {
                    action("New Bill Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Bill Group', Comment = 'ESP="Nueva remesa"';
                        RunObject = Page "Bill Groups";
                        RunPageMode = Create;
                        ToolTip = 'Create a new group of receivables documents for submission to the bank for electronic collection.', Comment = 'ESP="Crear un nuevo grupo de documentos a cobrar que se enviarán al banco para el cobro electrónico."';
                    }
                    action("New Payment Order")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Payment Order', Comment = 'ESP="Nueva orden pago"';
                        RunObject = Page "Payment Orders";
                        RunPageMode = Create;
                        ToolTip = 'Create a new order for payables documents for submission to the bank for electronic payment.', Comment = 'ESP="Permite crear una nueva orden de documentos a pagar que se enviará al banco para pago electrónico."';
                    }
                }
            }
            cuegroup("Cash Management")
            {
                Caption = 'Cash Management', Comment = 'ESP="Tesorería"';
                field("Non-Applied Payments"; "Non-Applied Payments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Reconciliation Journals', Comment = 'ESP="Diarios de conciliación de pagos"';
                    DrillDownPageID = "Pmt. Reconciliation Journals";
                    Image = Cash;
                    ToolTip = 'Specifies a window to reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.', Comment = 'ESP="Permite especificar una ventana para conciliar automáticamente los documentos sin pagar con sus respectivas transacciones bancarias al importar una fuente o un archivo de extracto bancario. En el diario de conciliación de pagos, los pagos entrantes o salientes en su banco se aplican, de forma automática o semiautomática, a sus respectivos movimientos contables de cliente o proveedor abiertos. Cualquier movimiento de cuenta bancaria abierto relacionado con los movimientos de cliente o proveedor liquidados se cerrará cuando elija la acción Registrar pagos y conciliar banco. Esto significa que la cuenta bancaria se concilia automáticamente para los pagos que se registran con el diario."';
                }

                actions
                {
                    action("New Payment Reconciliation Journal")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Payment Reconciliation Journal', Comment = 'ESP="Nuevo diario de conciliación de pagos"';
                        ToolTip = 'Reconcile unpaid documents automatically with their related bank transactions by importing bank a bank statement feed or file.', Comment = 'ESP="Permite conciliar automáticamente documentos sin pagar con sus respectivas transacciones bancarias al importar una fuente o un archivo de extracto bancario."';

                        trigger OnAction()
                        var
                            BankAccReconciliation: Record "Bank Acc. Reconciliation";
                        begin
                            BankAccReconciliation.OpenNewWorksheet
                        end;
                    }
                }
            }
            cuegroup("Incoming Documents")
            {
                Caption = 'Incoming Documents', Comment = 'ESP="Documentos entrantes"';
                field("New Incoming Documents"; "New Incoming Documents")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Incoming Documents";
                    ToolTip = 'Specifies the number of new incoming documents in the company. The documents are filtered by today''s date.', Comment = 'ESP="Especifica el número de nuevos documentos entrantes de la empresa. Los documentos se filtran por la fecha actual."';
                }
                field("Approved Incoming Documents"; "Approved Incoming Documents")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Incoming Documents";
                    ToolTip = 'Specifies the number of approved incoming documents in the company. The documents are filtered by today''s date.', Comment = 'ESP="Especifica el número de documentos entrantes aprobados de la empresa. Los documentos se filtran por la fecha actual."';
                }
                field("OCR Completed"; "OCR Completed")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Incoming Documents";
                    ToolTip = 'Specifies that incoming document records that have been created by the OCR service.', Comment = 'ESP="Especifica los registros de documentos entrantes que se han creado mediante el servicio de OCR."';
                }

                actions
                {
                    action(CheckForOCR)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Receive from OCR Service', Comment = 'ESP="Recibir del servicio OCR"';
                        RunObject = Codeunit "OCR - Receive from Service";
                        RunPageMode = View;
                        ToolTip = 'Process new incoming electronic documents that have been created by the OCR service and that you can convert to, for example, purchase invoices.', Comment = 'ESP="Permite procesar nuevos documentos electrónicos entrantes que se han creado mediante el servicio de OCR y que pueden convertirse, por ejemplo, en facturas de compra."';
                        Visible = ShowCheckForOCR;
                    }
                }
            }
            cuegroup("My User Tasks")
            {
                Caption = 'My User Tasks', Comment = 'ESP="Mis tareas de usuario"';
                field("UserTaskManagement.GetMyPendingUserTasksCount"; UserTaskManagement.GetMyPendingUserTasksCount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pending User Tasks', Comment = 'ESP="Tareas de usuario pendientes"';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of pending tasks that are assigned to you or to a group that you are a member of.', Comment = 'ESP="Especifica el número de tareas pendientes que tiene asignadas o que se han asignado a un grupo del que es miembro."';

                    trigger OnDrillDown()
                    var
                        UserTaskList: Page "User Task List";
                    begin
                        UserTaskList.SetPageToShowMyPendingUserTasks;
                        UserTaskList.Run;
                    end;
                }
            }
            cuegroup(MissingSIIEntries)
            {
                Caption = 'Missing SII Entries', Comment = 'ESP="Movs. SII que faltan"';
                field("Missing SII Entries"; "Missing SII Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Missing SII Entries', Comment = 'ESP="Movs. SII que faltan"';
                    DrillDownPageID = "Recreate Missing SII Entries";
                    ToolTip = 'Specifies that some posted documents were not transferred to SII.', Comment = 'ESP="Especifica que algunos documentos registrados no se transfirieron a SII."';

                    trigger OnDrillDown()
                    var
                        SIIRecreateMissingEntries: Codeunit "SII Recreate Missing Entries";
                    begin
                        SIIRecreateMissingEntries.ShowRecreateMissingEntriesPage;
                    end;
                }
                field("Days Since Last SII Check"; "Days Since Last SII Check")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Recreate Missing SII Entries";
                    Image = Calendar;
                    ToolTip = 'Specifies the number of days since the last check for missing SII entries.', Comment = 'ESP="Especifica el número de días desde que se comprobó por última vez si faltan movimientos SII."';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues;
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;

        SetFilter("Due Date Filter", '<=%1', WorkDate);
        SetFilter("Overdue Date Filter", '<%1', WorkDate);
        SetFilter("User ID Filter", UserId);
        ShowCheckForOCR := OCRServiceMgt.OcrServiceIsEnable;
    end;

    var
        OCRServiceMgt: Codeunit "OCR Service Mgt.";
        UserTaskManagement: Codeunit "User Task Management";
        ShowCheckForOCR: Boolean;

    local procedure CalculateCueFieldValues()
    var
        SIIRecreateMissingEntries: Codeunit "SII Recreate Missing Entries";
    begin
        if FieldActive("Missing SII Entries") then
            "Missing SII Entries" := SIIRecreateMissingEntries.GetMissingEntriesCount;
        if FieldActive("Days Since Last SII Check") then
            "Days Since Last SII Check" := SIIRecreateMissingEntries.GetDaysSinceLastCheck;
    end;
}