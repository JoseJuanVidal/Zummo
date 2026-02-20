page 17090 "ZM Ventas Maquina KPI OOB"
{
    Caption = 'Ventas Maquina KPI OOB', comment = 'ESP="Ventas Maquina KPI OOB"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Invoice Line";
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; "Document No.")
                { }
                field("Posting Date"; "Posting Date")
                { }
                field("No."; "No.")
                { }
                field(Description; Description)
                { }
                field(Quantity; Quantity)
                { }
                field(desClasVtas_btc; desClasVtas_btc)
                { }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                { }
            }
        }
    }


    trigger OnOpenPage()
    begin
        CargaTemporal();
    end;

    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesCRMemoLine: Record "Sales Cr.Memo Line";
        Windows: Dialog;

    local procedure CargaTemporal()
    begin
        Windows.Open('Nº documento #1#################\Linea #2##############');
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetFilter(selClasVtas_btc, '10|15|40|50');
        if SalesInvLine.FindFirst() then
            repeat
                Windows.Update(1, SalesInvLine."Document No.");
                Windows.Update(2, SalesInvLine."Line No.");
                Rec.Init();
                Rec.TransferFields(SalesInvLine);
                Rec.Insert();
            Until SalesInvLine.next() = 0;
        SalesCRMemoLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesCRMemoLine.SetFilter(selClasVtas_btc, '10|15|40|50');
        if SalesCRMemoLine.FindFirst() then
            repeat
                Windows.Update(1, SalesCRMemoLine."Document No.");
                Windows.Update(2, SalesCRMemoLine."Line No.");
                Rec.Init();
                Rec.TransferFields(SalesCRMemoLine);
                Rec.Quantity := -SalesCRMemoLine.Quantity;
                Rec.Insert();
            Until SalesCRMemoLine.next() = 0;

        Windows.Close();
    end;
}

