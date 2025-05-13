// table 17382 "ZM Value entry - G/L Entry"
// {
//     DataClassification = CustomerContent;
//     Caption = 'Value entry - G/L Entry Analysis', comment = 'ESP="Análisis Mov. Valor - Mov. Contable"';
//     ExternalName = 'ZUMMO$ZM Value entry - G_L Entry';
//     ExternalSchema = 'dbo';
//     TableType = ExternalSQL;
//     fields
//     {
//         field(1; "Value Entry No."; Integer)
//         {
//             Caption = 'Value Entry No.', Comment = 'ESP="Nº mov. valor"';
//             TableRelation = "Value Entry";
//             ExternalName = 'Value Entry No_';
//         }
//         field(2; "Item No."; Code[20])
//         {
//             Caption = 'Item No.', Comment = 'ESP="Nº producto"';
//             TableRelation = Item;
//             ExternalName = 'Item No_';
//         }
//         field(3; "Posting Date"; Date)
//         {
//             Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
//             ExternalName = 'Posting Date';
//         }
//         field(4; "Item Ledger Entry Type"; Option)
//         {
//             Caption = 'Item Ledger Entry Type', Comment = 'ESP="Tipo mov. producto"';
//             OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output',
//             Comment = 'ESP="Compra,Venta,Ajuste positivo,Ajuste negativo,Transferencia,Consumo,Salida desde fab., ,Consumo ensamblado,Salida ensamblado"';
//             OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
//             ExternalName = 'Item Ledger Entry Type';
//         }
//         field(6; "Document No."; Code[20])
//         {
//             Caption = 'Document No.', Comment = 'ESP="Nº documento"';
//             ExternalName = 'Document No_';
//         }
//         field(7; Description; Text[100])
//         {
//             Caption = 'Description', Comment = 'ESP="Descripción"';
//             ExternalName = 'Description';
//         }
//         field(8; "Location Code"; Code[10])
//         {
//             Caption = 'Location Code', Comment = 'ESP="Cód. almacén"';
//             TableRelation = Location;
//             ExternalName = 'Location Code';
//         }
//         field(9; "Inventory Posting Group"; Code[20])
//         {
//             Caption = 'Inventory Posting Group', Comment = 'ESP="Grupo registro inventario"';
//             TableRelation = "Inventory Posting Group";
//             ExternalName = 'Inventory Posting Group';
//         }
//         field(11; "Item Ledger Entry No."; Integer)
//         {
//             Caption = 'Item Ledger Entry No.', Comment = 'ESP="Nº mov. producto"';
//             TableRelation = "Item Ledger Entry";
//             ExternalName = 'Item Ledger Entry No_';
//         }
//         field(12; "Valued Quantity"; Decimal)
//         {
//             Caption = 'Valued Quantity', Comment = 'ESP="Cant. valorada"';
//             DecimalPlaces = 0 : 5;
//             ExternalName = 'Valued Quantity';
//         }
//         field(13; "Item Ledger Entry Quantity"; Decimal)
//         {
//             Caption = 'Item Ledger Entry Quantity', Comment = 'ESP="Cantidad mov. producto"';
//             DecimalPlaces = 0 : 5;
//             ExternalName = 'Item Ledger Entry Quantity';
//         }
//         field(14; "Invoiced Quantity"; Decimal)
//         {
//             Caption = 'Invoiced Quantity', Comment = 'ESP="Cantidad facturada"';
//             DecimalPlaces = 0 : 5;
//             ExternalName = 'Invoiced Quantity';
//         }
//         field(15; "Cost per Unit"; Decimal)
//         {
//             AutoFormatType = 2;
//             Caption = 'Cost per Unit', Comment = 'ESP="Coste por ud."';
//             ExternalName = 'Cost per Unit';
//         }
//         field(17; "Sales Amount (Actual)"; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Sales Amount (Actual)', Comment = 'ESP="Importe ventas (Real)"';
//             ExternalName = 'Sales Amount (Actual)';
//         }
//         field(22; "Salespers./Purch. Code"; Code[20])
//         {
//             Caption = 'Salespers./Purch. Code', Comment = 'ESP="Cód. vendedor/comprador"';
//             TableRelation = "Salesperson/Purchaser";
//             ExternalName = 'Salespers__Purch_ Code';
//         }
//         field(23; "Discount Amount"; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Discount Amount', Comment = 'ESP="Importe dto."';
//             ExternalName = 'Discount Amount';
//         }
//         field(28; "Applies-to Entry"; Integer)
//         {
//             Caption = 'Applies-to Entry', Comment = 'ESP="Liq. por nº orden"';
//             ExternalName = 'Applies-to Entry';
//         }
//         field(43; "Cost Amount (Actual)"; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Cost Amount (Actual)', Comment = 'ESP="Importe coste (Real)"';
//             ExternalName = 'Cost Amount (Actual)';
//         }
//         field(45; "Cost Posted to G/L"; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Cost Posted to G/L', Comment = 'ESP="Coste regis. en contab."';
//             ExternalName = 'Cost Posted to G_L';
//         }
//         field(46; "Reason Code"; Code[10])
//         {
//             AccessByPermission = TableData 223 = R;
//             Caption = 'Reason Code', Comment = 'ESP="Cód. auditoría"';
//             TableRelation = "Reason Code";
//             ExternalName = 'Reason Code';
//         }
//         field(47; "Drop Shipment"; Boolean)
//         {
//             Caption = 'Drop Shipment', Comment = 'ESP="Envío directo"';
//             ExternalName = 'Drop Shipment';
//         }
//         field(48; "Journal Batch Name"; Code[10])
//         {
//             Caption = 'Journal Batch Name', Comment = 'ESP="Nombre sección diario"';
//             ExternalName = 'Journal Batch Name';
//         }
//         field(57; "Gen. Bus. Posting Group"; Code[20])
//         {
//             Caption = 'Gen. Bus. Posting Group', Comment = 'ESP="Grupo registro neg. gen."';
//             TableRelation = "Gen. Business Posting Group";
//             ExternalName = 'Gen_ Bus_ Posting Group';
//         }
//         field(58; "Gen. Prod. Posting Group"; Code[20])
//         {
//             Caption = 'Gen. Prod. Posting Group', Comment = 'ESP="Grupo registro prod. gen."';
//             TableRelation = "Gen. Product Posting Group";
//             ExternalName = 'Gen_ Prod_ Posting Group';
//         }
//         field(60; "Document Date"; Date)
//         {
//             Caption = 'Document Date', Comment = 'ESP="Fecha emisión documento"';
//             ExternalName = 'Document Date';
//         }
//         field(61; "External Document No."; Code[35])
//         {
//             Caption = 'External Document No.', Comment = 'ESP="Nº documento externo"';
//             ExternalName = 'External Document No_';
//         }
//         field(68; "Cost Amount (Actual) (ACY)"; Decimal)
//         {
//             AutoFormatExpression = GetCurrencyCode;
//             AutoFormatType = 1;
//             Caption = 'Cost Amount (Actual) (ACY)', Comment = 'ESP="Importe coste (Real) (DA)"';
//             ExternalName = 'Cost Amount (Actual) (ACY)';
//         }
//         field(70; "Cost Posted to G/L (ACY)"; Decimal)
//         {
//             AccessByPermission = TableData 4 = R;
//             AutoFormatExpression = GetCurrencyCode;
//             AutoFormatType = 1;
//             Caption = 'Cost Posted to G/L (ACY)', Comment = 'ESP="Coste regis. en contab. (DA)"';
//             ExternalName = 'Cost Posted to G_L (ACY)';
//         }
//         field(72; "Cost per Unit (ACY)"; Decimal)
//         {
//             AccessByPermission = TableData 4 = R;
//             AutoFormatExpression = GetCurrencyCode;
//             AutoFormatType = 2;
//             Caption = 'Cost per Unit (ACY)', Comment = 'ESP="Coste por unidad (DA)"';
//             ExternalName = 'Cost per Unit (ACY)';
//         }
//         field(79; "Document Type"; Option)
//         {
//             Caption = 'Document Type', Comment = 'ESP="Tipo documento"';
//             OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly'
//                 , Comment = 'ESP=  ,Albarán venta,Factura venta,Recep. devol. ventas,Abono venta,Albarán compra,Factura compra,Envío devolución compra,Abono compra,Envío transfer.,Recep. transfer.,Servicio regis.,Factura ventas,Abono ventas,Ensamblado registrado"';
//             OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
//             ExternalName = 'Document Type';
//         }
//         field(80; "Document Line No."; Integer)
//         {
//             Caption = 'Document Line No.', Comment = 'ESP="Nº lín. documento"';
//             ExternalName = 'Document Line No_';
//         }
//         field(90; "Order Type"; Option)
//         {
//             Caption = 'Order Type', Comment = 'ESP="Tipo orden"';
//             Editable = false;
//             OptionCaption = ' ,Production,Transfer,Service,Assembly', Comment = 'ESP=" ,Producción,Transferencia,Servicio,Ensamblado"';
//             OptionMembers = " ",Production,Transfer,Service,Assembly;
//             ExternalName = 'Order Type';
//         }
//         field(91; "Order No."; Code[20])
//         {
//             Caption = 'Order No.', Comment = 'ESP="Nº pedido"';
//             Editable = false;
//             ExternalName = 'Order No_';
//         }
//         field(92; "Order Line No."; Integer)
//         {
//             Caption = 'Order Line No.', Comment = 'ESP="Nº línea pedido"';
//             Editable = false;
//             ExternalName = 'Order Line No_';
//         }
//         field(98; "Expected Cost"; Boolean)
//         {
//             Caption = 'Expected Cost', Comment = 'ESP="Coste previsto"';
//             ExternalName = 'Expected Cost';
//         }
//         field(99; "Item Charge No."; Code[20])
//         {
//             Caption = 'Item Charge No.', Comment = 'ESP="Nº cargo prod."';
//             TableRelation = "Item Charge";
//             ExternalName = 'Item Charge No_';
//         }
//         field(100; "Valued By Average Cost"; Boolean)
//         {
//             Caption = 'Valued By Average Cost', Comment = 'ESP="Valorado a coste medio"';
//             ExternalName = 'Valued By Average Cost';
//         }
//         field(102; "Partial Revaluation"; Boolean)
//         {
//             Caption = 'Partial Revaluation', Comment = 'ESP="Revalorización parcial"';
//             ExternalName = 'Partial Revaluation';
//         }
//         field(103; Inventoriable; Boolean)
//         {
//             Caption = 'Inventoriable', Comment = 'ESP="Inventariable"';
//             ExternalName = 'Inventoriable';
//         }
//         field(104; "Valuation Date"; Date)
//         {
//             Caption = 'Valuation Date', Comment = 'ESP="Fecha valoración"';
//             ExternalName = 'Valuation Date';
//         }
//         field(105; "Entry Type"; Option)
//         {
//             Caption = 'Entry Type', Comment = 'ESP="Tipo movimiento"';
//             Editable = false;
//             OptionCaption = 'Direct Cost,Revaluation,Rounding,Indirect Cost,Variance', Comment = 'ESP="Coste directo,Revalorización,Redondeo,Coste indirecto,Desviación"';
//             OptionMembers = "Direct Cost",Revaluation,Rounding,"Indirect Cost",Variance;
//             ExternalName = 'Entry Type';
//         }
//         field(106; "Variance Type"; Option)
//         {
//             Caption = 'Variance Type', Comment = 'ESP="Tipo desviación"';
//             Editable = false;
//             OptionCaption = ' ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead,Subcontracted', Comment = 'ESP=" ,Compras,Materiales,Capacidad,Gastos gen. capacidad,Gastos gen. fabr.,Subcontratación"';
//             OptionMembers = " ",Purchase,Material,Capacity,"Capacity Overhead","Manufacturing Overhead",Subcontracted;
//             ExternalName = 'Variance Type';
//         }
//         field(148; "Purchase Amount (Actual)"; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Purchase Amount (Actual)', Comment = 'ESP="Importe compra (actual)"';
//             ExternalName = 'Purchase Amount (Actual)';
//         }
//         field(149; "Purchase Amount (Expected)"; Decimal)
//         {
//             AccessByPermission = TableData 120 = R;
//             AutoFormatType = 1;
//             Caption = 'Purchase Amount (Expected)', Comment = 'ESP="Importe compra (esperado)"';
//             ExternalName = 'Purchase Amount (Expected)';
//         }
//         field(150; "Sales Amount (Expected)"; Decimal)
//         {
//             AccessByPermission = TableData 110 = R;
//             AutoFormatType = 1;
//             Caption = 'Sales Amount (Expected)', Comment = 'ESP="Importe ventas (Esperado)"';
//             ExternalName = 'Sales Amount (Expected)';
//         }
//         field(151; "Cost Amount (Expected)"; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Cost Amount (Expected)', Comment = 'ESP="Importe coste (Esperado)"';
//             ExternalName = 'Cost Amount (Expected)';
//         }
//         field(152; "Cost Amount (Non-Invtbl.)"; Decimal)
//         {
//             AccessByPermission = TableData 5800 = R;
//             AutoFormatType = 1;
//             Caption = 'Cost Amount (Non-Invtbl.)', Comment = 'ESP="Importe coste (No-invent.)"';
//             ExternalName = 'Cost Amount (Non-Invtbl_)';
//         }
//         field(156; "Cost Amount (Expected) (ACY)"; Decimal)
//         {
//             AutoFormatExpression = GetCurrencyCode;
//             AutoFormatType = 1;
//             Caption = 'Cost Amount (Expected) (ACY)', Comment = 'ESP="Importe coste (Esperado) (DA)"';
//             ExternalName = 'Cost Amount (Expected) (ACY)';
//         }
//         field(157; "Cost Amount (Non-Invtbl.)(ACY)"; Decimal)
//         {
//             AccessByPermission = TableData 5800 = R;
//             AutoFormatExpression = GetCurrencyCode;
//             AutoFormatType = 1;
//             Caption = 'Cost Amount (Non-Invtbl.)(ACY)', Comment = 'ESP="Importe coste (no-invent.)(DA)"';
//             ExternalName = 'Cost Amount (Non-Invtbl_)(ACY)';
//         }
//         field(158; "Expected Cost Posted to G/L"; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Expected Cost Posted to G/L', Comment = 'ESP="Coste esperado reg. en cont."';
//             ExternalName = 'Expected Cost Posted to G_L';
//         }
//         field(159; "Exp. Cost Posted to G/L (ACY)"; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Exp. Cost Posted to G/L (ACY)', Comment = 'ESP="Coste esperado reg. cont. (DA)"';
//             ExternalName = 'Exp_ Cost Posted to G_L (ACY)';
//         }
//         field(5831; "Capacity Ledger Entry No."; Integer)
//         {
//             Caption = 'Capacity Ledger Entry No.', Comment = 'ESP="Nº mov. capacidad"';
//             TableRelation = "Capacity Ledger Entry";
//             ExternalName = 'Capacity Ledger Entry No_';
//         }
//         field(5832; Type; Option)
//         {
//             Caption = 'Type', Comment = 'ESP="Tipo"';
//             OptionCaption = 'Work Center,Machine Center, ,Resource', Comment = 'ESP="Centro trabajo,Centro máquina, ,Recurso"';
//             OptionMembers = "Work Center","Machine Center"," ",Resource;
//             ExternalName = 'Type';
//         }
//         field(5834; "No."; Code[20])
//         {
//             Caption = 'No.', Comment = 'ESP="Nº"';
//             TableRelation = IF (Type = CONST("Machine Center")) "Machine Center"
//             ELSE IF (Type = CONST("Work Center")) "Work Center"
//             ELSE IF (Type = CONST(Resource)) Resource;
//             ExternalName = 'No_';
//         }
//         field(50104; "Account Type"; Option)
//         {
//             Caption = 'Account Type', comment = 'ESP="Tipo mov."';
//             OptionCaption = 'Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance'
//                 , comment = 'ESP="Inventario (provisional),Crecimiento inventario (provisional),Inventario,Inventario WIP,Ajuste inventario,Coste directo aplicado,Coste general aplicado,Desviación de compras,Coste ventas,Coste ventas (provisional),Desviación material,Desviación capacidad,Desviación subcontratada,Cap. Desv. coste gen.,Desv. coste gen."';
//             OptionMembers = "Inventory (Interim)","Invt. Accrual (Interim)",Inventory,"WIP Inventory","Inventory Adjmt.","Direct Cost Applied","Overhead Applied","Purchase Variance",COGS,"COGS (Interim)","Material Variance","Capacity Variance","Subcontracted Variance","Cap. Overhead Variance","Mfg. Overhead Variance";
//             ExternalName = 'Account Type';
//         }

