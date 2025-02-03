page 17219 "ZM Job Clafication"
{
    Caption = 'Job Clasification', comment = 'ESP="Clasificación"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM JOB Clasification";
    DataCaptionExpression = SetCaption;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Code)
                {
                    ApplicationArea = all;
                }
                field("Field No."; "Field No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
            }
        }
    }
    var
        Job: Record Job;
        lblCaption: Label 'Clasification', comment = 'ESP="Clasificación"';

    local procedure SetCaption(): Text
    var
        myInt: Integer;
    begin
        if rec.GetFilter("Field No.") = '' then
            exit(lblCaption);
        case Rec.GetFilter("Field No.") of
            '50010':
                exit(Job.FieldCaption(Machine));
            '50020':
                exit(Job.FieldCaption(Typology));
            '50030':
                exit(Job.FieldCaption(Criticality));
            '50040':
                exit(Job.FieldCaption(Laboratory));

        end;
    end;
}