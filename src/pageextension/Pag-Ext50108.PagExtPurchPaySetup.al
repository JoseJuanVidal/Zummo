pageextension 50108 "PagExtPurchPaySetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Accounts")
        {
            group(Bitec)
            {
                Caption = 'Bitec', comment = 'ESP="Bitec"';

                group(GrTextoEmail)
                {
                    Caption = 'Text e-mail purchase order', comment = 'ESP="Texto e-mail pedido compra"';

                    field(textoEmail; textoEmail)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        MultiLine = true;

                        trigger OnValidate()
                        begin
                            SetTextoEmail(textoEmail);
                        end;
                    }

                }
                field(WarningPlasticReceiptIntra; WarningPlasticReceiptIntra)
                {
                    ApplicationArea = all;
                }

                field("General Conditions Purchase"; "General Conditions Purchase")
                {
                    ApplicationArea = all;

                    trigger OnAssistEdit()
                    begin
                        GeneralConditions();
                    end;
                }

                field("General Conditions Pur. (ENG)"; "General Conditions Pur. (ENG)")
                {
                    ApplicationArea = all;

                    trigger OnAssistEdit()
                    begin
                        GeneralConditionsENG();
                    end;
                }

            }
            group("Sharepoint")
            {
                Caption = 'Sharepoint', comment = 'ESP="Sharepoint"';

                field("Sharepoint Connection"; "Sharepoint Connection")
                {
                    ApplicationArea = all;
                }
                field("Sharepoint Folder"; "Sharepoint Folder")
                {
                    ApplicationArea = all;
                }
                field(driveId; driveId)
                {
                    ApplicationArea = all;
                }
                field("Path Purchase Documents"; "Path Purchase Documents")
                {
                    ApplicationArea = all;

                    trigger OnAssistEdit()
                    begin
                        Rec."Path Purchase Documents" := SelectPathPurchaseDocuments();
                    end;
                }
                field("Path Purchase Docs. pending"; "Path Purchase Docs. pending")
                {
                    ApplicationArea = all;

                    trigger OnAssistEdit()
                    begin
                        rec."Path Purchase Docs. pending" := SelectPathPurchaseDocuments();
                    end;
                }
            }
            group(Contracts)
            {
                Caption = 'Contratos/Suministros', comment = 'ESP="Contratos/Suministros"';
                field("ZM Contracts Nos."; "ZM Contracts Nos.")
                {
                    ApplicationArea = all;
                }
                field("Warning Contracts"; "Warning Contracts")
                {
                    ApplicationArea = all;
                }
                field("Purchase Request Nos."; "Purchase Request Nos.")
                {
                    ApplicationArea = all;
                }
            }
            group(CONSULTIA)
            {
                field("CONSULTIA Url"; "CONSULTIA Url")
                {
                    ApplicationArea = all;
                }
                field("CONSULTIA User"; "CONSULTIA User")
                {
                    ApplicationArea = all;
                }
                field("CONSULTIA Password"; "CONSULTIA Password")
                {
                    ApplicationArea = all;
                    ExtendedDatatype = Masked;
                }
                field("CONSULTIA G/L Provide"; "CONSULTIA G/L Provide")
                {
                    ApplicationArea = all;
                }
                field("CONSULTIA Gen. Jnl. Template"; "CONSULTIA Gen. Jnl. Template")
                {
                    ApplicationArea = all;
                }
                field("CONSULTIA Gen. Journal Batch"; "CONSULTIA Gen. Journal Batch")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        textoEmail := GetTextoEmail();
    end;

    var
        FileManagement: Codeunit "File Management";
        Funciones: Codeunit Funciones;
        textoEmail: Text;
        lblPath: Label 'Select folder', comment = 'ESP="Seleccionar Carpeta"';
        lblExport: Label '¿Do you want to open or download the file?', comment = 'ESP="¿Desea abrir o descargar el fichero?"';

    local procedure SelectPathPurchaseDocuments(): Text
    var
        PathName: text;
    begin
        if FileManagement.SelectFolderDialog(lblPath, PathName) then
            Exit(PathName);
    end;

    local procedure GeneralConditions()
    var
        FileName: text;
        lblTitle: Label 'Select File (PDF)', comment = 'ESP="Seleccionar Fichero (PDF)"';
        lblfilter: Label 'PDF (*.pdf)|*.pdf', comment = 'ESP="PDF (*.pdf)|*.pdf"';
    begin
        Clear(Funciones);
        if Rec."General Conditions Purchase" <> '' then begin
            Funciones.DeleteGeneralConditions(Rec.FieldNo("General Conditions Purchase"));
            Rec."General Conditions Purchase" := '';
            Rec.Modify();
            Commit();
        end;

        FileName := Funciones.UploadGeneralConditions(Rec.FieldNo("General Conditions Purchase"));
        if FileName <> '' then begin
            Rec."General Conditions Purchase" := CopyStr(FileName, 1, MaxStrLen(Rec."General Conditions Purchase"));
        end;
        CurrPage.Update();
    end;

    local procedure GeneralConditionsENG()
    var
        FileName: text;
        lblTitle: Label 'Select File (PDF)', comment = 'ESP="Seleccionar Fichero (PDF)"';
        lblfilter: Label 'PDF (*.pdf)|*.pdf', comment = 'ESP="PDF (*.pdf)|*.pdf"';
    begin
        Clear(Funciones);
        if Rec."General Conditions Pur. (ENG)" <> '' then begin
            Funciones.DeleteGeneralConditions(Rec.FieldNo("General Conditions Pur. (ENG)"));
            Rec."General Conditions Pur. (ENG)" := '';
            Rec.Modify();
            Commit();
        end;
        FileName := Funciones.UploadGeneralConditions(Rec.FieldNo("General Conditions Pur. (ENG)"));
        if FileName <> '' then begin
            Rec."General Conditions Pur. (ENG)" := CopyStr(FileName, 1, MaxStrLen(Rec."General Conditions Purchase"));
        end;

        CurrPage.Update();
    end;

    local procedure DownloadGeneralConditions(FiledNo: Integer)
    var
        myInt: Integer;
    begin
        Clear(Funciones);
        if Rec."General Conditions Pur. (ENG)" <> '' then begin
            if not Confirm(lblExport) then
                exit;
            Funciones.DowloadGeneralConditions(Rec.FieldNo("General Conditions Pur. (ENG)"));
        end;
    end;
}