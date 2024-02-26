codeunit 17410 "ZM PL Items Regist. aprovals"
{
    trigger OnRun()
    begin

    end;

    // =============     EVENTOS para la alta de productos          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================

    [EventSubscriber(ObjectType::Table, Database::"Purchase Price", 'OnBeforeModifyEvent', '', true, true)]
    local procedure T7012_PurchasePrice_OnBeforeModifyEvent(var Rec: Record "Purchase Price"; var xRec: Record "Purchase Price"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;
        T7012_PurchasePrice_OnEvent_CheckApproval();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Price", 'OnBeforeInsertEvent', '', true, true)]
    local procedure T7012_PurchasePrice_OnBeforeInsertEvent(var Rec: Record "Purchase Price"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;
        T7012_PurchasePrice_OnEvent_CheckApproval();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Price", 'OnBeforeDeleteEvent', '', true, true)]
    local procedure T7012_PurchasePrice_OnBeforeDeleteEvent(var Rec: Record "Purchase Price"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;
        T7012_PurchasePrice_OnEvent_CheckApproval();
    end;

    local procedure T7012_PurchasePrice_OnEvent_CheckApproval()
    var
        SetupItemregistration: Record "ZM PL Setup Item registration";
        lblError: Label 'It is not possible to modify the purchase prices. Purchase price approval is enabled.', comment = 'ESP="No se puede modificar los precios de compra. Esta activada la aprobación de precios de compra. "';
    begin
        if SetupItemregistration.Get() then
            if SetupItemregistration."Enabled Approval Price List" then
                Error(lblError);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Prices", 'OnBeforeActionEvent', 'CopyPrices', true, true)]
    local procedure PAGE_PurchasePrices_OnBeforeActionEvent()
    begin
        T7012_PurchasePrice_OnEvent_CheckApproval();
    end;

    // =============     FUNCIONES DE CONTROL          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================

    procedure CheckSUPERUserConfiguration()
    var
        User: Record User;
        AccessControl: Record "Access Control";
    begin
        User.SetRange("User Name", UserID);
        User.FindFirst();
        AccessControl.Reset();
        AccessControl.SetRange("User Security ID", User."User Security ID");
        AccessControl.SetRange("Role ID", 'D365 FULL ACCESS');
        if not AccessControl.FindFirst() then
            ERROR(StrSubstNo('El usuario %1 no tiene permisos para editar estos datos', UserID));
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