//         field(50105; "Amount G/L"; Decimal)
//         {
//             Caption = 'Amount', Comment = 'ESP="Importe"';
//             ExternalName = 'Amount G_L';
//         }
//         field(50106; "Amount G/L (ACY)"; Decimal)
//         {
//             Caption = 'Amount (ACY)', Comment = 'ESP="Importe (DA)"';
//             ExternalName = 'Amount G_L (ACY)';
//         }
//         field(50107; "Interim Account"; Boolean)
//         {
//             Caption = 'Interim Account', Comment = 'ESP="Cuenta provisional"';
//             ExternalName = 'Interim Account';
//         }
//         field(50108; "Account No."; code[20])
//         {
//             Caption = 'Account No.', Comment = 'ESP="Nº cuenta"';
//             TableRelation = "G/L Account";
//             ExternalName = 'Account No_';
//         }
//         field(50109; "G/L Posting Date"; date)
//         {
//             Caption = 'G/L Posting Date', Comment = 'ESP="Fecha registro Contable"';
//             ExternalName = 'G_L Posting Date';
//         }
//         field(50112; Negative; Boolean)
//         {
//             Caption = 'Negative', Comment = 'ESP="Negativo"';
//             ExternalName = 'Negative';
//         }
//         field(50113; "G/L Entry No."; Integer)
//         {
//             Caption = 'G/L Entry No.', Comment = 'ESP="Nº mov. contable"';
//             TableRelation = "G/L Entry";
//             ExternalName = 'G_L Entry No_';
//         }
//         field(50114; "Bal. Account Type"; Option)
//         {
//             Caption = 'Bal. Account Type', Comment = 'ESP="Tipo contrapartida"';
//             OptionCaption = 'Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance'
//                 , comment = 'ESP="Inventario (provisional),Crecimiento inventario (provisional),Inventario,Inventario WIP,Ajuste inventario,Coste directo aplicado,Coste general aplicado,Desviación de compras,Coste ventas,Coste ventas (provisional),Desviación material,Desviación capacidad,Desviación subcontratada,Cap. Desv. coste gen.,Desv. coste gen."';
//             OptionMembers = "Inventory (Interim)","Invt. Accrual (Interim)",Inventory,"WIP Inventory","Inventory Adjmt.","Direct Cost Applied","Overhead Applied","Purchase Variance",COGS,"COGS (Interim)","Material Variance","Capacity Variance","Subcontracted Variance","Cap. Overhead Variance","Mfg. Overhead Variance";
//             ExternalName = 'Bal_ Account Type';

