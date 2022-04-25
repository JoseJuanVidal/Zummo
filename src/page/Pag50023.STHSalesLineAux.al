page 50023 "STH Sales Line Aux"
{
    Caption = 'Sales Line Aux', Comment = 'ESP="Lineas Aux"';
    PageType = ListPart;
    SourceTable = "STH Sales Line Aux";
    UsageCategory = Lists;
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                // {
                //     ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                //     ApplicationArea = All;
                //     // Visible = false;
                //     TableRelation = "STH Sales Header Aux"."Sell-to Customer No.";
                // }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                    Visible = false;
                    TableRelation = "STH Sales Header Aux"."No.";
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the value of the Line Discount % field.';
                    ApplicationArea = All;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ToolTip = 'Specifies the value of the Line Discount Amount field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.';
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ToolTip = 'Specifies the value of the Amount Including VAT field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
