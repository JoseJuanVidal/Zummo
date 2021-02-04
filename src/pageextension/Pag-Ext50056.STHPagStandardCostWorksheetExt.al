pageextension 50056 "STHPagStandardCostWorksheetExt" extends "Standard Cost Worksheet"
{
    layout
    {
        addlast(Content)
        {
            field(LastUnitCost; LastUnitCost)
            {
                ApplicationArea = all;
            }
        }
    }
}
