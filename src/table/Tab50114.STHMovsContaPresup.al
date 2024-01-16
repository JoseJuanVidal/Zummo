table 50114 "STH Movs Conta-Presup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "G/L Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº cuenta', comment = 'ESP="Nº cuenta"';

        }
        field(3; "Posting Date"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha registro', comment = 'ESP="Fecha registro"';
        }
        field(4; "Document No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº documento', comment = 'ESP="Nº documento"';
        }
        field(5; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripción', comment = 'ESP="Descripción"';
        }
        field(6; "Global Dimension 1 Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CECO', comment = 'ESP="CECO"';
        }
        field(7; "Global Dimension 2 Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PROYECTO', comment = 'ESP="PROYECTO"';
        }
        field(8; "Global Dimension 3 Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'DETALLE', comment = 'ESP="DETALLE"';
        }
        field(9; "Global Dimension 8 Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PARTIDA', comment = 'ESP="PARTIDA"';
        }
        field(10; "Importe"; decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Importe Presupuesto"; decimal)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Budget Name"; code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure CargarDatos(EjercicioActual: Boolean)
    var
        Contador: Integer;
        GLEntry: Record "G/L Entry";
        GLBudgetEntry: Record "G/L Budget Entry";
        Window: Dialog;
        lblWindow: Label 'Nª Movimiento: #1#########\Fecha: #2##############\';
    begin
        Window.Open(lblWindow);
        case EjercicioActual of
            true:
                begin
                    Rec.SetRange("Posting Date", CalcDate('-1A+PA+1D', WORKDATE), CalcDate('PA', WORKDATE));
                    Rec.DeleteAll();
                    Rec.Reset();
                    if Rec.FindLast() then
                        Contador := Rec."Entry No.";
                    GLEntry.SetRange("Posting Date", CalcDate('-1A+PA+1D', WORKDATE), CalcDate('PA', WORKDATE));
                    GLBudgetEntry.SetRange(Date, CalcDate('-1A+PA+1D', WORKDATE), CalcDate('PA', WORKDATE));
                end
            else begin
                Rec.DeleteAll();
            end;
        end;

        IF GLEntry.FINDSET THEN
            REPEAT
                Window.Update(1, GLEntry."Entry No.");
                Window.Update(2, GLEntry."Posting Date");
                Contador += 1;
                Rec.INIT;
                Rec."Entry No." := Contador;
                rec."Posting Date" := GLEntry."Posting Date";
                Rec."G/L Account No." := GLEntry."G/L Account No.";
                Rec."Document No." := GLEntry."Document No.";
                Rec.Description := GLEntry.Description;
                Rec."Global Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                Rec."Global Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                GLEntry.CalcFields("Global Dimension 3 Code");
                Rec."Global Dimension 3 Code" := GLEntry."Global Dimension 3 Code";
                GLEntry.CalcFields("Global Dimension 8 Code");
                Rec."Global Dimension 8 Code" := GLEntry."Global Dimension 8 Code";
                Rec.Importe := GLEntry.Amount;
                Rec.INSERT;
            UNTIL GLEntry.NEXT = 0;

        IF GLBudgetEntry.FINDSET THEN
            REPEAT
                Window.Update(1, GLBudgetEntry."Entry No.");
                Window.Update(2, GLBudgetEntry."Date");
                Contador += 1;
                Rec.INIT;
                Rec."Entry No." := Contador;
                Rec."G/L Account No." := GLBudgetEntry."G/L Account No.";
                REc."Posting Date" := GLBudgetEntry.Date;
                Rec."Document No." := '';
                Rec.Description := GLBudgetEntry.Description;
                Rec."Global Dimension 1 Code" := GLBudgetEntry."Global Dimension 1 Code";
                Rec."Global Dimension 2 Code" := GLBudgetEntry."Global Dimension 2 Code";
                Rec."Global Dimension 3 Code" := GLBudgetEntry."Budget Dimension 3 Code";
                Rec."Global Dimension 8 Code" := GLBudgetEntry."Budget Dimension 2 Code";
                Rec."Importe Presupuesto" := GLBudgetEntry.Amount;
                rec."Budget Name" := GLBudgetEntry."Budget Name";
                Rec.INSERT;
            UNTIL GLBudgetEntry.NEXT = 0;
        Window.Close;
    end;
}