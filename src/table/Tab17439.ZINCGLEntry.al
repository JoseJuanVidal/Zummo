// table 17439 "ZINC GL Entry"
// {
//     Caption = 'ABERTIA ZINC GL Entry';
//     Description = 'ABERTIA - Actualizacion datos G/L Entry';
//     ExternalName = 'Zummo, Inc$G_L Entry';
//     ExternalSchema = 'dbo';
//     TableType = ExternalSQL;

//     fields
//     {

//         Field(1; "Entry No_"; Integer) { ExternalName = 'Entry No_'; }
//         Field(2; "G_L Account No_"; code[20]) { ExternalName = 'G_L Account No_'; }
//         Field(3; "Posting Date"; Date) { ExternalName = 'Posting Date'; }
//         Field(4; "Document Type"; Integer) { ExternalName = 'Document Type'; }
//         Field(5; "Document No_"; code[20]) { ExternalName = 'Document No_'; }
//         Field(6; "Description"; text[100]) { ExternalName = 'Description'; }
//         Field(7; "Bal_ Account No_"; code[20]) { ExternalName = 'Bal_ Account No_'; }
//         Field(8; "Amount"; Decimal) { ExternalName = 'Amount'; }
//         Field(9; "Global Dimension 1 Code"; code[20]) { ExternalName = 'Global Dimension 1 Code'; }
//         Field(10; "Global Dimension 2 Code"; code[20]) { ExternalName = 'Global Dimension 2 Code'; }
//         Field(11; "User ID"; code[50]) { ExternalName = 'User ID'; }
//         Field(12; "Source Code"; code[10]) { ExternalName = 'Source Code'; }
//         Field(13; "System-Created Entry"; Boolean) { ExternalName = 'System-Created Entry'; }
//         Field(14; "Prior-Year Entry"; Boolean) { ExternalName = 'Prior-Year Entry'; }
//         Field(15; "Job No_"; code[20]) { ExternalName = 'Job No_'; }
//         Field(16; "Quantity"; Decimal) { ExternalName = 'Quantity'; }
//         Field(17; "VAT Amount"; Decimal) { ExternalName = 'VAT Amount'; }
//         Field(18; "Business Unit Code"; code[20]) { ExternalName = 'Business Unit Code'; }
//         Field(19; "Journal Batch Name"; code[10]) { ExternalName = 'Journal Batch Name'; }
//         Field(20; "Reason Code"; code[10]) { ExternalName = 'Reason Code'; }
//         Field(21; "Gen_ Posting Type"; Integer) { ExternalName = 'Gen_ Posting Type'; }
//         Field(22; "Gen_ Bus_ Posting Group"; code[20]) { ExternalName = 'Gen_ Bus_ Posting Group'; }
//         Field(23; "Gen_ Prod_ Posting Group"; code[20]) { ExternalName = 'Gen_ Prod_ Posting Group'; }
//         Field(24; "Bal_ Account Type"; Integer) { ExternalName = 'Bal_ Account Type'; }
//         Field(25; "Transaction No_"; Integer) { ExternalName = 'Transaction No_'; }
//         Field(26; "Debit Amount"; Decimal) { ExternalName = 'Debit Amount'; }
//         Field(27; "Credit Amount"; Decimal) { ExternalName = 'Credit Amount'; }
//         Field(28; "Document Date"; Date) { ExternalName = 'Document Date'; }
//         Field(29; "External Document No_"; code[35]) { ExternalName = 'External Document No_'; }
//         Field(30; "Source Type"; Integer) { ExternalName = 'Source Type'; }
//         Field(31; "Source No_"; code[20]) { ExternalName = 'Source No_'; }
//         Field(32; "No_ Series"; code[20]) { ExternalName = 'No_ Series'; }
//         Field(33; "Tax Area Code"; code[20]) { ExternalName = 'Tax Area Code'; }
//         Field(34; "Tax Liable"; Boolean) { ExternalName = 'Tax Liable'; }
//         Field(35; "Tax Group Code"; code[20]) { ExternalName = 'Tax Group Code'; }
//         Field(36; "Use Tax"; Boolean) { ExternalName = 'Use Tax'; }
//         Field(37; "VAT Bus_ Posting Group"; code[20]) { ExternalName = 'VAT Bus_ Posting Group'; }
//         Field(38; "VAT Prod_ Posting Group"; code[20]) { ExternalName = 'VAT Prod_ Posting Group'; }
//         Field(39; "Additional-Currency Amount"; Decimal) { ExternalName = 'Additional-Currency Amount'; }
//         Field(40; "Add_-Currency Debit Amount"; Decimal) { ExternalName = 'Add_-Currency Debit Amount'; }
//         Field(41; "Add_-Currency Credit Amount"; Decimal) { ExternalName = 'Add_-Currency Credit Amount'; }
//         Field(42; "Close Income Statement Dim_ ID"; Integer) { ExternalName = 'Close Income Statement Dim_ ID'; }
//         Field(43; "IC Partner Code"; code[20]) { ExternalName = 'IC Partner Code'; }
//         Field(44; "Reversed"; Boolean) { ExternalName = 'Reversed'; }
//         Field(45; "Reversed by Entry No_"; Integer) { ExternalName = 'Reversed by Entry No_'; }
//         Field(46; "Reversed Entry No_"; Integer) { ExternalName = 'Reversed Entry No_'; }
//         Field(47; "Dimension Set ID"; Integer) { ExternalName = 'Dimension Set ID'; }
//         Field(48; "Prod_ Order No_"; code[20]) { ExternalName = 'Prod_ Order No_'; }
//         Field(49; "FA Entry Type"; Integer) { ExternalName = 'FA Entry Type'; }
//         Field(50; "FA Entry No_"; Integer) { ExternalName = 'FA Entry No_'; }
//         field(51; "Last Modified DateTime"; DateTime) { ExternalName = 'Last Modified DateTime'; }

