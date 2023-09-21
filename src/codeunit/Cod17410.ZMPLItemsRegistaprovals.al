codeunit 17410 "ZM PL Items Regist. aprovals"
{
    trigger OnRun()
    begin

    end;

    procedure ItemRegistrationChangeState(Rec: Record "ZM PL Items temporary")
    var
        myInt: Integer;
    begin
        // cambiar los estados de la peticion de alta de producto y 

        Message('enviada la Alta de Producto');
    end;

    procedure ItemRegistratio_OpenRequested(var Rec: Record "ZM PL Items temporary"): Boolean
    var
        lblConfirm: Label '¿Do you want to open the discharge request for item %1 %2?', comment = 'ESP="¿Desea Abrir la petición de alta del producto %1 %2?"';
    begin
        if not Confirm(lblConfirm, true, Rec."No.", Rec.Description) then
            exit;

        Rec."State Creation" := Rec."State Creation"::" ";
        Rec.Modify();
        exit(true);
    end;

}