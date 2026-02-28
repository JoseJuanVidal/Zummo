page 20350 "ZM Document Register Platforms"
{
    Caption = 'Document Register Platforms', comment = 'ESP="Registro Documentos plataformas"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    SourceTable = "ZM Document Register Platforms";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Document Code"; "Document Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = all;
                }
                field("Platform PRL"; "Platform PRL")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                    ApplicationArea = all;
                }
                field("First Due Date"; "First Due Date")
                {
                    ApplicationArea = all;
                }
                field("Expiration Warning"; "Expiration Warning")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Customer)
            {
                ApplicationArea = all;
                Caption = 'Customer', comment = 'ESP="Cliente"';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Customer No.");
            }
        }
    }
}