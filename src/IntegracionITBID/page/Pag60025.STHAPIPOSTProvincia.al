page 60025 "STH API POST Provincia"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Provincia';
    // EntityCaption = 'STH API Provincia';
    // EntitySetCaption = 'STH API Provincia';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostProvincia';
    EntitySetName = 'sthPostProvincia';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = "Area";
    // Editable = false;
    SourceTableTemporary = true;

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
                field("text"; Rec."Text")
                {
                    Caption = 'Text';
                }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }
    var
        provincia: Record "Area";
        actionHTTP: Text;
        result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if provincia.Get(Rec.Code) then begin
                        provincia.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    if provincia.Get(Rec.Code) then
                        Error('El registro ya existe %1', Rec.Code);

                    provincia.Init();
                    provincia.TransferFields(Rec);
                    provincia.Insert();
                end;
            'PATCH':
                begin
                    if provincia.Get(Rec.Code) then begin
                        provincia.TransferFields(Rec);
                        provincia.Modify();
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;
}
