table 17462 "ABERTIA GL Budget"
{
    Caption = 'ABERTIA GL Account';
    Description = 'ABERTIA - actualizacion datos G/L Account';
    ExternalName = 'tBIFinan_PresupuestoFinanzas';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {
        field(1; "Nombre"; text[100])
        {
            ExternalName = 'Nombre';
        }
        field(2; "Cuenta"; Decimal)
        {
            ExternalName = 'Cuenta';
        }
        field(3; "fecha"; Datetime)
        {
            ExternalName = 'fecha';
        }
        field(4; "Global Dimension 1 Code"; code[20])
        {
            ExternalName = 'Global Dimension 1 Code';
        }
        field(5; Amount; Decimal)
        {
            ExternalName = 'Amount';
        }
        field(6; "Año"; Integer)
        {
            ExternalName = 'Año';
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

    procedure CreateTableConnection()
    begin
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI',
            'Data Source=zummo.ddns.net;Initial Catalog=ReportingZummo;User ID=jvidal;Password=Bario5622$');
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;

    procedure CreateGLBudget()
    var
        GLBudget: Record "G/L Budget Name";
        GLBudgetEntry: Record "G/L Budget Entry";
        ABGLBudget: Record "ABERTIA GL Budget";
        Cuenta: Decimal;
        Window: Dialog;
    begin
        Window.Open('Presupuesto: #1####################\Nº Movimiento #2################');
        GLBudget.Reset();
        if GLBudget.FindFirst() then
            repeat
                Window.Update(1, GLBudget."Name");
                GLBudgetEntry.Reset();
                GLBudgetEntry.SetRange("Budget Name", GLBudget.Name);
                if GLBudgetEntry.FindFirst() then
                    repeat
                        Window.Update(2, GLBudgetEntry."Entry No.");
                        ABGLBudget.Reset();
                        Evaluate(Cuenta, GLBudgetEntry."G/L Account No.");
                        ABGLBudget.SetRange(Nombre, GLBudgetEntry."Budget Name");
                        ABGLBudget.SetRange(Cuenta, Cuenta);
                        ABGLBudget.SetRange(fecha, CreateDateTime(GLBudgetEntry.Date, 0T));
                        ABGLBudget.SetRange("Global Dimension 1 Code", GLBudgetEntry."Global Dimension 1 Code");
                        if not ABGLBudget.FindFirst() then begin
                            UpdateABGLBudgetEntry(GLBudgetEntry, ABGLBudget);
                        end;
                    Until GLBudgetEntry.next() = 0;
            Until GLBudget.next() = 0;
        Window.Close();

    end;

    local procedure UpdateABGLBudgetEntry(GLBudgetEntry: Record "G/L Budget Entry"; var ABGLBudget: Record "ABERTIA GL Budget")
    var
        vDec: Decimal;
        vInt: Integer;
    begin
        ABGLBudget.Init();
        ABGLBudget.ID := CreateGuid();
        Evaluate(vDec, GLBudgetEntry."G/L Account No.");
        ABGLBudget.Nombre := GLBudgetEntry."Budget Name";
        ABGLBudget.Cuenta := vDec;
        ABGLBudget.fecha := CreateDateTime(GLBudgetEntry.Date, 0T);
        ABGLBudget."Global Dimension 1 Code" := GLBudgetEntry."Global Dimension 1 Code";
        vint := Date2DMY(GLBudgetEntry.Date, 3);
        ABGLBudget."Año" := vInt;
        ABGLBudget.Amount := GetBudgetAmount(GLBudgetEntry);
        case CompanyName of
            'ZUMMO':
                ABGLBudget."00 - Origen" := 'ZIM';
            'INVESTMENTS':
                ABGLBudget."00 - Origen" := 'ZINV';
        end;
        ABGLBudget.Insert();
    end;

    local procedure GetBudgetAmount(GLBudgetEntry: Record "G/L Budget Entry"): Decimal
    var
        GLBudgetAmount: Record "G/L Budget Entry";
    begin
        GLBudgetAmount.Reset();
        GLBudgetAmount.SetRange("Budget Name", GLBudgetEntry."Budget Name");
        GLBudgetAmount.SetRange("G/L Account No.", GLBudgetEntry."G/L Account No.");
        GLBudgetAmount.SetRange(Date, GLBudgetEntry.Date);
        GLBudgetAmount.SetRange("Global Dimension 1 Code", GLBudgetEntry."Global Dimension 1 Code");
        GLBudgetAmount.CalcSums(Amount);
        exit(GLBudgetAmount.Amount);

    end;
}