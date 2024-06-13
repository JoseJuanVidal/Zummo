page 60017 "STH API POST Payment Day"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Payment Day';
    // EntityCaption = 'STH Payment Day';
    // EntitySetCaption = 'STH Payment Day';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostPaymentDay';
    EntitySetName = 'sthPostPaymentDay';
    ODataKeyFields = Code;
    PageType = API;
    SourceTable = "Payment Day";
    SourceTableTemporary = true;
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
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(dayOfTheMonth; Rec."Day of the month")
                {
                    Caption = 'Day of the month';
                }
                field(newDay; newDay)
                {

                }
                field(actionHTTP; actionHTTP)
                {
                }
                field(result; result) { }
            }
        }
    }

    var
        paymentDay: Record "Payment Day";
        actionHTTP: Text;
        newDay: Integer;
        result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    paymentDay.SetRange("Table Name", paymentDay."Table Name"::Vendor);
                    paymentDay.SetRange(Code, Rec.Code);
                    paymentDay.SetRange("Day of the month", Rec."Day of the month");
                    if paymentDay.FindFirst() then begin
                        paymentDay.Delete();
                    end;
                    result := 'Success';
                    exit(true);
                end;
            'POST':
                begin
                    paymentDay.SetRange("Table Name", paymentDay."Table Name"::Vendor);
                    paymentDay.SetRange(Code, Rec.Code);
                    paymentDay.SetRange("Day of the month", Rec."Day of the month");
                    if paymentDay.FindFirst() then
                        Error('El registro ya existe %1 %2', Rec.Code, Rec."Day of the month");

                    paymentDay.Init();
                    paymentDay.TransferFields(Rec);
                    paymentDay.Insert();
                end;
            'PATCH':
                begin
                    paymentDay.SetRange("Table Name", paymentDay."Table Name"::Vendor);
                    paymentDay.SetRange(Code, Rec.Code);
                    paymentDay.SetRange("Day of the month", Rec."Day of the month");
                    if paymentDay.FindFirst() then begin
                        //if paymentDay.Get("Table Name"::Vendor, Rec.Code) then begin
                        paymentDay.Rename(paymentDay."Table Name"::Vendor, Rec.Code, newDay);
                        // paymentDay.TransferFields(Rec);
                        // paymentDay.Modify();
                    end;
                end;
        end;
        result := 'Success';
    end;
}
