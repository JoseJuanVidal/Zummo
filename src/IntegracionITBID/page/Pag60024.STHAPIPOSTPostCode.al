page 60024 "STH API POST Post Code"
{
    APIGroup = 'sothiGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Post Code';
    // EntityCaption = 'STH API Post Code';
    // EntitySetCaption = 'STH API Post Code';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostPostCode';
    EntitySetName = 'sthPostPostCode';
    ODataKeyFields = "Code", City;
    PageType = API;
    SourceTable = "Post Code";
    SourceTableTemporary = true;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(id; Rec.Id)
                // {
                //     Caption = 'Id';
                // }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                }
                field(County; Rec.County)
                {
                }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }
    var
        postCode: Record "Post Code";
        actionHTTP: Text;
        result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if postCode.Get(Rec.Code, Rec.City) then begin
                        postCode.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    if postCode.Get(Rec.Code, Rec.City) then
                        Error('El registro ya existe %1', Rec.Code, Rec.City);

                    postCode.Init();
                    postCode.TransferFields(Rec);
                    postCode.Insert();
                end;
            'PATCH':
                begin
                    // if postCode.Get(Rec.Code, Rec.City) then begin
                    //     postCode.TransferFields(Rec);
                    //     postCode.Modify();
                    // end;
                    Error('No se permite modificar directamente los registros, consulte la documentación');
                end;
        end;
        result := 'Success';
        exit(false);
    end;
}
