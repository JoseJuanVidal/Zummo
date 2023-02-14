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
                }

                field(Quantity; dQuantity)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        ITEMOnValidate;
                    end;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Source Purch. Order No"; "Source Purch. Order No")
                {
                    ApplicationArea = all;
                }
                field("Source Purch Order Line"; "Source Purch Order Line")
                {
                    ApplicationArea = all;
                }
                field("Source Purch Order Price"; "Source Purch Order Price")
                {
                    ApplicationArea = all;
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
                Rec.Quantity := dQuantity;
                Rec."Quantity (Base)" := dQuantity;
                Rec."Outstanding Quantity" := dQuantity;
                Rec."Outstanding Qty. (Base)" := dQuantity;
            end else begin
                Rec.Validate(Type, Rec.Type::Item);
                Rec.Validate("No.", ItemNo);
                Rec.Validate(Quantity, dQuantity);
            end;
        end;
    end;

    var
        ItemNo: Code[20];
        dQuantity: Decimal;
        DocumentNo: Code[20];
        ItemDescription: Text;
}