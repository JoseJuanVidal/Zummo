table 17383 "ZM G/L Register Inventory"
{
    DataClassification = CustomerContent;
    Caption = 'G/L Register Inventory', comment = 'ESP="Registros Inventario Contable"';

    fields
    {
        field(1; "G/L Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Entry No.', comment = 'ESP="Nº mov. contabilidad"';
            TableRelation = "Value Entry";
        }
        field(3; "G/L Register No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Register No.', comment = 'ESP="Nº asto. registro"';
            TableRelation = "G/L Entry";
        }
        field(10; "G/L Account No."; code[20])
        {
            Caption = 'G/L Account No.', comment = 'ESP="Nº cuenta"';
            TableRelation = "G/L Account";
        }
        field(11; "G/L Posting Date"; date)
        {
            Caption = 'G/L Posting Date', comment = 'ESP="Fecha Registro contable"';
        }
        field(12; Amount; Decimal)
        {
            Caption = 'Amount', comment = 'ESP="Importe"';
        }
        field(13; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount', comment = 'ESP="Importe Debe"';
        }
        field(14; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount', comment = 'ESP="Importe Haber"';
        }
        field(15; "Clasification Entry"; Option)
        {
            Caption = 'Clasification Entry', comment = 'ESP="Clasificación Mov."';
            OptionMembers = " ",Inventory,Purchase,Sales,Production,Assembly,Adjmt;
            OptionCaption = ' ,Inventory,Purchase,Sales,Production,Assembly,Adjmt', comment = 'ESP=" ,Existencias,Compras,Ventas,Fabricación,Ensamblado,Ajustes"';
        }
        field(16; "Description"; text[100])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(20; "G/L Account Name"; text[100])
        {
            Caption = 'G/L Account Name', comment = 'ESP="Nombre cuenta"';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("G/L Account No.")));
            Editable = false;
        }
        field(50; "Amount Total G/L Entry"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Total G/L Entry', comment = 'ESP="Importe Total Apunte"';
        }
        field(60; "PYL"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'PYL', comment = 'ESP="PYL"';
        }
    }

    keys
    {
        key(PK; "G/L Entry No.", "G/L Account No.", "Clasification Entry")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        GLItemLedgerRelation: Record "G/L - Item Ledger Relation";

    procedure UpdateEntries()
    var
        GLEntry: Record "G/L Entry";
        ValueEntry: Record "Value Entry";
        GLItemLedgerRelation: Record "G/L - Item Ledger Relation";
        GLRegisterInventory: Record "ZM G/L Register Inventory";
        Window: Dialog;
        Cost: Decimal;
        ValueEntryNo: Integer;
        I: Integer;
        lblDialog: Label 'Mov. Valor #1#########################\Mov Contabilidad:#2#################\Fecha:#3############'
            , comment = 'ESP="Mov. Valor #1#########################\Mov. Contabilidad:#2#################\Fecha:#3############"';
    begin
        if GuiAllowed then
            Window.Open(lblDialog);
        GLItemLedgerRelation.SetCurrentKey("Value Entry No.");
        GLItemLedgerRelation.SetFilter("Value Entry No.", '%1..', 4640590);
        GLItemLedgerRelation.SetRange("Updated Cost Entry", false);
        if GLItemLedgerRelation.FindFirst() then
            repeat
                if GuiAllowed then begin
                    Window.Update(1, GLItemLedgerRelation."Value Entry No.");
                    Window.Update(2, GLItemLedgerRelation."G/L Entry No.");
                end;
                if GLEntry.Get(GLItemLedgerRelation."G/L Entry No.") then
                    if ValueEntry.Get(GLItemLedgerRelation."Value Entry No.") and
                    not (ValueEntry."Item Ledger Entry Type" in [ValueEntry."Item Ledger Entry Type"::Transfer]) then begin
                        if GuiAllowed then
                            Window.Update(3, GLEntry."Posting Date");
                        if ValueEntryNo <> GLItemLedgerRelation."Value Entry No." then begin
                            ValueEntryNo := GLItemLedgerRelation."Value Entry No.";
                            i := 0;
                        end;
                        i += 1;
                        Cost := GetCostValueEntry(ValueEntry, I);
                        GLRegisterInventory.Reset();
                        GLRegisterInventory.SetRange("G/L Entry No.", GLItemLedgerRelation."G/L Entry No.");
                        GLRegisterInventory.SetRange("G/L Account No.", GLEntry."G/L Account No.");
                        GLRegisterInventory.SetRange("Clasification Entry", GetClassification(ValueEntry));
                        if not GLRegisterInventory.FindFirst() then begin
                            Clear(GLRegisterInventory);
                            GLRegisterInventory.Init();
                            GLRegisterInventory."G/L Entry No." := GLItemLedgerRelation."G/L Entry No.";
                            GLRegisterInventory."G/L Register No." := GLItemLedgerRelation."G/L Register No.";
                            GLRegisterInventory."Clasification Entry" := GetClassification(ValueEntry);
                            GLRegisterInventory."G/L Account No." := GLEntry."G/L Account No.";
                            GLRegisterInventory."G/L Account Name" := GLEntry.Description;
                            GLRegisterInventory."G/L Posting Date" := GLEntry."Posting Date";
                            GLRegisterInventory."Amount Total G/L Entry" := GLEntry.Amount;
                            GLRegisterInventory.PYL := CopyStr(GLEntry."G/L Account No.", 1, 1) <> '3';
                            GLRegisterInventory.Insert();
                        end;
                        GLRegisterInventory.Amount += Cost;
                        if GLEntry."Debit Amount" > 0 then
                            GLRegisterInventory."Debit Amount" += abs(Cost);
                        if GLEntry."Credit Amount" > 0 then
                            GLRegisterInventory."Credit Amount" += abs(Cost);
                        GLRegisterInventory.Modify();
                        Commit();
                    end;
            Until GLItemLedgerRelation.next() = 0;

        if GuiAllowed then
            Window.Close();

    end;

    local procedure GetCostValueEntry(ValueEntry: Record "Value Entry"; I: Integer) Cost: Decimal
    begin
        if (ValueEntry."Cost Amount (Actual)" <> 0) and (ValueEntry."Cost Amount (Expected)" <> 0) then begin
            // segun el bucle de cuentas, las asignamos
            // 1º Real 2º provi 3º provi 4 real
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