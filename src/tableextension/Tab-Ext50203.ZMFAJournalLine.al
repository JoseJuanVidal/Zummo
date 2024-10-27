tableextension 50203 "ZM FA Journal Line" extends "FA Journal Line"
{
    fields
    {
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
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    local procedure OnValidate_PurchRequest()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseRequest: Record "Purchase Requests less 200";
        AutLoginMgt: Codeunit "AUT Login Mgt.";
        DocumentNo: code[20];
        ExistInvoiced: Boolean;
        lblError: Label 'La solicitud ya ha sido facturada en el documento %1', comment = 'ESP="La solicitud ya ha sido facturada en el documento %1"';
        lblErroAccountType: Label 'La solicitud %1 debe ser un %2 o %.', comment = 'ESP="La solicitud %1 debe ser un %2 o %3."';
    begin
        if Rec."Purch. Request less 200" = '' then
            exit;
        PurchaseRequest.Get(Rec."Purch. Request less 200");
        if Rec."Purch. Request less 200" = xRec."Purch. Request less 200" then
            exit;
        if Rec."Purch. Request less 200" = '' then
            exit;

        // si ya esta en un historico de facturas y si está asignado a otra linea de Diario General
        DocumentNo := PurchaseRequest.CheckDocumentNo();
        if (DocumentNo <> '') and (Rec."Document No." <> DocumentNo) then
            Error(lblError, PurchaseRequest."Purchase Invoice");

        // si esta asignado a una factura de compra pendiente de registrar
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        PurchaseHeader.SetRange("Purch. Request less 200", Rec."Purch. Request less 200");
        if PurchaseHeader.FindFirst() then
            Error(lblError, PurchaseHeader."No.");

        case PurchaseRequest.Type of
            PurchaseRequest.Type::"Fixed Asset":
                begin
                    if Rec."FA Posting Type" <> Rec."FA Posting Type"::"Acquisition Cost" then
                        Rec."FA Posting Type" := Rec."FA Posting Type"::"Acquisition Cost";
                    Rec.validate("FA No.", PurchaseRequest."G/L Account No.");
                end;
            else
                Error(lblErroAccountType, PurchaseRequest."No.", PurchaseRequest.Type::"G/L Account", PurchaseRequest.Type::"Fixed Asset");
        end;
        Rec.Description := PurchaseRequest.Description;
        Rec.validate(Amount, PurchaseRequest.Amount);
        SetGenJnlLineDimensiones(PurchaseRequest, Rec);
        if not Rec.Insert() then
            Rec.Modify();
    end;

    local procedure SetGenJnlLineDimensiones(PurchaseRequest: Record "Purchase Requests less 200"; var FAJnlLine: Record "FA Journal Line")
    var
    begin
        FAJnlLine.ValidateShortcutDimCode(1, PurchaseRequest."Global Dimension 1 Code");
        FAJnlLine.ValidateShortcutDimCode(3, PurchaseRequest."Global Dimension 3 Code");
        FAJnlLine.ValidateShortcutDimCode(8, PurchaseRequest."Global Dimension 8 Code");
    end;
}