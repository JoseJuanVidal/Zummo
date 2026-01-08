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
        T7012_PurchasePrice_OnEvent_CheckApproval(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Price", 'OnBeforeInsertEvent', '', true, true)]
    local procedure T7012_PurchasePrice_OnBeforeInsertEvent(var Rec: Record "Purchase Price"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;
        T7012_PurchasePrice_OnEvent_CheckApproval(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Price", 'OnBeforeDeleteEvent', '', true, true)]
    local procedure T7012_PurchasePrice_OnBeforeDeleteEvent(var Rec: Record "Purchase Price"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;
        T7012_PurchasePrice_OnEvent_CheckApproval(Rec);
    end;

    local procedure T7012_PurchasePrice_OnEvent_CheckApproval(var Rec: Record "Purchase Price")
    var
        SetupItemregistration: Record "ZM PL Setup Item registration";
        lblError: Label 'It is not possible to modify the purchase prices. Purchase price approval is enabled.\You must create an Request.',
            comment = 'ESP="No se puede modificar los precios de compra. Esta activada la aprobación de precios de compra.\Debe realizar una solicitud."';
    begin
        if Rec.Approval then begin
            Rec.Approval := false;
            exit;
        end;
        if SetupItemregistration.Get() then
            if SetupItemregistration."Enabled Approval Price List" then
                Error(lblError);

    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Prices", 'OnBeforeActionEvent', 'CopyPrices', true, true)]
    local procedure PAGE_PurchasePrices_OnBeforeActionEvent(var Rec: Record "Purchase Price")
    begin
        T7012_PurchasePrice_OnEvent_CheckApproval(Rec);
    end;

    // =============     FUNCIONES DE CONTROL          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================

    procedure CheckSUPERUserConfiguration(ShowError: Boolean): Boolean
    var
        User: Record User;
        AccessControl: Record "Access Control";
    begin
        User.SetRange("User Name", UserID);
        User.FindFirst();
        AccessControl.Reset();
        AccessControl.SetRange("User Security ID", User."User Security ID");
        AccessControl.SetRange("Role ID", 'D365 FULL ACCESS');
        AccessControl.SetFilter("Company Name", '%1|%2', '', CompanyName);
        if not AccessControl.FindFirst() then begin
            if ShowError then
                ERROR(StrSubstNo('El usuario %1 no tiene permisos para editar estos datos', UserID));
            exit(false);
        end;
        exit(true);
    end;

    procedure CheckUserItemPurchasePriceApproval(): Boolean
    var
        SetupItemregistration: Record "ZM PL Setup Item registration";
        ItemSetupApproval: Record "ZM PL Item Setup Approval";
        ItemSetupDepartment: Record "ZM PL Item Setup Department";
    begin
        if SetupItemregistration.Get() then
            if not SetupItemregistration."Enabled Approval Price List" then
                exit(false);
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", Database::"Purchase Price");
        ItemSetupApproval.SetRange("Field No.", 0);  // permisos a la tabla para aprobación
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Approval, ItemSetupApproval.Rol::Both);
        if ItemSetupApproval.FindFirst() then
            repeat
                if ItemSetupDepartment.Get(ItemSetupApproval.Department) then begin
                    if ItemSetupDepartment."User Id" = UserId then
                        exit(true);
                end;
            Until ItemSetupApproval.next() = 0;
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
                    ItemPurchasePrices."Status Approval" := ItemPurchasePrices."Status Approval"::Pending;
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
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Approval, ItemSetupApproval.Rol::Both);
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
        Body += '<td style="width: 64.8125px; height: 18px;"><strong>C&oacute;d. Unidad Medida</strong></td>';
        Body += '<td style="width: 64.8125px; height: 18px;"><strong>Acci&oacute;n</strong></td>';
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
                Body += '<td style="width: 43.9688px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Minimum Quantity") + '</td>';
                Body += '<td style="width: 43.9688px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Direct Unit Cost") + ' &euro;</td>';
                Body += '<td style="width: 64.8125px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Ending Date") + '</td>';
                Body += '<td style="width: 64.8125px; height: 10px;text-align: right;">' + ItemPurchasePrices."Unit of Measure Code" + '</td>';
                Body += '<td style="width: 64.8125px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Action Approval") + '</td>';
            Until ItemPurchasePrices.next() = 0;
        Body += '</tbody>';
        Body += '</table>';
        Body += '<p><strong>&nbsp;</strong></p>';

    end;

    procedure RequestEmaiApprobalItemPurchasePrices(Item: Record Item; var ItemPurchasePrices: record "ZM PL Item Purchase Prices")
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
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Owner, ItemSetupApproval.Rol::Both);
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
        body := RequestEmailItemPruchasePricesBody(ItemPurchasePrices);
        cduSmtp.CreateMessage(CompanyName(), recSMTPSetup."User ID", Destino, StrSubstNo('Cambios de precios Producto %1 %2', Item."No.", Item.Description), body, TRUE); //pDireccion, pAsunto, pCuerpo, TRUE);
        // filePathPurchaseHeader := GetDocAttachment(PurchLinesRequest."Document No.", FileName);
        // if filePathPurchaseHeader <> '' then
        //     if Exists(filePathPurchaseHeader) then
        //         cduSmtp.AddAttachment(filePathPurchaseHeader, FileName);
        cduSmtp.Send();

    end;

    local procedure RequestEmailItemPruchasePricesBody(var ItemPurchasePrices: record "ZM PL Item Purchase Prices") Body: Text
    var
        Companyinfo: Record "Company Information";
        Item: Record Item;
        Vendor: Record Vendor;
        Color: text;
    begin
        Companyinfo.Get();
        ItemPurchasePrices.FindFirst();
        Item.Get(ItemPurchasePrices."Item No.");
        Body := '<p>&nbsp;</p>';
        Body += '<h1 style="color: #5e9ca0;">' + Companyinfo.Name + '</h1>';
        Body += '<h2 style="color: #2e6c80;">Cambios de precios Producto</h2>';
        Body += '<p><strong>Cód. producto:</strong> ' + ItemPurchasePrices."Item No." + '</p>';
        Body += '<p><strong>Descripción</strong> ' + Item.Description + '</p>';
        Body += '<p><strong>Fecha:</strong> ' + format(WorkDate()) + '</p>';
        // Body += '<p><strong>Solicitante</strong>:&nbsp; &nbsp; &nbsp; ' + Solitante;
        Body += '<h2 style="color: #2e6c80;">L&iacute;neas:</h2>';
        Body += '<table class="editorDemoTable" style="width: 980px; height: 18px;">';
        Body += '<thead>';
        Body += '<tr style="height: 15px;">';
        Body += '<td style="width: 115.141px; height: 18px;"><strong>Proveedor</strong></td>';
        Body += '<td style="width: 277.078px; height: 18px;"><strong>Nombre</strong></td>';
        Body += '<td style="width: 80.75px; height: 18px;text-align: right;"><strong>C&oacute;d. Divisa</strong></td>';
        Body += '<td style="width: 57.25px; height: 18px;text-align: right;"><strong>Fecha Inicial</strong></td>';
        Body += '<td style="width: 57.25px; height: 18px;text-align: right;"><strong>Cantidad M&iacute;nima</strong></td>';
        Body += '<td style="width: 43.9688px; height: 18pxtext-align: right;;"><strong>Coste Unit. Directo</strong>.&nbsp;</td>';
        Body += '<td style="width: 43.9688px; height: 18px;text-align: right;"><strong>Fecha Final</strong>.&nbsp;</td>';
        Body += '<td style="width: 64.8125px; height: 18px;text-align: right;"><strong>C&oacute;d. Unidad Medida</strong></td>';
        Body += '<td style="width: 64.8125px; height: 18px;text-align: right;"><strong>Acci&oacute;n</strong></td>';
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
                Body += '<td style="width: 43.9688px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Minimum Quantity") + '</td>';
                Body += '<td style="width: 43.9688px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Direct Unit Cost") + ' &euro;</td>';
                Body += '<td style="width: 64.8125px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Ending Date") + '</td>';
                Body += '<td style="width: 64.8125px; height: 10px;text-align: right;">' + ItemPurchasePrices."Unit of Measure Code" + '</td>';
                Body += '<td style="width: 64.8125px; height: 10px;text-align: right;">' + format(ItemPurchasePrices."Action Approval") + '</td>';
            Until ItemPurchasePrices.next() = 0;
        Body += '</tbody>';
        Body += '</table>';
        Body += '<p><strong>&nbsp;</strong></p>';

    end;

    procedure ItemPurchasePricesApproval(var ItemPurchasePrices: record "ZM PL Item Purchase Prices"; Approve: Boolean)
    var
        PurchasesPrice: Record "Purchase Price";
    begin
        case ItemPurchasePrices."Action Approval" of
            ItemPurchasePrices."Action Approval"::Delete:
                begin
                    if PurchasesPrice.Get(ItemPurchasePrices."Item No.", ItemPurchasePrices."Vendor No.", ItemPurchasePrices."Starting Date",
                            ItemPurchasePrices."Currency Code", ItemPurchasePrices."Variant Code", ItemPurchasePrices."Unit of Measure Code",
                            ItemPurchasePrices."Minimum Quantity") then begin
                        ItemPurchasePrices."Status Approval" := ItemPurchasePrices."Status Approval"::Approved;
                        PurchasesPrice.Approval := true;
                        PurchasesPrice.Delete(false);
                    end;
                end;
            else begin
                PurchasesPrice.Reset();
                if not PurchasesPrice.Get(ItemPurchasePrices."Item No.", ItemPurchasePrices."Vendor No.", ItemPurchasePrices."Starting Date",
                        ItemPurchasePrices."Currency Code", ItemPurchasePrices."Variant Code", ItemPurchasePrices."Unit of Measure Code",
                        ItemPurchasePrices."Minimum Quantity") then begin
                    PurchasesPrice.Init();
                    PurchasesPrice."Item No." := ItemPurchasePrices."Item No.";
                    PurchasesPrice."Vendor No." := ItemPurchasePrices."Vendor No.";
                    PurchasesPrice."Starting Date" := ItemPurchasePrices."Starting Date";
                    PurchasesPrice."Currency Code" := ItemPurchasePrices."Currency Code";
                    PurchasesPrice."Variant Code" := ItemPurchasePrices."Variant Code";
                    PurchasesPrice."Unit of Measure Code" := ItemPurchasePrices."Unit of Measure Code";
                    PurchasesPrice."Minimum Quantity" := ItemPurchasePrices."Minimum Quantity";
                    PurchasesPrice."Direct Unit Cost" := ItemPurchasePrices."Direct Unit Cost";
                    PurchasesPrice.Approval := true;
                    PurchasesPrice.Insert(false);
                end;
                PurchasesPrice.Approval := true;
                PurchasesPrice."Direct Unit Cost" := ItemPurchasePrices."Direct Unit Cost";
                PurchasesPrice."Ending Date" := ItemPurchasePrices."Ending Date";
                PurchasesPrice.Modify(false);
            end;
        end;
        // ponemos el estado 
        case Approve of
            true:
                ItemPurchasePrices."Status Approval" := ItemPurchasePrices."Status Approval"::Approved;
            else
                ItemPurchasePrices."Status Approval" := ItemPurchasePrices."Status Approval"::Reject;
        end;
        ItemPurchasePrices.Modify();
    end;

    procedure GetRequestDeleteSelection(ItemNo: code[20])
    var
        PurchasePrice: Record "Purchase Price";
        ItemPurchasePrices: Record "ZM PL Item Purchase Prices";
        GetPurchasePrices: page "Get Purchase Price";
    begin
        PurchasePrice.SetRange("Item No.", ItemNo);
        GetPurchasePrices.SetTableView(PurchasePrice);
        GetPurchasePrices.LookupMode(true);
        if GetPurchasePrices.RunModal() = action::LookupOK then begin
            GetPurchasePrices.SetSelectionFilter(PurchasePrice);
            if PurchasePrice.FindFirst() then
                repeat
                    ItemPurchasePrices.Reset();
                    ItemPurchasePrices.SetRange("Item No.", PurchasePrice."Item No.");
                    ItemPurchasePrices.SetRange("Vendor No.", PurchasePrice."Vendor No.");
                    ItemPurchasePrices.SetRange("Starting Date", PurchasePrice."Starting Date");
                    ItemPurchasePrices.SetRange("Currency Code", PurchasePrice."Currency Code");
                    ItemPurchasePrices.SetRange("Variant Code", PurchasePrice."Variant Code");
                    ItemPurchasePrices.SetRange("Unit of Measure Code", PurchasePrice."Unit of Measure Code");
                    ItemPurchasePrices.SetRange("Minimum Quantity", PurchasePrice."Minimum Quantity");
                    ItemPurchasePrices.SetRange("Status Approval", ItemPurchasePrices."Status Approval"::Pending);
                    if not ItemPurchasePrices.FindFirst() then begin
                        ItemPurchasePrices.Reset();
                        ItemPurchasePrices.Init();
                        ItemPurchasePrices."Record ID" := CreateGuid();
                        ItemPurchasePrices."Item No." := PurchasePrice."Item No.";
                        ItemPurchasePrices."Vendor No." := PurchasePrice."Vendor No.";
                        ItemPurchasePrices."Starting Date" := PurchasePrice."Starting Date";
                        ItemPurchasePrices."Currency Code" := PurchasePrice."Currency Code";
                        ItemPurchasePrices."Variant Code" := PurchasePrice."Variant Code";
                        ItemPurchasePrices."Unit of Measure Code" := PurchasePrice."Unit of Measure Code";
                        ItemPurchasePrices."Minimum Quantity" := PurchasePrice."Minimum Quantity";
                        ItemPurchasePrices."Direct Unit Cost" := PurchasePrice."Direct Unit Cost";
                        ItemPurchasePrices."Ending Date" := PurchasePrice."Ending Date";
                        ItemPurchasePrices."Action Approval" := ItemPurchasePrices."Action Approval"::Delete;
                        ItemPurchasePrices."Date/Time Creation" := CreateDateTime(Today(), Time());
                        ItemPurchasePrices.Insert()
                    end else begin
                        ItemPurchasePrices."Direct Unit Cost" := PurchasePrice."Direct Unit Cost";
                        ItemPurchasePrices."Ending Date" := PurchasePrice."Ending Date";
                        ItemPurchasePrices."Action Approval" := ItemPurchasePrices."Action Approval"::Delete;
                        if ItemPurchasePrices."Date/Time Creation" = 0DT then
                            ItemPurchasePrices."Date/Time Creation" := CreateDateTime(Today(), Time());
                        ItemPurchasePrices.Modify();
                    end;
                Until PurchasePrice.next() = 0;
        end
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure EventSubscriber_Item_OnAfterValidateEventNo(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        EventSubscriber_Item_OnAfterValidateEvent(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Description', true, true)]
    local procedure EventSubscriber_Item_OnAfterValidateEventDescription(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        EventSubscriber_Item_OnAfterValidateEvent(Rec, xRec, CurrFieldNo);
    end;

    local procedure EventSubscriber_Item_OnAfterValidateEvent(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        SetupPreItemReg: record "ZM PL Setup Item registration";
    begin
        case CurrFieldNo of
            Rec.FieldNo(Rec."No."):
                begin
                    SetupPreItemReg.CheckMaxLengthItemNo(Rec."No.");
                end;
            Rec.FieldNo(Rec.Description):
                begin
                    SetupPreItemReg.CheckMaxLengthItemDescription(Rec.Description);
                end;
        end;
    end;


    // =============     cambios de valores en los campos          ====================
    // ==  
    // ==   
    // ==  
    // ======================================================================================================


    procedure LogInsertion(var ItemTemporary: Record "ZM PL Items Temporary")
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        i: Integer;
    begin
        if not (ItemTemporary."Request Type" in [ItemTemporary."Request Type"::Change]) then
            exit;
        RecRef.GetTable(ItemTemporary);
        IF RecRef.ISTEMPORARY THEN
            EXIT;

        FOR i := 1 TO RecRef.FIELDCOUNT DO BEGIN
            FldRef := RecRef.FIELDINDEX(i);
            IF HasValue(FldRef) THEN
                IF IsNormalField(FldRef) THEN
                    IF ItemTemporary_IsLogActive(RecRef.NUMBER, FldRef.NUMBER) THEN
                        InsertLogEntry(FldRef, FldRef, RecRef, true);
        END;
    end;

    procedure LogModification(var ItemTemporary: Record "ZM PL Items Temporary"; fieldNumber: integer)
    var
        RecRef: RecordRef;
        xRecRef: RecordRef;
        FldRef: FieldRef;
        xFldRef: FieldRef;
        i: Integer;
        Number: Integer;

    begin
        if not (ItemTemporary."Request Type" in [ItemTemporary."Request Type"::Change]) then
            exit;
        RecRef.GetTable(ItemTemporary);
        IF RecRef.ISTEMPORARY THEN
            EXIT;
        xRecRef.OPEN(RecRef.NUMBER);
        xRecRef."SECURITYFILTERING" := SECURITYFILTER::Filtered;
        IF xRecRef.READPERMISSION THEN
            IF NOT xRecRef.GET(RecRef.RECORDID) THEN;
        number := RecRef.FieldCount;
        //        FOR i := 1 TO RecRef.FIELDCOUNT DO BEGIN
        // FldRef := RecRef.FIELDINDEX(i);
        // xFldRef := xRecRef.FIELDINDEX(i);
        FldRef := RecRef.FIELD(fieldNumber);
        xFldRef := xRecRef.FIELD(fieldNumber);
        if HasValue(FldRef) or HasValue(xFldRef) then begin
            IF IsNormalField(FldRef) THEN
                if FldRef.Value <> xFldRef.Value then
                    IF ItemTemporary_IsLogActive(RecRef.NUMBER, FldRef.NUMBER) THEN
                        InsertLogEntry(FldRef, xFldRef, RecRef, false);
        end;
        //      END;

    end;

    local procedure IsNormalField(FieldRef: FieldRef): Boolean
    begin
        EXIT(FORMAT(FieldRef.CLASS) = 'Normal')
    end;

    local procedure HasValue(FldRef: FieldRef): Boolean
    var
        Field: Record Field;
        HasValue: Boolean;
        Int: Integer;
        Dec: Decimal;
        D: Date;
        T: Time;
    begin
        EVALUATE(Field.Type, FORMAT(FldRef.TYPE));

        CASE Field.Type OF
            Field.Type::Boolean:
                HasValue := FldRef.VALUE;
            Field.Type::Option:
                HasValue := TRUE;
            Field.Type::Integer:
                BEGIN
                    Int := FldRef.VALUE;
                    HasValue := Int <> 0;
                END;
            Field.Type::Decimal:
                BEGIN
                    Dec := FldRef.VALUE;
                    HasValue := Dec <> 0;
                END;
            Field.Type::Date:
                BEGIN
                    D := FldRef.VALUE;
                    HasValue := D <> 0D;
                END;
            Field.Type::Time:
                BEGIN
                    T := FldRef.VALUE;
                    HasValue := T <> 0T;
                END;
            Field.Type::BLOB:
                HasValue := FALSE;
            ELSE
                HasValue := FORMAT(FldRef.VALUE) <> '';
        END;

        EXIT(HasValue);
    end;

    local procedure ItemTemporary_IsLogActive(TableNumber: Integer; FieldNumber: Integer): Boolean
    var
        myInt: Integer;
    begin
        case TableNumber of
            database::"ZM PL Items Temporary":
                begin
                    exit(true);
                end;

        end;
    end;

    local procedure InsertLogEntry(VAR FldRef: FieldRef; VAR xFldRef: FieldRef; VAR RecRef: RecordRef; New: Boolean)
    //'Insertion,Modification,Deletion'
    var
        ChangeLogEntry: Record "Change Log Entry";
        KeyFldRef: FieldRef;
        KeyRef1: KeyRef;
        i: Integer;
    begin
        IF RecRef.CURRENTCOMPANY <> ChangeLogEntry.CURRENTCOMPANY THEN
            ChangeLogEntry.CHANGECOMPANY(RecRef.CURRENTCOMPANY);
        // primero comprobamos si ya existe y modificamos valores
        // User if , recref 
        ChangeLogEntry.SetRange("Record ID", RecRef.RecordId);
        ChangeLogEntry.SetRange("User ID", UserId);
        ChangeLogEntry.SetRange("Table No.", RecRef.Number);
        ChangeLogEntry.SetRange("Field No.", FldRef.Number);
        if not ChangeLogEntry.FindFirst() then begin
            ChangeLogEntry.Reset();
            ChangeLogEntry.INIT;
            ChangeLogEntry."Date and Time" := CURRENTDATETIME;
            ChangeLogEntry.Time := DT2TIME(ChangeLogEntry."Date and Time");

            ChangeLogEntry."User ID" := USERID;
            ChangeLogEntry."Table No." := RecRef.NUMBER;
            ChangeLogEntry."Field No." := FldRef.NUMBER;
            case New of
                true:
                    begin
                        ChangeLogEntry."Type of Change" := ChangeLogEntry."Type of Change"::Insertion;
                        ChangeLogEntry."Old Value" := '';
                    end;
                else begin
                    ChangeLogEntry."Type of Change" := ChangeLogEntry."Type of Change"::Modification;
                    ChangeLogEntry."Old Value" := FORMAT(xFldRef.VALUE, 0, 9);
                end;
            END;
            ChangeLogEntry.Insert();
        end;
        ChangeLogEntry."New Value" := FORMAT(FldRef.VALUE, 0, 9);
        ChangeLogEntry."Record ID" := RecRef.RECORDID;
        ChangeLogEntry."Primary Key" := COPYSTR(RecRef.GETPOSITION(FALSE), 1, MAXSTRLEN(ChangeLogEntry."Primary Key"));

        KeyRef1 := RecRef.KEYINDEX(1);
        FOR i := 1 TO KeyRef1.FIELDCOUNT DO BEGIN
            KeyFldRef := KeyRef1.FIELDINDEX(i);

            CASE i OF
                1:
                    BEGIN
                        ChangeLogEntry."Primary Key Field 1 No." := KeyFldRef.NUMBER;
                        ChangeLogEntry."Primary Key Field 1 Value" :=
                          COPYSTR(FORMAT(KeyFldRef.VALUE, 0, 9), 1, MAXSTRLEN(ChangeLogEntry."Primary Key Field 1 Value"));
                    END;
                2:
                    BEGIN
                        ChangeLogEntry."Primary Key Field 2 No." := KeyFldRef.NUMBER;
                        ChangeLogEntry."Primary Key Field 2 Value" :=
                          COPYSTR(FORMAT(KeyFldRef.VALUE, 0, 9), 1, MAXSTRLEN(ChangeLogEntry."Primary Key Field 2 Value"));
                    END;
                3:
                    BEGIN
                        ChangeLogEntry."Primary Key Field 3 No." := KeyFldRef.NUMBER;
                        ChangeLogEntry."Primary Key Field 3 Value" :=
                          COPYSTR(FORMAT(KeyFldRef.VALUE, 0, 9), 1, MAXSTRLEN(ChangeLogEntry."Primary Key Field 3 Value"));
                    END;
            END;
        END;
        ChangeLogEntry.Modify();
    end;
}