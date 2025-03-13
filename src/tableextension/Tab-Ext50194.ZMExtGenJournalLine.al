tableextension 50194 "ZM Ext Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50120; "Purch. Request less 200"; code[20])
        {
            Caption = 'Purch. Request less 200', Comment = 'ESP="Compra menor 200"';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Requests less 200" where(Status = const(Approved));

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
            PurchaseRequest.Type::"G/L Account":
                begin
                    if Rec."Account Type" <> Rec."Account Type"::"G/L Account" then
                        Rec."Account Type" := Rec."Account Type"::"G/L Account";
                    Rec."Account Type" := Rec."Account Type"::"G/L Account";
                    Rec.validate("Account No.", PurchaseRequest."G/L Account No.");
                end;
            PurchaseRequest.Type::"Fixed Asset":
                begin
                    Rec."Account Type" := Rec."Account Type"::"Fixed Asset";
                    Rec.Validate("Account No.", PurchaseRequest."G/L Account No.");
                end;
            PurchaseRequest.Type::Item:
                begin
                    // buscamos el numero de cuenta contable del ITEM
                    Rec.Validate("Account No.", GetGenProdPostingGroup(Rec."Account No."));
                end;
            else
                Error(lblErroAccountType, PurchaseRequest."No.", PurchaseRequest.Type::"G/L Account", PurchaseRequest.Type::"Fixed Asset");
        end;
        Rec.Description := PurchaseRequest.Description;
        Rec.validate(Amount, PurchaseRequest.Amount);
        Rec."Shortcut Dimension 1 Code" := PurchaseRequest."Global Dimension 1 Code";
        SetGenJnlLineDimensiones(PurchaseRequest, Rec);
        if not Rec.Insert() then
            Rec.Modify();
    end;

    local procedure SetGenJnlLineDimensiones(PurchaseRequest: Record "Purchase Requests less 200"; var GenJnlLine: Record "Gen. Journal Line")
    var
    begin
        GenJnlLine.ValidateShortcutDimCode(1, PurchaseRequest."Global Dimension 1 Code");
        GenJnlLine.ValidateShortcutDimCode(3, PurchaseRequest."Global Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(8, PurchaseRequest."Global Dimension 8 Code");
    end;

    local procedure GetGenProdPostingGroup(ItemNo: code[20]): code[20]
    var
        Item: Record Item;
        GeneralPostingSetup: Record "General Posting Setup";
    begin
        if not Item.Get(ItemNo) then
            exit;
        GeneralPostingSetup.Reset();
        GeneralPostingSetup.SetRange("Gen. Bus. Posting Group", Rec."Gen. Bus. Posting Group");
        GeneralPostingSetup.SetRange("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
        if GeneralPostingSetup.FindFirst() then
            exit(GeneralPostingSetup."Purch. Account");

    end;
}