//         }
//         field(50115; "Job No."; Code[20])
//         {
//             Caption = 'Job No.', Comment = 'ESP="Nº proyecto"';
//             ExternalName = 'Job No_';
//         }
//         field(50116; "Account Heading"; Code[1])
//         {
//             Caption = 'Account Heading', Comment = 'ESP="Cuenta Mayor"';
//             ExternalName = 'Account Heading';
//         }
//         field(50117; "Entry No."; Integer)
//         {
//             Caption = 'Entry No.', comment = 'ESP="Nº Mov."';
//             ExternalName = 'Entry No_';
//         }
//     }

//     keys
//     {
//         key(PK; "Value Entry No.", "G/L Entry No.", "Account No.")
//         {
//             Clustered = true;
//         }
//         key(Key1; "Item Ledger Entry No.", "Item Ledger Entry Type")
//         { }
//         key(Key2; "Entry No.")
//         { }
//         key(Key3; "Posting Date", "Item No.", "Item Ledger Entry Type")
//         { }
//     }

//     fieldgroups
//     {
//         // Add changes to field groups here
//     }

//     var
//         GLSetup: Record "General Ledger Setup";
//         ValueEntryGLEntry: Record "ZM Value entry - G/L Entry";
//         GLSetupRead: Boolean;



//     local procedure GetCurrencyCode(): Code[10]
//     begin
//         IF NOT GLSetupRead THEN BEGIN
//             GLSetup.GET;
//             GLSetupRead := TRUE;
//         END;
//         EXIT(GLSetup."Additional Reporting Currency");
//     end;