//     }


//     var
//         GenLedgerSetup: Record "General Ledger Setup";
//         ServiceMgtSetup: Record "Service Mgt. Setup";

//     procedure CreateTableConnection()
//     begin
//         ServiceMgtSetup.Get();
//         IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINCSQL') THEN
//             UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINCSQL');

//         REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINCSQL', ServiceMgtSetup.ZUMMOINCTABLECONNECTION());
//         // SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINCSQL');
//     end;


//     procedure CreateZINCGLEntry(TypeUpdate: Option Periodo,Todo) RecordNo: Integer;
//     var
//         ZINCGLEntry: Record "ZINC GL Entry";
//         ABGLEntry: Record "ABERTIA GL Entry";
//         Window: Dialog;
//     begin
//         Window.Open('Nº Movimiento contable #1################\Fecha #2################');
//         GenLedgerSetup.Get();
//         ZINCGLEntry.Reset();
//         case TypeUpdate of
//             TypeUpdate::Periodo:
//                 begin
//                     // buscamos el mes de fecha de trabajo y ponermos los filtros
//                     ZINCGLEntry.SetRange("Posting Date", GenLedgerSetup."Allow Posting From", GenLedgerSetup."Allow Posting To");
//                 end;
//             TypeUpdate::Todo:
//                 begin

//                 end;
//         end;
//         if ZINCGLEntry.FindFirst() then
//             repeat
//                 Window.Update(1, ZINCGLEntry."Entry No_");
//                 Window.Update(2, ZINCGLEntry."Posting Date");
//                 ABGLEntry.Reset();
//                 case CompanyName of
//                     'ZUMMO':
//                         ABGLEntry.SetRange("00 - Origen", 'ZIM');
//                     'INVESTMENTS':
//                         ABGLEntry.SetRange("00 - Origen", 'ZINV');
//                     else
//                         ABGLEntry.SetRange("00 - Origen", '');
//                 end;
//                 ABGLEntry.SetRange("Entry No_", ZINCGLEntry."Entry No_");
//                 if not ABGLEntry.FindFirst() then begin
//                     UpdateABGLEntry(ZINCGLEntry, ABGLEntry);
//                     RecordNo += 1;
//                 end;
//             Until ZINCGLEntry.next() = 0;
//         Window.Close();

//     end;

