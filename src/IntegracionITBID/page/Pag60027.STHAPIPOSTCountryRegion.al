page 60027 "STH API POST Country/Region"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Country Region';
    // EntityCaption = 'STH API Country Region';
    // EntitySetCaption = 'STH API Country Region';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostCountryRegion';
    EntitySetName = 'sthPostCountryRegion';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = "Country/Region";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(euCountryRegionCode; Rec."EU Country/Region Code")
                {
                    Caption = 'EU Country/Region Code';
                }
                field(countyName; Rec."County Name")
                {
                    Caption = 'County Name';
                }
                // field(id; Rec.Id)
                // {
                //     Caption = 'Id';
                // }
                // field(systemId; Rec.SystemId)
                // {
                //     Caption = 'SystemId';
                // }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }
    var
        countryRegion: Record "Country/Region";
        actionHTTP: Text;
        result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if countryRegion.Get(Rec.Code) then begin
                        countryRegion.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    if countryRegion.Get(Rec.Code) then
                        Error('El registro ya existe %1', Rec.Code);

                    countryRegion.Init();
                    countryRegion.TransferFields(Rec);
                    countryRegion.Insert();
                end;
            'PATCH':
                begin
                    if countryRegion.Get(Rec.Code) then begin
                        countryRegion.TransferFields(Rec);
                        countryRegion.Modify();
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;
}