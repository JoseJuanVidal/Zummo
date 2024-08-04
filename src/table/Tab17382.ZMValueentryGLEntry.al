table 17382 "ZM Value entry - G/L Entry"
{
    DataClassification = CustomerContent;
    Caption = 'Value entry - G/L Entry Analysis', comment = 'ESP="Análisis Mov. Valor - Mov. Contable"';

    fields
    {
        field(1; "Value Entry No."; Integer)
        {
            Caption = 'Value Entry No.', Comment = 'ESP="Nº mov. valor"';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Nº producto"';
            TableRelation = Item;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
        }
        field(4; "Item Ledger Entry Type"; Option)
        {
            Caption = 'Item Ledger Entry Type', Comment = 'ESP="Tipo mov. producto"';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code', Comment = 'ESP="Cód. almacén"';
            TableRelation = Location;
        }
        field(9; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group', Comment = 'ESP="Grupo registro inventario"';
            TableRelation = "Inventory Posting Group";
        }
        field(11; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.', Comment = 'ESP="Nº mov. producto"';
            TableRelation = "Item Ledger Entry";
        }
        field(12; "Valued Quantity"; Decimal)
        {
            Caption = 'Valued Quantity', Comment = 'ESP="Cant. valorada"';
            DecimalPlaces = 0 : 5;
        }
        field(13; "Item Ledger Entry Quantity"; Decimal)
        {
            Caption = 'Item Ledger Entry Quantity', Comment = 'ESP="Cantidad mov. producto"';
            DecimalPlaces = 0 : 5;
        }
        field(14; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity', Comment = 'ESP="Cantidad facturada"';
            DecimalPlaces = 0 : 5;
        }
        field(15; "Cost per Unit"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Cost per Unit', Comment = 'ESP="Coste por ud."';
        }
        field(17; "Sales Amount (Actual)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Sales Amount (Actual)', Comment = 'ESP="Importe ventas (Real)"';
        }
        field(22; "Salespers./Purch. Code"; Code[20])
        {
            Caption = 'Salespers./Purch. Code', Comment = 'ESP="Cód. vendedor/comprador"';
            TableRelation = "Salesperson/Purchaser";
        }
        field(23; "Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Discount Amount', Comment = 'ESP="Importe dto."';
        }
        field(28; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry', Comment = 'ESP="Liq. por nº orden"';
        }
        field(43; "Cost Amount (Actual)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Actual)', Comment = 'ESP="Importe coste (Real)"';
        }
        field(45; "Cost Posted to G/L"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Posted to G/L', Comment = 'ESP="Coste regis. en contab."';
        }
        field(46; "Reason Code"; Code[10])
        {
            AccessByPermission = TableData 223 = R;
            Caption = 'Reason Code', Comment = 'ESP="Cód. auditoría"';
            TableRelation = "Reason Code";
        }
        field(47; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment', Comment = 'ESP="Envío directo"';
        }
        field(48; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name', Comment = 'ESP="Nombre sección diario"';
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(57; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group', Comment = 'ESP="Grupo registro neg. gen."';
            TableRelation = "Gen. Business Posting Group";
        }
        field(58; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group', Comment = 'ESP="Grupo registro prod. gen."';
            TableRelation = "Gen. Product Posting Group";
        }
        field(60; "Document Date"; Date)
        {
            Caption = 'Document Date', Comment = 'ESP="Fecha emisión documento"';
        }
        field(61; "External Document No."; Code[35])
        {
            Caption = 'External Document No.', Comment = 'ESP="Nº documento externo"';
        }
        field(68; "Cost Amount (Actual) (ACY)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Actual) (ACY)', Comment = 'ESP="Importe coste (Real) (DA)"';
        }
        field(70; "Cost Posted to G/L (ACY)"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Posted to G/L (ACY)', Comment = 'ESP="Coste regis. en contab. (DA)"';
        }
        field(72; "Cost per Unit (ACY)"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            Caption = 'Cost per Unit (ACY)', Comment = 'ESP="Coste por unidad (DA)"';
        }
        field(79; "Document Type"; Option)
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo documento"';
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly'
                , Comment = 'ESP=  ,Albarán venta,Factura venta,Recep. devol. ventas,Abono venta,Albarán compra,Factura compra,Envío devolución compra,Abono compra,Envío transfer.,Recep. transfer.,Servicio regis.,Factura ventas,Abono ventas,Ensamblado registrado"';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
        }
        field(80; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.', Comment = 'ESP="Nº lín. documento"';
        }
        field(90; "Order Type"; Option)
        {
            Caption = 'Order Type', Comment = 'ESP="Tipo orden"';
            Editable = false;
            OptionCaption = ' ,Production,Transfer,Service,Assembly', Comment = 'ESP=" ,Producción,Transferencia,Servicio,Ensamblado"';
            OptionMembers = " ",Production,Transfer,Service,Assembly;
        }
        field(91; "Order No."; Code[20])
        {
            Caption = 'Order No.', Comment = 'ESP="Nº pedido"';
            Editable = false;
        }
        field(92; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.', Comment = 'ESP="Nº línea pedido"';
            Editable = false;
        }
        field(98; "Expected Cost"; Boolean)
        {
            Caption = 'Expected Cost', Comment = 'ESP="Coste previsto"';
        }
        field(99; "Item Charge No."; Code[20])
        {
            Caption = 'Item Charge No.', Comment = 'ESP="Nº cargo prod."';
            TableRelation = "Item Charge";
        }
        field(100; "Valued By Average Cost"; Boolean)
        {
            Caption = 'Valued By Average Cost', Comment = 'ESP="Valorado a coste medio"';
        }
        field(102; "Partial Revaluation"; Boolean)
        {
            Caption = 'Partial Revaluation', Comment = 'ESP="Revalorización parcial"';
        }
        field(103; Inventoriable; Boolean)
        {
            Caption = 'Inventoriable', Comment = 'ESP="Inventariable"';
        }
        field(104; "Valuation Date"; Date)
        {
            Caption = 'Valuation Date', Comment = 'ESP="Fecha valoración"';
        }
        field(105; "Entry Type"; Option)
        {
            Caption = 'Entry Type', Comment = 'ESP="Tipo movimiento"';
            Editable = false;
            OptionCaption = 'Direct Cost,Revaluation,Rounding,Indirect Cost,Variance', Comment = 'ESP="Coste directo,Revalorización,Redondeo,Coste indirecto,Desviación"';
            OptionMembers = "Direct Cost",Revaluation,Rounding,"Indirect Cost",Variance;
        }
        field(106; "Variance Type"; Option)
        {
            Caption = 'Variance Type', Comment = 'ESP="Tipo desviación"';
            Editable = false;
            OptionCaption = ' ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead,Subcontracted', Comment = 'ESP=" ,Compras,Materiales,Capacidad,Gastos gen. capacidad,Gastos gen. fabr.,Subcontratación"';
            OptionMembers = " ",Purchase,Material,Capacity,"Capacity Overhead","Manufacturing Overhead",Subcontracted;
        }
        field(148; "Purchase Amount (Actual)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Purchase Amount (Actual)', Comment = 'ESP="Importe compra (actual)"';
        }
        field(149; "Purchase Amount (Expected)"; Decimal)
        {
            AccessByPermission = TableData 120 = R;
            AutoFormatType = 1;
            Caption = 'Purchase Amount (Expected)', Comment = 'ESP="Importe compra (esperado)"';
        }
        field(150; "Sales Amount (Expected)"; Decimal)
        {
            AccessByPermission = TableData 110 = R;
            AutoFormatType = 1;
            Caption = 'Sales Amount (Expected)', Comment = 'ESP="Importe ventas (Esperado)"';
        }
        field(151; "Cost Amount (Expected)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Expected)', Comment = 'ESP="Importe coste (Esperado)"';
        }
        field(152; "Cost Amount (Non-Invtbl.)"; Decimal)
        {
            AccessByPermission = TableData 5800 = R;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Non-Invtbl.)', Comment = 'ESP="Importe coste (No-invent.)"';
        }
        field(156; "Cost Amount (Expected) (ACY)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Expected) (ACY)', Comment = 'ESP="Importe coste (Esperado) (DA)"';
        }
        field(157; "Cost Amount (Non-Invtbl.)(ACY)"; Decimal)
        {
            AccessByPermission = TableData 5800 = R;
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Non-Invtbl.)(ACY)', Comment = 'ESP="Importe coste (no-invent.)(DA)"';
        }
        field(158; "Expected Cost Posted to G/L"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Expected Cost Posted to G/L', Comment = 'ESP="Coste esperado reg. en cont."';
        }
        field(159; "Exp. Cost Posted to G/L (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Exp. Cost Posted to G/L (ACY)', Comment = 'ESP="Coste esperado reg. cont. (DA)"';
        }
        field(5831; "Capacity Ledger Entry No."; Integer)
        {
            Caption = 'Capacity Ledger Entry No.', Comment = 'ESP="Nº mov. capacidad"';
            TableRelation = "Capacity Ledger Entry";
        }
        field(5832; Type; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            OptionCaption = 'Work Center,Machine Center, ,Resource', Comment = 'ESP="Centro trabajo,Centro máquina, ,Recurso"';
            OptionMembers = "Work Center","Machine Center"," ",Resource;
        }
        field(5834; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            TableRelation = IF (Type = CONST("Machine Center")) "Machine Center"
            ELSE IF (Type = CONST("Work Center")) "Work Center"
            ELSE IF (Type = CONST(Resource)) Resource;
        }
        field(50000; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.', comment = 'ESP="Nº Mov. contabilidad"';
        }

        field(50001; "Clasification Entry"; Option)
        {
            Caption = 'Clasification Entry', comment = 'ESP="Clasificación Mov."';
            OptionMembers = " ",Inventory,Purchase,Sales,Production,Assembly,Adjmt;
            OptionCaption = ' ,Inventory,Purchase,Sales,Production,Assembly,Adjmt', comment = 'ESP=" ,Existencias,Compras,Ventas,Fabricación,Ensamblado,Ajustes"';
        }
        field(50002; "G/L Account No."; code[20])
        {
            Caption = 'G/L Account No.', comment = 'ESP="Nº cuenta"';
        }
        field(50003; "G/L Posting Date"; date)
        {
            Caption = 'G/L Posting Date', comment = 'ESP="Fecha Registro contable"';
        }
        field(50004; Amount; Decimal)
        {
            Caption = 'Amount', comment = 'ESP="Importe"';
        }
        field(50005; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount', comment = 'ESP="Importe Debe"';
        }
        field(50006; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount', comment = 'ESP="Importe Haber"';
        }
    }

    keys
    {
        key(PK; "Value Entry No.", "G/L Entry No.", "Clasification Entry")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        GLSetup: Record "General Ledger Setup";
        GLEntry: Record "G/L Entry";
        ValueEntryGLEntry: Record "ZM Value entry - G/L Entry";
        GLSetupRead: Boolean;

    local procedure GetCurrencyCode(): Code[10]
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;


    procedure UpdateEntries()
    var
        ValueEntry: Record "Value Entry";
        tmpValueEntry: Record "Value Entry" temporary;
        GLItemLedgerRelation: Record "G/L - Item Ledger Relation";
        Window: Dialog;
        lblDialog: Label 'Tipo #1#########################\Movimiento Valor:#2#################\Fecha:#3############', comment = 'ESP="Tipo #1#########################\Movimiento Valor:#2#################\Fecha:#3############"';
    begin
        if GuiAllowed then
            Window.Open(lblDialog);
        // primero mirarmos todos los movimientos de valor y si ya tienen el registro contable
        ValueEntry.Reset();
        ValueEntry.SetRange("Updated Cost Entry", false);
        if ValueEntry.FindFirst() then
            repeat
                if GuiAllowed then
                    Window.Update(1, ValueEntry.TableCaption);
                if GuiAllowed then
                    Window.Update(2, ValueEntry."Entry No.");
                if GuiAllowed then
                    Window.Update(3, ValueEntry."Posting Date");

                // segun el tipo y si tiene cantidad facturada, registramos apunte 600 o 700
                if ValueEntry."Valued Quantity" <> 0 then begin
                    case ValueEntry."Item Ledger Entry Type" of
                        ValueEntry."Item Ledger Entry Type"::Purchase:
                            begin
                                // creamos el apunte en la cuenta 600
                                InitialValueEntryGLRelation(ValueEntry, false);
                            end;
                        ValueEntry."Item Ledger Entry Type"::Sale:
                            begin
                                // creamos el apunte en la cuenta 700
                                InitialValueEntryGLRelation(ValueEntry, true);
                            end;
                    end;
                end;
                CreateValueGLEntry(ValueEntry);
                Commit();
            Until ValueEntry.next() = 0;
        // despues miramos el registro de variacion de existencias en contabilidad
        GLItemLedgerRelation.Reset();
        GLItemLedgerRelation.SetRange("Updated Cost Entry", false);
        if GLItemLedgerRelation.FindFirst() then
            repeat
                if GuiAllowed then
                    Window.Update(1, GLItemLedgerRelation.TableCaption);
                if GuiAllowed then
                    Window.Update(2, GLItemLedgerRelation."Value Entry No.");
                if GuiAllowed then
                    Window.Update(3, '');
                tmpValueEntry.Init();
                tmpValueEntry."Entry No." := GLItemLedgerRelation."Value Entry No.";
                tmpValueEntry.Insert();
            Until GLItemLedgerRelation.next() = 0;
        ValueEntry.Reset();
        if tmpValueEntry.FindFirst() then
            repeat
                if GuiAllowed then
                    Window.Update(1, ValueEntry.TableCaption);
                if GuiAllowed then
                    Window.Update(2, ValueEntry."Entry No.");
                if GuiAllowed then
                    Window.Update(3, ValueEntry."Posting Date");
                ValueEntry.Get(tmpValueEntry."Entry No.");

                CreateValueGLEntry(ValueEntry);
            Until tmpValueEntry.next() = 0;
        if GuiAllowed then
            Window.Close();
    end;

    local procedure InitialValueEntryGLRelation(ValueEntry: Record "Value Entry"; Sales: Boolean)
    var
        Cost: Decimal;
    begin
        ValueEntryGLEntry.Reset();
        ValueEntryGLEntry.SetRange("Value Entry No.", ValueEntry."Entry No.");
        ValueEntryGLEntry.SetRange("G/L Entry No.", ValueEntry."Entry No.");
        if Sales then
            ValueEntryGLEntry.SetRange("Clasification Entry", ValueEntryGLEntry."Clasification Entry"::Sales)
        else
            ValueEntryGLEntry.SetRange("Clasification Entry", ValueEntryGLEntry."Clasification Entry"::Purchase);

        if ValueEntryGLEntry.FindFirst() then
            exit;

        ValueEntryGLEntry.Init();
        ValueEntryGLEntry.TransferFields(ValueEntry);
        ValueEntryGLEntry."G/L Entry No." := ValueEntry."Entry No.";
        if sales then
            ValueEntryGLEntry."G/L Account No." := '700'
        else
            ValueEntryGLEntry."G/L Account No." := '600';
        ValueEntryGLEntry."G/L Posting Date" := ValueEntry."Posting Date";
        if Sales then
            cost := ValueEntry."Sales Amount (Actual)"
        else
            Cost := ValueEntry."Cost Amount (Actual)";
        ValueEntryGLEntry.Amount := Cost;
        if Cost > 0 then
            ValueEntryGLEntry."Debit Amount" := abs(Cost)
        else
            ValueEntryGLEntry."Credit Amount" := abs(Cost);
        Rec."Clasification Entry" := GetClassification(ValueEntry);
        ValueEntryGLEntry.Insert();
    end;

    local procedure CreateValueGLEntry(ValueEntry: Record "Value Entry")
    var
        GLItemLedgerRelation: Record "G/L - Item Ledger Relation";
        Cost: Decimal;
        i: Integer;
    begin
        GLItemLedgerRelation.Reset();
        GLItemLedgerRelation.SetRange("Value Entry No.", ValueEntry."Entry No.");
        if not GLItemLedgerRelation.FindFirst() then begin
            // no esta registrada contablemente la variacion de existencia
            // creamos solo value entry con G/L Entry No. = CERO
            CreateItemLedgerGLWithoutGLRegister(ValueEntry)
        end else
            repeat
                if (ValueEntry."Cost Amount (Actual)" <> 0) and (ValueEntry."Cost Amount (Expected)" <> 0) then begin
                    // segun el bucle de cuentas, las asignamos
                    // 1º Real 2º provi 3º provi 4 real
                    i += 1;
                    case i of
                        1:  // Real
                            cost := ValueEntry."Cost Amount (Actual)";
                        2:  // provision
                            cost := ValueEntry."Cost Amount (Expected)";
                        3:  // Provision
                            cost := ValueEntry."Cost Amount (Expected)";
                        else  // Real
                            cost := ValueEntry."Cost Amount (Actual)";
                    end;
                end else begin
                    if ValueEntry."Cost Amount (Actual)" <> 0 then
                        Cost := ValueEntry."Cost Amount (Actual)"
                    else
                        cost := ValueEntry."Cost Amount (Expected)";
                end;
                CreateItemLedgerGlEntry(GLItemLedgerRelation, Cost);
            Until GLItemLedgerRelation.next() = 0;
    end;

    local procedure CreateItemLedgerGLWithoutGLRegister(ValueEntry: Record "Value Entry")
    var
        myInt: Integer;
    begin
        ValueEntryGLEntry.Reset();
        if not ValueEntryGLEntry.Get(ValueEntry."Entry No.", 0, GetClassification(ValueEntry)) then begin
            DeleteTempValueEntryGLEntry(ValueEntry);
            if not (ValueEntry."Item Ledger Entry Type" in [ValueEntry."Item Ledger Entry Type"::Transfer]) then begin
                ValueEntryGLEntry.Init();
                Clear(ValueEntryGLEntry);
                ValueEntryGLEntry.TransferFields(ValueEntry);
                ValueEntryGLEntry."G/L Entry No." := 0;
                ValueEntryGLEntry."Clasification Entry" := GetClassification(ValueEntry);
                ValueEntryGLEntry.Insert();
                ValueEntry."Updated Cost Entry" := true;
                ValueEntry.Modify();
            end;
        end;
    end;

    local procedure CreateItemLedgerGlEntry(var GLItemLedgerRelation: Record "G/L - Item Ledger Relation"; Cost: Decimal)
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.Reset();
        GLEntry.Reset();
        ValueEntryGLEntry.Reset();
        ValueEntry.Get(GLItemLedgerRelation."Value Entry No.");
        if not ValueEntryGLEntry.Get(GLItemLedgerRelation."Value Entry No.", GLEntry."Entry No.", GetClassification(ValueEntry)) then begin

            DeleteTempValueEntryGLEntry(ValueEntry);
            if not (ValueEntry."Item Ledger Entry Type" in [ValueEntry."Item Ledger Entry Type"::Transfer]) then begin
                GLEntry.Get(GLItemLedgerRelation."G/L Entry No.");
                ValueEntryGLEntry.Init();
                ValueEntryGLEntry.TransferFields(ValueEntry);
                ValueEntryGLEntry."G/L Entry No." := GLItemLedgerRelation."G/L Entry No.";
                ValueEntryGLEntry."G/L Account No." := GLEntry."G/L Account No.";
                ValueEntryGLEntry."G/L Posting Date" := GLEntry."Posting Date";

                ValueEntryGLEntry.Amount := Cost;
                if GLEntry."Debit Amount" > 0 then
                    ValueEntryGLEntry."Debit Amount" := abs(Cost);
                if GLEntry."Credit Amount" > 0 then
                    ValueEntryGLEntry."Credit Amount" := abs(Cost);
                Rec."Clasification Entry" := GetClassification(ValueEntry);
                ValueEntryGLEntry.Insert();
                ValueEntry."Updated Cost Entry" := true;
                ValueEntry.Modify();
            end;
        end;
        GLItemLedgerRelation."Updated Cost Entry" := true;
        GLItemLedgerRelation.Modify();
    end;

    local procedure DeleteTempValueEntryGLEntry(ValueEntry: Record "Value Entry")
    var
        myInt: Integer;
    begin
        ValueEntryGLEntry.Reset();
        ValueEntryGLEntry.SetRange("Value Entry No.", ValueEntry."Entry No.");
        ValueEntryGLEntry.SetRange("G/L Entry No.", 0);
        ValueEntryGLEntry.DeleteAll();
    end;

    local procedure GetClassification(ValueEntry: Record "Value Entry"): Integer
    var
        myInt: Integer;
    begin
        case ValueEntry."Item Ledger Entry Type" of
            ValueEntry."Item Ledger Entry Type"::" ", ValueEntry."Item Ledger Entry Type"::Consumption, ValueEntry."Item Ledger Entry Type"::Output:
                begin
                    exit(Rec."Clasification Entry"::Production);
                end;
            ValueEntry."Item Ledger Entry Type"::Sale:
                exit(Rec."Clasification Entry"::Sales);
            ValueEntry."Item Ledger Entry Type"::Purchase:
                exit(Rec."Clasification Entry"::Inventory);
            ValueEntry."Item Ledger Entry Type"::"Assembly Consumption", ValueEntry."Item Ledger Entry Type"::"Assembly Output":
                exit(Rec."Clasification Entry"::Assembly);
            ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.", ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.":
                exit(Rec."Clasification Entry"::Adjmt);
        end;
    end;
}