//     procedure UpdateEntries(EntryNo: Integer; DateFilter: Text)
//     var
//         ValueEntry: Record "Value Entry";
//         GLItemLedgerRelation: Record "G/L - Item Ledger Relation";
//         Window: Dialog;
//         lblDialog: Label 'Tipo #1#########################\Movimiento Valor:#2#################\Fecha:#3############', comment = 'ESP="Tipo #1#########################\Movimiento Valor:#2#################\Fecha:#3############"';
//     begin
//         if GuiAllowed then
//             Window.Open(lblDialog);
//         // primero mirarmos todos los movimientos de valor y si ya tienen el registro contable
//         ValueEntry.Reset();
//         if EntryNo <> 0 then
//             ValueEntry.SetFilter("Entry No.", '%1..', EntryNo);
//         // ValueEntry.SetRange("Updated Cost Entry", false);
//         if DateFilter <> '' then
//             ValueEntry.SetFilter("Posting Date", DateFilter);
//         if ValueEntry.FindSet() then
//             repeat
//                 if (ValueEntry."Cost Posted to G/L" <> 0) or (ValueEntry."Expected Cost Posted to G/L" <> 0) then begin
//                     if GuiAllowed then
//                         Window.Update(1, ValueEntry.TableCaption);
//                     if GuiAllowed then
//                         Window.Update(2, ValueEntry."Entry No.");
//                     if CreateValueGLEntry(ValueEntry) then
//                         if GuiAllowed then
//                             Window.Update(3, ValueEntry."Posting Date");
//                     Commit();
//                 end;
//             until ValueEntry.Next() = 0;

