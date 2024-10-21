table 17458 "ABERTIA GL Entry"
{
    Caption = 'ABERTIA GL Entry';
    Description = 'ABERTIA - Actualizacion datos G/L Entry';
    ExternalName = 'tBIFinan3Nav';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {

        field(1; "Entry No_"; BigInteger)
        {
            ExternalName = 'Entry No_';
        }
        field(3; "G_L Account No_"; Decimal)
        {
            ExternalName = 'G_L Account No_';
        }
        field(4; "Posting Date"; DateTime)
        {
            ExternalName = 'Posting Date';
        }
        field(5; "Document Type"; Integer)
        {
            ExternalName = 'Document Type';
        }
        field(6; "Document No_"; Code[20])
        {
            ExternalName = 'Document No_';
        }
        field(7; "Description"; text[100])
        {
            ExternalName = 'Description';
        }
        field(10; "Bal_ Account No_"; Code[20])
        {
            ExternalName = 'Bal_ Account No_';
        }
        field(17; "Amount"; Decimal)
        {
            ExternalName = 'Amount';
        }
        field(23; "Dimension 1 Code"; Code[20])
        {
            ExternalName = 'Global Dimension 1 Code';
        }
        field(24; "Dimension 2 Code"; Code[20])
        {
            ExternalName = 'Global Dimension 2 Code';
        }
        field(27; "User ID"; Code[50])
        {
            ExternalName = 'User ID';
        }
        field(28; "Source Code"; Code[10])
        {
            ExternalName = 'Source Code';
        }
        field(29; "System-Created Entry"; Integer)
        {
            ExternalName = 'System-Created Entry';
        }
        field(30; "Prior-Year Entry"; Integer)
        {
            ExternalName = 'Prior-Year Entry';
        }
        field(41; "Job No_"; Code[20])
        {
            ExternalName = 'Job No_';
        }
        field(42; "Quantity"; Decimal)
        {
            ExternalName = 'Quantity';
        }
        field(43; "VAT Amount"; Decimal)
        {
            ExternalName = 'VAT Amount';
        }
        field(45; "Business Unit Code"; Code[20])
        {
            ExternalName = 'Business Unit Code';
        }
        field(46; "Journal Batch Name"; Code[10])
        {
            ExternalName = 'Journal Batch Name';
        }
        field(47; "Reason Code"; Code[10])
        {
            ExternalName = 'Reason Code';
        }
        field(48; "Gen_ Posting Type"; Integer)
        {
            ExternalName = 'Gen_ Posting Type';
        }
        field(49; "Gen_ Bus_ Posting Group"; Code[20])
        {
            ExternalName = 'Gen_ Bus_ Posting Group';
        }
        field(50; "Gen_ Prod_ Posting Group"; Code[20])
        {
            ExternalName = 'Gen_ Prod_ Posting Group';
        }
        field(51; "Bal_ Account Type"; Integer)
        {
            ExternalName = 'Bal_ Account Type';
        }
        field(52; "Transaction No_"; Decimal)
        {
            ExternalName = 'Transaction No_';
            DecimalPlaces = 0 : 0;
        }
        field(53; "Debit Amount"; Decimal)
        {
            ExternalName = 'Debit Amount';
        }
        field(54; "Credit Amount"; Decimal)
        {
            ExternalName = 'Credit Amount';
        }
        field(55; "Document Date"; DateTime)
        {
            ExternalName = 'Document Date';
        }
        field(56; "External Document No_"; Code[35])
        {
            ExternalName = 'External Document No_';
        }
        field(57; "Source Type"; Integer)
        {
            ExternalName = 'Source Type';
        }
        field(58; "Source No_"; Code[20])
        {
            ExternalName = 'Source No_';
        }
        field(59; "No_ Series"; Code[20])
        {
            ExternalName = 'No_ Series';
        }
        field(60; "Tax Area Code"; Code[20])
        {
            ExternalName = 'Tax Area Code';
        }
        field(61; "Tax Liable"; Integer)
        {
            ExternalName = 'Tax Liable';
        }
        field(62; "Tax Group Code"; Code[20])
        {
            ExternalName = 'Tax Group Code';
        }
        field(63; "Use Tax"; Integer)
        {
            ExternalName = 'Use Tax';
        }
        field(64; "VAT Bus_ Posting Group"; Code[20])
        {
            ExternalName = 'VAT Bus_ Posting Group';
        }
        field(65; "VAT Prod_ Posting Group"; Code[20])
        {
            ExternalName = 'VAT Prod_ Posting Group';
        }
        field(68; "Additional-Currency Amount"; Decimal)
        {
            ExternalName = 'Additional-Currency Amount';
        }
        field(69; "Add_-Currency Debit Amount"; Decimal)
        {
            ExternalName = 'Add_-Currency Debit Amount';
        }
        field(70; "Add_-Currency Credit Amount"; Decimal)
        {
            ExternalName = 'Add_-Currency Credit Amount';
        }
        field(71; "Close Income Statement Dim_ ID"; Integer)
        {
            ExternalName = 'Close Income Statement Dim_ ID';
        }
        field(72; "IC Partner Code"; Code[20])
        {
            ExternalName = 'IC Partner Code';
        }
        field(73; "Reversed"; Integer)
        {
            ExternalName = 'Reversed';
        }
        field(74; "Reversed by Entry No_"; Integer)
        {
            ExternalName = 'Reversed by Entry No_';
        }
        field(75; "Reversed Entry No_"; Integer)
        {
            ExternalName = 'Reversed Entry No_';
        }
        field(480; "Dimension Set ID"; Decimal)
        {
            ExternalName = 'Dimension Set ID';
            DecimalPlaces = 0 : 0;
        }
        field(5400; "Prod_ Order No_"; Code[20])
        {
            ExternalName = 'Prod_ Order No_';
        }
        field(5600; "FA Entry Type"; Integer)
        {
            ExternalName = 'FA Entry Type';
        }
        field(5601; "FA Entry No_"; Integer)
        {
            ExternalName = 'FA Entry No_';
        }
        field(8005; "Last Modified DateTime"; DateTime)
        {
            ExternalName = 'Last Modified DateTime';
        }
        field(10720; "New G_L Account No_"; Code[20])
        {
            ExternalName = 'New G_L Account No_';
        }
        field(10721; "Old G_L Account No_"; Code[20])
        {
            ExternalName = 'Old G_L Account No_';
        }
        field(10722; "Updated"; Integer)
        {
            ExternalName = 'Updated';
        }
        field(10723; "Period Trans_ No_"; Integer)
        {
            ExternalName = 'Period Trans_ No_';
        }
        field(7000000; "Bill No_"; Integer)
        {
            ExternalName = 'Bill No_';
        }
        field(50998; "00 - Origen"; code[10])
        {
            ExternalName = '00 - Origen';
        }
        field(50999; ID; Guid)
        {
            Caption = 'ID';
            ExternalName = 'ID';
            ExternalType = 'Uniqueidentifier';
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid(Rec.ID) then
            Rec.ID := CreateGuid();
    end;

    var
        GenLedgerSetup: Record "General Ledger Setup";
        CUCron: Codeunit CU_Cron;

    procedure CreateTableConnection()
    begin
        GenLedgerSetup.Get();
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI', GenLedgerSetup.AbertiaTABLECONNECTION());
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;

    procedure CreateGLEntry(TypeUpdate: Option Periodo,Todo,Nuevo) RecordNo: Integer;
    var
        GLEntry: Record "G/L Entry";
        ABGLEntry: Record "ABERTIA GL Entry";
        Window: Dialog;
    begin
        Window.Open('Nº Movimiento contable #1################\Fecha #2################');
        GenLedgerSetup.Get();
        GLEntry.Reset();
        ABGLEntry.Reset();
        ABGLEntry.SetCurrentKey("00 - Origen", "Entry No_");
        case TypeUpdate of
            TypeUpdate::Nuevo:
                begin
                    case CompanyName of
                        'ZUMMO':
                            ABGLEntry.SetRange("00 - Origen", 'ZIM');
                        'INVESTMENTS':
                            ABGLEntry.SetRange("00 - Origen", 'ZINV');
                        else
                            ABGLEntry.SetRange("00 - Origen", '');
                    end;
                    if ABGLEntry.FindLast() then
                        GLEntry.SetRange("Entry No.", ABGLEntry."Entry No_");
                end;
            TypeUpdate::Periodo:
                begin
                    // buscamos el mes de fecha de trabajo y ponermos los filtros
                    GLEntry.SetRange("Posting Date", GenLedgerSetup."Allow Posting From", GenLedgerSetup."Allow Posting To");
                end;
            TypeUpdate::Todo:
                begin

                end;
        end;
        if GLEntry.FindSet() then
            repeat
                Window.Update(1, GLEntry."Entry No.");
                Window.Update(2, GLEntry."Posting Date");
                ABGLEntry.Reset();
                case CompanyName of
                    'ZUMMO':
                        ABGLEntry.SetRange("00 - Origen", 'ZIM');
                    'INVESTMENTS':
                        ABGLEntry.SetRange("00 - Origen", 'ZINV');
                    else
                        ABGLEntry.SetRange("00 - Origen", '');
                end;
                ABGLEntry.SetRange("Entry No_", GLEntry."Entry No.");
                if not ABGLEntry.FindFirst() then begin
                    if not UpdateABGLEntry(GLEntry, ABGLEntry) then
                        CUCron.ABERTIALOGUPDATE('GL Entry', GetLastErrorText());
                    RecordNo += 1;
                    Commit();
                end;
            Until GLEntry.next() = 0;
        CUCron.ABERTIALOGUPDATE('GL Entry', StrSubstNo('Entry: %1', RecordNo));
        Window.Close();

    end;

    [TryFunction]
    local procedure UpdateABGLEntry(GLEntry: Record "G/L Entry"; var ABGLEntry: Record "ABERTIA GL Entry")
    var
        vDec: Decimal;
        vInt: Integer;
    begin
        ABGLEntry.Init();
        ABGLEntry.ID := CreateGuid();
        ABGLEntry."Entry No_" := GLEntry."Entry No.";
        if Evaluate(vDec, GLEntry."G/L Account No.") then
            ABGLEntry."G_L Account No_" := vDec;
        ABGLEntry."Posting Date" := CreateDateTime(GLEntry."Posting Date", 0T);
        ABGLEntry."Document Type" := GLEntry."Document Type";
        ABGLEntry."Document No_" := GLEntry."Document No.";
        ABGLEntry."Description" := GLEntry.Description;
        ABGLEntry."Bal_ Account No_" := GLEntry."Bal. Account No.";
        ABGLEntry."Amount" := GLEntry.Amount;
        ABGLEntry."Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        ABGLEntry."Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        ABGLEntry."User ID" := GLEntry."User ID";
        ABGLEntry."Source Code" := GLEntry."Source Code";
        case GLEntry."System-Created Entry" of
            true:
                ABGLEntry."System-Created Entry" := 1;
            else
                ABGLEntry."System-Created Entry" := 0;
        end;
        case GLEntry."Prior-Year Entry" of
            true:
                ABGLEntry."Prior-Year Entry" := 1;
            else
                ABGLEntry."Prior-Year Entry" := 0;
        end;
        ABGLEntry."Job No_" := GLEntry."Job No.";
        ABGLEntry."Quantity" := GLEntry.Quantity;
        ABGLEntry."VAT Amount" := GLEntry."VAT Amount";
        ABGLEntry."Business Unit Code" := GLEntry."Business Unit Code";
        ABGLEntry."Journal Batch Name" := GLEntry."Journal Batch Name";
        ABGLEntry."Reason Code" := GLEntry."Reason Code";
        ABGLEntry."Gen_ Posting Type" := GLEntry."Gen. Posting Type";
        ABGLEntry."Gen_ Bus_ Posting Group" := GLEntry."Gen. Bus. Posting Group";
        ABGLEntry."Gen_ Prod_ Posting Group" := GLEntry."Gen. Prod. Posting Group";
        ABGLEntry."Bal_ Account Type" := GLEntry."Bal. Account Type";
        ABGLEntry."Transaction No_" := GLEntry."Transaction No.";
        ABGLEntry."Debit Amount" := GLEntry."Debit Amount";
        ABGLEntry."Credit Amount" := GLEntry."Credit Amount";
        ABGLEntry."Document Date" := CreateDateTime(GLEntry."Document Date", 0T);
        ABGLEntry."External Document No_" := GLEntry."External Document No.";
        ABGLEntry."Source Type" := GLEntry."Source Type";
        ABGLEntry."Source No_" := GLEntry."Source No.";
        ABGLEntry."No_ Series" := GLEntry."No. Series";
        ABGLEntry."Tax Area Code" := GLEntry."Tax Area Code";
        case GLEntry."Tax Liable" of
            true:
                ABGLEntry."Tax Liable" := 1;
            else
                ABGLEntry."Tax Liable" := 0;
        end;
        ABGLEntry."Tax Group Code" := GLEntry."Tax Group Code";
        case GLEntry."Use Tax" of
            true:
                ABGLEntry."Use Tax" := 1;
            else
                ABGLEntry."Use Tax" := 0;
        end;
        ABGLEntry."VAT Bus_ Posting Group" := GLEntry."VAT Bus. Posting Group";
        ABGLEntry."VAT Prod_ Posting Group" := GLEntry."VAT Prod. Posting Group";
        ABGLEntry."Additional-Currency Amount" := GLEntry."Additional-Currency Amount";
        ABGLEntry."Add_-Currency Debit Amount" := GLEntry."Add.-Currency Debit Amount";
        ABGLEntry."Add_-Currency Credit Amount" := GLEntry."Add.-Currency Credit Amount";
        ABGLEntry."Close Income Statement Dim_ ID" := GLEntry."Close Income Statement Dim. ID";
        ABGLEntry."IC Partner Code" := GLEntry."IC Partner Code";
        case GLEntry.Reversed of
            true:
                ABGLEntry."Reversed" := 1;
            else
                ABGLEntry."Reversed" := 0;
        end;
        ABGLEntry."Reversed by Entry No_" := GLEntry."Reversed by Entry No.";
        ABGLEntry."Reversed Entry No_" := GLEntry."Reversed Entry No.";
        ABGLEntry."Dimension Set ID" := GLEntry."Dimension Set ID";
        ABGLEntry."Prod_ Order No_" := GLEntry."Prod. Order No.";
        ABGLEntry."FA Entry Type" := GLEntry."FA Entry Type";
        ABGLEntry."FA Entry No_" := GLEntry."FA Entry No.";
        ABGLEntry."Last Modified DateTime" := GLEntry."Last Modified DateTime";
        // ABGLEntry."New G_L Account No_" := GLEntry.ne;
        // ABGLEntry."Old G_L Account No_" := GLEntry.old;
        // ABGLEntry."Updated" := GLEntry.up;
        ABGLEntry."Period Trans_ No_" := GLEntry."Period Trans. No.";
        if Evaluate(vInt, GLEntry."Bill No.") then
            ABGLEntry."Bill No_" := vInt;
        case CompanyName of
            'ZUMMO':
                ABGLEntry."00 - Origen" := 'ZIM';
            'INVESTMENTS':
                ABGLEntry."00 - Origen" := 'ZINV';
        end;
        ABGLEntry.Insert();
    end;
}