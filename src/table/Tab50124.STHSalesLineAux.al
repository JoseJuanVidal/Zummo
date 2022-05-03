table 50124 "STH Sales Line Aux"
{
    Caption = 'STH Sales Line Aux';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.', Comment = 'ESP="Venta-a Nº"';
            DataClassification = CustomerContent;
            TableRelation = "STH Sales Header Aux"."Sell-to Customer No.";
            ObsoleteState = Removed;
            ObsoleteReason = 'El campo "Sell-to Customer" no es necesario';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº Documento"';
            DataClassification = CustomerContent;
            TableRelation = "STH Sales Header Aux"."No.";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº Linea"';
            DataClassification = CustomerContent;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            DataClassification = CustomerContent;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(6; "Description 2"; Text[50])
        {
            Caption = 'Description 2', Comment = 'ESP="Descripción 2"';
            DataClassification = CustomerContent;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
            DataClassification = CustomerContent;
        }
        field(8; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %', Comment = 'ESP="% Linea Descuento"';
            DataClassification = CustomerContent;
        }
        field(9; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount', Comment = 'ESP="Total Linea Descuento"';
            DataClassification = CustomerContent;
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Total"';
            DataClassification = CustomerContent;
        }
        field(11; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount', Comment = 'ESP="Total Linea"';
            DataClassification = CustomerContent;
        }
        field(12; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price', Comment = 'ESP="Precio Unitario"';
            DataClassification = CustomerContent;
        }
        field(13; "Quote ID"; Guid)
        {
            Caption = 'Quote ID', Comment = 'ESP="Id Oferta"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateDocNoId;
            end;
        }
        field(14; "Item ID"; Guid)
        {
            Caption = 'Item ID', Comment = 'ESP="Id Producto"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateItemId;
            end;
        }
        // TODO REVISION 
        // field(15; "Revision ID"; Integer)
        // {
        //     Caption = 'RevisionNumber', Comment = 'ESP="RevisionNumber"';
        // }

        field(30; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT', Comment = 'ESP="Importe IVA incl."';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Quote ID", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        Item: Record Item;
        CRMIntegrationRecord: record "CRM Integration Record";

    local procedure UpdateItemId()
    var
        AccountId: RecordId;
        ItemRecRef: RecordRef;
        ItemNo: code[20];
    begin
        // poner los ID de cliente
        IF CRMIntegrationRecord.FindRecordIDFromID("Item ID", Database::Item, AccountId) then begin
            if ItemRecRef.get(AccountId) then begin
                ItemNo := format(ItemRecRef.field(Item.FieldNo("No.")));
                UpdateAccountIdItem(ItemNo);
            end;
        end;
    end;

    local procedure UpdateAccountIdItem(ItemNo: code[20])
    begin
        if Item.get(ItemNo) then begin
            Rec."No." := item."No.";
            Rec.Description := Item.Description;
            Rec."Description 2" := Item."Description 2";
        end;
    end;

    local procedure UpdateDocNoId()
    var
        SalesQuoteAux: Record "STH Sales Header Aux";
        AccountId: RecordId;
        QuoteRecRef: RecordRef;
        QuoteNo: code[20];
    begin
        IF CRMIntegrationRecord.FindRecordIDFromID("Quote ID", Database::"STH Sales Header Aux", AccountId) then begin
            if QuoteRecRef.get(AccountId) then begin
                QuoteNo := format(QuoteRecRef.field(SalesQuoteAux.FieldNo("No.")));
                Rec."Document No." := QuoteNo;
                // TODO REVISION Rec."Revision ID" := QuoteRecRef.field(SalesQuoteAux.FieldNo("Revision ID");
                if Rec."Line No." = 0 then begin
                    Rec."Line No." := GetLastLineQuoteAux(QuoteNo);
                end;
            end;
        end;
    end;

    local procedure GetLastLineQuoteAux(QuoteNo: code[20]): Integer
    var
        SalesQuoteAuxLin: Record "STH Sales Line Aux";
    begin
        SalesQuoteAuxLin.SetRange("Document No.", QuoteNo);
        if SalesQuoteAuxLin.FindLast() then
            exit(SalesQuoteAuxLin."Line No." + 10000)
        else
            exit(10000);
    end;
}
