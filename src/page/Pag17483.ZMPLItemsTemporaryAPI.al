page 17483 "ZM PL Items Temporary API"
{
    PageType = List;
    //    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "ZM PL Items Temporary";
    SourceTableView = where("State Creation" = filter('' | Requested));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; "No.") { }
                field("State Creation"; "State Creation") { }
                field(Type; Type) { }
                // antes del nº producto: sus validaciones dependen del tipo (Nuevo: el producto no debe existir)
                field("Request Type"; "Request Type") { }
                field("Item No."; "Item No.") { }
                // después del nº producto: si el PDM envía el ID del documento, prevalece sobre la búsqueda por código
                field("PDM Document ID"; "PDM Document ID") { }
                field("PDM Status"; "PDM Status") { Editable = false; }
                field(Description; Description) { }
                field("Base Unit of Measure"; "Base Unit of Measure") { }
                // Clasificación (en la tabla no es editable): rellena Type
                field("Clasification Type"; ClasificationType)
                {

                    trigger OnValidate()
                    begin
                        Rec.Validate("Clasification Type", ClasificationType);
                    end;
                }
                field("Sujeto a Control de Calidad"; "Sujeto a Control de Calidad") { }
                field("Control Certificado proveedor"; "Control Certificado proveedor") { }
                field("User ID"; "User ID") { }
                field("Codigo Empleado"; CodigoEmpleado)
                {
                    trigger OnValidate()
                    begin
                        Rec.Validate("Codigo Empleado", CodigoEmpleado);
                    end;
                }
                field(Department; Department) { }
                field("Product manager"; "Product manager") { }
                field(Activity; Activity) { }
                field("Posting Date"; "Posting Date") { }
                field(Prototype; Prototype) { }
                field("Tipo de Cambio"; "Tipo de Cambio") { }
                field("Replaces Item No."; "Replaces Item No.") { }
                field("Tipo aprovisionamiento"; "Tipo aprovisionamiento") { }
                field("Replenishment System"; "Replenishment System") { }
                field(Reason; ReasonText) { }
                field(Blocked; Blocked) { }
                field("Reason Blocked"; "Reason Blocked") { }
                field("Purch. Family"; "Purch. Family") { }
                field("Purch. Category"; "Purch. Category") { }
                field("Purch. SubCategory"; "Purch. SubCategory") { }
                field(Alto; Alto) { }
                field(Ancho; Ancho) { }
                field(Largo; Largo) { }
                field("Net Weight"; "Net Weight") { }
                field("Gross Weight"; "Gross Weight") { }
                field(Material; Material) { }
                field("Fixed Assets"; "Fixed Assets") { }
                field(TranslateENG; TranslateENG) { }
                field(TranslateFRA; TranslateFRA) { }
                field(Packaging; Packaging) { }
                field(Lanzado; Lanzado) { }
            }
        }
    }
    var
        ItemTranslationtemporary: Record "ZM Item Translation temporary";
        PDMSync: Codeunit "ZM PDM Sync";
        TranslateENG: text[100];
        TranslateFRA: text[100];
        ReasonText: text;
        Lanzado: Boolean;
        // mismos valores (y orden) que "Clasification Type"; en OData se envían/leen con estos textos
        ClasificationType: Option " ","Raw Material/Item",Service,"Item Out of stock";
        CodigoEmpleado: Code[50];

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ClasificationType);
        Clear(CodigoEmpleado);
        // por defecto alta de producto nuevo (desde el PDM una revisión nueva es un producto nuevo)
        Rec."Request Type" := Rec."Request Type"::New;
    end;

    // En OData (BC14) el alta se hace en dos pasos: primero se inserta con los campos de la tabla
    // (OnInsertRecord) y después se aplican los campos que son variables de la página (Motivo,
    // TranslateENG/FRA, Clasificación, Código empleado, Lanzado) con una modificación (OnModifyRecord).
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (Rec."No." = '') or not Rec.Find('=') then
            Rec.Insert(true);
        // datos del plano que no se envían (las traducciones necesitan el nº de solicitud ya asignado)
        if Rec."PDM Document ID" <> 0 then
            PDMSync.ValidateRequestDocument(Rec)
        else
            if Rec."Item No." <> '' then
                PDMSync.LinkRequest(Rec, true);
        Rec.Modify();
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        // lo enviado prevalece sobre lo que haya rellenado el PDM
        if ReasonText <> '' then
            SetReason(ReasonText);
        CreateItemTranslate();
        Rec.Modify();
        // igual que la acción "Solicitud Alta/Actualización" de la ficha (también con un PATCH posterior)
        if Lanzado then begin
            Lanzado := false;
            Rec.LaunchRegisterItemTemporary(false);
        end;
        exit(false);
    end;

    trigger OnAfterGetRecord()
    begin
        ClasificationType := Rec."Clasification Type";
        CodigoEmpleado := Rec."Codigo Empleado";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ReasonText := Rec.GetWorkDescription();
        GetItemTranslate();
    end;

    local procedure SetReason(NewReason: Text)
    var
        TempBlob: Record TempBlob;
    begin
        // como SetWorkDescription pero sin Modify (lo hace OnModifyRecord)
        TempBlob.WriteAsText(NewReason, TextEncoding::UTF8);
        Rec.Reason := TempBlob.Blob;
    end;

    local procedure CreateItemTranslate()
    var
        myInt: Integer;
    begin
        if TranslateENG <> '' then begin
            if not ItemTranslationtemporary.Get(Rec."No.", '', 'ENG') then begin
                ItemTranslationtemporary.Init();
                ItemTranslationtemporary."Item No." := Rec."No.";
                ItemTranslationtemporary."Language Code" := 'ENG';
                ItemTranslationtemporary.Insert();
            end;
            ItemTranslationtemporary.Description := TranslateENG;
            ItemTranslationtemporary.Modify();
        end;
        if TranslateFRA <> '' then begin
            if not ItemTranslationtemporary.Get(Rec."No.", '', 'FRA') then begin
                ItemTranslationtemporary.Init();
                ItemTranslationtemporary."Item No." := Rec."No.";
                ItemTranslationtemporary."Language Code" := 'FRA';
                ItemTranslationtemporary.Insert();
            end;
            ItemTranslationtemporary.Description := TranslateFRA;
            ItemTranslationtemporary.Modify();
        end;
    end;

    local procedure GetItemTranslate()
    var
        myInt: Integer;
    begin
        Clear(TranslateENG);
        Clear(TranslateFRA);
        if ItemTranslationtemporary.Get(Rec."No.", '', 'ENG') then
            TranslateENG := ItemTranslationtemporary.Description;
        if ItemTranslationtemporary.Get(Rec."No.", '', 'FRA') then
            TranslateFRA := ItemTranslationtemporary.Description;
    end;
}