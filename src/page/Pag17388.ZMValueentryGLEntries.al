page 17388 "ZM Value entry - G/L Entries"
{
    ApplicationArea = All;
    Caption = 'Value entry - G/L Entries', Comment = 'ESP="Costes Mov. valor - Mov. conta "';
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    PageType = List;
    SourceTable = "ZM Value entry - G/L Entry";
    SourceTableView = sorting("Entry No.");
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {

            group(Options)
            {
                Caption = 'Options', comment = 'ESP="Opciones"';
                field(DateFilterIni; DateFilterIni)
                {
                    ApplicationArea = all;
                    Caption = 'Start Daet', comment = 'ESP="Fecha Inicio"';
                    ToolTip = 'Filter date for update Data', comment = 'ESP="Filtro fecha para actualización Datos"';
                }
                field(DateFilterFin; DateFilterFin)
                {
                    ApplicationArea = all;
                    Caption = 'End Date', comment = 'ESP="Fecha Fin"';
                    ToolTip = 'Filter date for update Data', comment = 'ESP="Filtro fecha para actualización Datos"';
                }
            }
            repeater(General)
            {
                Editable = false;
                field("Value Entry No."; "Value Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Item Ledger Entry Type"; "Item Ledger Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Item Ledger Entry No."; "Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Valued Quantity"; "Valued Quantity")
                {
                    ApplicationArea = all;
                }
                field("Item Ledger Entry Quantity"; "Item Ledger Entry Quantity")
                {
                    ApplicationArea = all;
                }
                field("Invoiced Quantity"; "Invoiced Quantity")
                {
                    ApplicationArea = all;
                }
                field("Cost per Unit"; "Cost per Unit")
                {
                    ApplicationArea = all;
                }
                field("Sales Amount (Actual)"; "Sales Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Discount Amount"; "Discount Amount")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Applies-to Entry"; "Applies-to Entry")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Amount (Actual)"; "Cost Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field("Cost Posted to G/L"; "Cost Posted to G/L")
                {
                    ApplicationArea = all;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Drop Shipment"; "Drop Shipment")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Amount (Actual) (ACY)"; "Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Posted to G/L (ACY)"; "Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost per Unit (ACY)"; "Cost per Unit (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Document Line No."; "Document Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Order Type"; "Order Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Order No."; "Order No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Order Line No."; "Order Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Expected Cost"; "Expected Cost")
                {
                    ApplicationArea = all;
                }
                field("Item Charge No."; "Item Charge No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Valued By Average Cost"; "Valued By Average Cost")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Partial Revaluation"; "Partial Revaluation")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Inventoriable; Inventoriable)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Valuation Date"; "Valuation Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Variance Type"; "Variance Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Purchase Amount (Actual)"; "Purchase Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field("Purchase Amount (Expected)"; "Purchase Amount (Expected)")
                {
                    ApplicationArea = all;
                }
                field("Sales Amount (Expected)"; "Sales Amount (Expected)")
                {
                    ApplicationArea = all;
                }
                field("Cost Amount (Expected)"; "Cost Amount (Expected)")
                {
                    ApplicationArea = all;
                }
                field("Cost Amount (Non-Invtbl.)"; "Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Amount (Expected) (ACY)"; "Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; "Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Expected Cost Posted to G/L"; "Expected Cost Posted to G/L")
                {
                    ApplicationArea = all;
                }
                field("Exp. Cost Posted to G/L (ACY)"; "Exp. Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Capacity Ledger Entry No."; "Capacity Ledger Entry No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("G/L Entry No."; "G/L Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = all;
                }
                field("Amount G/L"; "Amount G/L")
                {
                    ApplicationArea = all;
                }
                field("Amount G/L (ACY)"; "Amount G/L (ACY)")
                {
                    ApplicationArea = all;
                }
                field("Interim Account"; "Interim Account")
                {
                    ApplicationArea = all;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = all;
                }
                field(postingDate; "Posting Date")

                {
                    ApplicationArea = all;
                }
                field(Negative; "Negative")
                {
                    ApplicationArea = all;
                }
                field("Bal. Account Type"; "Bal. Account Type")

                {
                    ApplicationArea = all;
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = all;
                }
                field("Account Heading"; "Account Heading")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Update)
            {
                Caption = 'Update', comment = 'ESP="Actualizar"';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    lblError: Label 'You have to indicate a Date filter.\%1 to %2', comment = 'ESP="Debe indicar un filtro de Fecha.\%1 a %2"';
                    lblConfirm: Label '¿Desea actualizar los movimientos de Costes.\Filtro Fecha: %1?', comment = 'ESP="¿Desea actualizar los movimientos de Costes.\Filtro Fecha %1?"';
                begin
                    if (DateFilterIni = 0D) or (DateFilterFin = 0D) then
                        error(lblError, DateFilterIni, DateFilterFin);
                    Customer.SetRange("Date Filter", DateFilterIni, DateFilterFin);
                    if Confirm(lblConfirm, false, Customer.GetFilter("Date Filter")) then
                        Rec.UpdateEntries(0, Customer.GetFilter("Date Filter"));
                end;
            }
            // action(heading)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Heading';
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     PromotedCategory = Process;

            //     trigger OnAction()
            //     begin
            //         UpdateMayorAccount();
            //     end;
            // }
        }
        area(Navigation)
        {
            action(ItemLedgerEntry)
            {
                Caption = 'Item Ledger Entrie', comment = 'ESP="Movs. Productos"';
                Image = ItemLedger;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                trigger OnAction()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                begin
                    ItemLedgerEntry.SetRange("Entry No.", Rec."Item Ledger Entry No.");
                    page.Run(Page::"Item Ledger Entries", ItemLedgerEntry);
                end;
            }
            action(BOMExplode)
            {
                Caption = 'BOM Explode', comment = 'ESP="Costes L. Materiales"';
                Image = ExplodeBOM;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    BomExplode_CostesGLEntry();
                end;
            }
        }
    }
    trigger OnInit()
    begin
        OpenTableConnection();
    end;

    var
        DateFilterIni: date;
        DateFilterFin: Date;

    local procedure BomExplode_CostesGLEntry()
    var
        myInt: Integer;
    begin
        BomExplode_CostesGLEntry
    end;

    procedure OpenTableConnection()
    begin
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes', ZMCostesTABLECONNECTION());
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes');
    end;

    procedure ZMCostesTABLECONNECTION(): Text
    var
        GenLedgerSetup: Record "General Ledger Setup";
        lblConnectionString: Label 'Data Source=%1;Initial Catalog=%2;User ID=%3;Password=%4';
    begin
        GenLedgerSetup.Get();
        GenLedgerSetup.TestField("Data Source");
        GenLedgerSetup.TestField("User ID");
        GenLedgerSetup.TestField(Password);
        // exit(StrSubstNo(lblConnectionString, GenLedgerSetup."Data Source", GenLedgerSetup."Initial Catalog", GenLedgerSetup."User ID", GenLedgerSetup.Password));
        exit(StrSubstNo(lblConnectionString, '192.168.1.252\bc', 'ZUMMO Inventario', 'jjvidal', 'Bario5622$'));
    end;
}
