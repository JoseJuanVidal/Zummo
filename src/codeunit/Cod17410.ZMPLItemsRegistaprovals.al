
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

    procedure SendApprovalItemPurchasePrices(Item: record Item)
    var
        ItemPurchasePrices: record "ZM PL Item Purchase Prices";
    begin
        ItemPurchasePrices.Reset();
        ItemPurchasePrices.SetRange("Item No.", Item."No.");
        ItemPurchasePrices.SetRange("Status Approval", ItemPurchasePrices."Status Approval"::Pending);
        if SendEmaiApprobalItemPurchasePrices(Item, ItemPurchasePrices) then
            if ItemPurchasePrices.FindFirst() then
                repeat
                    ItemPurchasePrices."Date Send Approval" := WorkDate();
                    ItemPurchasePrices.Modify();
                Until ItemPurchasePrices.next() = 0;
    end;

    procedure SendEmaiApprobalItemPurchasePrices(Item: Record Item; var ItemPurchasePrices: record "ZM PL Item Purchase Prices"): Boolean
    var
        UserSetup: Record "User Setup";
        ItemSetupApproval: Record "ZM PL Item Setup Approval";
        ItemSetupDepartment: Record "ZM PL Item Setup Department";
        Employee: Record Employee;
        recSMTPSetup: Record "SMTP Mail Setup";
        cduSmtp: Codeunit "SMTP Mail";
        Destino: Text;
        body: text;
        FileName: text;
        Solitante: Text;
        filePathPurchaseHeader: text;
        lblSinDestino: Label 'There are no users configured for approval %1.', comment = 'ESP="No existen usuarios configurados para aprobación %1."';
    begin
        // EnviaEmail(txtAsunto, txtCuerpo, recEmployee."Company E-Mail", recPurchaseHeader, recTemp."Item No.");
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", Database::"Purchase Price");
        ItemSetupApproval.SetRange("Field No.", 0);  // permisos a la tabla para aprobación
        if ItemSetupApproval.FindFirst() then
            repeat
                if ItemSetupDepartment.Get(ItemSetupApproval.Department) then begin
                    AddEmail(Destino, ItemSetupDepartment.Email);
                    Employee.Reset();
                    Employee.SetRange("Approval User Id", ItemSetupDepartment."User Id");
                    if Employee.FindFirst() then
                        repeat
                            AddEmail(Destino, Employee."Company E-Mail");
                        Until Employee.next() = 0;
                end;
            Until ItemSetupApproval.next() = 0;

        if Destino = '' then
            Error(lblSinDestino, Database::"Purchase Price");
        recSMTPSetup.Get();
        recSMTPSetup.TestField("SMTP Server");
        recSMTPSetup.TestField("User ID");
        Clear(cduSmtp);
        body := EmailItemPruchasePricesBody(Item, ItemPurchasePrices);
        cduSmtp.CreateMessage(CompanyName(), recSMTPSetup."User ID", Destino, StrSubstNo('Solicitud aprobación precios Producto %1 %2', Item."No.", Item.Description), body, TRUE); //pDireccion, pAsunto, pCuerpo, TRUE);
        // filePathPurchaseHeader := GetDocAttachment(PurchLinesRequest."Document No.", FileName);
        // if filePathPurchaseHeader <> '' then
        //     if Exists(filePathPurchaseHeader) then
        //         cduSmtp.AddAttachment(filePathPurchaseHeader, FileName);
        cduSmtp.Send();
        exit(true);
    end;

    local procedure AddEmail(var Solitante: text; email: Text)
    var
        myInt: Integer;
    begin
        if email = '' then
            exit;
        if Solitante <> '' then
            Solitante += ';';
        Solitante += email;
    end;

    local procedure EmailItemPruchasePricesBody(Item: Record Item; var ItemPurchasePrices: record "ZM PL Item Purchase Prices") Body: Text
    var
        Companyinfo: Record "Company Information";
        Vendor: Record Vendor;
        Color: text;
    begin
        Companyinfo.Get();
        Body := '<p>&nbsp;</p>';
        Body += '<h1 style="color: #5e9ca0;">' + Companyinfo.Name + '</h1>';
        Body += '<h2 style="color: #2e6c80;">Solicitud aprobación precios Producto</h2>';
        Body += '<p><strong>Cód. producto:</strong> ' + Item."No." + '</p>';
        Body += '<p><strong>Descripción</strong> ' + Item.Description + '</p>';
        Body += '<p><strong>Fecha:</strong> ' + format(WorkDate()) + '</p>';
        // Body += '<p><strong>Solicitante</strong>:&nbsp; &nbsp; &nbsp; ' + Solitante;
        Body += '<h2 style="color: #2e6c80;">L&iacute;neas:</h2>';
        Body += '<table class="editorDemoTable" style="width: 980px; height: 18px;">';
        Body += '<thead>';
        Body += '<tr style="height: 15px;">';
        Body += '<td style="width: 115.141px; height: 18px;"><strong>Proveedor</strong></td>';
        Body += '<td style="width: 277.078px; height: 18px;"><strong>Nombre</strong></td>';
        Body += '<td style="width: 80.75px; height: 18px;"><strong>C&oacute;d. Divisa</strong></td>';
        Body += '<td style="width: 57.25px; height: 18px;"><strong>Fecha Inicial</strong></td>';
        Body += '<td style="width: 57.25px; height: 18px;"><strong>Cantidad M&iacute;nima</strong></td>';
        Body += '<td style="width: 43.9688px; height: 18px;"><strong>Coste Unit. Directo</strong>.&nbsp;</td>';
        Body += '<td style="width: 43.9688px; height: 18px;"><strong>Fecha Final</strong>.&nbsp;</td>';
        Body += '<td style="width: 64.8125px; height: 18px;"><strong>C&oacute;d. Unidad</strong></td>';
        Body += '</tr>';
        Body += '</thead>';
        Body += '<tbody>';

        if ItemPurchasePrices.findset() then
            repeat
                // if PurchLinesRequest."Line Amount" = PurchLinesRequest."New Line Amount" then
                //     Color := '#000000'
                // else
                //     Color := '#ff0000';
                Vendor.Get(ItemPurchasePrices."Vendor No.");
                Body += '<tr style="height: 20px;">';
                Body += '<td style="color:' + Color + ';width: 115.141px; height: 10px;"><p>' + ItemPurchasePrices."Vendor No." + '</p></td>';
                Body += '<td style="color:' + Color + ';width: 277.078px; height: 10px;">' + Vendor.Name + '</td>';
                Body += '<td style="width: 80.75px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Currency Code") + '</td>';
                Body += '<td style="width: 57.25px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Starting Date") + '</td>';
                Body += '<td style="width: 43.9688px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Direct Unit Cost") + ' &euro;</td>';
                Body += '<td style="width: 43.9688px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Minimum Quantity") + '</td>';
                Body += '<td style="width: 64.8125px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Ending Date") + '</td>';
                Body += '<td style="width: 64.8125px; height: 10px;text-align: right;">' + ItemPurchasePrices."Unit of Measure Code" + '</td>';

            Until ItemPurchasePrices.next() = 0;
        Body += '</tbody>';
        Body += '</table>';
        Body += '<p><strong>&nbsp;</strong></p>';

    end;


}