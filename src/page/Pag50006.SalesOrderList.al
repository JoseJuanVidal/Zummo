page 50006 "SalesOrderList"
{

    PageType = List;
    SourceTable = "Sales Header";
    Caption = 'Sales Order List', comment = 'ESP="Lista Pedidos Almacén"';
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }

                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {

                }
                field(ComentarioInterno_btc; ComentarioInterno_btc)
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Quote Valid Until Date"; "Quote Valid Until Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                { }
                field(Shipped; Shipped)
                { }
                field("Completely Shipped"; "Completely Shipped")
                {
                    ApplicationArea = All;
                }

            }
        }
    }


    procedure GetResult(VAR SalesHeader: Record "Sales Header")
    begin
        CurrPage.SETSELECTIONFILTER(SalesHeader);
    end;
}
