page 50149 "API Sales Quote Line"
{
    PageType = ListPart;
    SourceTable = "Sales Line";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(DocumentNo; "Document No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        InsertData();
                    end;
                }
                field(ItemNo; ItemNo)
                {
                    ApplicationArea = All;
                }
                field(ItemDescription; ItemDescription)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        ITEMOnValidate;
                    end;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var

    begin

    end;

    local procedure InsertData()
    var
        SalesLine: Record "Sales Line";
        LineNo: Integer;
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
        SalesLine.SetRange("Document No.", Rec."Document No.");
        if not SalesLine.FindLast() then
            LineNo := 10000
        else
            LineNo := SalesLine."Line No." + 10000;

        Rec.Validate("Document Type", Rec."Document Type"::Quote);
        Rec.Validate("Line No.", LineNo);
        Rec.Validate(Type, SalesLine.Type::Item);
    end;

    local procedure ITEMOnValidate()
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then begin
            Rec.Validate(Type, Rec.Type::" ");
            Rec.Validate(Description, ItemDescription);
        end else begin
            // Aqui controlamos si el producto está bloqueado
            if Item.Blocked then begin
                Rec.Validate(Type, Rec.Type::Item);
                Rec."No." := ItemNo;
                Rec.Description := Item.Description;
            end else begin
                Rec.Validate(Type, Rec.Type::Item);
                Rec.Validate("No.", ItemNo);
            end;
        end;
    end;

    var
        ItemNo: Code[20];
        Quantity: Decimal;
        DocumentNo: Code[20];
        ItemDescription: Text;
}