//         if GuiAllowed then
//             Window.Close();
//     end;

//     local procedure CreateValueGLEntry(ValueEntry: Record "Value Entry"): Boolean
//     var
//         Cost: Decimal;
//         i: Integer;
//     begin
//         // GLItemLedgerRelation.SetRange("Value Entry No.", ValueEntry."Entry No.");
//         // if GLItemLedgerRelation.FindFirst() then
//         //     repeat
//         // comprobamos si tiene 
//         DeleteTempValueEntryGLEntry(ValueEntry);
//         if CreateItemLedgerGlEntry(ValueEntry) then
//             exit(true);
//         // Until GLItemLedgerRelation.next() = 0;
//     end;

//     local procedure CreateItemLedgerGlEntry(ValueEntry: record "Value Entry"): Boolean
//     var
//         GLAccount: Record "G/L Account";
//         GLEntry: Record "G/L Entry";
//         GLItemLedgRelation: Record "G/L - Item Ledger Relation";
//         tmpInvtPostBuf: Record "Invt. Posting Buffer" temporary;
//         InvPosting: Codeunit "Inventory Posting To G/L";
//         AmountValue: Decimal;
//     begin
//         ValueEntry."Cost Posted to G/L" := 0;
//         ValueEntry."Expected Cost Posted to G/L" := 0;
//         Clear(InvPosting);
//         InvPosting.BufferInvtPosting(ValueEntry);
//         InvPosting.GetInvtPostBuf(tmpInvtPostBuf);
//         GLItemLedgRelation.SetRange("Value Entry No.", ValueEntry."Entry No.");
//         if GLItemLedgRelation.FindFirst() then
//             repeat
//                 AmountValue := abs(ValueEntry."Cost Posted to G/L" + ValueEntry."Expected Cost Posted to G/L");
//                 if GLEntry.Amount <= 0 then
//                     AmountValue := -AmountValue;
//                 GLEntry.GET(GLItemLedgRelation."G/L Entry No.");
//                 GLAccount.Get(GLEntry."G/L Account No.");
//                 ValueEntryGLEntry.Init();
//                 ValueEntryGLEntry.TransferFields(ValueEntry);
//                 ValueEntryGLEntry."G/L Entry No." := GLEntry."Entry No.";
//                 ValueEntryGLEntry."Account No." := GLEntry."G/L Account No.";
//                 ValueEntryGLEntry."Account Heading" := CopyStr(ValueEntryGLEntry."Account No.", 1, MaxStrLen(ValueEntryGLEntry."Account Heading"));
//                 ValueEntryGLEntry."G/L Posting Date" := GLEntry."Posting Date";
//                 ValueEntryGLEntry."Account Type" := tmpInvtPostBuf."Account Type";
//                 ValueEntryGLEntry."Amount G/L" := AmountValue;
//                 ValueEntryGLEntry."Amount G/L (ACY)" := AmountValue;
//                 ValueEntryGLEntry."Interim Account" := tmpInvtPostBuf."Interim Account";
//                 ValueEntryGLEntry."Account No." := GLEntry."G/L Account No.";
//                 ValueEntryGLEntry."G/L Posting Date" := GLEntry."Posting Date";
//                 ValueEntryGLEntry.Negative := tmpInvtPostBuf.Negative;
//                 ValueEntryGLEntry."Bal. Account Type" := tmpInvtPostBuf."Bal. Account Type";
//                 ValueEntryGLEntry."Job No." := GLEntry."Job No.";
//                 ValueEntryGLEntry.Insert();
//             Until GLItemLedgRelation.next() = 0;
//         exit(true);
//     end;

