tableextension 50041 "GLEntry" extends "G/L Entry" //17
{//17
    fields
    {
        field(50000; "Original Date Reverse"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50100; "IdFactAbno_btc"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice/Cr. Memo No.', comment = 'ESP="Nº factura/abono"';
        }

        field(50101; "Liquidado_btc"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Applied', comment = 'ESP="Liquidado"';
        }

        field(50110; "Global Dimension 3 Code"; Code[20])
        {
            Editable = false;
            Caption = 'Detalle', comment = 'ESP="Detalle"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = filter('DETALLE')));
        }
        field(50111; "Global Dimension 8 Code"; Code[20])
        {
            Editable = false;
            Caption = 'Partida', comment = 'ESP="Partida"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = filter('PARTIDA')));
        }
        field(50112; "Customer Name"; text[100])
        {
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Source No.")));
            Editable = false;
        }
        field(50114; "Customer Country/Region Code"; code[10])
        {
            Caption = 'Customer Country/Region Code', comment = 'ESP="Cód Pais Cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Country/Region Code" where("No." = field("Source No.")));
            Editable = false;
        }
        field(50115; "Cust. Ledger Currency Factor"; Decimal)
        {
            Caption = 'Cust. Ledger Currency Factor', comment = 'ESP="Factor conversión mov. Cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Adjusted Currency Factor" where("Document Type" = field("Document Type"), "Document No." = field("Document No.")));
            Editable = false;
        }
        field(50120; "Purch. Request less 200"; code[20])
        {
            Caption = 'Purch. Request less 200', Comment = 'ESP="Compra menor 200"';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Requests less 200" where(Status = const(Approved), Invoiced = const(false));
        }
    }

    procedure ChangeDateforReverseEntry()
    var
        GLEntry: Record "G/L Entry";
        InputDate: page "ZM Input Date";
        ChangeDate: Date;
        lblConfirmChange: Label '¿Desea cambiar %1 movimientos de contabilidad a Fecha %2?', comment = 'ESP="¿Desea cambiar %1 movimientos de contabilidad a Fecha %2?"';
    begin
        // comprobamos que con ese numero de documento, no existan otros movimientos
        CheckDateforReverseEntry();
        InputDate.LookupMode := true;
        if InputDate.RunModal() = Action::LookupOK then begin
            ChangeDate := InputDate.GetFecha();
            if ChangeDate = 0D then
                exit;
            GLEntry.Reset();
            GLEntry.SetRange("Transaction No.", Rec."Transaction No.");
            if not Confirm(lblConfirmChange, false, GLEntry.Count, ChangeDate) then
                exit;
            GLEntry.ModifyAll("Original Date Reverse", Rec."Posting Date");
            GLEntry.ModifyAll("Posting Date", ChangeDate);
        end
    end;

    procedure CheckDateforReverseEntry()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        FAEntryEntry: Record "FA Ledger Entry";
        lblError: Label 'There are %1 with document number %2.', comment = 'ESP="Existen %1 con el numero de documento %2."';
    begin
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Document No.", Rec."Document No.");
        if CustLedgerEntry.FindFirst() then
            Error(lblError, CustLedgerEntry.TableCaption, Rec."Document No.");
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document No.", Rec."Document No.");
        if VendorLedgerEntry.FindFirst() then
            Error(lblError, VendorLedgerEntry.TableCaption, Rec."Document No.");
        BankAccountLedgerEntry.Reset();
        BankAccountLedgerEntry.SetRange("Document No.", Rec."Document No.");
        if BankAccountLedgerEntry.FindFirst() then
            Error(lblError, BankAccountLedgerEntry.TableCaption, Rec."Document No.");
        FAEntryEntry.Reset();
        FAEntryEntry.SetRange("Document No.", Rec."Document No.");
        if FAEntryEntry.FindFirst() then
            Error(lblError, FAEntryEntry.TableCaption, Rec."Document No.");
    end;

    procedure ReverseChangeDateforReverseEntry()
    var
        GLEntry: Record "G/L Entry";
    begin
        // "Original Date Reverse" guardaremos la fecha inicial del movimiento en este campo para despues devolverlo
        GLEntry.Reset();
        GLEntry.SetRange("Transaction No.", Rec."Transaction No.");
        if GLEntry.FindFirst() then
            repeat
                if GLEntry."Original Date Reverse" <> 0D then
                    if GLEntry."Posting Date" <> GLEntry."Original Date Reverse" then begin
                        GLEntry."Posting Date" := GLEntry."Original Date Reverse";
                        GLEntry.Modify();
                    end
            Until GLEntry.next() = 0;
    end;
}