page 50129 "Productions tools"
{
    ApplicationArea = All;
    Caption = 'Productions tool', Comment = 'ESP="Lista Utiles calidad"';
    PageType = List;
    SourceTable = "ZM Productión Tools";
    UsageCategory = Lists;
    CardPageId = "Productions tool";
    //Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Use; Use)
                {
                    ApplicationArea = all;
                }
                field(Bin; Bin)
                {
                    ApplicationArea = all;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }

                field(Periodicity; Rec.Periodicity)
                {
                    ApplicationArea = All;
                }
                field(Units; Units)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Last date revision"; Rec."Last date revision")
                {
                    ApplicationArea = All;
                }
                field("Next date revision"; "Next date revision")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Resolution; Rec.Resolution)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "ZM Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments', Comment = 'ESP="Doc. Adjuntos"';
                SubPageLink = "Table ID" = CONST(50152), "No." = FIELD(Code), "Line No." = const(0);
            }
        }

    }

    actions
    {
        area(Navigation)
        {
            action(ShowProdToolLdgEntry)
            {
                ApplicationArea = all;
                Caption = 'Prod. Tools Ledger Entrys', comment = 'ESP="Movs. Utiles Prod."';
                Image = Ledger;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowProdToolLdgEntrys;
                end;


            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage."Attached Documents".Page.SetTableNo(50152, Rec.Code, 0);
        CurrPage."Attached Documents".Page.SetProdTools_RecordRef(Rec);

    end;
}

