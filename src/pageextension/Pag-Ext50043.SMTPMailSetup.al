pageextension 50043 "SMTPMailSetup" extends "SMTP Mail Setup"
{
    layout
    {
        addafter(Password)
        {
            field(UsuarioVencimientos; UsuarioVencimientos)
            {
                ApplicationArea = All;
            }

            field(passVencimientosTxt; passVencimientosTxt)
            {
                ApplicationArea = All;
                ExtendedDatatype = Masked;
                Caption = 'Statements Pass', comment = 'ESP="Contraseña Vencimientos"';

                trigger OnValidate()
                var
                    Funciones: Codeunit Funciones;
                    ServicePassword: Record "Service Password";
                begin
                    Funciones.SaveServicePassword(PassVencimientos, passVencimientosTxt);

                    // IF ISNULLGUID(PassVencimientos) OR NOT ServicePassword.GET(PassVencimientos) THEN BEGIN
                    //     ServicePassword.SavePassword(passVencimientosTxt);
                    //     ServicePassword.INSERT(TRUE);
                    //     PassVencimientos := ServicePassword.Key;
                    // END ELSE BEGIN
                    //     ServicePassword.SavePassword(passVencimientosTxt);
                    //     ServicePassword.MODIFY;
                    // END;

                    Commit();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UsuarioVencimientos <> '' then
            passVencimientosTxt := '***';
    end;

    var
        passVencimientosTxt: Text[250];
}