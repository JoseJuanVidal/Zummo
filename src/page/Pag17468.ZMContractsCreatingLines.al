page 17468 "ZM Contracts Creating Lines"
{
    PageType = Document;
    SourceTable = "ZM Contracts/supplies Lines";
    SourceTableTemporary = true;
    AutoSplitKey = true;
    Caption = 'Crear Pedido Compra', Comment = 'ESP="Crear Pedido Compra"';
    DataCaptionFields = "Document No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    RefreshOnActivate = true;
    DeleteAllowed = false;

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
                    Caption = 'No.', Comment = 'ESP="Nº"';
                }
                field(ContractsVendorNo; Contracts."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                    Caption = 'Buy-from Vendor No.', Comment = 'ESP="Compra a-Nº proveedor"';
                }
                field(ContractsVendorName; Contracts."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                    Caption = 'Buy-from Vendor Name', Comment = 'ESP="Compra a-Nombre"';
                }
                field(ContractNoVendor; Contracts."Contract No. Vendor")
                {
                    ApplicationArea = all;
                    Caption = 'Contract No. Vendor', Comment = 'ESP="Nº contrato proveedor"';
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
                field("Global Dimension 1 code"; "Global Dimension 1 code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 code"; "Global Dimension 2 code")
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
                field("Global Dimension 3 code"; "Global Dimension 3 code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    CaptionClass = '1,2,3';
                }
                field("Global Dimension 4 code"; "Global Dimension 4 code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    CaptionClass = '1,2,4';
                }
                field("Global Dimension 5 code"; "Global Dimension 5 code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    CaptionClass = '1,2,5';
                }
                field("Global Dimension 6 code"; "Global Dimension 6 code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    CaptionClass = '1,2,6';
                }
                field("Global Dimension 7 code"; "Global Dimension 7 code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    CaptionClass = '1,2,7';
                }
                field("Global Dimension 8 code"; "Global Dimension 8 code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    CaptionClass = '1,2,8';
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