//     local procedure OLDCreateItemLedgerGlEntry(ValueEntry: record "Value Entry"; Cost: Decimal): Boolean
//     var
//         tmpInvtPostBuf: Record "Invt. Posting Buffer" temporary;
//         // GLItemLedgRelation: Record "G/L - Item Ledger Relation";
//         InvPosting: Codeunit "Inventory Posting To G/L";
//     begin
//         ValueEntry."Cost Posted to G/L" := 0;
//         ValueEntry."Expected Cost Posted to G/L" := 0;
//         Clear(InvPosting);
//         if not InvPosting.BufferInvtPosting(ValueEntry) then
//             exit;
//         // Message(StrSubstNo('No se encuentran datos buffer %1', ValueEntry."Entry No."));
//         InvPosting.GetInvtPostBuf(tmpInvtPostBuf);
//         if tmpInvtPostBuf.FindSet() then
//             repeat
//                 ValueEntryGLEntry.Init();
//                 ValueEntryGLEntry.TransferFields(ValueEntry);
//                 ValueEntryGLEntry."G/L Entry No." := tmpInvtPostBuf."Entry No.";
//                 ValueEntryGLEntry."Account No." := tmpInvtPostBuf."Account No.";
//                 ValueEntryGLEntry."Account Heading" := CopyStr(ValueEntryGLEntry."Account No.", 1, MaxStrLen(ValueEntryGLEntry."Account Heading"));
//                 ValueEntryGLEntry."G/L Posting Date" := tmpInvtPostBuf."Posting Date";
//                 ValueEntryGLEntry."Account Type" := tmpInvtPostBuf."Account Type";
//                 ValueEntryGLEntry."Amount G/L" := tmpInvtPostBuf.Amount;
//                 ValueEntryGLEntry."Amount G/L (ACY)" := tmpInvtPostBuf."Amount (ACY)";
//                 ValueEntryGLEntry."Interim Account" := tmpInvtPostBuf."Interim Account";
//                 ValueEntryGLEntry."Account No." := tmpInvtPostBuf."Account No.";
//                 ValueEntryGLEntry."G/L Posting Date" := tmpInvtPostBuf."Posting Date";
//                 ValueEntryGLEntry.Negative := tmpInvtPostBuf.Negative;
//                 ValueEntryGLEntry."Bal. Account Type" := tmpInvtPostBuf."Bal. Account Type";
//                 ValueEntryGLEntry."Job No." := tmpInvtPostBuf."Job No.";
//                 ValueEntryGLEntry.Insert();
//             // ValueEntry."Updated Cost Entry" := true;
//             // ValueEntry.Modify();
//             Until tmpInvtPostBuf.next() = 0;
//         // GLItemLedgerRelation."Updated Cost Entry" := true;
//         // GLItemLedgerRelation.Modify();
//         Commit();
//         exit(true);
//     end;

