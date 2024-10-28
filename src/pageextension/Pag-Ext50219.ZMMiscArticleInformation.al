pageextension 50219 "ZM Misc. Article Information" extends "Misc. Article Information"
{
    layout
    {
        addafter("Employee No.")
        {
            field("Employee Name"; "Employee Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addbefore("Serial No.")
        {
            field("Device Type"; "Device Type")
            {
                ApplicationArea = all;
            }
            field(Model; Model)
            {
                ApplicationArea = all;
            }
        }
        addlast(FactBoxes)
        {
            part("Attachment Document"; "ZM Document Attachment Factbox")
            {
                ApplicationArea = all;
                Caption = 'Attachment Document', comment = 'ESP="Documentos adjuntos"';
                SubPageLink = "Table ID" = const(5214), "No." = field("Misc. Article Code"), "Line No." = field("Line No.");
            }
        }
    }
    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        RefRecord: recordRef;
    begin
        RefRecord.Get(Rec.RecordId);
        CurrPage."Attachment Document".Page.SetTableNo(5214, Rec."Misc. Article Code", Rec."Line No.", RefRecord);
    end;

    var
        Employee: Record Employee;
}