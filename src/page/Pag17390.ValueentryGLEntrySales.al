// page 17390 "Value entry - G/L Entry Sales"
// {
//     ApplicationArea = All;
//     Caption = 'Value entry - G/L Entries Sales', Comment = 'ESP="Costes Ventas Mov. valor - Mov. conta "';
//     PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
//     PageType = list;
//     SourceTable = "ZM Cost Value entry Sales";
//     SourceTableView = sorting("Parent Value Entry No.", "Value Entry No.", "G/L Entry No.", "Account No.");
//     UsageCategory = Lists;


//     layout
//     {
//         area(Content)
//         {

//             group(Options)
//             {
//                 Caption = 'Options', comment = 'ESP="Opciones"';
//                 field(EntryNoFilterIni; EntryNoFilterIni)
//                 {
//                     ApplicationArea = all;
//                     Caption = 'Start Entry No.', comment = 'ESP="Nº Mov. Inicio"';
//                 }
//                 field(DateFilterIni; DateFilterIni)
//                 {
//                     ApplicationArea = all;
//                     Caption = 'Start Date', comment = 'ESP="Fecha Inicio"';
//                     ToolTip = 'Filter date for update Data', comment = 'ESP="Filtro fecha para actualización Datos"';
//                 }
//                 field(EntryNoFilterFin; EntryNoFilterFin)
//                 {
//                     ApplicationArea = all;
//                     Caption = 'Start Entry No.', comment = 'ESP="Nº Mov. Fin"';
//                 }
//                 field(DateFilterFin; DateFilterFin)
//                 {
//                     ApplicationArea = all;
//                     Caption = 'End Date', comment = 'ESP="Fecha Fin"';
//                     ToolTip = 'Filter date for update Data', comment = 'ESP="Filtro fecha para actualización Datos"';
//                 }
//             }
//             repeater(General)
//             {
//                 Editable = false;
//                 field("Parent Value Entry No."; "Parent Value Entry No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Parent Item No."; "Parent Item No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Parent Description"; "Parent Description")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Parent Posting Date"; "Parent Posting Date")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Parent Valued Quantity"; "Parent Valued Quantity")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Value Entry No."; "Value Entry No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Item No."; "Item No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Posting Date"; "Posting Date")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Item Ledger Entry Type"; "Item Ledger Entry Type")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Document No."; "Document No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field(Description; Description)
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Location Code"; "Location Code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Inventory Posting Group"; "Inventory Posting Group")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Item Ledger Entry No."; "Item Ledger Entry No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Valued Quantity"; "Valued Quantity")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Item Ledger Entry Quantity"; "Item Ledger Entry Quantity")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Cost Amount (Actual)"; "Cost Amount (Actual)")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Cost Posted to G/L"; "Cost Posted to G/L")
//                 {
//                     ApplicationArea = all;
//                 }

//                 field("Document Date"; "Document Date")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("External Document No."; "External Document No.")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Cost Amount (Actual) (ACY)"; "Cost Amount (Actual) (ACY)")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Cost Posted to G/L (ACY)"; "Cost Posted to G/L (ACY)")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Cost per Unit (ACY)"; "Cost per Unit (ACY)")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Document Type"; "Document Type")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Document Line No."; "Document Line No.")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }

//                 field("Valuation Date"; "Valuation Date")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }

//                 field("Purchase Amount (Actual)"; "Purchase Amount (Actual)")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Purchase Amount (Expected)"; "Purchase Amount (Expected)")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Sales Amount (Expected)"; "Sales Amount (Expected)")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Cost Amount (Expected)"; "Cost Amount (Expected)")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Cost Amount (Non-Invtbl.)"; "Cost Amount (Non-Invtbl.)")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Cost Amount (Expected) (ACY)"; "Cost Amount (Expected) (ACY)")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Cost Amount (Non-Invtbl.)(ACY)"; "Cost Amount (Non-Invtbl.)(ACY)")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Expected Cost Posted to G/L"; "Expected Cost Posted to G/L")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Exp. Cost Posted to G/L (ACY)"; "Exp. Cost Posted to G/L (ACY)")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Capacity Ledger Entry No."; "Capacity Ledger Entry No.")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field(Type; Type)
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("G/L Entry No."; "G/L Entry No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Account Type"; "Account Type")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Amount G/L"; "Amount G/L")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Amount G/L (ACY)"; "Amount G/L (ACY)")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Interim Account"; "Interim Account")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Account No."; "Account No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field(postingDate; "Posting Date")

//                 {
//                     ApplicationArea = all;
//                 }
//                 field(Negative; "Negative")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Bal. Account Type"; "Bal. Account Type")