//     local procedure DeleteTempValueEntryGLEntry(ValueEntry: Record "Value Entry")
//     begin
//         ValueEntryGLEntry.Reset();
//         ValueEntryGLEntry.SetRange("Value Entry No.", ValueEntry."Entry No.");
//         ValueEntryGLEntry.DeleteAll();
//     end;

//     procedure BomExplode_CostesGLEntry()
//     var
//         Item: Record Item;
//         BOMCosts: Record "ZM Value entry - G/L Entry" temporary;
//     begin
//         Rec.TestField("Item Ledger Entry Type", Rec."Item Ledger Entry Type"::Output);
//         ValueEntryGLEntry.Reset();
//         ValueEntryGLEntry.SetRange("Item Ledger Entry No.", Rec."Item Ledger Entry No.");
//         UpdateValueEntryTemporary(BOMCosts, ValueEntryGLEntry, Rec."Valued Quantity");
//         // Explode BOM
//         Item.Get(Rec."Item No.");
//         if Item.HasBOM() then
//             ExplodeProductionConsumption(BOMCosts, Rec."Document No.");
//         // Page.Run(Page::"ZM Value entry - G/L Entries", BOMCosts);
//     end;

//     local procedure UpdateValueEntryTemporary(var BOMCosts: Record "ZM Value entry - G/L Entry"; var ValueEntryGLEntry: Record "ZM Value entry - G/L Entry";
//             Quantity: Decimal)
//     var
//         EntryNo: Integer;
//     begin
//         if ValueEntryGLEntry.FindFirst() then
//             repeat
//                 if not BOMCosts.Get(ValueEntryGLEntry."Value Entry No.", ValueEntryGLEntry."G/L Entry No.", ValueEntryGLEntry."Account No.") then begin
//                     EntryNo := BOMCosts."Entry No.";
//                     BOMCosts.Init();
//                     BOMCosts.TransferFields(ValueEntryGLEntry);
//                     BOMCosts."Entry No." := EntryNo + 1;
//                     BOMCosts.Insert();
//                 end else begin
//                     if Quantity <> BOMCosts."Valued Quantity" then begin
//                         // TODO                    Multiplicar por cantidad

//                     end;
//                 end;
//             Until ValueEntryGLEntry.next() = 0;
//     end;

//     local procedure ExplodeProductionConsumption(var BOMCosts: Record "ZM Value entry - G/L Entry"; ProdOrderNo: code[20])
//     var
//         ItemLedgerEntry: Record "Item Ledger Entry";
//     begin
//         ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
//         ItemLedgerEntry.SetRange("Document No.", ProdOrderNo);
//         if ItemLedgerEntry.FindFirst() then
//             repeat
//                 ValueEntryGLEntry.Reset();
//                 ValueEntryGLEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
//                 UpdateValueEntryTemporary(BOMCosts, ValueEntryGLEntry, ItemLedgerEntry."Quantity");

//                 GetItemApplicationEntry(BOMCosts, ItemLedgerEntry);

//             until ItemLedgerEntry.Next() = 0;
//     end;

