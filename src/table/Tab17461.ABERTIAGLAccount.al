table 17461 "ABERTIA GL Account"
{
    Caption = 'ABERTIA GL Account';
    Description = 'ABERTIA - actualizacion datos G/L Account';
    ExternalName = 'tBIFinan_Cuentas';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {


        field(1; "C7 - Cuenta1"; Integer)
        {
            ExternalName = 'C7 - Cuenta1';
        }
        field(2; "C7 - Cuenta2"; Integer)
        {
            ExternalName = 'C7 - Cuenta2';
        }
        field(3; "C7 - Cuenta3"; Integer)
        {
            ExternalName = 'C7 - Cuenta3';
        }
        field(4; "C7 - Cuenta4"; Integer)
        {
            ExternalName = 'C7 - Cuenta4';
        }
        field(5; "C8 - Cuenta Cod7"; Decimal)
        {
            ExternalName = 'C8 - Cuenta Cod7';
            DecimalPlaces = 0 : 0;
            AutoFormatType = 10;
            AutoFormatExpression = '<precision, 0:0><standard format,1>';
        }
        field(6; "DescCuenta1"; Text[100])
        {
            ExternalName = 'DescCuenta1';
        }
        field(7; "DescCuenta2"; Text[100])
        {
            ExternalName = 'DescCuenta2';
        }
        field(8; "DescCuenta3"; Text[100])
        {
            ExternalName = 'DescCuenta3';
        }
        field(9; "DescCuenta4"; Text[100])
        {
            ExternalName = 'DescCuenta4';
        }
        field(10; "DescCuenta7"; Text[100])
        {
            ExternalName = 'DescCuenta7';
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

    keys
    {
        key(pk; "C7 - Cuenta1", "C7 - Cuenta2", "C7 - Cuenta3", "C7 - Cuenta4", "C8 - Cuenta Cod7")
        {

        }
    }
    trigger OnInsert()
    begin
        if IsNullGuid(Rec.ID) then
            Rec.ID := CreateGuid();
    end;

    var
        GenLedgerSetup: Record "General Ledger Setup";

    procedure CreateTableConnection()
    begin
        GenLedgerSetup.Get();
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI', GenLedgerSetup.AbertiaTABLECONNECTION());

        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;

    procedure CreateGLAccount()
    var
        GLAccount: Record "G/L Account";
        ABGLAccount: Record "ABERTIA GL Account";
        Cuenta: Integer;
        Window: Dialog;
    begin
        Window.Open('Nº Cuenta #1################');
        GLAccount.Reset();
        // GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if GLAccount.FindFirst() then
            repeat
                Window.Update(1, GLAccount."No.");
                ABGLAccount.Reset();
                case CompanyName of
                    'ZUMMO':
                        ABGLAccount.SetRange("00 - Origen", 'ZIM');
                    'INVESTMENTS':
                        ABGLAccount.SetRange("00 - Origen", 'ZINV');
                    else
                        ABGLAccount.SetRange("00 - Origen", '');
                end;
                if StrLen(GLAccount."No.") >= 1 then begin
                    Evaluate(Cuenta, Copystr(GLAccount."No.", 1, 1));
                    ABGLAccount.SetRange("C7 - Cuenta1", Cuenta);
                end;
                if StrLen(GLAccount."No.") >= 2 then begin
                    Evaluate(Cuenta, Copystr(GLAccount."No.", 1, 2));
                    ABGLAccount.SetRange("C7 - Cuenta2", Cuenta);
                end else
                    ABGLAccount.SetRange("C7 - Cuenta2", 0);
                if StrLen(GLAccount."No.") >= 3 then begin
                    Evaluate(Cuenta, Copystr(GLAccount."No.", 1, 3));
                    ABGLAccount.SetRange("C7 - Cuenta3", Cuenta);
                end else
                    ABGLAccount.SetRange("C7 - Cuenta3", 0);
                if StrLen(GLAccount."No.") >= 4 then begin
                    Evaluate(Cuenta, Copystr(GLAccount."No.", 1, 4));
                    ABGLAccount.SetRange("C7 - Cuenta4", Cuenta);
                end else
                    ABGLAccount.SetRange("C7 - Cuenta4", 0);
                if StrLen(GLAccount."No.") >= 7 then begin
                    Evaluate(Cuenta, GLAccount."No.");
                    ABGLAccount.SetRange("C8 - Cuenta Cod7", Cuenta);
                end else
                    ABGLAccount.SetRange("C8 - Cuenta Cod7", 0);
                if not ABGLAccount.FindFirst() then begin
                    UpdateABGLAccount(GLAccount, ABGLAccount);
                end;
            Until GLAccount.next() = 0;
        Window.Close();

    end;

    local procedure UpdateABGLAccount(GLAccount: Record "G/L Account"; var ABGLAccount: Record "ABERTIA GL Account")
    var
        vInt: Integer;
        vDec: Decimal;
    begin
        ABGLAccount.Init();
        ABGLAccount.ID := CreateGuid();
        if Evaluate(vInt, Copystr(GLAccount."No.", 1, 1)) then
            ABGLAccount."C7 - Cuenta1" := vInt;
        if StrLen(GLAccount."No.") >= 2 then begin
            Evaluate(vInt, Copystr(GLAccount."No.", 1, 2));
            ABGLAccount."C7 - Cuenta2" := vInt;
        end;
        if StrLen(GLAccount."No.") >= 3 then begin
            Evaluate(vInt, Copystr(GLAccount."No.", 1, 3));
            ABGLAccount."C7 - Cuenta3" := vInt;
        end;
        if StrLen(GLAccount."No.") >= 4 then begin
            Evaluate(vInt, Copystr(GLAccount."No.", 1, 4));
            ABGLAccount."C7 - Cuenta4" := vInt;
        end;
        if StrLen(GLAccount."No.") >= 7 then begin
            Evaluate(vDec, GLAccount."No.");
            ABGLAccount."C8 - Cuenta Cod7" := vDec;
        end;
        if StrLen(GLAccount."No.") >= 1 then
            ABGLAccount.DescCuenta1 := GetDescAccountNo(GLAccount, 1);
        if StrLen(GLAccount."No.") >= 2 then
            ABGLAccount.DescCuenta2 := GetDescAccountNo(GLAccount, 2);
        if StrLen(GLAccount."No.") >= 3 then
            ABGLAccount.DescCuenta3 := GetDescAccountNo(GLAccount, 3);
        if StrLen(GLAccount."No.") >= 4 then
            ABGLAccount.DescCuenta4 := GetDescAccountNo(GLAccount, 4);
        if StrLen(GLAccount."No.") >= 7 then
            ABGLAccount.DescCuenta7 := GLAccount.Name;
        case CompanyName of
            'ZUMMO':
                ABGLAccount."00 - Origen" := 'ZIM';
            'INVESTMENTS':
                ABGLAccount."00 - Origen" := 'ZINV';
        end;
        ABGLAccount.Insert();
    end;

    local procedure GetDescAccountNo(GLAccount: Record "G/L Account"; NumCar: Integer): text
    var
        GLAccountHeading: Record "G/L Account";
    begin
        if GLAccountHeading.Get(Copystr(GLAccount."No.", 1, NumCar)) then
            exit(GLAccountHeading.Name)
    end;
}