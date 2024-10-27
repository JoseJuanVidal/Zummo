page 17215 "Purchase Request less 200 List"
{
    Caption = 'Purchase Request less 200', Comment = 'ESP="Compra menor 200"';
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    PageType = List;
    SourceTable = "Purchase Requests less 200";
    UsageCategory = None;
    CardPageId = "Purchase Request less 200 Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                // field(Quantity; Rec.Quantity)
                // {
                //     ApplicationArea = All;
                // }
                // field("Unit Price"; "Unit Price")
                // {
                //     ApplicationArea = all;
                // }
                // field(Amount; Rec.Amount)
                // {
                //     ApplicationArea = All;
                // }
                // field("Currency Code"; "Currency Code")
                // {
                //     ApplicationArea = all;
                // }
                // field("No. Series"; Rec."No. Series")
                // {
                //     ApplicationArea = All;
                //     Visible = false;
                // }
                // field(Status; Status)
                // {
                //     ApplicationArea = all;
                // }
                // field("Purchase Invoice"; "Purchase Invoice")
                // {
                //     ApplicationArea = all;
                // }
                // field("G/L Entry"; "G/L Entry")
                // {
                //     ApplicationArea = all;
                // }
                // field("User Id"; "User Id")
                // {
                //     ApplicationArea = all;
                //     Visible = false;
                // }
                // field("Codigo Empleado"; "Codigo Empleado")
                // {
                //     ApplicationArea = all;
                //     Visible = false;
                // }
                // field("Nombre Empleado"; "Nombre Empleado")
                // {
                //     ApplicationArea = all;
                //     Visible = false;
                // }
            }
        }
    }
}
