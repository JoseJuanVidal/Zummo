page 50130 "Productions tool"
{
    Caption = 'Productions tool', Comment = 'ESP="Utiles producción"';
    PageType = Card;
    SourceTable = "ZM Productión Tools";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
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
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
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
            group(date)
            {
                ShowCaption = false;

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                }

                field(Periodicity; Rec.Periodicity)
                {
                    ApplicationArea = All;
                }
                field("Last date revision"; Rec."Last date revision")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Next date revision"; "Next date revision")
                {
                    ApplicationArea = all;
                }
                group(Observations)
                {
                    Caption = 'Observations', comment = 'ESP="Observaciones"';

                    field(Comments; vComments)
                    {
                        ShowCaption = false;
                        MultiLine = true;

                        trigger OnValidate()
                        begin
                            SetComments(vComments);
                        end;
                    }
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
        area(Processing)
        {
            action(CreateRevision)
            {
                ApplicationArea = all;
                Caption = 'New Calibration', comment = 'ESP="Nueva Calibración"';
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CreateRevisions;
                end;


            }
        }
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
        vComments := GetComments;

        CurrPage."Attached Documents".Page.SetTableNo(50152, Rec.Code, 0);
        CurrPage."Attached Documents".Page.SetProdTools_RecordRef(Rec);
    end;

    var
        vComments: Text;

    local procedure GetComments(): Text
    begin
        CALCFIELDS(Rec.Comments);
        EXIT(GetCommentsCalculated);
    end;

    local procedure GetCommentsCalculated(): Text
    var
        TempBlob: record TempBlob;
        CR: text;
    begin
        IF NOT Rec.Comments.HASVALUE THEN
            EXIT('');

        CR[1] := 10;
        TempBlob.Blob := Rec.Comments;
        EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::UTF8));
    end;

    local procedure SetComments(NewComments: text);
    var
        TempBlob: record TempBlob;
    begin
        CLEAR(Comments);
        IF vComments = '' THEN
            EXIT;
        TempBlob.Blob := Rec.Comments;
        TempBlob.WriteAsText(NewComments, TEXTENCODING::UTF8);
        Rec.Comments := TempBlob.Blob;
        MODIFY;
    end;
}
