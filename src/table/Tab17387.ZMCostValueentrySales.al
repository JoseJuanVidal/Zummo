table 17387 "ZM Cost Value entry Sales"
{
    DataClassification = CustomerContent;
    Caption = 'Value entry - G/L Entry Sales Analysis', comment = 'ESP="Análisis Ventas Mov. Valor - Mov. Contable"';
    ExternalName = 'ZUMMO$Cost Value Entry Sales';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;
    fields
    {
        field(1; "Value Entry No."; Integer)
        {
            Caption = 'Value Entry No.', Comment = 'ESP="Nº mov. valor"';
            TableRelation = "Value Entry";
            ExternalName = 'Value Entry No_';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Nº producto"';
            TableRelation = Item;
            ExternalName = 'Item No_';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
            ExternalName = 'Posting Date';
        }
        field(4; "Item Ledger Entry Type"; Option)
        {
            Caption = 'Item Ledger Entry Type', Comment = 'ESP="Tipo mov. producto"';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output',
            Comment = 'ESP="Compra,Venta,Ajuste positivo,Ajuste negativo,Transferencia,Consumo,Salida desde fab., ,Consumo ensamblado,Salida ensamblado"';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
            ExternalName = 'Item Ledger Entry Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';
            ExternalName = 'Document No_';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            ExternalName = 'Description';
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code', Comment = 'ESP="Cód. almacén"';
            TableRelation = Location;
            ExternalName = 'Location Code';
        }
        field(9; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group', Comment = 'ESP="Grupo registro inventario"';
            TableRelation = "Inventory Posting Group";
            ExternalName = 'Inventory Posting Group';
        }
        field(11; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.', Comment = 'ESP="Nº mov. producto"';
            TableRelation = "Item Ledger Entry";
            ExternalName = 'Item Ledger Entry No_';
        }
        field(12; "Valued Quantity"; Decimal)
        {
            Caption = 'Valued Quantity', Comment = 'ESP="Cant. valorada"';
            DecimalPlaces = 0 : 5;
            ExternalName = 'Valued Quantity';
        }
        field(13; "Item Ledger Entry Quantity"; Decimal)
        {
            Caption = 'Item Ledger Entry Quantity', Comment = 'ESP="Cantidad mov. producto"';
            DecimalPlaces = 0 : 5;
            ExternalName = 'Item Ledger Entry Quantity';
        }


        field(43; "Cost Amount (Actual)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Actual)', Comment = 'ESP="Importe coste (Real)"';
            ExternalName = 'Cost Amount (Actual)';
        }
        field(45; "Cost Posted to G/L"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Posted to G/L', Comment = 'ESP="Coste regis. en contab."';
            ExternalName = 'Cost Posted to G_L';
        }

        field(60; "Document Date"; Date)
        {
            Caption = 'Document Date', Comment = 'ESP="Fecha emisión documento"';
            ExternalName = 'Document Date';
        }
        field(61; "External Document No."; Code[35])
        {
            Caption = 'External Document No.', Comment = 'ESP="Nº documento externo"';
            ExternalName = 'External Document No_';
        }
        field(68; "Cost Amount (Actual) (ACY)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Actual) (ACY)', Comment = 'ESP="Importe coste (Real) (DA)"';
            ExternalName = 'Cost Amount (Actual) (ACY)';
        }
        field(70; "Cost Posted to G/L (ACY)"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Posted to G/L (ACY)', Comment = 'ESP="Coste regis. en contab. (DA)"';
            ExternalName = 'Cost Posted to G_L (ACY)';
        }
        field(72; "Cost per Unit (ACY)"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            Caption = 'Cost per Unit (ACY)', Comment = 'ESP="Coste por unidad (DA)"';
            ExternalName = 'Cost per Unit (ACY)';
        }
        field(79; "Document Type"; Option)
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo documento"';
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly'
                , Comment = 'ESP=  ,Albarán venta,Factura venta,Recep. devol. ventas,Abono venta,Albarán compra,Factura compra,Envío devolución compra,Abono compra,Envío transfer.,Recep. transfer.,Servicio regis.,Factura ventas,Abono ventas,Ensamblado registrado"';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
            ExternalName = 'Document Type';
        }
        field(80; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.', Comment = 'ESP="Nº lín. documento"';
            ExternalName = 'Document Line No_';
        }
        field(104; "Valuation Date"; Date)
        {
            Caption = 'Valuation Date', Comment = 'ESP="Fecha valoración"';
            ExternalName = 'Valuation Date';
        }
        field(148; "Purchase Amount (Actual)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Purchase Amount (Actual)', Comment = 'ESP="Importe compra (actual)"';
            ExternalName = 'Purchase Amount (Actual)';
        }
        field(149; "Purchase Amount (Expected)"; Decimal)
        {
            AccessByPermission = TableData 120 = R;
            AutoFormatType = 1;
            Caption = 'Purchase Amount (Expected)', Comment = 'ESP="Importe compra (esperado)"';
            ExternalName = 'Purchase Amount (Expected)';
        }
        field(150; "Sales Amount (Expected)"; Decimal)
        {
            AccessByPermission = TableData 110 = R;
            AutoFormatType = 1;
            Caption = 'Sales Amount (Expected)', Comment = 'ESP="Importe ventas (Esperado)"';
            ExternalName = 'Sales Amount (Expected)';
        }
        field(151; "Cost Amount (Expected)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Expected)', Comment = 'ESP="Importe coste (Esperado)"';
            ExternalName = 'Cost Amount (Expected)';
        }
        field(152; "Cost Amount (Non-Invtbl.)"; Decimal)
        {
            AccessByPermission = TableData 5800 = R;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Non-Invtbl.)', Comment = 'ESP="Importe coste (No-invent.)"';
            ExternalName = 'Cost Amount (Non-Invtbl_)';
        }
        field(156; "Cost Amount (Expected) (ACY)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Expected) (ACY)', Comment = 'ESP="Importe coste (Esperado) (DA)"';
            ExternalName = 'Cost Amount (Expected) (ACY)';
        }
        field(157; "Cost Amount (Non-Invtbl.)(ACY)"; Decimal)
        {
            AccessByPermission = TableData 5800 = R;
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Non-Invtbl.)(ACY)', Comment = 'ESP="Importe coste (no-invent.)(DA)"';
            ExternalName = 'Cost Amount (Non-Invtbl_)(ACY)';
        }
        field(158; "Expected Cost Posted to G/L"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Expected Cost Posted to G/L', Comment = 'ESP="Coste esperado reg. en cont."';
            ExternalName = 'Expected Cost Posted to G_L';
        }
        field(159; "Exp. Cost Posted to G/L (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Exp. Cost Posted to G/L (ACY)', Comment = 'ESP="Coste esperado reg. cont. (DA)"';
            ExternalName = 'Exp_ Cost Posted to G_L (ACY)';
        }
        field(5831; "Capacity Ledger Entry No."; Integer)
        {
            Caption = 'Capacity Ledger Entry No.', Comment = 'ESP="Nº mov. capacidad"';
            TableRelation = "Capacity Ledger Entry";
            ExternalName = 'Capacity Ledger Entry No_';
        }
        field(5832; Type; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            OptionCaption = 'Work Center,Machine Center, ,Resource', Comment = 'ESP="Centro trabajo,Centro máquina, ,Recurso"';
            OptionMembers = "Work Center","Machine Center"," ",Resource;
            ExternalName = 'Type';
        }
        field(5834; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            TableRelation = IF (Type = CONST("Machine Center")) "Machine Center"
            ELSE IF (Type = CONST("Work Center")) "Work Center"
            ELSE IF (Type = CONST(Resource)) Resource;
            ExternalName = 'No_';
        }
        field(50104; "Account Type"; Option)
        {
            Caption = 'Account Type', comment = 'ESP="Tipo mov."';
            OptionCaption = 'Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance'
                , comment = 'ESP="Inventario (provisional),Crecimiento inventario (provisional),Inventario,Inventario WIP,Ajuste inventario,Coste directo aplicado,Coste general aplicado,Desviación de compras,Coste ventas,Coste ventas (provisional),Desviación material,Desviación capacidad,Desviación subcontratada,Cap. Desv. coste gen.,Desv. coste gen."';
            OptionMembers = "Inventory (Interim)","Invt. Accrual (Interim)",Inventory,"WIP Inventory","Inventory Adjmt.","Direct Cost Applied","Overhead Applied","Purchase Variance",COGS,"COGS (Interim)","Material Variance","Capacity Variance","Subcontracted Variance","Cap. Overhead Variance","Mfg. Overhead Variance";
            ExternalName = 'Account Type';
        }

        field(50105; "Amount G/L"; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
            ExternalName = 'Amount G_L';
        }
        field(50106; "Amount G/L (ACY)"; Decimal)
        {
            Caption = 'Amount (ACY)', Comment = 'ESP="Importe (DA)"';
            ExternalName = 'Amount G_L (ACY)';
        }
        field(50107; "Interim Account"; Boolean)
        {
            Caption = 'Interim Account', Comment = 'ESP="Cuenta provisional"';
            ExternalName = 'Interim Account';
        }
        field(50108; "Account No."; code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº cuenta"';
            TableRelation = "G/L Account";
            ExternalName = 'Account No_';
        }
        field(50109; "G/L Posting Date"; date)
        {
            Caption = 'G/L Posting Date', Comment = 'ESP="Fecha registro Contable"';
            ExternalName = 'G_L Posting Date';
        }
        field(50112; Negative; Boolean)
        {
            Caption = 'Negative', Comment = 'ESP="Negativo"';
            ExternalName = 'Negative';
        }
        field(50113; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.', Comment = 'ESP="Nº mov. contable"';
            TableRelation = "G/L Entry";
            ExternalName = 'G_L Entry No_';
        }
        field(50114; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type', Comment = 'ESP="Tipo contrapartida"';
            OptionCaption = 'Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance'
                , comment = 'ESP="Inventario (provisional),Crecimiento inventario (provisional),Inventario,Inventario WIP,Ajuste inventario,Coste directo aplicado,Coste general aplicado,Desviación de compras,Coste ventas,Coste ventas (provisional),Desviación material,Desviación capacidad,Desviación subcontratada,Cap. Desv. coste gen.,Desv. coste gen."';
            OptionMembers = "Inventory (Interim)","Invt. Accrual (Interim)",Inventory,"WIP Inventory","Inventory Adjmt.","Direct Cost Applied","Overhead Applied","Purchase Variance",COGS,"COGS (Interim)","Material Variance","Capacity Variance","Subcontracted Variance","Cap. Overhead Variance","Mfg. Overhead Variance";
            ExternalName = 'Bal_ Account Type';

        }
        field(50115; "Job No."; Code[20])
        {
            Caption = 'Job No.', Comment = 'ESP="Nº proyecto"';
            ExternalName = 'Job No_';
        }
        field(50116; "Account Heading"; Code[1])
        {
            Caption = 'Account Heading', Comment = 'ESP="Cuenta Mayor"';
            ExternalName = 'Account Heading';
        }
        field(50117; "Entry No."; Integer)
        {
            Caption = 'Entry No.', comment = 'ESP="Nº Mov."';
            ExternalName = 'Entry No_';
        }
        field(50200; "Parent Value Entry No."; Integer)
        {
            Caption = 'Parent Value Entry No.', Comment = 'ESP="Nº Principal mov. valor"';
            TableRelation = "Value Entry";
            ExternalName = 'Parent Value Entry No_';
        }
        field(50202; "Parent Item No."; Code[20])
        {
            Caption = 'Parent Item No.', Comment = 'ESP="Nº producto principal"';
            TableRelation = Item;
            ExternalName = 'Parent Item No_';
        }
        field(50203; "Parent Posting Date"; Date)
        {
            Caption = 'Parent Posting Date', Comment = 'ESP="Fecha registro principal"';
            ExternalName = 'Parent Posting Date';
        }
        field(50207; "Parent Description"; Text[100])
        {
            Caption = 'Parent Description', Comment = 'ESP="Descripción principal"';
            ExternalName = 'Parent Description';
        }
        field(50212; "Parent Valued Quantity"; Decimal)
        {
            Caption = 'Parent Valued Quantity', Comment = 'ESP="Cant. valorada principal"';
            DecimalPlaces = 0 : 5;
            ExternalName = 'Parent Valued Quantity';
        }
    }

    keys
    {
        key(PK; "Parent Value Entry No.", "Value Entry No.", "G/L Entry No.", "Account No.")
        {
            Clustered = true;
        }
        key(Key1; "Item Ledger Entry No.", "Item Ledger Entry Type")
        { }
        key(Key2; "Entry No.")
        { }
        key(Key3; "Posting Date", "Item No.", "Item Ledger Entry Type")
        { }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        GLSetup: Record "General Ledger Setup";
        ValueEntryGLEntry: Record "ZM Cost Value entry Sales";
        GLSetupRead: Boolean;



    local procedure GetCurrencyCode(): Code[10]
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;


    procedure UpdateEntries(DateFilter: Text; EntriesFilter: text)
    var
        ValueEntry: Record "Value Entry";
        GLItemLedgerRelation: Record "G/L - Item Ledger Relation";
        Window: Dialog;
        lblDialog: Label 'Tipo #1#########################\Movimiento Valor:#2#################\Fecha:#3############', comment = 'ESP="Tipo #1#########################\Movimiento Valor:#2#################\Fecha:#3############"';
    begin
        if GuiAllowed then
            Window.Open(lblDialog);
        // primero mirarmos todos los movimientos de valor y si ya tienen el registro contable
        ValueEntry.Reset();
        if EntriesFilter <> '' then
            ValueEntry.SetFilter("Entry No.", EntriesFilter);
        // ValueEntry.SetRange("Updated Cost Entry", false);
        if DateFilter <> '' then
            ValueEntry.SetFilter("Posting Date", DateFilter);

        ValueEntry.SetFilter("Item Ledger Entry Type", '%1', ValueEntry."Item Ledger Entry Type"::Sale, ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.");
        if ValueEntry.FindFirst() then
            repeat
                if (ValueEntry."Cost Posted to G/L" <> 0) or (ValueEntry."Expected Cost Posted to G/L" <> 0) then begin
                    if GuiAllowed then
                        Window.Update(1, ValueEntry.TableCaption);
                    if GuiAllowed then
                        Window.Update(2, ValueEntry."Entry No.");
                    if CreateValueGLEntry(ValueEntry) then
                        if GuiAllowed then
                            Window.Update(3, ValueEntry."Posting Date");
                end;
            until ValueEntry.Next() = 0;

        if GuiAllowed then
            Window.Close();
    end;

    local procedure CreateValueGLEntry(ValueEntry: Record "Value Entry"): Boolean
    var
        Cost: Decimal;
        i: Integer;
    begin
        // GLItemLedgerRelation.SetRange("Value Entry No.", ValueEntry."Entry No.");
        // if GLItemLedgerRelation.FindFirst() then
        //     repeat
        // comprobamos si tiene 
        DeleteTempValueEntryGLEntry(ValueEntry);
        if CreateItemLedgerGlEntry(ValueEntry, ValueEntry, Cost) then
            exit(true);

        // Until GLItemLedgerRelation.next() = 0;
    end;

    local procedure CreateItemLedgerGlEntry(ParentValueEntry: record "Value Entry"; ValueEntry: record "Value Entry"; Cost: Decimal): Boolean
    var
        tmpInvtPostBuf: Record "Invt. Posting Buffer" temporary;
        InvPosting: Codeunit "Inventory Posting To G/L";
        Functions: Codeunit "Zummo Inn. IC Functions";
    begin
        ValueEntry."Cost Posted to G/L" := 0;
        ValueEntry."Expected Cost Posted to G/L" := 0;
        Clear(InvPosting);
        if not InvPosting.BufferInvtPosting(ValueEntry) then
            exit;
        // Message(StrSubstNo('No se encuentran datos buffer %1', ValueEntry."Entry No."));
        InvPosting.GetInvtPostBuf(tmpInvtPostBuf);

        if tmpInvtPostBuf.FindFirst() then
            repeat
                Functions.UpdateParentValueEntry(ValueEntry, ValueEntry, tmpInvtPostBuf);
            // ValueEntry."Updated Cost Entry" := true;
            // ValueEntry.Modify();
            Until tmpInvtPostBuf.next() = 0;
        // GLItemLedgerRelation."Updated Cost Entry" := true;
        // GLItemLedgerRelation.Modify();
        Commit();
        exit(true);
    end;

    local procedure DeleteTempValueEntryGLEntry(ValueEntry: Record "Value Entry")
    begin
        ValueEntryGLEntry.Reset();
        ValueEntryGLEntry.SetRange("Parent Value Entry No.", ValueEntry."Entry No.");
        ValueEntryGLEntry.DeleteAll();
    end;


    local procedure UpdateValueEntryTemporary(var BOMCosts: Record "ZM Value entry - G/L Entry"; var ValueEntryGLEntry: Record "ZM Value entry - G/L Entry";
            Quantity: Decimal)
    var
        EntryNo: Integer;
    begin
        if ValueEntryGLEntry.FindFirst() then
            repeat
                if not BOMCosts.Get(ValueEntryGLEntry."Value Entry No.", ValueEntryGLEntry."G/L Entry No.", ValueEntryGLEntry."Account No.") then begin
                    EntryNo := BOMCosts."Entry No.";
                    BOMCosts.Init();
                    BOMCosts.TransferFields(ValueEntryGLEntry);
                    BOMCosts."Entry No." := EntryNo + 1;
                    BOMCosts.Insert();
                end else begin
                    if Quantity <> BOMCosts."Valued Quantity" then begin
                        // TODO                    Multiplicar por cantidad

                    end;
                end;
            Until ValueEntryGLEntry.next() = 0;
    end;

    local procedure GetItemApplicationEntry(var BOMCosts: Record "ZM Value entry - G/L Entry"; ItemledgerEntry: record "Item Ledger Entry")
    var
        ItemApplnEntry: record "Item Application Entry";
        ItemLedgEntry: record "Item Ledger Entry";
    begin
        IF ItemledgerEntry.Positive THEN BEGIN
            case ItemledgerEntry."Entry Type" of
                ItemledgerEntry."Entry Type"::Transfer:
                    begin
                        ItemApplnEntry.RESET;
                        ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.", "Outbound Item Entry No.", "Cost Application");
                        ItemApplnEntry.SETRANGE("Inbound Item Entry No.", ItemledgerEntry."Entry No.");
                        ItemApplnEntry.SETFILTER("Transferred-from Entry No.", '<>%1', 0);
                        ItemApplnEntry.SETRANGE("Cost Application", TRUE);
                        IF ItemApplnEntry.FIND('-') THEN
                            REPEAT
                                ItemLedgEntry.Get(ItemApplnEntry."Inbound Item Entry No.");
                                case ItemLedgEntry."Entry Type" of
                                    ItemLedgEntry."Entry Type"::Transfer:
                                        begin
                                            ItemLedgEntry.Get(ItemApplnEntry."Transferred-from Entry No.");
                                            GetItemApplicationEntry(BOMCosts, ItemLedgEntry);
                                        end;
                                end;
                            UNTIL ItemApplnEntry.NEXT = 0;
                    end;
                else
                    ValueEntryGLEntry.Reset();
                    ValueEntryGLEntry.SetRange("Item Ledger Entry No.", ItemledgerEntry."Entry No.");
            // UpdateValueEntryTemporary(BOMCosts, ValueEntryGLEntry, ItemledgerEntry.Quantity);
            end;
        END ELSE BEGIN
            ItemApplnEntry.RESET;
            ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
            ItemApplnEntry.SETRANGE("Outbound Item Entry No.", ItemledgerEntry."Entry No.");
            ItemApplnEntry.SETRANGE("Item Ledger Entry No.", ItemledgerEntry."Entry No.");
            ItemApplnEntry.SETRANGE("Cost Application", TRUE);
            IF ItemApplnEntry.FIND('-') THEN
                REPEAT
                    // Si no es compra o transferencia, seguimos explorando
                    // InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.", -ItemApplnEntry.Quantity);
                    ItemLedgEntry.Get(ItemApplnEntry."Inbound Item Entry No.");
                    case ItemLedgEntry."Entry Type" of
                        ItemLedgEntry."Entry Type"::Transfer:
                            begin
                                GetItemApplicationEntry(BOMCosts, ItemLedgEntry);
                            end;
                    end;
                UNTIL ItemApplnEntry.NEXT = 0;
        END;
    end;

    // local procedure InsertTempEntry(var BOMCosts: Record "ZM Value entry - G/L Entry"; EntryNo: Integer; AppliedQty: Decimal)
    // var
    //     ItemLedgEntry: record "Item Ledger Entry";
    // begin
    //     ItemLedgEntry.GET(EntryNo);
    //     IF AppliedQty * ItemLedgEntry.Quantity < 0 THEN
    //         EXIT;
    //     ValueEntryGLEntry.Reset();
    //     ValueEntryGLEntry.SetRange("Item Ledger Entry No.", EntryNo);
    //     UpdateValueEntryTemporary(BOMCosts, ValueEntryGLEntry, AppliedQty);
    // end;

    procedure UpdateMayorAccount()
    var
        Window: Dialog;
    begin
        Window.Open('Actualizando cuentas mayores #1####################');
        ValueEntryGLEntry.Reset();
        if ValueEntryGLEntry.FindFirst() then
            repeat
                Window.Update(1, ValueEntryGLEntry."Value Entry No.");
                ValueEntryGLEntry."Account Heading" := CopyStr(ValueEntryGLEntry."Account No.", 1, MaxStrLen(ValueEntryGLEntry."Account Heading"));
                ValueEntryGLEntry.Modify();
            Until ValueEntryGLEntry.next() = 0;
        Window.Close();
    end;
}
