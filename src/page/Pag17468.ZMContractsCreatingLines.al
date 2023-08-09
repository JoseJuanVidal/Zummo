page 17468 "ZM Contracts Creating Lines"
{
    PageType = List;
    SourceTable = "ZM Contracts/supplies Lines";
    SourceTableTemporary = true;
    AutoSplitKey = true;
    Caption = 'Crear ´Pedidio Compra', Comment = 'ESP="Crear ´Pedidio Compra"';
    DataCaptionFields = "Document No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field(ContractsNo; Contracts."No.")
                {
                    ApplicationArea = all;
                }
                field(ContractsVendorNo; Contracts."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(ContractsVendorName; Contracts."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                }
                field(ContractNoVendor; Contracts."Contract No. Vendor")
                {
                    ApplicationArea = all;
                }
            }
            repeater(Lines)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = EditType;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                    Editable = EditNo;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Precio negociado"; Rec."Precio negociado")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Unidades; Unidades)
                {
                    ApplicationArea = all;
                }
                field("Unit of measure"; "Unit of measure")
                {
                    ApplicationArea = all;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = all;
                }
                field("Dimension 1 code"; "Dimension 1 code")
                {
                    ApplicationArea = all;
                }
                field("Dimension 2 code"; "Dimension 2 code")
                {
                    ApplicationArea = all;
                }
                field("Minimum Order Quantity"; "Minimum Order Quantity")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Order Multiple"; "Order Multiple")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Contracts.Get(Rec."Document No.") then;

        ApplyEditable;
    end;

    var
        Contracts: Record "ZM Contracts/Supplies Header";
        EditType: Boolean;
        EditNo: Boolean;

    local procedure ApplyEditable()
    var
        myInt: Integer;
    begin
        EditType := Rec.Type in [Rec.Type::" "];
        EditNo := Rec."No." = '';
    end;

    procedure AddContractLines(ContractsLine: Record "ZM Contracts/Supplies Lines")
    var
    begin
        Rec.Init();
        Rec.Copy(ContractsLine);
        Rec.Validate(Unidades, 0);
        Rec.Insert();
        if Rec.FindFirst() then;
    end;

    procedure GetContractLines(var tmpContractsLine: Record "ZM Contracts/Supplies Lines")
    var
    begin
        if Rec.FindFirst() then
            repeat
                tmpContractsLine.Init();
                tmpContractsLine.Copy(Rec);
                tmpContractsLine.Insert();
            Until Rec.next() = 0;
    end;
}
