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
                    StyleExpr = StyleTxt;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field(Use; Use)
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                }
                field(Bin; Bin)
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }

                field(Periodicity; Rec.Periodicity)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field(Units; Units)
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                }
                field("Last date revision"; Rec."Last date revision")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Next date revision"; "Next date revision")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field(Resolution; Rec.Resolution)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
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
    var
        RefRecord: recordRef;
    begin
        RefRecord.Get(Rec.RecordId);
        CurrPage."Attached Documents".Page.SetTableNo(50152, Rec.Code, 0, RefRecord);
        CurrPage."Attached Documents".Page.SetProdTools_RecordRef(Rec);

        // en rojo los que se tienen que revisar este mes
        if Rec.RevisionThisMonth() then
            StyleTxt := 'Unfavorable'
        else
            StyleTxt := 'Standard';
    end;

    var
        StyleTxt: Text;
}

