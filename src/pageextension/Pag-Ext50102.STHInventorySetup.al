pageextension 50102 "STHInventorySetup" extends "Inventory Setup"
{
    layout
    {
        addafter("Copy Item Descr. to Entries")
        {
            field("Fecha Diario dentro periodo"; "Fecha Diario dentro periodo")
            {
                ApplicationArea = all;
            }
        }
        addafter(Numbering)
        {
            group(CalcNeed)
            {
                Caption = 'Calculate Balance Qty.', comment = 'ESP="Calcular Cantidad Balance"';

                field(Inventory; Inventory)
                {
                    ApplicationArea = all;
                }
                field("Qty. on Assembly Order"; "Qty. on Assembly Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Prod. Order"; "Qty. on Prod. Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                    ApplicationArea = all;
                }
                field("Trans. Ord. Receipt (Qty.)"; "Trans. Ord. Receipt (Qty.)")
                {
                    ApplicationArea = all;
                }

                field("Qty. on Asm. Component"; "Qty. on Asm. Component")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Component Lines"; "Qty. on Component Lines")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Job Order"; "Qty. on Job Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Service Order"; "Qty. on Service Order")
                {
                    ApplicationArea = all;
                }
                field("Trans. Ord. Shipment (Qty.)"; "Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Sales Quote"; "Qty. on Sales Quote")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Component Quote"; "Qty. on Component Quote")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Planning MPS Component"; "Qty. on Planning MPS Component")
                {
                    ApplicationArea = all;
                }
                field("MRP Bitec Activo"; "MRP Bitec Activo")
                {
                    ApplicationArea = all;
                }
            }
            group(UtilesCalidad)
            {
                Caption = 'Quality tools', comment = 'ESP="Útiles calidad"';

                field("Email aviso revision utiles"; "Email aviso revision utiles")
                {
                    ApplicationArea = all;
                    ToolTip = 'Recipients (separated by ;) of the monthly email with the tools to be revised this month.', comment = 'ESP="Destinatarios (separados por ;) del email mensual con los útiles que se tienen que revisar este mes."';
                }
                field("Ult. aviso revision utiles"; "Ult. aviso revision utiles")
                {
                    ApplicationArea = all;
                }
            }
            group(PDM)
            {
                Caption = 'PDM SolidWorks', comment = 'ESP="PDM SolidWorks"';

                field("PDM SQL Server"; "PDM SQL Server")
                {
                    ApplicationArea = all;
                }
                field("PDM SQL Database"; "PDM SQL Database")
                {
                    ApplicationArea = all;
                }
                field("PDM SQL User"; "PDM SQL User")
                {
                    ApplicationArea = all;
                    ToolTip = 'Read-only SQL user. Leave it blank to use the account of the Business Central service.', comment = 'ESP="Usuario SQL de solo lectura. En blanco se usa la cuenta del servicio de Business Central."';
                }
                field(PDMPassword; PDMPassword)
                {
                    ApplicationArea = all;
                    Caption = 'PDM SQL Password', comment = 'ESP="Contraseña SQL PDM"';
                    ExtendedDatatype = Masked;

                    trigger OnValidate()
                    begin
                        if PDMPassword <> '********' then
                            PDMSync.SetPassword(PDMPassword);
                    end;
                }
                field("PDM Vault Path"; "PDM Vault Path")
                {
                    ApplicationArea = all;
                    ToolTip = 'Folder of the PDM vault files, accessible by the Business Central service account (e.g. \\server\pdm-fs\Data\PDM-ZUMMO).', comment = 'ESP="Carpeta de ficheros del almacén del PDM, accesible por la cuenta del servicio de Business Central (p. ej. \\servidor\pdm-fs\Data\PDM-ZUMMO)."';
                }
                field("PDM Last Sync"; "PDM Last Sync")
                {
                    ApplicationArea = all;
                }
                field("PDM Pending From Date"; "PDM Pending From Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'The tray ''PDM approved without item'' shows the drawings approved from this date.', comment = 'ESP="La bandeja ''Aprobados PDM sin producto'' muestra los planos aprobados desde esta fecha."';
                }
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(EnviarAvisoRevisionUtiles)
            {
                ApplicationArea = all;
                Caption = 'Send tools revision warning', comment = 'ESP="Enviar aviso revisión útiles"';
                ToolTip = 'Sends now the email with the quality tools to be revised this month, without waiting for the job queue.', comment = 'ESP="Envía ahora el email con los útiles de calidad a revisar este mes, sin esperar a la cola."';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CUCron: Codeunit CU_Cron;
                    lblConfirm: Label '¿Enviar ahora el aviso de revisión de útiles a %1?', comment = 'ESP="¿Enviar ahora el aviso de revisión de útiles a %1?"';
                    lblEnviado: Label 'Aviso enviado', comment = 'ESP="Aviso enviado"';
                begin
                    Rec.TestField("Email aviso revision utiles");
                    if not Confirm(lblConfirm, false, Rec."Email aviso revision utiles") then
                        exit;
                    CUCron.AvisoRevisionUtiles(true);
                    Message(lblEnviado);
                end;
            }
            group(PDMActions)
            {
                Caption = 'PDM', comment = 'ESP="PDM"';
                Image = Document;

                action(PDMTestConnection)
                {
                    ApplicationArea = all;
                    Caption = 'Test PDM connection', comment = 'ESP="Probar conexión PDM"';
                    Image = TestDatabase;

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord();
                        PDMSync.TestConnection();
                    end;
                }
                action(PDMSynchronize)
                {
                    ApplicationArea = all;
                    Caption = 'Synchronize PDM now', comment = 'ESP="Sincronizar PDM ahora"';
                    ToolTip = 'Reads from the PDM the documents changed since the last synchronization.', comment = 'ESP="Lee del PDM los documentos que han cambiado desde la última sincronización."';
                    Image = Refresh;

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord();
                        PDMSync.Synchronize(false);
                        CurrPage.Update(false);
                    end;
                }
                action(PDMFullReload)
                {
                    ApplicationArea = all;
                    Caption = 'PDM full reload', comment = 'ESP="Recarga completa PDM"';
                    ToolTip = 'Deletes the PDM data in Business Central and reads again all the approved documents.', comment = 'ESP="Borra los datos del PDM en Business Central y vuelve a leer todos los documentos aprobados."';
                    Image = RefreshLines;

                    trigger OnAction()
                    var
                        lblConfirm: Label 'Delete the PDM data and read again all the approved documents?', comment = 'ESP="¿Borrar los datos del PDM y volver a leer todos los documentos aprobados?"';
                    begin
                        if not Confirm(lblConfirm, false) then
                            exit;
                        CurrPage.SaveRecord();
                        PDMSync.Synchronize(true);
                        CurrPage.Update(false);
                    end;
                }
                action(PDMDocuments)
                {
                    ApplicationArea = all;
                    Caption = 'PDM Documents', comment = 'ESP="Documentos PDM"';
                    Image = Documents;
                    RunObject = page "ZM PDM Documents";
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // la contraseña no se muestra: solo se indica si está guardada
        PDMPassword := '';
        if PDMSync.HasPassword() then
            PDMPassword := '********';
    end;

    var
        PDMSync: Codeunit "ZM PDM Sync";
        PDMPassword: Text;
        myInt: Integer;
}