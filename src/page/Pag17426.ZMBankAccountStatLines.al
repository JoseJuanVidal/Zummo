page 17426 "ZM Bank Account Stat. Lines"
{
    Caption = 'Bank Account Stat. Lines', comment = 'ESP="Líneas de Extracto bancario"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "Bank Account Statement Line";
    PromotedActionCategories = 'New,Process,Report,Navigate', Comment = 'ESP="Nuevo,Procesar,Informe,Navegar"';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                Caption = 'Lines', comment = 'ESP="Líneas"';
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Statement No."; "Statement No.")
                {
                    ApplicationArea = all;
                }
                field("Statement Line No."; "Statement Line No.")
                {
                    ApplicationArea = all;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = all;
                }
                field("Value Date"; "Value Date")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Statement Amount"; "Statement Amount")
                {
                    ApplicationArea = all;
                }
                field("Applied Amount"; "Applied Amount")
                {
                    ApplicationArea = all;
                }
                field(Difference; Difference)
                {
                    ApplicationArea = all;
                }
                field("Applied Entries"; "Applied Entries")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Showdocument)
            {
                ApplicationArea = All;
                Caption = 'Show Document', comment = 'ESP="Muestra documento"';
                Image = BankAccountStatement;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = page "Bank Account Statement";
                RunPageLink = "Statement No." = field("Statement No.");


            }
        }
    }

    var
        myInt: Integer;
}