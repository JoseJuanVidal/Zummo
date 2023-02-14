page 17451 "ZM Purch. Line Plastic"
{
    Caption = 'Purch. Line Plastic', Comment = 'ESP="Líneas Ped. Compra (Plastico)"';
    PageType = List;
    SourceTable = "Purchase Line";
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            Group(Options)
            {
                field(Total; Total)
                {
                    ApplicationArea = all;
                    Caption = 'Total Plastic KG', comment = 'ESP="Total KG Plástico"';
                }
            }
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Salvage Value"; Rec."Salvage Value")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Plastic packing (kg)', comment = 'ESP="Plástico embalaje proveedor (kg)"';
                    DecimalPlaces = 5 : 5;
                }
                field(LineTotal; LineTotal)
                {
                    ApplicationArea = all;
                    Caption = 'Total', comment = 'ESP="Total"';
                    DecimalPlaces = 5 : 5;
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        LineTotal := Rec."Quantity (Base)" * Rec."Salvage Value";
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then;
        Total := Funciones.PurchaseOrderCalcPlasticVendor(PurchaseHeader);
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        Funciones: Codeunit Funciones;
        LineTotal: Decimal;
        Total: Decimal;
}
