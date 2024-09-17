tableextension 50194 "ZM Ext Gen. Journal Line" extends "Gen. Journal Line"
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
        GenJnlLine: Record "Gen. Journal Line";
        PurchaseRequest: Record "Purchase Requests less 200";
        AutLoginMgt: Codeunit "AUT Login Mgt.";
        ExistInvoiced: Boolean;
        lblError: Label 'La solicitud ya ha sido facturada en el documento %1', comment = 'ESP="La solicitud ya ha sido facturada en el documento %1"';
        lblMaxRequest: Label 'El importe %1 es diferente de la solicitud %2.', comment = 'ESP="El importe %1 es diferente de la solicitud %2."';
        lblDimensionPurchLine: Label '¿Desea actualizar las dimensiones partida %1 y detalle %2 de las líneas?', comment = 'ESP="¿Desea actualizar las dimensiones partida %1 y detalle %2 de las líneas?"';
    begin
        if Rec."Purch. Request less 200" = '' then
            exit;
        PurchaseRequest.Get(Rec."Purch. Request less 200");
        if Rec."Purch. Request less 200" = xRec."Purch. Request less 200" then
            exit;
        if Rec."Purch. Request less 200" = '' then
            exit;
        // si ya esta en un historico de facturas
        PurchaseRequest.CalcFields("Purchase Invoice");
        if PurchaseRequest."Purchase Invoice" <> '' then
            Error(lblError, PurchaseRequest."Purchase Invoice");

        // si esta asignado a una factura de compra pendiente de registrar
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        PurchaseHeader.SetRange("Purch. Request less 200", Rec."Purch. Request less 200");
        if PurchaseHeader.FindFirst() then
            Error(lblError, PurchaseHeader."No.");

        // miramos si está asignado a otra linea de Diario General
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Purch. Request less 200", Rec."Purch. Request less 200");
        if GenJnlLine.FindFirst() then
            repeat
                if (GenJnlLine."Journal Template Name" <> Rec."Journal Template Name") or (GenJnlLine."Line No." <> Rec."Line No.") then
                    Error(lblError, StrSubstNo('%1 %2', GenJnlLine."Journal Template Name", GenJnlLine."Line No."));
            Until GenJnlLine.next() = 0;

        // Si el importe es el mismo que el de la solicitud                  
        if abs(Rec.Amount) <> abs(PurchaseRequest.Amount) then
            Error(lblMaxRequest, abs(GenJnlLine.Amount), abs(PurchaseRequest.Amount));

    end;
}