//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Job No."; "Job No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Account Heading"; "Account Heading")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Entry No."; "Entry No.")
//                 {
//                     ApplicationArea = all;
//                 }
//             }
//         }
//     }
//     actions
//     {
//         area(Processing)
//         {
//             action(Update)
//             {
//                 Caption = 'Update', comment = 'ESP="Actualizar"';
//                 Image = UpdateUnitCost;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 var
//                     ValueEntry: Record "Value Entry";
//                     Customer: Record Customer;
//                     DateFilter: text;
//                     EntrynoFilter: text;
//                     lblError: Label 'You have to indicate a filter.', comment = 'ESP="Debe indicar un filtro."';
//                     lblConfirm: Label '¿Desea actualizar los movimientos de Costes.\Filtro Fecha: %1\Filtro Mov: %2?', comment = 'ESP="¿Desea actualizar los movimientos de Costes.\Filtro Fecha %1\Filtro Mov: %2?"';
//                 begin
//                     if (DateFilterIni = 0D) and (DateFilterFin = 0D) and (EntryNoFilterIni = 0) and (EntryNoFilterFin = 0) then
//                         error(lblError, DateFilterIni, DateFilterFin);
//                     if (DateFilterIni <> 0D) and (DateFilterFin <> 0D) then begin
//                         Customer.SetRange("Date Filter", DateFilterIni, DateFilterFin);
//                         DateFilter := Customer.GetFilter("Date Filter");
//                     end;
//                     if (EntryNoFilterIni <> 0) and (EntryNoFilterFin <> 0) then begin
//                         ValueEntry.SetRange("Entry No.", EntryNoFilterIni, EntryNoFilterFin);
//                         EntrynoFilter := ValueEntry.GetFilter("Entry No.");
//                     end;
//                     if Confirm(lblConfirm, false, DateFilter, EntrynoFilter) then
//                         Rec.UpdateEntries(DateFilter, EntrynoFilter);
//                 end;
//             }
//             // action(heading)
//             // {
//             //     ApplicationArea = All;
//             //     Caption = 'Heading';
//             //     Promoted = true;
//             //     PromotedIsBig = true;
//             //     PromotedCategory = Process;

//             //     trigger OnAction()
//             //     begin
//             //         UpdateMayorAccount();
//             //     end;
//             // }
//         }
//         area(Navigation)
//         {
//             action(ItemLedgerEntry)
//             {
//                 Caption = 'Item Ledger Entrie', comment = 'ESP="Movs. Productos"';
//                 Image = ItemLedger;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 PromotedCategory = Category4;
//                 trigger OnAction()
//                 var
//                     ItemLedgerEntry: Record "Item Ledger Entry";
//                 begin
//                     ItemLedgerEntry.SetRange("Entry No.", Rec."Item Ledger Entry No.");
//                     page.Run(Page::"Item Ledger Entries", ItemLedgerEntry);
//                 end;
//             }
//             action(BOMExplode)
//             {
//                 Caption = 'BOM Explode', comment = 'ESP="Costes L. Materiales"';
//                 Image = ExplodeBOM;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 PromotedCategory = Category4;
//                 trigger OnAction()
//                 begin
//                     BomExplode_CostesGLEntry();
//                 end;
//             }
//         }
//     }
//     trigger OnInit()
//     begin
//         OpenTableConnection();
//     end;

//     var
//         EntryNoFilterIni: Integer;
//         EntryNoFilterFin: Integer;
//         DateFilterIni: date;
//         DateFilterFin: Date;

//     local procedure BomExplode_CostesGLEntry()
//     var
//         myInt: Integer;
//     begin
//         BomExplode_CostesGLEntry
//     end;

//     procedure OpenTableConnection()
//     begin
//         IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes') THEN
//             UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes');

//         REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes', ZMCostesTABLECONNECTION());
//         SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes');
//     end;

//     procedure ZMCostesTABLECONNECTION(): Text
//     var
//         GenLedgerSetup: Record "General Ledger Setup";
//         lblConnectionString: Label 'Data Source=%1;Initial Catalog=%2;User ID=%3;Password=%4';
//     begin
//         GenLedgerSetup.Get();
//         GenLedgerSetup.TestField("Data Source");
//         GenLedgerSetup.TestField("User ID");
//         GenLedgerSetup.TestField(Password);
//         // exit(StrSubstNo(lblConnectionString, GenLedgerSetup."Data Source", GenLedgerSetup."Initial Catalog", GenLedgerSetup."User ID", GenLedgerSetup.Password));
//         exit(StrSubstNo(lblConnectionString, 'localhost', 'ZUMMO Inventario', 'sa', 'Bario5622$'));
//     end;
// }
