page 50124 "Acc Manager 2 Role Center"
{
    
    Caption = 'Accounting Manager', Comment = 'Administrador de contabilidad';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control99; "Finance Performance")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part(Control1902304208; AccountManagerActivities2)
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Control1907692008; "My Customers")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control103; "Trailing Sales Orders Chart")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part(Control106; "My Job Queue")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part(Control100; "Cash Flow Forecast Chart")
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Control1902476008; "My Vendors")
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Control108; "Report Inbox Part")
                {
                    ApplicationArea = Basic, Suite;
                }
                systempart(Control1901377608; MyNotes)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&G/L Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&G/L Trial Balance', Comment = 'ESP="Balance comprobación con&tabilidad"';
                Image = "Report";
                RunObject = Report "Trial Balance";
                ToolTip = 'View, print, or send a report that shows the balances for the general ledger accounts, including the debits and credits. You can use this report to ensure accurate accounting practices.', Comment = 'ESP="Permite ver, imprimir o enviar un informe que muestra los saldos de las cuentas de contabilidad, incluidos los importes del debe y el haber. Este informe se puede utilizar para garantizar la precisión de las prácticas contables."';
            }
            action("&Bank Detail Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Bank Detail Trial Balance', Comment = 'ESP="&Balance comprobación detalles bancarios"';
                Image = "Report";
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
                ToolTip = 'View, print, or send a report that shows a detailed trial balance for selected bank accounts. You can use the report at the close of an accounting period or fiscal year.', Comment = 'ESP="Permite ver, imprimir o enviar un informe que muestra un balance de comprobación detallado de las cuentas bancarias seleccionadas. El informe se puede utilizar en el cierre de un periodo contable o un ejercicio."';
            }
            action("&Account Schedule")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Account Schedule', Comment = 'ESP="Es&quema cuentas"';
                Image = "Report";
                RunObject = Report "Account Schedule";
                ToolTip = 'Open an account schedule to analyze figures in general ledger accounts or to compare general ledger entries with general ledger budget entries.', Comment = 'ESP="Permite abrir un esquema de cuentas para analizar las cifras de las cuentas de contabilidad general o para comparar los movimientos de contabilidad general con los movimientos de presupuesto de contabilidad general."';
            }
            action("Normalized Account Schedule")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Normalized Account Schedule', Comment = 'ESP="Esquema cuentas normalizado"';
                Image = "Report";
                RunObject = Report "Normalized Account Schedule";
                ToolTip = 'View information about each general ledger account and its schedule of fees, terms, and applicable conditions. This report is formatted to print account schedules on preprinted stationary.', Comment = 'ESP="Permite ver información acerca de cada cuenta de contabilidad general y su esquema de tarifas, términos y condiciones aplicables. Este informe tiene formato para imprimir los esquemas de cuentas en papel preimpreso."';
            }
            action("Detail Account Statement")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Detail Account Statement', Comment = 'ESP="Extracto movs. cuenta"';
                Image = "Report";
                RunObject = Report "Detail Account Statement";
                ToolTip = 'View all general ledger entries by account for a specific period.', Comment = 'ESP="Permite ver todos los movimientos de contabilidad por cuenta durante un período determinado."';
            }
            action("Bu&dget")
            {
                ApplicationArea = Suite;
                Caption = 'Bu&dget', Comment = 'ESP="Presupuest&o"';
                Image = "Report";
                RunObject = Report Budget;
                ToolTip = 'View or edit estimated amounts for a range of accounting periods.', Comment = 'ESP="Permite ver o editar los importes estimados de un intervalo de períodos contables."';
            }
            action("Trial Bala&nce/Budget")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Bala&nce/Budget', Comment = 'ESP="Balance s&umas y saldos/Ppto."';
                Image = "Report";
                RunObject = Report "Trial Balance/Budget";
                ToolTip = 'View a trial balance in comparison to a budget. You can choose to see a trial balance for selected dimensions. You can use the report at the close of an accounting period or fiscal year.', Comment = 'ESP="Permite ver un balance de sumas y saldos con respecto a un presupuesto. Puede elegir consultar un balance de comprobación de las dimensiones seleccionadas. Puede utilizar el informe al cierre de un ejercicio contable o fiscal."';
            }
            action("Trial Balance by &Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance by &Period', Comment = 'ESP="Bal. su&mas y saldos/periodo"';
                Image = "Report";
                RunObject = Report "Trial Balance by Period";
                ToolTip = 'Show the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.', Comment = 'ESP="Muestra el saldo inicial de cada cuenta, los movimientos producidos durante el periodo seleccionado de mes, trimestre o año, así como el saldo de cierre resultante."';
            }
            action("&Fiscal Year Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Fiscal Year Balance', Comment = 'ESP="Saldo del e&jercicio"';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
                ToolTip = 'View, print, or send a report that shows balance sheet movements for selected periods. The report shows the closing balance by the end of the previous fiscal year for the selected ledger accounts. It also shows the fiscal year until this date, the fiscal year by the end of the selected period, and the balance by the end of the selected period, excluding the closing entries. The report can be used at the close of an accounting period or fiscal year.', Comment = 'ESP="Permite ver, imprimir o enviar un informe que muestra los movimientos producidos en el balance durante los periodos seleccionados. El informe presenta el saldo de cierre de las cuentas contables seleccionadas al final del ejercicio anterior. Además, muestra el ejercicio hasta esta fecha, el ejercicio al final del periodo seleccionado y el saldo al final del periodo seleccionado, excluidos los movimientos de cierre. El informe se puede utilizar en el cierre de un periodo contable o un ejercicio."';
            }
            action("Balance Comp. - Prev. Y&ear")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Balance Comp. - Prev. Y&ear', Comment = 'ESP="Comp. de saldo - Año a&nterior"';
                Image = "Report";
                RunObject = Report "Balance Comp. - Prev. Year";
                ToolTip = 'View a report that shows your company''s assets, liabilities, and equity compared to the previous year.', Comment = 'ESP="Permite ver un informe que muestra el activo, el pasivo y los recursos propios de la empresa comparados con los del año anterior."';
            }
            action("&Closing Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Closing Trial Balance', Comment = 'ESP="Cierr&e del balance de comprobación"';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
                ToolTip = 'View, print, or send a report that shows this year''s and last year''s figures as an ordinary trial balance. The closing of the income statement accounts is posted at the end of a fiscal year. The report can be used in connection with closing a fiscal year.', Comment = 'ESP="Permite ver, imprimir o enviar un informe que muestra las cifras del ejercicio actual y del ejercicio anterior en forma de un balance de comprobación habitual. El cierre de las cuentas de balance de ingresos se registran al final del ejercicio. El informe puede utilizarse en relación con el cierre del ejercicio."';
            }
            separator(Action49)
            {
            }
            action("Cash Flow Date List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Flow Date List', Comment = 'ESP="Lista fechas flujo efectivo"';
                Image = "Report";
                RunObject = Report "Cash Flow Date List";
                ToolTip = 'View forecast entries for a period of time that you specify. The registered cash flow forecast entries are organized by source types, such as receivables, sales orders, payables, and purchase orders. You specify the number of periods and their length.', Comment = 'ESP="Permite ver movimientos de previsión para el período de tiempo que especifique. Los movimientos de la previsión del flujo de efectivo registrados se organizan por tipos de origen, como cobros, pedidos de ventas, pagos y pedidos de compra. Especifica el número de períodos y su duración."';
            }
            separator(Action115)
            {
            }
            action("Aged Accounts &Receivable")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged Accounts &Receivable', Comment = 'ESP="&Antigüedad cobros"';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
                ToolTip = 'View an overview of when your receivables from customers are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.', Comment = 'ESP="Permite ver un resumen del vencimiento de los cobros de los clientes (divididos en cuatro periodos). Es necesario especificar la fecha a partir de la cual se desea calcular la antigüedad y la duración del periodo para el que cada columna contendrá datos."';
            }
            action("Aged Accounts Pa&yable")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged Accounts Pa&yable', Comment = 'ESP="Antigüedad pa&gos"';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
                ToolTip = 'View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.', Comment = 'ESP="Permite ver un resumen del vencimiento de los pagos o los pagos vencidos a los proveedores (divididos en cuatro periodos). Es necesario especificar la fecha a partir de la cual se desea calcular la antigüedad y la duración del periodo para el que cada columna contendrá datos."';
            }
            action("Reconcile Cus&t. and Vend. Accs")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reconcile Cus&t. and Vend. Accs', Comment = 'ESP="Re&conc. ctas. client./prov."';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
                ToolTip = 'View if a certain general ledger account reconciles the balance on a certain date for the corresponding posting group. The report shows the accounts that are included in the reconciliation with the general ledger balance and the customer or the vendor ledger balance for each account and shows any differences between the general ledger balance and the customer or vendor ledger balance.', Comment = 'ESP="Permite ver si una cuenta de contabilidad determinada concilia el saldo en una fecha determinada para el grupo de registro correspondiente. El informe muestra las cuentas incluidas en la conciliación con el saldo de contabilidad general y el saldo de contabilidad del cliente o el proveedor de cada cuenta, así como las diferencias entre ambos saldos."';
            }
            separator(Action53)
            {
            }
            action("&VAT Registration No. Check")
            {
                ApplicationArea = VAT;
                Caption = '&VAT Registration No. Check', Comment = 'ESP="Verificar CIF/NI&F"';
                Image = "Report";
                RunObject = Report "VAT Registration No. Check";
                ToolTip = 'Use an EU VAT number validation service to validated the VAT number of a business partner.', Comment = 'ESP="Usar un servicio de validación numérico de IVA de la UE para validar el número de IVA de un socio comercial."';
            }
            action("VAT E&xceptions")
            {
                ApplicationArea = VAT;
                Caption = 'VAT E&xceptions', Comment = 'ESP="E&xcepciones IVA"';
                Image = "Report";
                RunObject = Report "VAT Exceptions";
                ToolTip = 'View the VAT entries that were posted and placed in a general ledger register in connection with a VAT difference. The report is used to document adjustments made to VAT amounts that were calculated for use in internal or external auditing.', Comment = 'ESP="Muestra los movimientos de IVA registrados y colocados en un registro de contabilidad general en relación con una diferencia de IVA. El informe se usa para los ajustes de documentos realizados en los importes de IVA que se calculan para su uso en auditoría interna o externa."';
            }
            action("VAT &Statement")
            {
                ApplicationArea = VAT;
                Caption = 'VAT &Statement', Comment = 'ESP="&Declaración IVA"';
                Image = "Report";
                RunObject = Report "VAT Statement";
                ToolTip = 'View a statement of posted VAT and calculate the duty liable to the customs authorities for the selected period.', Comment = 'ESP="Muestra una declaración de IVA registrada y calcular los impuestos por pagar a las autoridades aduaneras para el periodo seleccionado."';
            }
            action("G/L - VAT Reconciliation")
            {
                ApplicationArea = VAT;
                Caption = 'G/L - VAT Reconciliation', Comment = 'ESP="C/G: Conciliación de IVA"';
                Image = "Report";
                RunObject = Report "G/L - VAT Reconciliation";
                ToolTip = 'Verify that the VAT amounts on the VAT statements match the amounts from the G/L entries.', Comment = 'ESP="Compruebe que los importes de IVA de las declaraciones de IVA coinciden con los importes de los movimientos de contabilidad."';
            }
            action("VAT - VIES Declaration Tax Aut&h")
            {
                ApplicationArea = BasicEU;
                Caption = 'VAT - VIES Declaration Tax Aut&h', Comment = 'ESP="I&VA - Admon. fiscal decl. VIES"';
                Image = "Report";
                RunObject = Report "VAT- VIES Declaration Tax Auth";
                ToolTip = 'View information to the customs and tax authorities for sales to other EU countries/regions. If the information must be printed to a file, you can use the VAT- VIES Declaration Disk report.', Comment = 'ESP="Permite ver información a los clientes y la autoridades fiscales sobre las ventas a otros países o regiones de la UE. Si la información se debe imprimir a un archivo, puede utilizar el informe IVA- Declar. intracom. disco."';
            }
            action("VAT - VIES Declaration Dis&k")
            {
                ApplicationArea = BasicEU;
                Caption = 'VAT - VIES Declaration Dis&k', Comment = 'ESP="IVA - Declar. int&racom. disco"';
                Image = "Report";
                RunObject = Report "Make 349 Declaration";
                ToolTip = 'Report your sales to other EU countries or regions to the customs and tax authorities. If the information must be printed out on a printer, you can use the VAT- VIES Declaration Tax Auth report. The information is shown in the same format as in the declaration list from the customs and tax authorities.', Comment = 'ESP="Notifica sus ventas a otros países o regiones de la UE a las autoridades aduaneras y fiscales. Si la información tiene que imprimirse físicamente, puede utilizar el informe IVA - admon. fiscal decl. VIES. Esta información se muestra en el mismo formato que en la lista de declaración de las autoridades aduaneras y fiscales."';
            }
            action("EC Sales &List")
            {
                ApplicationArea = BasicEU;
                Caption = 'EC Sales &List', Comment = 'ESP="&Lista venta CE"';
                Image = "Report";
                RunObject = Report "EC Sales List";
                ToolTip = 'Calculate VAT amounts from sales, and submit the amounts to a tax authority.', Comment = 'ESP="Permite calcular los importes de IVA de ventas y enviar los importes a una autoridad fiscal."';
            }
            separator(Action60)
            {
            }
            action("&Intrastat - Checklist")
            {
                ApplicationArea = BasicEU;
                Caption = '&Intrastat - Checklist', Comment = 'ESP="Intra&stat - Test"';
                Image = "Report";
                RunObject = Report "Intrastat - Checklist";
                ToolTip = 'View a checklist that you can use to find possible errors before printing and also as documentation for what is printed. You can use the report to check the Intrastat journal before you use the Intrastat - Make Disk Tax Auth batch job.', Comment = 'ESP="Permite ver una lista de comprobación que puede usar para detectar errores antes de imprimir y también para documentar lo que se imprime. Puede utilizar el informe para comprobar el diario de intrastat antes de ejecutar el proceso Intrastat - Decl. disquete."';
            }
            action("Intrastat - For&m")
            {
                ApplicationArea = BasicEU;
                Caption = 'Intrastat - For&m', Comment = 'ESP="Intrastat - Formular&io"';
                Image = "Report";
                RunObject = Report "Intrastat - Form";
                ToolTip = 'View all the information that must be transferred to the printed Intrastat form.', comment = 'ESP="Muestra toda la información que se debe transferir al formulario Intrastat impreso."';
            }
            separator(Action4)
            {
            }
            action("Cost Accounting P/L Statement")
            {
                ApplicationArea = CostAccounting;
                Caption = 'Cost Accounting P/L Statement', Comment = 'ESP="Extracto P/G costes"';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement";
                ToolTip = 'View the credit and debit balances per cost type, together with the chart of cost types.', Comment = 'ESP="Permite ver los saldos de crédito y débito por tipo de coste, junto con el plan de tipos coste."';
            }
            action("CA P/L Statement per Period")
            {
                ApplicationArea = CostAccounting;
                Caption = 'CA P/L Statement per Period', Comment = 'ESP="Extracto P/G costes por periodo"';
                Image = "Report";
                RunObject = Report "Cost Acctg. Stmt. per Period";
                ToolTip = 'View profit and loss for cost types over two periods with the comparison as a percentage.', Comment = 'ESP="Permite ver pérdidas y ganancias de tipos de coste en dos períodos con la comparación expresada en porcentaje."';
            }
            action("CA P/L Statement with Budget")
            {
                ApplicationArea = CostAccounting;
                Caption = 'CA P/L Statement with Budget', Comment = 'ESP="Extracto P/G costes con ppto."';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement/Budget";
                ToolTip = 'View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.', Comment = 'ESP="Permite ver una comparación del saldo con los importes del presupuesto y calcula la variación y el porcentaje de varianza en el periodo contable actual, el periodo contable acumulado y el ejercicio."';
            }
            action("Cost Accounting Analysis")
            {
                ApplicationArea = CostAccounting;
                Caption = 'Cost Accounting Analysis', Comment = 'ESP="Análisis de contabilidad de costes"';
                Image = "Report";
                RunObject = Report "Cost Acctg. Analysis";
                ToolTip = 'View balances per cost type with columns for seven fields for cost centers and cost objects. It is used as the cost distribution sheet in Cost accounting. The structure of the lines is based on the chart of cost types. You define up to seven cost centers and cost objects that appear as columns in the report.', Comment = 'ESP="Permite ver saldos por tipo de coste con columnas de siete campos para centros de coste y objetos de coste. Se utiliza como hoja de distribución de costes en Contabilidad de costes. La estructura de las líneas se basa en el plan de tipos coste. Debe definir hasta siete centros de coste y objetos de coste que se muestran como columnas en el informe."';
            }
        }
        area(embedding)
        {
            action("Chart of Accounts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chart of Accounts', Comment = 'ESP="Plan de cuentas"';
                RunObject = Page "Chart of Accounts";
                ToolTip = 'View the chart of accounts.', Comment = 'ESP="Permite ver el plan de cuentas."';
            }
            action(Vendors)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendors', Comment = 'ESP="Proveedores"';
                Image = Vendor;
                RunObject = Page "Vendor List";
                ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.', Comment = 'ESP="Permite ver o editar la información detallada de los proveedores con los que realiza operaciones comerciales. En cada ficha de proveedor, puede abrir información relacionada, como estadísticas de compras y pedidos en curso. Además, puede definir los precios especiales y los descuentos de línea que el proveedor le concede si se cumplen ciertas condiciones."';
            }
            action(VendorsBalance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Balance', Comment = 'ESP="Saldo"';
                Image = Balance;
                RunObject = Page "Vendor List";
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
                ToolTip = 'View a summary of the bank account balance in different periods.', Comment = 'ESP="Permite ver un resumen del saldo de la cuenta bancaria en distintos períodos."';
            }
            action("Purchase Orders")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Orders', Comment = 'ESP="Pedidos compra"';
                RunObject = Page "Purchase Order List";
                ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.', Comment = 'ESP="Permite crear pedidos de compra para reflejar los documentos de venta que le envían los proveedores. Esto le permite registrar el coste de compra y realizar un seguimiento de las cuentas por pagar. Al registrar los pedidos de compra dinámicamente, se actualizan los niveles de inventario para que pueda reducir los costes de inventario y ofrecer un mejor servicio al cliente. Los pedidos de compra permiten recepciones parciales (a diferencia de las facturas de compra), así como el envío directo desde el proveedor al cliente. Los pedidos de compra se pueden crear automáticamente a partir de archivos PDF o de imagen proporcionados por los proveedores mediante la característica Documentos entrantes."';
            }
            action(Budgets)
            {
                ApplicationArea = Suite;
                Caption = 'Budgets', Comment = 'ESP="Presupuestos"';
                RunObject = Page "G/L Budget Names";
                ToolTip = 'View or edit estimated amounts for a range of accounting periods.', Comment = 'ESP="Permite ver o editar los importes estimados de un intervalo de períodos contables."';
            }
            action("Bank Accounts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Accounts', Comment = 'ESP="Bancos"';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
                ToolTip = 'View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.', Comment = 'ESP="Permite ver o configurar información detallada sobre la cuenta bancaria, por ejemplo, la divisa que se usa, el formato de archivos bancarios que se usa para importar y exportar como pagos electrónicos y la numeración de los cheques."';
            }
            action("VAT Statements")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Statements', Comment = 'ESP="Declaraciones IVA"';
                RunObject = Page "VAT Statement Names";
                ToolTip = 'View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.', Comment = 'ESP="Permite ver una declaración de los importes de IVA registrados, calcular el importe de liquidación de IVA de un periodo determinado, como un trimestre, y preparar el envío de la liquidación a las autoridades fiscales."';
            }
            action(Items)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items', Comment = 'ESP="Productos"';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.', Comment = 'ESP="Permite ver o editar la información detallada de los productos que comercializa. La ficha de producto puede ser del tipo Inventario o Servicio para especificar si el producto es una unidad física o una unidad de tiempo de mano de obra. Este campo también define si los productos del inventario o de los pedidos entrantes se reservan automáticamente para los documentos de salida y si se crean vínculos de seguimiento de pedidos entre la demanda y el suministro para reflejar las acciones planificadas."';
            }
            action(Customers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customers', Comment = 'ESP="Clientes"';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.', Comment = 'ESP="Permite ver o editar la información detallada de los clientes con los que realiza operaciones comerciales. En cada ficha cliente, puede abrir información relacionada, como estadísticas de ventas y pedidos en curso. Además, puede definir los precios especiales y los descuentos de línea que concede si se cumplen ciertas condiciones."';
            }
            action(CustomersBalance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Balance', Comment = 'ESP="Saldo"';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
                ToolTip = 'View a summary of the bank account balance in different periods.', Comment = 'ESP="Permite ver un resumen del saldo de la cuenta bancaria en distintos períodos."';
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Orders', Comment = 'ESP="Pedidos venta"';
                Image = "Order";
                RunObject = Page "Sales Order List";
                ToolTip = 'Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.', Comment = 'ESP="Permite registrar los acuerdos con los clientes para vender determinados productos según determinadas condiciones de pago y entrega. Los pedidos de venta, a diferencia de las facturas de venta, le permiten realizar envíos parciales, entregar directamente desde el proveedor al cliente, iniciar la manipulación de almacén e imprimir diversos documentos para los clientes. La facturación de ventas está integrada en el proceso de los pedidos de venta."';
            }
            action(Reminders)
            {
                ApplicationArea = Suite;
                Caption = 'Reminders', Comment = 'ESP="Recordatorios"';
                Image = Reminder;
                RunObject = Page "Reminder List";
                ToolTip = 'Remind customers about overdue amounts based on reminder terms and the related reminder levels. Each reminder level includes rules about when the reminder will be issued in relation to the invoice due date or the date of the previous reminder and whether interests are added. Reminders are integrated with finance charge memos, which are documents informing customers of interests or other money penalties for payment delays.', Comment = 'ESP="Permite recordar a los clientes los importes vencidos según los términos de recordatorio y los niveles de recordatorio relacionados. Cada nivel de recordatorio incluye reglas que determinan cuándo se generará el recordatorio en relación con la fecha de vencimiento de la factura o la fecha del recordatorio anterior, y si se agregan intereses. Los recordatorios se integran a documentos de interés, que son documentos para notificar a los clientes sobre intereses u otras sanciones monetarias a raíz de retrasos de pago."';
            }
            action("Finance Charge Memos")
            {
                ApplicationArea = Suite;
                Caption = 'Finance Charge Memos', Comment = 'ESP="Docs. interés"';
                Image = FinChargeMemo;
                RunObject = Page "Finance Charge Memo List";
                ToolTip = 'Send finance charge memos to customers with delayed payments, typically following a reminder process. Finance charges are calculated automatically and added to the overdue amounts on the customer''s account according to the specified finance charge terms and penalty/interest amounts.', Comment = 'ESP="Permite enviar documentos de interés a los clientes que tienen pagos atrasados. Normalmente, el envío se realiza después del proceso de recordatorio. Los intereses se calculan automáticamente y se agregan a los importes vencidos en la cuenta del cliente conforme a los términos de interés y los importes de recargo por mora o interés especificados."';
            }
            action("Incoming Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Incoming Documents', Comment = 'ESP="Documentos entrantes"';
                Image = Documents;
                RunObject = Page "Incoming Documents";
                ToolTip = 'Handle incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.', Comment = 'ESP="Permite administrar los documentos entrantes (por ejemplo, facturas de proveedor en PDF o como archivos de imagen) que se pueden convertir a registros de documento de forma manual o automática (por ejemplo, facturas de compra). Los archivos externos que representan los documentos entrantes se pueden asociar a cualquier etapa del proceso, incluidos los documentos registrados y los movimientos de proveedor, cliente y contabilidad general resultantes."';
            }
            action("EC Sales List")
            {
                ApplicationArea = BasicEU;
                Caption = 'EC Sales List', Comment = 'ESP="Lista venta CE"';
                RunObject = Page "EC Sales List Reports";
                ToolTip = 'Prepare the EC Sales List report so you can submit VAT amounts to a tax authority.', Comment = 'ESP="Prepara el informe de lista de ventas CE de modo que puede enviar los importes de IVA a una autoridad fiscal."';
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals', Comment = 'ESP="Diarios"';
                Image = Journals;
                action(PurchaseJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Journals', Comment = 'ESP="Diarios de compras"';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Purchases),
                                        Recurring = CONST(false));
                    ToolTip = 'Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.', Comment = 'ESP="Permite registrar cualquier transacción relacionada con las compras directamente en una cuenta de proveedor, banco o contabilidad general en lugar de utilizar documentos dedicados. Puede registrar todos los tipos de transacciones de compra financieras, incluidos pagos, reembolsos e importes financieros. Tenga en cuenta que no puede registrar las cantidades de producto con un diario de compras."';
                }
                action(SalesJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Journals', Comment = 'ESP="Diarios de ventas"';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Sales),
                                        Recurring = CONST(false));
                    ToolTip = 'Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.', Comment = 'ESP="Permite registrar cualquier transacción relacionada con las ventas directamente en una cuenta de cliente, banco o contabilidad general en lugar de utilizar documentos dedicados. Puede registrar todos los tipos de transacciones de venta financieras, incluidos pagos, reembolsos e importes financieros. Tenga en cuenta que no puede registrar las cantidades de producto con un diario de ventas."';
                }
                action(CashReceiptJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Receipt Journals', Comment = 'ESP="Diarios de recibo de efectivo"';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                        Recurring = CONST(false));
                    ToolTip = 'Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.', Comment = 'ESP="Permite registrar los pagos recibidos al aplicarlos manualmente a los movimientos relacionados de banco, proveedor o cliente. Posteriormente, es necesario registrar los pagos en las cuentas de contabilidad general y cerrar los movimientos relacionados."';
                }
                action(PaymentJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Journals', Comment = 'ESP="Diarios de pagos"';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
                    ToolTip = 'Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.', Comment = 'ESP="Permite registrar los pagos a proveedores. Un diario de pagos es un tipo de diario general que se utiliza para registrar transacciones de pago salientes en las cuentas de contabilidad general, banco, cliente, proveedor, empleado y activos fijos. Las función Proponer pagos a proveedores rellena automáticamente el diario con pagos que vencen. Cuando se registran los pagos, puede exportar los pagos a un archivo de banco para cargarlo en su banco si el sistema está configurado para la banca electrónica. También puede emitir cheques electrónicos desde el diario de pagos."';
                }
                action(ICGeneralJournals)
                {
                    ApplicationArea = Intercompany;
                    Caption = 'IC General Journals', Comment = 'ESP="Diarios generales IC"';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Intercompany),
                                        Recurring = CONST(false));
                    ToolTip = 'Post intercompany transactions. IC general journal lines must contain either an IC partner account or a customer or vendor account that has been assigned an intercompany partner code.', Comment = 'ESP="Registra transacciones de empresas vinculadas. Las líneas del diario general IC deben contener una cuenta de socio IC o una cuenta de cliente o proveedor a la que se haya asignado un código de socio de empresas vinculadas."';
                }
                action(GeneralJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'General Journals', Comment = 'ESP="Diarios generales"';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(false));
                    ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.', Comment = 'ESP="Permite registrar las transacciones financieras directamente en las cuentas de contabilidad general y otras cuentas, como las cuentas de banco, cliente, proveedor y empleado. Al registrar con un diario general, siempre se crean movimientos en las cuentas de contabilidad general. Esto es así incluso cuando, por ejemplo, se registra una línea del diario en una cuenta de cliente, ya que el movimiento se registra en una cuenta contable de cobros a través de un grupo contable."';
                }
                action("Intrastat Journals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Intrastat Journals', Comment = 'ESP="Diarios Intrastat"';
                    Image = "Report";
                    RunObject = Page "Intrastat Jnl. Batches";
                    ToolTip = 'Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.', Comment = 'ESP="Permite resumir el valor de sus compras y ventas con socios comerciales de la UE para fines estadísticos y preparar el envío correspondiente a las autoridades competentes."';
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets', Comment = 'ESP="Activos fijos"';
                Image = FixedAssets;
                action(Action17)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets', Comment = 'ESP="Activos fijos"';
                    RunObject = Page "Fixed Asset List";
                    ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.', Comment = 'ESP="Permite gestionar la amortización periódica de la maquinaria o las máquinas, realizar un seguimiento de los costes de mantenimiento, gestionar pólizas de seguros relacionadas con activos fijos y controlar las estadísticas de activos fijos."';
                }
                action(Insurance)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insurance', Comment = 'ESP="Seguros"';
                    RunObject = Page "Insurance List";
                    ToolTip = 'Manage insurance policies for fixed assets and monitor insurance coverage.', Comment = 'ESP="Administra las pólizas de seguros de activos fijos y supervisa la cobertura del seguro."';
                }
                action("Fixed Assets G/L Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets G/L Journals', Comment = 'ESP="Diarios generales A/F"';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Assets),
                                        Recurring = CONST(false));
                    ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation, in integration with the general ledger. The FA G/L Journal is a general journal, which is integrated into the general ledger.', Comment = 'ESP="Permite registrar activos fijos, como adquisiciones y amortizaciones, en la integración con la contabilidad general. El diario general de activos fijos es un diario general, integrado en la contabilidad."';
                }
                action("Fixed Assets Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets Journals', Comment = 'ESP="Diarios activos fijos"';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                    ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.', Comment = 'ESP="Permite registrar transacciones de activos fijos, como un libro de adquisición o amortización, sin la integración con la contabilidad."';
                }
                action("Fixed Assets Reclass. Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets Reclass. Journals', Comment = 'ESP="Diario reclasific. activos fijos"';
                    RunObject = Page "FA Reclass. Journal Batches";
                    ToolTip = 'Transfer, split, or combine fixed assets by preparing reclassification entries to be posted in the fixed asset journal.', Comment = 'ESP="Permite transferir, dividir o combinar activos fijos preparando movimientos de reclasificación para registrarlos en el diario de activos fijos."';
                }
                action("Insurance Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insurance Journals', Comment = 'ESP="Diarios de seguros"';
                    RunObject = Page "Insurance Journal Batches";
                    ToolTip = 'Post entries to the insurance coverage ledger.', Comment = 'ESP="Registra movimientos en la cobertura de seguros."';
                }
                action("<Action3>")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Recurring General Journals', Comment = 'ESP="Diarios generales periódicos"';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(true));
                    ToolTip = 'Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts', Comment = 'ESP="Permite definir cómo registrar transacciones que se repiten con unos pocos cambios o ninguno en las cuentas de contabilidad, bancos, clientes, proveedores o activos fijos."';
                }
                action("Recurring Fixed Asset Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Recurring Fixed Asset Journals', Comment = 'ESP="Diarios periódicos activos fijos"';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(true));
                    ToolTip = 'Post recurring fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.', Comment = 'ESP="Permite registrar transacciones de activos fijos recurrentes, como un libro de adquisición o amortización, sin la integración con la contabilidad."';
                }
            }
            group("Cash Flow")
            {
                Caption = 'Cash Flow', Comment = 'ESP="Flujo de efectivo"';
                action("Cash Flow Forecasts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Flow Forecasts', Comment = 'ESP="Previsiones de flujo de efectivo"';
                    RunObject = Page "Cash Flow Forecast List";
                    ToolTip = 'Combine various financial data sources to find out when a cash surplus or deficit might happen or whether you should pay down debt, or borrow to meet upcoming expenses.', Comment = 'ESP="Permite combinar varios orígenes de datos financieros para averiguar cuándo puede producirse un excedente de efectivo o déficit o si debe saldar la deuda o solicitar un préstamo para cubrir los próximos gastos."';
                }
                action("Chart of Cash Flow Accounts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chart of Cash Flow Accounts', Comment = 'ESP="Plan de cuentas de flujo de efectivo"';
                    RunObject = Page "Chart of Cash Flow Accounts";
                    ToolTip = 'View a chart contain a graphical representation of one or more cash flow accounts and one or more cash flow setups for the included general ledger, purchase, sales, services, or fixed assets accounts.', Comment = 'ESP="Permite ver un gráfico que contiene una representación gráfica de una o varias cuentas de flujo de efectivo y una o más configuraciones de flujo de efectivo para las cuentas de contabilidad general, compra, ventas, servicios o activos fijos incluidas."';
                }
                action("Cash Flow Manual Revenues")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Flow Manual Revenues', Comment = 'ESP="Ingresos manuales de flujo de efectivo"';
                    RunObject = Page "Cash Flow Manual Revenues";
                    ToolTip = 'Record manual revenues, such as rental income, interest from financial assets, or new private capital to be used in cash flow forecasting.', Comment = 'ESP="Permite registrar ingresos manuales, como ingresos por alquileres, intereses de activos fijos o nuevo capital privado que se emplearán en la previsión de flujo de efectivo."';
                }
                action("Cash Flow Manual Expenses")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Flow Manual Expenses', Comment = 'ESP="Gastos manuales de flujo de efectivo"';
                    RunObject = Page "Cash Flow Manual Expenses";
                    ToolTip = 'Record manual expenses, such as salaries, interest on credit, or planned investments to be used in cash flow forecasting.', Comment = 'ESP="Permite registrar gastos manuales, como salarios, intereses de los créditos o inversiones planificadas que se emplearán en la previsión de flujo de efectivo."';
                }
            }
            group("Cost Accounting")
            {
                Caption = 'Cost Accounting', Comment = 'ESP="Contabilidad de costes"';
                action("Cost Types")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Types', Comment = 'ESP="Tipos coste"';
                    RunObject = Page "Chart of Cost Types";
                    ToolTip = 'View the chart of cost types with a structure and functionality that resembles the general ledger chart of accounts. You can transfer the general ledger income statement accounts or create your own chart of cost types.', Comment = 'ESP="Permite ver el plan de tipos de coste con una estructura y la funcionalidad similar a la del plan de contabilidad general de cuentas. Puede transferir las cuentas de regularización de contabilidad o crear su propio plan de tipos de coste."';
                }
                action("Cost Centers")
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Cost Centers', Comment = 'ESP="Centros coste"';
                    RunObject = Page "Chart of Cost Centers";
                    ToolTip = 'Manage cost centers, which are departments and profit centers that are responsible for costs and income. Often, there are more cost centers set up in cost accounting than in any dimension that is set up in the general ledger. In the general ledger, usually only the first level cost centers for direct costs and the initial costs are used. In cost accounting, additional cost centers are created for additional allocation levels.', Comment = 'ESP="Permite administrar centros de coste que son departamentos y los centros de beneficio responsables de ingresos y costes. Con frecuencia, hay más centros de coste configurados en contabilidad de costes que en cualquier dimensión que se configura en la contabilidad. En esta, normalmente solo se utilizan los centros de coste de primer nivel para costes directos y los costes iniciales. En contabilidad de costes, se crean centros de coste adicionales para los niveles de asignación adicional."';
                }
                action("Cost Objects")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Objects', Comment = 'ESP="Objetos coste"';
                    RunObject = Page "Chart of Cost Objects";
                    ToolTip = 'Set up cost objects, which are products, product groups, or services of a company. These are the finished goods of a company that carry the costs. You can link cost centers to departments and cost objects to projects in your company.', Comment = 'ESP="Permite configurar objetos de coste, es decir, productos, grupos de productos o servicios de una empresa. Se trata de los productos terminados de una empresa que carga con los costes. Puede vincular centros de coste a departamentos y objetos de coste a los proyectos de la empresa."';
                }
                action("Cost Allocations")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Allocations', Comment = 'ESP="Asignaciones coste"';
                    RunObject = Page "Cost Allocation Sources";
                    ToolTip = 'Manage allocation rules to allocate costs and revenues between cost types, cost centers, and cost objects. Each allocation consists of an allocation source and one or more allocation targets. For example, all costs for the cost type Electricity and Heating are an allocation source. You want to allocate the costs to the cost centers Workshop, Production, and Sales, which are three allocation targets.', Comment = 'ESP="Permite administrar reglas de asignación para asignar costes e ingresos entre tipos de coste, centros de coste y objetos de coste. Cada asignación consta de un origen de asignación y uno o más destinos de asignación. Por ejemplo, todos los costes para el tipo Electricidad y Calefacción son un origen de asignación. Asignar los costes a los centros de coste Taller, Producción, y Ventas, que son tres destinos de asignación."';
                }
                action("Cost Budgets")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Budgets', Comment = 'ESP="Presupuestos coste"';
                    RunObject = Page "Cost Budget Names";
                    ToolTip = 'Set up cost accounting budgets that are created based on cost types just as a budget for the general ledger is created based on general ledger accounts. A cost budget is created for a certain period of time, for example, a fiscal year. You can create as many cost budgets as needed. You can create a new cost budget manually, or by importing a cost budget, or by copying an existing cost budget as the budget base.', Comment = 'ESP="Permite configurar presupuestos contabilidad de costes creados sobre la base de tipos de coste, tal y como un presupuesto de contabilidad se crea sobre la base de cuentas de la contabilidad. Un presupuesto de costes se crea para un cierto período de tiempo, por ejemplo, un ejercicio fiscal. Puede crear tantos presupuestos de costes como necesite. Puede crear manualmente un nuevo presupuesto de costes, importar un presupuesto de costes o copiar un presupuesto de costes existente como base presupuestaria."';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents', Comment = 'ESP="Documentos registrados"';
                Image = FiledPosted;
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices', Comment = 'ESP="Histórico facuras venta"';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.', Comment = 'ESP="Abre la lista de facturas de ventas registradas."';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos', Comment = 'ESP="Histórico abonos venta"';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.', Comment = 'ESP="Permite abrir la lista de abonos de ventas registrados."';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices', Comment = 'ESP="Histórico facturas compra"';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Open the list of posted purchase invoices.', Comment = 'ESP="Abre la lista de facturas de compra registradas."';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Credit Memos', Comment = 'ESP="Histórico abonos compra"';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Open the list of posted purchase credit memos.', Comment = 'ESP="Permite abrir la lista de abonos de compra registrados."';
                }
                action("Issued Reminders")
                {
                    ApplicationArea = Suite;
                    Caption = 'Issued Reminders', Comment = 'ESP="Recordatorios emitidos"';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                    ToolTip = 'View the list of issued reminders.', Comment = 'ESP="Permite ver la lista de recordatorios emitidos."';
                }
                action("Issued Fin. Charge Memos")
                {
                    ApplicationArea = Suite;
                    Caption = 'Issued Fin. Charge Memos', Comment = 'ESP="Docs. de interés emitidos"';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                    ToolTip = 'View the list of issued finance charge memos.', Comment = 'ESP="Permite ver la lista de documentos de interés emitidos."';
                }
                action("G/L Registers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'G/L Registers', Comment = 'ESP="Registro movs. contabilidad"';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'View posted G/L entries.', Comment = 'ESP="Permite ver los movimientos de C/G registrados."';
                }
                action("Cost Accounting Registers")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Accounting Registers', Comment = 'ESP="=Registros contabilidad costes"';
                    RunObject = Page "Cost Registers";
                    ToolTip = 'Get an overview of all cost entries sorted by posting date. ', Comment = 'ESP="Permite ver un resumen de todos los movimientos de coste ordenados por fecha de registro."';
                }
                action("Cost Accounting Budget Registers")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Accounting Budget Registers', Comment = 'ESP="Registros presupuestos contabilidad costes"';
                    RunObject = Page "Cost Budget Registers";
                    ToolTip = 'Get an overview of all cost budget entries sorted by posting date. ', Comment = 'ESP="Permite ver un resumen de todos los movimientos de presupuesto de costes ordenados por fecha de registro. "';
                }
            }
            group(Administration)
            {
                Caption = 'Administration', Comment = 'ESP="Administración"';
                Image = Administration;
                action(Currencies)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currencies', Comment = 'ESP="Divisas"';
                    Image = Currency;
                    RunObject = Page Currencies;
                    ToolTip = 'View the different currencies that you trade in or update the exchange rates by getting the latest rates from an external service provider.', Comment = 'ESP="Permite ver las distintas divisas que se usan o actualizar los tipos de cambio al obtener los tipos más recientes de un proveedor de servicios externos."';
                }
                action("Accounting Periods")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Accounting Periods', Comment = 'ESP="Periodos contables"';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                    ToolTip = 'Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.', Comment = 'ESP="Permite configurar el número de períodos contables, por ejemplo, 12 períodos mensuales, dentro del ejercicio y especificar qué periodo inicia el nuevo ejercicio."';
                }
                action("Number Series")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Number Series', Comment = 'ESP="Serie numérica"';
                    RunObject = Page "No. Series";
                    ToolTip = 'View or edit the number series that are used to organize transactions', Comment = 'ESP="Permite ver o editar las series numéricas que se usan para organizar transacciones."';
                }
                action("Analysis Views")
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Analysis Views', Comment = 'ESP="Vistas de análisis"';
                    RunObject = Page "Analysis View List";
                    ToolTip = 'Analyze amounts in your general ledger by their dimensions using analysis views that you have set up.', Comment = 'ESP="Permite analizar los importes en la contabilidad general por sus dimensiones mediante vista de análisis configuradas."';
                }
                action("Account Schedules")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Schedules', Comment = 'ESP="Esquemas de cuentas"';
                    RunObject = Page "Account Schedule Names";
                    ToolTip = 'Get insight into the financial data stored in your chart of accounts. Account schedules analyze figures in G/L accounts, and compare general ledger entries with general ledger budget entries. For example, you can view the general ledger entries as percentages of the budget entries. Account schedules provide the data for core financial statements and views, such as the Cash Flow chart.', Comment = 'ESP="Permite conocer los datos financieros almacenados en su plan de cuentas. Los esquemas de cuentas analizan las cifras de las cuentas de contabilidad y comparan los movimientos de contabilidad general con los movimientos de presupuesto de contabilidad general. Por ejemplo, puede ver los movimientos de contabilidad como porcentajes de los movimientos de presupuesto. Los esquemas de cuentas proporcionan los datos para los informes financieros fundamentales y vistas como el gráfico de flujo de efectivo."';
                }
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', Comment = 'ESP="Permite ver o editar dimensiones, como el área, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones."';
                }
                action("Bank Account Posting Groups")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account Posting Groups', Comment = 'ESP="Grupos registro cuenta bancaria"';
                    RunObject = Page "Bank Account Posting Groups";
                    ToolTip = 'Set up posting groups, so that payments in and out of each bank account are posted to the specified general ledger account.', Comment = 'ESP="Permite configurar grupos contables de modo que los pagos entrantes y salientes de cada cuenta bancaria se registren en la cuenta contable especificada."';
                }
            }
        }
        area(creation)
        {
            action("Sales &Credit Memo")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales &Credit Memo', Comment = 'ESP="A&bono venta"';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Credit Memo";
                RunPageMode = Create;
                ToolTip = 'Create a new sales credit memo to revert a posted sales invoice.', Comment = 'ESP="Permite crear un nuevo abono de venta para revertir una factura de venta registrada."';
            }
            action("P&urchase Credit Memo")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&urchase Credit Memo', Comment = 'ESP="&Abono compra"';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Credit Memo";
                RunPageMode = Create;
                ToolTip = 'Create a new purchase credit memo so you can manage returned items to a vendor.', Comment = 'ESP="Permite crear un nuevo abono de compra para poder administrar los productos devueltos a un proveedor."';
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks', Comment = 'ESP="Tareas"';
                IsHeader = true;
            }
            action("Cas&h Receipt Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cas&h Receipt Journal', Comment = 'ESP="&Diario de recibos de efectivo"';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
                ToolTip = 'Apply received payments to the related non-posted sales documents.', Comment = 'ESP="Aplica los pagos recibidos a los documentos de ventas no registrados correspondientes."';
            }
            action("Pa&yment Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pa&yment Journal', Comment = 'ESP="Diario de &pagos"';
                Image = PaymentJournal;
                RunObject = Page "Payment Journal";
                ToolTip = 'Make payments to vendors.', Comment = 'ESP="Realiza pagos a proveedores."';
            }
            separator(Action67)
            {
            }
            action("Analysis &Views")
            {
                ApplicationArea = Dimensions;
                Caption = 'Analysis &Views', Comment = 'ESP="Vistas de &análisis"';
                Image = AnalysisView;
                RunObject = Page "Analysis View List";
                ToolTip = 'Analyze amounts in your general ledger by their dimensions using analysis views that you have set up.', Comment = 'ESP="Permite analizar los importes en la contabilidad general por sus dimensiones mediante vista de análisis configuradas."';
            }
            action("Analysis by &Dimensions")
            {
                ApplicationArea = Dimensions;
                Caption = 'Analysis by &Dimensions', Comment = 'ESP="Análisis por dim&ensiones"';
                Image = AnalysisViewDimension;
                RunObject = Page "Analysis by Dimensions";
                ToolTip = 'Analyze activities using dimensions information.', Comment = 'ESP="Permite analizar actividades mediante la información de las dimensiones."';
            }
            action("Calculate Deprec&iation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Calculate Deprec&iation', Comment = 'ESP="Calcular amort&ización"';
                Ellipsis = true;
                Image = CalculateDepreciation;
                RunObject = Report "Calculate Depreciation";
                ToolTip = 'Calculate depreciation according to the conditions that you define. If the fixed assets that are included in the batch job are integrated with the general ledger (defined in the depreciation book that is used in the batch job), the resulting entries are transferred to the fixed assets general ledger journal. Otherwise, the batch job transfers the entries to the fixed asset journal. You can then post the journal or adjust the entries before posting, if necessary.', Comment = 'ESP="Permite calcular la amortización en función de las condiciones que defina. Si los activos fijos que están incluidos en el proceso se integran con la contabilidad (definida en el libro de amortización que se usa en el proceso), los movimientos resultantes se transfieren al diario de contabilidad de activos fijos. En caso contrario, el proceso transfiere los movimientos al diario de activos fijos. Después, si es necesario, puede registrar el diario o ajustar los movimientos antes de registrar."';
            }
            action("Import Co&nsolidation from Database")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Co&nsolidation from Database', Comment = 'ESP="Importar c&onsolidación de base de datos"';
                Ellipsis = true;
                Image = ImportDatabase;
                RunObject = Report "Import Consolidation from DB";
                ToolTip = 'Import entries from the business units that will be included in a consolidation. You can use the batch job if the business unit comes from the same database in Business Central as the consolidated company.', Comment = 'ESP="Importa entradas de las unidades de negocios que se incluirán en una consolidación. Puede usar el proceso si la unidad de negocio proviene de la misma base de datos de Business Central que la empresa consolidada."';
            }
            action("Bank Account R&econciliation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Account R&econciliation', Comment = 'ESP="Conciliación b&anco"';
                Image = BankAccountRec;
                RunObject = Page "Bank Acc. Reconciliation";
                ToolTip = 'View the entries and the balance on your bank accounts against a statement from the bank.', Comment = 'ESP="Permite ver los movimientos y el saldo de las cuentas bancarias mediante un extracto del banco."';
            }
            action("Payment Reconciliation Journals")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Reconciliation Journals', Comment = 'ESP="Diarios de conciliación de pagos"';
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Pmt. Reconciliation Journals";
                RunPageMode = View;
                ToolTip = 'Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.', Comment = 'ESP="Permite conciliar automáticamente los documentos sin pagar con sus respectivas transacciones bancarias al importar una fuente o un archivo de extracto bancario. En el diario de conciliación de pagos, los pagos entrantes o salientes en su banco se aplican, de forma automática o semiautomática, a sus respectivos movimientos contables de cliente o proveedor abiertos. Cualquier movimiento de cuenta bancaria abierto relacionado con los movimientos de cliente o proveedor liquidados se cerrará cuando elija la acción Registrar pagos y conciliar banco. Esto significa que la cuenta bancaria se concilia automáticamente para los pagos que se registran con el diario."';
            }
            action("Adjust E&xchange Rates")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Adjust E&xchange Rates', Comment = 'ESP="A&justar tipos de cambio"';
                Ellipsis = true;
                Image = AdjustExchangeRates;
                RunObject = Report "Adjust Exchange Rates";
                ToolTip = 'Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.', Comment = 'ESP="Ajusta los movimientos de contabilidad general, clientes, proveedores y bancos para que reflejen un saldo más actualizado si el tipo de cambio ha variado desde que se registraron los movimientos."';
            }
            action("P&ost Inventory Cost to G/L")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost Inventory Cost to G/L', Comment = 'ESP="Regis. variación in&ventario"';
                Image = PostInventoryToGL;
                RunObject = Report "Post Inventory Cost to G/L";
                ToolTip = 'Record the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.', Comment = 'ESP="Permite registrar los cambios de cantidad y valor del inventario en los movimientos de producto y en los movimientos de valor, respectivamente, al registrar transacciones de inventario, como albaranes de ventas o recibos de compra."';
            }
            separator(Action97)
            {
            }
            action("C&reate Reminders")
            {
                ApplicationArea = Suite;
                Caption = 'C&reate Reminders', Comment = 'ESP="C&rear recordatorios"';
                Ellipsis = true;
                Image = CreateReminders;
                RunObject = Report "Create Reminders";
                ToolTip = 'Create reminders for one or more customers with overdue payments.', Comment = 'ESP="Crear recordatorios para uno o varios clientes con pagos vencidos."';
            }
            action("Create Finance Charge &Memos")
            {
                ApplicationArea = Suite;
                Caption = 'Create Finance Charge &Memos', Comment = 'ESP="Crear doc&umentos interés"';
                Ellipsis = true;
                Image = CreateFinanceChargememo;
                RunObject = Report "Create Finance Charge Memos";
                ToolTip = 'Create finance charge memos for one or more customers with overdue payments.', Comment = 'ESP="Crear documentos de interés para uno o varios clientes con importes vencidos."';
            }
            separator(Action73)
            {
            }
            action("Intrastat &Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Intrastat &Journal', Comment = 'ESP="Diario In&trastat"';
                Image = Journal;
                RunObject = Page "Intrastat Jnl. Batches";
                ToolTip = 'Report your trade with other EU countries/regions for Intrastat reporting.', Comment = 'ESP="Informe de su comercio con otros países o regiones de la UE para informes de intrastat."';
            }
            action("Calc. and Pos&t VAT Settlement")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Calc. and Pos&t VAT Settlement', Comment = 'ESP="Calc. y registrar li&q. IVA"';
                Image = SettleOpenTransactions;
                RunObject = Report "Calc. and Post VAT Settlement";
                ToolTip = 'Close open VAT entries and transfers purchase and sales VAT amounts to the VAT settlement account. For every VAT posting group, the batch job finds all the VAT entries in the VAT Entry table that are included in the filters in the definition window.', Comment = 'ESP="Cerrar movimientos de IVA y transferencias e importes de IVA por comprar y ventas a la cuenta de liquidación de IVA. Para cada grupo de registro de IVA, el proceso busca todos los movimientos de IVA en la tabla de movimientos de IVA incluidos en los filtros en la ventana de definición."';
            }
            separator(Action80)
            {
                Caption = 'Administration', Comment = 'ESP="Administración"';
                IsHeader = true;
            }
            action("General &Ledger Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'General &Ledger Setup', Comment = 'ESP="Confi&guración contabilidad"';
                Image = Setup;
                RunObject = Page "General Ledger Setup";
                ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.', Comment = 'ESP="Permite registrar las transacciones financieras directamente en las cuentas de contabilidad general y otras cuentas, como las cuentas de banco, cliente, proveedor y empleado. Al registrar con un diario general, siempre se crean movimientos en las cuentas de contabilidad general. Esto es así incluso cuando, por ejemplo, se registra una línea del diario en una cuenta de cliente, ya que el movimiento se registra en una cuenta contable de cobros a través de un grupo contable."';
            }
            action("&Sales && Receivables Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Sales && Receivables Setup', Comment = 'ESP="Configuración venta&s y cobros"';
                Image = Setup;
                RunObject = Page "Sales & Receivables Setup";
                ToolTip = 'Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.', Comment = 'ESP="Permite definir las directivas generales de facturación de ventas y devoluciones, tales como cuándo mostrar advertencias de crédito y de falta de stock y cómo registrar los descuentos de venta. Configure las series numéricas para la creación de clientes y los distintos documentos de venta."';
            }
            action("&Purchases && Payables Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Purchases && Payables Setup', Comment = 'ESP="&Configuración compras y pagos"';
                Image = Setup;
                RunObject = Page "Purchases & Payables Setup";
                ToolTip = 'Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.', Comment = 'ESP="Permite definir las directivas generales de facturación de compras y devoluciones, tales como si se deben requerir números de factura de proveedor y cómo registrar descuentos de compra. Configure las series numéricas para la creación de proveedores y los distintos documentos de compra."';
            }
            action("&Fixed Asset Setup")
            {
                ApplicationArea = FixedAssets;
                Caption = '&Fixed Asset Setup', Comment = 'ESP="Configuración &activos fijos"';
                Image = Setup;
                RunObject = Page "Fixed Asset Setup";
                ToolTip = 'Define your accounting policies for fixed assets, such as the allowed posting period and whether to allow posting to main assets. Set up your number series for creating new fixed assets.', Comment = 'ESP="Permite definir las directivas contables de activos fijos, tales como el periodo contable permitido y si se permite el registro en activos principales. Configure las series numéricas para crear nuevos activos fijos."';
            }
            action("Cash Flow Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Flow Setup', Comment = 'ESP="Configuración flujos efectivo"';
                Image = CashFlowSetup;
                RunObject = Page "Cash Flow Setup";
                ToolTip = 'Set up the accounts where cash flow figures for sales, purchase, and fixed-asset transactions are stored.', Comment = 'ESP="Permite configurar las cuentas en las que se almacenan las cifras de flujo de efectivo para las transacciones de compra, venta y activo fijo."';
            }
            action("Cost Accounting Setup")
            {
                ApplicationArea = Dimensions;
                Caption = 'Cost Accounting Setup', Comment = 'ESP="Configuración contabilidad costes"';
                Image = CostAccountingSetup;
                RunObject = Page "Cost Accounting Setup";
                ToolTip = 'Specify how you transfer general ledger entries to cost accounting, how you link dimensions to cost centers and cost objects, and how you handle the allocation ID and allocation document number.', Comment = 'ESP="Especifique cómo va a transferir los movimientos de contabilidad a la contabilidad de costes, cómo va a vincular dimensiones con centros de coste y objetos de coste y cómo controlará el Id. de asignación y el número de documento de asignación."';
            }
            action("Cartera Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cartera Setup', Comment = 'ESP="Configuración de cartera"';
                RunObject = Page "Cartera Setup";
                ToolTip = 'Configure your company''s policies for bill groups and payment orders.', Comment = 'ESP="Permite configurar directivas de la empresa para remesas y órdenes de pago."';
            }
            separator(History)
            {
                Caption = 'History', Comment = 'ESP="Historial"';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Navi&gate', Comment = 'ESP="&Navegar"';
                Image = Navigate;
                RunObject = Page Navigate;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.', Comment = 'ESP="Permite buscar todos los movimientos y los documentos que existen para el número de documento y la fecha de registro que constan en el movimiento, o documento, seleccionado."';
            }
        }
    }
}
