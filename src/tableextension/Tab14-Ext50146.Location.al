tableextension 50146 "Location" extends Location  //14
{//14

    //Ordenación almacenes

    fields
    {
        field(50100; Ordenacion_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Ordination', comment = 'ESP="Ordenación"';
            BlankZero = true;
        }
        field(50101; RequiredShipinvoice; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Not allow "Ship and Invoice" without send complety', comment = 'ESP="No permitir "Enviar y Facturar" sin envio completo"';
            BlankZero = true;
        }
        field(50102; CalculoPlanificaion; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Planned Calculation', comment = 'ESP="Calcular en Planificación"';
        }
    }

    trigger OnModify()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then;
        IF (Code = 'MMPP') and not (UserSetup."Permite cambiar MMPP") then
            Error('User %1 no le esta permitido cambiar los datos de configuración de este almacen, hable con administrador de sistema', UserId);
    end;
}