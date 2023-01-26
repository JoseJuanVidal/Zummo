page 17450 "ZM Sales Line - Service"
{
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = const(Order));

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                    ApplicationArea = all;
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer No."; SalesHeader."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field(SalesHeaderCustomerName; SalesHeader."Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = all;
                }
                field(PedidoServicio_btc; NPedidoServicio_btc)
                {
                    ApplicationArea = all;
                }
                field(SalesHeaderPostingdate; SalesHeader."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(ServiceHeaderNo; ServiceHeader."No.")
                {
                    ApplicationArea = all;
                }
                field(IsWarranty; ServiceHeader.IsWarranty)
                {
                    ApplicationArea = all;
                }
                field(ServiceHeaderDescription; ServiceHeader.Description)
                {
                    ApplicationArea = all;
                }
                field(ServiceHeaderOperationDescription; ServiceHeader."Operation Description")
                {
                    ApplicationArea = all;
                }
                field(ServiceHeaderOperationDescription2; ServiceHeader."Operation Description 2")
                {
                    ApplicationArea = all;
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        clear(ServiceHeader);
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then;
        NPedidoServicio_btc := GetServiceNoSalesHeader(SalesHeader);
        if ServiceHeader.Get(ServiceHeader."Document Type"::Order, NPedidoServicio_btc) then;
    end;

    var
        SalesHeader: Record "Sales Header";
        ServiceHeader: Record "Service Header";
        NPedidoServicio_btc: code[20];

    local procedure GetServiceNoSalesHeader(auxSalesHeader: Record "Sales Header"): code[20]
    var
        RecRef: RecordRef;
        FieldR: FieldRef;
    begin
        RecRef.GetTable(auxSalesHeader);
        if RecRef.FieldExist(50613) then begin   // PedidoServicio_sga_btc
            FieldR := RecRef.Field(50613);
            exit(FieldR.Value);
        end;
    end;
}