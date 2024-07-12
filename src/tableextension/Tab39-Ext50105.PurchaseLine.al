tableextension 50105 "PurchaseLine" extends "Purchase Line"  //39
{
    fields
    {
        field(50000; FechaRechazo_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Rejected Date', Comment = 'ESP="Fecha Rechazo"';
            Description = 'Bitec';
        }

        field(50001; TextoRechazo; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Rejected Text', Comment = 'ESP="Comentario"';
            Description = 'Bitec';
        }
        field(50002; PermitirMatarResto; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Nombre Proveedor"; Text[100])
        {
            Caption = 'Nombre Proveedor', Comment = 'ESP="Nombre Proveedor"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Buy-from Vendor Name" WHERE
            ("Document Type" = FIELD("Document Type"),
             "No." = FIELD("Document No.")
            ));
        }
        field(50004; "Primera Fecha Recep."; date)
        {
            Caption = 'Primera fecha Recep.', comment = 'ESP="Primera fecha Recep."';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Line"."Posting Date" where("Order No." = field("Document No."), "Order Line No." = field("Line No."), Quantity = filter(<> 0)));
        }
        field(50005; StandarCost; decimal)
        {
            Caption = 'Coste Estandar', Comment = 'ESP="Coste Estandar"';
            Description = 'Bitec';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Standard Cost" where("No." = field("No.")));
            Editable = false;
        }
        field(50050; "IdCorp_Sol"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ID Corporativo Solicitante', comment = 'ESP="ID Corporativo Solicitante"';
            Editable = false;
        }
        field(50051; "Nombre Empleado"; code[250])
        {
            Caption = 'Nombre Solicitante', comment = 'ESP="Nombre Solicitante"';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field(IdCorp_Sol)));
            Editable = false;
        }
        field(50055; "Purch. Order No."; code[20])
        {
            Caption = 'Purch. Order No.', comment = 'ESP="Nº Pedido Compra"';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Order No." where("No." = field("Receipt No.")));
            Editable = false;
        }
        field(50100; "Process No."; Code[20])
        {
            Caption = 'Process No.', Comment = 'ESP="Cód. proceso"';
            DataClassification = CustomerContent;
        }
        field(50101; "Contracts No."; code[20])
        {
            Caption = 'Contracts No.', comment = 'ESP="Nº Contrato"';
            DataClassification = CustomerContent;
            TableRelation = "ZM Contracts/Supplies Header";
            Editable = false;
        }
        field(50102; "Contracts Line No."; Integer)
        {
            Caption = 'Contracts Line No.', comment = 'ESP="Nº Línea Contrato"';
            DataClassification = CustomerContent;
            TableRelation = "ZM Contracts/Supplies Lines"."Line No." where("Document No." = field("Document No."));
            Editable = false;
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
    }

    trigger OnAfterInsert()
    begin
    end;

    trigger OnAfterModify()
    begin
        UpdatePurchaseHeaderJobNo();
    end;

    local procedure UpdatePurchaseHeaderJobNo()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if not (Rec.Type in [Rec.Type::"G/L Account", Rec.Type::Item]) then
            exit;
        if Rec."No." = '' then
            exit;

        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            if (Rec."Job No." = '') and (Rec."Job Task No." = '') then
                exit;
            if PurchaseHeader."Job No." <> '' then
                Rec.Validate("Job No.", PurchaseHeader."Job No.");
            if PurchaseHeader."Job Task No." <> '' then
                Rec.Validate("Job Task No.", PurchaseHeader."Job Task No.");
            if Rec."Receipt No." = '' then
                Rec."Job Line Amount" := 0;
            Rec.Modify();
        end;
    end;
}