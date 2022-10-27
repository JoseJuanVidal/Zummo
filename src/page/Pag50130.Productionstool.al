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
                field("Last date revision"; Rec."Last date revision")
                {
                    ApplicationArea = All;
                }
                field(Periodicity; Rec.Periodicity)
                {
                    ApplicationArea = All;
                }
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


    trigger OnAfterGetRecord()
    begin
        vComments := GetComments;
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
