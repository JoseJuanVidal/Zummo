tableextension 50104 "TabExtPurchaseHeader_btc" extends "Purchase Header"  //38
{
    fields
    {
        field(50000; "Pendiente_btc"; Boolean)
        {
            Caption = 'Has pending amount', Comment = 'ESP="Tiene cantidad pendiente"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Purchase Line" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Outstanding Quantity" = FILTER(<> 0)));
        }
        field(50001; "Motivo rechazo"; Text[100])
        {
            Caption = 'Motivo rechazo', Comment = 'ESP="Motivo rechazo"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line".TextoRechazo WHERE
            ("Document Type" = FIELD("Document Type"),
             "Document No." = FIELD("No."),
            "Outstanding Quantity" = FILTER(> 0),
            TextoRechazo = filter(<> '')
            ));
        }
        field(50002; "Fecha Mas Temprana"; Date)
        {
            Caption = 'Fecha Mas Temprana', Comment = 'ESP="Fecha Mas Temprana"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = min("Purchase Line"."Expected Receipt Date" where("Document Type" = FIELD("Document Type"),
             "Document No." = FIELD("No."),
            "Outstanding Quantity" = FILTER(> 0)));
        }
        field(50023; "Amount Subcontractor"; Decimal)
        {
            Caption = 'Amount Subcontractor', Comment = 'ESP="Importe subcontratación"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Order No." = filter(<> '')));
        }
        field(50024; "Amount Inc. VAT Subcontractor"; Decimal)
        {
            Caption = 'Amount Inc. VAT Subcontractor', Comment = 'ESP="Importe con IVA subcontr."';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Order No." = filter(<> '')));
        }
        field(50030; "Job No."; code[20])
        {
            Caption = 'Job No.', Comment = 'ESP="Nº Proyecto"';
            TableRelation = Job;


            trigger OnValidate()
            begin
                Update_JobTaskNo();
            end;
        }
        field(50032; "Job Task No."; code[20])
        {
            Caption = 'Job Task No', Comment = 'ESP="Nº Tarea Proyecto"';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));

            trigger OnValidate()
            begin
                Update_JobTaskNo();
            end;
        }
        field(50033; "Job Preview Mode"; Boolean)
        {
            Caption = 'Job Preview Mode', Comment = 'ESP="Registro Preview mode"';
        }

        field(50035; "Job Category"; code[20])
        {
            Caption = 'Job Category', Comment = 'ESP="Categoría proyecto"';
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(tabla), TipoTabla = const("Job Clasification"));

        }
        field(50110; "ZM Job No."; code[20])
        {
            Caption = 'Fixed Asset Job No.', Comment = 'ESP="A/F Nº Proyecto"';
            TableRelation = Job;
        }
        field(50112; "ZM Job Task No."; code[20])
        {
            Caption = 'Fixed Asset Job Task No', Comment = 'ESP="A/F Nº Tarea Proyecto"';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("ZM Job No."));
        }
        field(50120; "Purch. Request less 200"; code[20])
        {
            Caption = 'Purch. Request less 200', Comment = 'ESP="Compra menor 200"';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Requests less 200" where(Status = const(Approved), Invoiced = const(false));

            trigger OnValidate()
            begin
                OnValidate_PurchRequest();
            end;

        }
        field(50125; "CONSULTIA ID Factura"; Integer)
        {
            Caption = 'CONSULTIA Id Factura', Comment = 'ESP="CONSULTIA Id Factura"';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "ZM CONSULTIA Invoice Header";
        }
        field(50126; "CONSULTIA N Factura"; code[20])
        {
            Caption = 'CONSULTIA Id Factura', Comment = 'ESP="CONSULTIA Id Factura"';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "ZM CONSULTIA Invoice Header".N_Factura where(Id = field("CONSULTIA ID Factura"));
        }
        //+  NORMATIVA MEDIO AMBIENTAL
        Field(50200; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic (kg)', comment = 'ESP="Plástico (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50201; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Recycled (kg)', comment = 'ESP="Plástico reciclado (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50202; "Plastic Date Declaration"; Date)
        {
            Caption = 'Plastic Date Declaration', comment = 'ESP="Fecha Declaración plástico"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //-  NORMATIVA MEDIO AMBIENTAL
    }

    local procedure OnValidate_PurchRequest()
    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseRequest: Record "Purchase Requests less 200";
        AutLoginMgt: Codeunit "AUT Login Mgt.";
        DocumentNo: code[20];
        ExistInvoiced: Boolean;
        lblError: Label 'La solicitud ya ha sido facturada en el documento %1', comment = 'ESP="La solicitud ya ha sido facturada en el documento %1"';
        lblCreateLine: Label '%1 %2 tiene líneas.\¿Se van a eliminar y crear las líneas de %3 %4?', comment = 'ESP="%1 %2 tiene líneas.\¿Se van a eliminar y crear las líneas de %3 %4?"';
        lblTxtLineDesc: Label '%1 %2 de %3', comment = 'ESP="%1 %2 de %3"';
    begin
        if Rec."Purch. Request less 200" = '' then
            exit;
        if Rec."Purch. Request less 200" = xRec."Purch. Request less 200" then
            exit;
        PurchaseRequest.Get(Rec."Purch. Request less 200");
        PurchaseSetup.Get();


        if (PurchaseRequest."Vendor No." <> '') then
            PurchaseRequest.TestField("Vendor No.", Rec."Buy-from Vendor No.");

        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        PurchaseHeader.SetRange("Purch. Request less 200", Rec."Purch. Request less 200");
        if PurchaseHeader.FindFirst() then
            repeat
                if PurchaseHeader."No." <> Rec."No." then
                    Error(lblError, PurchaseHeader."No.");
            Until PurchaseHeader.next() = 0;
        DocumentNo := PurchaseRequest.CheckDocumentNo();
        if DocumentNo <> '' then
            Error(lblError, DocumentNo);

        // se revisa si tiene lineas creadas, avisamos, eliminamos y creamos lineas con el importe y concepto de la compra menor 200

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        if PurchaseLine.FindFirst() then
            if not confirm(lblCreateLine, false, PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseRequest.TableCaption, PurchaseRequest."No.") then
                exit;

        // Actualizar Dimensiones de partidas presupuestaria
        PurchaseLine.DeleteAll();
        PurchaseLine.Init();
        PurchaseLine."Document Type" := Rec."Document Type";
        PurchaseLine."Document No." := Rec."No.";
        PurchaseLine."Buy-from Vendor No." := Rec."Buy-from Vendor No.";
        PurchaseLine."Line No." := 10000;
        PurchaseLine.Validate(Type, PurchaseLine.Type::" ");
        PurchaseLine.Description := copystr(StrSubstNo(lblTxtLineDesc, PurchaseRequest.TableCaption, PurchaseRequest."No.", PurchaseRequest."Vendor Name"), 1, MaxStrLen(PurchaseLine.Description));
        PurchaseLine.Insert(true);
        PurchaseLine."Line No." += PurchaseLine."Line No.";
        case PurchaseRequest.Type of
            PurchaseRequest.Type::"Fixed Asset":
                PurchaseLine.Validate(Type, PurchaseLine.Type::"Fixed Asset");
            PurchaseRequest.Type::"G/L Account":
                PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
            PurchaseRequest.Type::Item:
                PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
        end;
        PurchaseLine.Validate("No.", PurchaseRequest."G/L Account No.");
        PurchaseLine.Description := PurchaseRequest.Description;
        PurchaseLine.Quantity := 1;
        PurchaseLine.Validate("Direct Unit Cost", PurchaseRequest.Amount);

        //  Aprobacion de usuario a las lineas
        if PurchaseLine."Codigo Empleado Aprobacion" = AutLoginMgt.GetEmpleado() then
            PurchaseLine."Estado Aprobacion" := PurchaseLine."Estado Aprobacion"::Aprobada;

        SetPurchaseLineDimensiones(PurchaseRequest, PurchaseLine);
        PurchaseLine.Insert(true);

    end;

    local procedure SetPurchaseLineDimensiones(PurchaseRequest: Record "Purchase Requests less 200"; var PurchaseLine: Record "Purchase Line")
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntry: record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
        recNewDimSetEntry: record "Dimension Set Entry" temporary;
        cduDimMgt: Codeunit DimensionManagement;
        cduCambioDim: Codeunit CambioDimensiones;
        GlobalDim1: code[20];
        GlobalDim2: code[20];
        bGlobalDim1: Boolean;
        bGlobalDim3: Boolean;
        bGlobalDim8: Boolean;
        intDimSetId: Integer;
    begin
        GLSetup.Get();
        DimSetEntry.SetRange("Dimension Set ID", PurchaseLine."Dimension Set ID");
        if DimSetEntry.FindFirst() then
            repeat
                recNewDimSetEntry.Init();
                recNewDimSetEntry.TransferFields(DimSetEntry);
                // CECO
                if (PurchaseRequest."Global Dimension 1 Code" <> '') and (DimSetEntry."Dimension Code" = GLSetup."Shortcut Dimension 1 Code") then begin
                    recNewDimSetEntry.Validate("Dimension Value Code", PurchaseRequest."Global Dimension 1 Code");
                    bGlobalDim1 := true;
                end;
                // PARTIDA
                if (PurchaseRequest."Global Dimension 8 Code" <> '') and (DimSetEntry."Dimension Code" = GLSetup."Shortcut Dimension 8 Code") then begin
                    recNewDimSetEntry.Validate("Dimension Value Code", PurchaseRequest."Global Dimension 8 Code");
                    bGlobalDim8 := true;
                end;
                // DETALLE
                if (PurchaseRequest."Global Dimension 3 Code" <> '') and (DimSetEntry."Dimension Code" = GLSetup."Shortcut Dimension 3 Code") then begin
                    recNewDimSetEntry.Validate("Dimension Value Code", PurchaseRequest."Global Dimension 3 Code");
                    bGlobalDim3 := true;
                end;
                recNewDimSetEntry.Insert();
            Until DimSetEntry.next() = 0;
        // si no existen CECO, PARTIDA y DETALLE los creamos
        if not bGlobalDim1 and (PurchaseRequest."Global Dimension 1 Code" <> '') then begin
            recNewDimSetEntry.Init();
            recNewDimSetEntry."Dimension Set ID" := PurchaseLine."Dimension Set ID";
            recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 1 Code";
            recNewDimSetEntry.Validate("Dimension Value Code", PurchaseRequest."Global Dimension 3 Code");
            recNewDimSetEntry.Insert();
        end;
        if not bGlobalDim3 and (PurchaseRequest."Global Dimension 3 Code" <> '') then begin
            recNewDimSetEntry.Init();
            recNewDimSetEntry."Dimension Set ID" := PurchaseLine."Dimension Set ID";
            recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 3 Code";
            recNewDimSetEntry.Validate("Dimension Value Code", PurchaseRequest."Global Dimension 3 Code");
            recNewDimSetEntry.Insert();
        end;
        if not bGlobalDim8 and (PurchaseRequest."Global Dimension 8 Code" <> '') then begin
            recNewDimSetEntry.Init();
            recNewDimSetEntry."Dimension Set ID" := PurchaseLine."Dimension Set ID";
            recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
            recNewDimSetEntry.Validate("Dimension Value Code", PurchaseRequest."Global Dimension 8 Code");
            recNewDimSetEntry.Insert();
        end;

        Clear(cduDimMgt);
        intDimSetId := cduDimMgt.GetDimensionSetID(recNewDimSetEntry);
        clear(cduCambioDim);

        GlobalDim1 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 1 Code", intDimSetId);
        GlobalDim2 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 2 Code", intDimSetId);

        PurchaseLine."Dimension Set ID" := intDimSetId;
        PurchaseLine."Shortcut Dimension 1 Code" := GlobalDim1;
        PurchaseLine."Shortcut Dimension 2 Code" := GlobalDim2;
    end;


    local procedure Update_JobTaskNo()
    var
        PurchaseLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        JobTask: Record "Job Task";
        lblConfirmUpdate: Label 'Se va a actualizar las líneas del pedido de compra con el proyecto %1 y tarea %2.\¿Desea Continuar?',
            comment = 'ESP="Se va a actualizar las líneas del pedido de compra con el proyecto %1 y tarea %2.\¿Desea Continuar?"';
    begin
        JobTask.Reset();
        JobTask.SetRange("Job No.", Rec."Job No.");
        JobTask.SetRange("Job Task No.", Rec."Job Task No.");
        if not JobTask.FindFirst() then
            Rec."Job Task No." := '';
        if (Rec."Job No." <> xRec."Job No.") or (Rec."Job Task No." <> xRec."Job Task No.") then
            if confirm(lblConfirmUpdate, false, Rec."Job No.", Rec."Job Task No.") then begin
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", Rec."Document Type");
                PurchaseLine.SetRange("Document No.", Rec."No.");
                if PurchaseLine.FindFirst() then
                    repeat
                        if PurchaseLine.Type in [PurchaseLine.Type::"Fixed Asset"] then begin
                            PurchaseLine."ZM Job No." := Rec."Job No.";
                            PurchaseLine."ZM Job Task No." := Rec."Job Task No.";
                            PurchaseLine.Modify();
                        end;
                    Until PurchaseLine.next() = 0;
            end;
    end;
}