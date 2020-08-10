page 50142 "ReqWkshNames"
{
    PageType = List;
    SourceTable = "Requisition Wksh. Name";
    Caption = 'Hojas planificacion', comment = 'ESP="Hojas planificacion"';
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Name) { }

            }
        }
    }


    procedure GetResult(VAR SalesHeader: Record "Requisition Wksh. Name")
    begin
        CurrPage.SETSELECTIONFILTER(SalesHeader);
    end;
}
