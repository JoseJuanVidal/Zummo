page 60021 "STH API POST Currency"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Currency';
    // EntityCaption = 'STH API Currency';
    // EntitySetCaption = 'STH API Currency';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostCurrency';
    EntitySetName = 'sthPostCurrency';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = Currency;
    //Editable = false;
    SourceTableTemporary = true;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }
    var
        currency: Record "Currency";
        actionHTTP: Text;
        result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if currency.Get(Rec.Code) then begin
                        currency.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    if currency.Get(Rec.Code) then
                        Error('El registro ya existe %1', Rec.Code);

                    currency.Init();
                    currency.TransferFields(Rec);
                    currency.Insert();
                end;
            'PATCH':
                begin
                    if currency.Get(Rec.Code) then begin
                        currency.TransferFields(Rec);
                        currency.Modify();
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;
}