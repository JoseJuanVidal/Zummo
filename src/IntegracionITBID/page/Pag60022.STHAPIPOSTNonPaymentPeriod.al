page 60022 "STH API POST Non-PaymentPeriod"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Non-Payment Period';
    // EntityCaption = 'STH API Non-Payment Period';
    // EntitySetCaption = 'STH API Non-Payment Period';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostNonPaymentPeriod';
    EntitySetName = 'sthPostNonPaymentPeriod';
    ODataKeyFields = "Table Name", Code, "From Date";
    PageType = API;
    SourceTable = "Non-Payment Period";
    // Extensible = false;

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
                field(tableName; Rec."Table Name")
                {

                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(fromDate; Rec."From Date")
                {
                    Caption = 'From Date';
                }
                field(toDate; Rec."To Date")
                {
                    Caption = 'To Date';
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
        nonPaymentPeriod: Record "Non-Payment Period";
        actionHTTP: Text;
        result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if nonPaymentPeriod.Get(Rec."Table Name"::Vendor, Rec.Code, Rec."From Date") then begin
                        nonPaymentPeriod.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    if nonPaymentPeriod.Get(Rec."Table Name"::Vendor, Rec.Code, Rec."From Date") then
                        Error('El registro ya existe %1', Rec.Code);

                    nonPaymentPeriod.Init();
                    nonPaymentPeriod.TransferFields(Rec);
                    nonPaymentPeriod.Insert();
                end;
            'PATCH':
                begin
                    if nonPaymentPeriod.Get(Rec."Table Name"::Vendor, Rec.Code, Rec."From Date") then begin
                        nonPaymentPeriod.TransferFields(Rec);
                        nonPaymentPeriod.Modify();
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;
}