//     local procedure UpdateABGLEntry(ZINCGLEntry: Record "ZINC GL Entry"; var ABGLEntry: Record "ABERTIA GL Entry")
//     var
//         vDec: Decimal;
//         vInt: Integer;
//     begin
//         ABGLEntry.Init();
//         ABGLEntry.ID := CreateGuid();
//         ABGLEntry."Entry No_" := ZINCGLEntry."Entry No_";
//         if Evaluate(vDec, ZINCGLEntry."G_L Account No_") then
//             ABGLEntry."G_L Account No_" := vDec;
//         ABGLEntry."Posting Date" := CreateDateTime(ZINCGLEntry."Posting Date", 0T);
//         ABGLEntry."Document Type" := ZINCGLEntry."Document Type";
//         ABGLEntry."Document No_" := ZINCGLEntry."Document No_";
//         ABGLEntry."Description" := ZINCGLEntry.Description;
//         ABGLEntry."Bal_ Account No_" := ZINCGLEntry."Bal_ Account No_";
//         ABGLEntry."Amount" := ZINCGLEntry.Amount;
//         ABGLEntry."Dimension 1 Code" := ZINCGLEntry."Global Dimension 1 Code";
//         ABGLEntry."Dimension 2 Code" := ZINCGLEntry."Global Dimension 2 Code";
//         ABGLEntry."User ID" := ZINCGLEntry."User ID";
//         ABGLEntry."Source Code" := ZINCGLEntry."Source Code";
//         case ZINCGLEntry."System-Created Entry" of
//             true:
//                 ABGLEntry."System-Created Entry" := 1;
//             else
//                 ABGLEntry."System-Created Entry" := 0;
//         end;
//         case ZINCGLEntry."Prior-Year Entry" of
//             true:
//                 ABGLEntry."Prior-Year Entry" := 1;
//             else
//                 ABGLEntry."Prior-Year Entry" := 0;
//         end;
//         ABGLEntry."Job No_" := ZINCGLEntry."Job No_";
//         ABGLEntry."Quantity" := ZINCGLEntry.Quantity;
//         ABGLEntry."VAT Amount" := ZINCGLEntry."VAT Amount";
//         ABGLEntry."Business Unit Code" := ZINCGLEntry."Business Unit Code";
//         ABGLEntry."Journal Batch Name" := ZINCGLEntry."Journal Batch Name";
//         ABGLEntry."Reason Code" := ZINCGLEntry."Reason Code";
//         ABGLEntry."Gen_ Posting Type" := ZINCGLEntry."Gen_ Posting Type";
//         ABGLEntry."Gen_ Bus_ Posting Group" := ZINCGLEntry."Gen_ Bus_ Posting Group";
//         ABGLEntry."Gen_ Prod_ Posting Group" := ZINCGLEntry."Gen_ Prod_ Posting Group";
//         ABGLEntry."Bal_ Account Type" := ZINCGLEntry."Bal_ Account Type";
//         ABGLEntry."Transaction No_" := ZINCGLEntry."Transaction No_";
//         ABGLEntry."Debit Amount" := ZINCGLEntry."Debit Amount";
//         ABGLEntry."Credit Amount" := ZINCGLEntry."Credit Amount";
//         ABGLEntry."Document Date" := CreateDateTime(ZINCGLEntry."Document Date", 0T);
//         ABGLEntry."External Document No_" := ZINCGLEntry."External Document No_";
//         ABGLEntry."Source Type" := ZINCGLEntry."Source Type";
//         ABGLEntry."Source No_" := ZINCGLEntry."Source No_";
//         ABGLEntry."No_ Series" := ZINCGLEntry."No_ Series";
//         ABGLEntry."Tax Area Code" := ZINCGLEntry."Tax Area Code";
//         case ZINCGLEntry."Tax Liable" of
//             true:
//                 ABGLEntry."Tax Liable" := 1;
//             else
//                 ABGLEntry."Tax Liable" := 0;
//         end;
//         ABGLEntry."Tax Group Code" := ZINCGLEntry."Tax Group Code";
//         case ZINCGLEntry."Use Tax" of
//             true:
//                 ABGLEntry."Use Tax" := 1;
//             else
//                 ABGLEntry."Use Tax" := 0;
//         end;
//         ABGLEntry."VAT Bus_ Posting Group" := ZINCGLEntry."VAT Bus_ Posting Group";
//         ABGLEntry."VAT Prod_ Posting Group" := ZINCGLEntry."VAT Prod_ Posting Group";
//         ABGLEntry."Additional-Currency Amount" := ZINCGLEntry."Additional-Currency Amount";
//         ABGLEntry."Add_-Currency Debit Amount" := ZINCGLEntry."Add_-Currency Debit Amount";
//         ABGLEntry."Add_-Currency Credit Amount" := ZINCGLEntry."Add_-Currency Credit Amount";
//         ABGLEntry."Close Income Statement Dim_ ID" := ZINCGLEntry."Close Income Statement Dim_ ID";
//         ABGLEntry."IC Partner Code" := ZINCGLEntry."IC Partner Code";
//         case ZINCGLEntry.Reversed of
//             true:
//                 ABGLEntry."Reversed" := 1;
//             else
//                 ABGLEntry."Reversed" := 0;
//         end;
//         ABGLEntry."Reversed by Entry No_" := ZINCGLEntry."Reversed by Entry No_";
//         ABGLEntry."Reversed Entry No_" := ZINCGLEntry."Reversed Entry No_";
//         ABGLEntry."Dimension Set ID" := ZINCGLEntry."Dimension Set ID";
//         ABGLEntry."Prod_ Order No_" := ZINCGLEntry."Prod_ Order No_";
//         ABGLEntry."FA Entry Type" := ZINCGLEntry."FA Entry Type";
//         ABGLEntry."FA Entry No_" := ZINCGLEntry."FA Entry No_";
//         ABGLEntry."Last Modified DateTime" := ZINCGLEntry."Last Modified DateTime";
//         // ABGLEntry."New G_L Account No_" := GLEntry.ne;
//         // ABGLEntry."Old G_L Account No_" := GLEntry.old;
//         // ABGLEntry."Updated" := GLEntry.up;        
//         ABGLEntry."00 - Origen" := 'ZINC';
//         ABGLEntry.Insert();
//         Commit();
//     end;
// }