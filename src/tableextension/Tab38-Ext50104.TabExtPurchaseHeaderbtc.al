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
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchaseRequest: Record "Purchase Requests less 200";
        ExistInvoiced: Boolean;
        lblError: Label 'La solicitud ya ha sido facturada en el documento %1', comment = 'ESP="La solicitud ya ha sido facturada en el documento %1"';
        lblMaxRequest: Label 'El importe %1 supera el máximo permitido por solicitud %2.', comment = 'ESP="El importe %1 supera el máximo permitido por solicitud %2."';
    begin
        PurchaseRequest.Get(Rec."Purch. Request less 200");
        if Rec."Purch. Request less 200" = xRec."Purch. Request less 200" then
            exit;
        if Rec."Purch. Request less 200" = '' then begin
            exit;
        end;

        if (PurchaseRequest."Vendor No." <> '') then
            PurchaseRequest.TestField("Vendor No.", Rec."Buy-from Vendor No.");
        PurchaseSetup.Get();
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        PurchaseHeader.SetRange("Purch. Request less 200", Rec."Purch. Request less 200");
        if PurchaseHeader.FindFirst() then
            repeat
                if PurchaseHeader."No." <> Rec."No." then
                    Error(lblError, PurchaseHeader."No.");
            Until PurchaseHeader.next() = 0;

        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("Purch. Request less 200", Rec."Purch. Request less 200");
        if PurchInvHeader.FindFirst() then
            Error(lblError, PurchInvHeader."No.");

        if PurchaseHeader.Get(Rec."Document Type", Rec."No.") then begin
            PurchaseHeader.CalcFields(Amount);
            if PurchaseHeader."Amount Including VAT" > PurchaseSetup."Maximum amount Request" then
                Error(lblMaxRequest, PurchaseHeader."Amount Including VAT", PurchaseSetup."Maximum amount Request");
        end;

    end;

    local procedure Update_JobTaskNo()
    var
        PruchaseLine: Record "Purchase Line";
        JobTask: Record "Job Task";
        lblConfirmUpdate: Label 'Se va a actualizar las líneas del pedido de compra con el proyecto %1 y tarea %2.\¿Desea Continuar?',
            comment = 'ESP="Se va a actualizar las líneas del pedido de compra con el proyecto %1 y tarea %2.\¿Desea Continuar?"';
    begin
        JobTask.Reset();
        JobTask.SetRange("Job No.", Rec."Job No.");
        JobTask.SetRange("Job Task No.", Rec."Job Task No.");
        if not JobTask.FindFirst() then
            Rec."Job Task No." := '';
        if (Rec."Job No." <> xRec."Job No.") or (Rec."Job Task No." <> Rec."Job Task No.") then
            if confirm(lblConfirmUpdate, false, Rec."Job No.", Rec."Job Task No.") then begin
                PruchaseLine.Reset();
                PruchaseLine.SetRange("Document Type", Rec."Document Type");
                PruchaseLine.SetRange("Document No.", Rec."No.");
                if PruchaseLine.FindFirst() then
                    repeat
                        if PruchaseLine.Type in [PruchaseLine.Type::Item, PruchaseLine.Type::"G/L Account"] then begin
                            PruchaseLine.Validate("Job No.", Rec."Job No.");
                            PruchaseLine.Validate("Job Task No.", Rec."Job Task No.");
                            PruchaseLine.Modify();
                        end;
                    Until PruchaseLine.next() = 0;
            end;

    end;
}