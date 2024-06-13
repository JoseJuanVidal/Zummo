codeunit 60000 "STH Zummo Events"
{
    [EventSubscriber(ObjectType::Table, database::Item, 'OnAfterModifyEvent', '', true, true)]
    local procedure Item_OnAfterModifyEvent(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    begin
        if Rec.isTemporary then
            exit;

        checkModifyItemFields(Rec, xRec);
    end;

    local procedure checkModifyItemFields(var Rec: Record Item; var xRec: Record Item)
    begin
        if (Rec."No." <> xRec."No.")
            OR (Rec.Description <> xRec.Description)
            OR (Rec."Purch. SubCategory" <> xRec."Purch. SubCategory")
            OR (Rec."Base Unit of Measure" <> xRec."Base Unit of Measure")
            OR (Rec."Unit Cost" <> xRec."Unit Cost")
            OR (Rec.Inventory <> xRec.Inventory)
            OR (Rec."Safety Stock Quantity" <> xRec."Safety Stock Quantity") then begin

            Rec."STH To Update" := true;
            Rec.Modify();

            CrearTareaPutItem(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Comment Line", 'OnAfterModifyEvent', '', true, true)]
    local procedure Comments_OnAfterModifyEvent_OnlyItems(var Rec: Record "Comment Line"; var xRec: Record "Comment Line"; RunTrigger: Boolean)
    begin
        if Rec.isTemporary then
            exit;

        if Rec."Table Name" = Rec."Table Name"::Item then
            checkModifyItemCommentsFields(Rec, xRec);
    end;

    local procedure checkModifyItemCommentsFields(var Rec: Record "Comment Line"; var xRec: Record "Comment Line")
    var
        items: Record Item;
    begin
        repeat
            if Rec.Comment <> xRec.Comment then begin
                if items.Get(Rec."No.") then begin
                    items."STH To Update" := true;
                    items.Modify();
                    CrearTareaPutItem(items);
                end;
            end;
        until (Rec.Next() = 0) AND (xRec.Next() = 0);
    end;

    local procedure CrearTareaPutItem(var productos: Record Item)
    begin
        TaskScheduler.CreateTask(Codeunit::"STH Create Task Process", Codeunit::"STH Task Scheduler Failure", true, CompanyName, CurrentDateTime + 2000, productos.RecordId);
    end;
}