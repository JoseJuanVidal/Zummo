pageextension 50126 "WorkCenterList" extends "Work Center List"
{
    actions
    {
        addafter("&Calendar")
        {
            action(WorkCenterCalendar)
            {
                ApplicationArea = all;
                Caption = 'Cap. Product and Work Center', comment = 'ESP="Cap. Producto y Centro Trabajo"';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page PagePrincipalMatrices;
            }
        }
    }
}