//     local procedure GetItemApplicationEntry(var BOMCosts: Record "ZM Value entry - G/L Entry"; ItemledgerEntry: record "Item Ledger Entry")
//     var
//         ItemApplnEntry: record "Item Application Entry";
//         ItemLedgEntry: record "Item Ledger Entry";
//     begin
//         IF ItemledgerEntry.Positive THEN BEGIN
//             case ItemledgerEntry."Entry Type" of
//                 ItemledgerEntry."Entry Type"::Transfer:
//                     begin
//                         ItemApplnEntry.RESET;
//                         ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.", "Outbound Item Entry No.", "Cost Application");
//                         ItemApplnEntry.SETRANGE("Inbound Item Entry No.", ItemledgerEntry."Entry No.");
//                         ItemApplnEntry.SETFILTER("Transferred-from Entry No.", '<>%1', 0);
//                         ItemApplnEntry.SETRANGE("Cost Application", TRUE);
//                         IF ItemApplnEntry.FIND('-') THEN
//                             REPEAT
//                                 ItemLedgEntry.Get(ItemApplnEntry."Inbound Item Entry No.");
//                                 case ItemLedgEntry."Entry Type" of
//                                     ItemLedgEntry."Entry Type"::Transfer:
//                                         begin
//                                             ItemLedgEntry.Get(ItemApplnEntry."Transferred-from Entry No.");
//                                             GetItemApplicationEntry(BOMCosts, ItemLedgEntry);
//                                         end;
//                                 end;
//                             UNTIL ItemApplnEntry.NEXT = 0;
//                     end;
//                 else
//                     ValueEntryGLEntry.Reset();
//                     ValueEntryGLEntry.SetRange("Item Ledger Entry No.", ItemledgerEntry."Entry No.");
//                     UpdateValueEntryTemporary(BOMCosts, ValueEntryGLEntry, ItemledgerEntry.Quantity);
//             end;
//         END ELSE BEGIN
//             ItemApplnEntry.RESET;
//             ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
//             ItemApplnEntry.SETRANGE("Outbound Item Entry No.", ItemledgerEntry."Entry No.");
//             ItemApplnEntry.SETRANGE("Item Ledger Entry No.", ItemledgerEntry."Entry No.");
//             ItemApplnEntry.SETRANGE("Cost Application", TRUE);
//             IF ItemApplnEntry.FIND('-') THEN
//                 REPEAT
//                     // Si no es compra o transferencia, seguimos explorando
//                     // InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.", -ItemApplnEntry.Quantity);
//                     ItemLedgEntry.Get(ItemApplnEntry."Inbound Item Entry No.");
//                     case ItemLedgEntry."Entry Type" of
//                         ItemLedgEntry."Entry Type"::Transfer:
//                             begin
//                                 GetItemApplicationEntry(BOMCosts, ItemLedgEntry);
//                             end;
//                     end;
//                 UNTIL ItemApplnEntry.NEXT = 0;
//         END;
//     end;

//     local procedure InsertTempEntry(var BOMCosts: Record "ZM Value entry - G/L Entry"; EntryNo: Integer; AppliedQty: Decimal)
//     var
//         ItemLedgEntry: record "Item Ledger Entry";
//     begin
//         ItemLedgEntry.GET(EntryNo);
//         IF AppliedQty * ItemLedgEntry.Quantity < 0 THEN
//             EXIT;
//         ValueEntryGLEntry.Reset();
//         ValueEntryGLEntry.SetRange("Item Ledger Entry No.", EntryNo);
//         UpdateValueEntryTemporary(BOMCosts, ValueEntryGLEntry, AppliedQty);
//     end;

//     procedure UpdateMayorAccount()
//     var
//         Window: Dialog;
//     begin
//         Window.Open('Actualizando cuentas mayores #1####################');
//         ValueEntryGLEntry.Reset();
//         if ValueEntryGLEntry.FindFirst() then
//             repeat
//                 Window.Update(1, ValueEntryGLEntry."Value Entry No.");
//                 ValueEntryGLEntry."Account Heading" := CopyStr(ValueEntryGLEntry."Account No.", 1, MaxStrLen(ValueEntryGLEntry."Account Heading"));
//                 ValueEntryGLEntry.Modify();
//             Until ValueEntryGLEntry.next() = 0;
//         Window.Close();
//     end;

//     procedure OpenTableConnection()
//     begin
//         IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes') THEN
//             UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes');

//         REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes', ZMCostesTABLECONNECTION());
//         SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOCostes');
//     end;

//     local procedure ZMCostesTABLECONNECTION(): Text
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
