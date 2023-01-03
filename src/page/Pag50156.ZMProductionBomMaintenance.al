page 50156 "ZM Production Bom Maintenance"
{
    Caption = 'Production BOM Maintenance', comment = 'ESP="Gestión de cambios - L. M. Productos"';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Ledger Entry Matching Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Options)
            {
                Caption = 'Options', comment = 'ESP="Opciones"';
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No. change', comment = 'ESP="Cód. producto"';
                    ToolTip = 'Select L.M. containing', comment = 'ESP="Seleccionar L.M. que contengan"';

                    TableRelation = Item;

                    trigger OnValidate()
                    begin
                        ValidateItemNo();
                    end;
                }
                field(ItemDescription; ItemDescription)
                {
                    ApplicationArea = all;
                    Caption = 'Description', comment = 'ESP="Descripción"';
                    Editable = false;
                }
                field(Tasks; Tasks)
                {
                    ApplicationArea = all;
                    Caption = 'Tasks', comment = 'ESP="Tareas"';
                    ToolTip = 'Indicate the action to be taken in the BOM components', comment = 'ESP="Indique la acción a realizar en los componentes de la listas de materiales"';

                    trigger OnValidate()
                    begin
                        ChangeTask();
                    end;
                }
            }
            group(ChangeDades)
            {
                Caption = 'Change dades', comment = 'ESP="Cambiar datos"';
                Visible = not notShowChangeDate;

                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = all;
                    Caption = 'Quantity per', comment = 'ESP="Cantidad por"';
                    ToolTip = 'Indicate the new "Quantity per" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Cantidad por" a actualizar en las listas de materiales"';
                    DecimalPlaces = 5 : 5;

                }
                field("Remaining Amt. Incl. Discount"; "Remaining Amt. Incl. Discount")
                {
                    ApplicationArea = all;
                    Caption = 'Quantity añadir', comment = 'ESP="Cantidad añadir"';
                    ToolTip = 'Indicate the add Quantity to be updated in the BOM', comment = 'ESP="Indicar la cantidad añadir para actualizar en las listas de materiales"';
                    DecimalPlaces = 5 : 5;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'Unit of measure', comment = 'ESP="Unidad de medida"';
                    ToolTip = 'Indicate the new "Unit of measure" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Unidad de medida" a actualizar en las listas de materiales"';
                    TableRelation = "Item Unit of Measure" where("Item No." = field("Account No."));
                }
                // field()
                // {
                //     ApplicationArea = all;
                //     Caption = '', comment = 'ESP=""';
                // }
            }
            group(LMChange)
            {
                Caption = 'Changes in Estructure', comment = 'ESP="Cambios en Estructura"';
                Visible = ShowChangeItem;
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = all;
                    Caption = 'New Product Code', comment = 'ESP="Nuevo Cód. Producto"';
                    TableRelation = Item;

                    trigger OnValidate()
                    begin
                        ValidateNewItemNo();
                    end;
                }
                field(NewItemDescription; NewItemDescription)
                {
                    ApplicationArea = all;
                    Caption = 'Description', comment = 'ESP="Descripción"';
                    Editable = false;
                }
                field("New Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = all;
                    Caption = 'Quantity per', comment = 'ESP="Cantidad por"';
                    ToolTip = 'Indicate the new "Quantity per" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Cantidad por" a actualizar en las listas de materiales"';
                    DecimalPlaces = 5 : 5;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'Unit of measure', comment = 'ESP="Unidad de medida"';
                    ToolTip = 'Indicate the new "Unit of measure" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Unidad de medida" a actualizar en las listas de materiales"';
                    TableRelation = "Item Unit of Measure" where("Item No." = field("Bal. Account No."));
                }
            }
            part(Lines; "ZM Production Bom Check")
            {
                ApplicationArea = All;
                Caption = 'BOM list', comment = 'ESP="Lista de materiales"';
                Editable = false;
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(Check)
            {
                ApplicationArea = All;
                Caption = 'Check', comment = 'ESP="Revisar"';
                Image = Check;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;


                trigger OnAction()
                begin
                    CheckAction;
                end;
            }
            action(Run)
            {
                ApplicationArea = All;
                Caption = 'Run', comment = 'ESP="Realizar"';
                Image = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    RunAction;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.Caption := 'Productos';
    end;

    trigger OnOpenPage()
    begin

        if not Rec.Get() then
            Rec.Insert();
    end;

    var
        Item: Record Item;
        ItemNoChange: code[20];
        ItemDescription: Text[100];
        NewItemDescription: Text[100];
        Tasks: Enum "ZM Task Production Bom change";
        notShowChangeDate: Boolean;
        ShowChangeItem: Boolean;
        lblConfirmChanges: Label 'The data in the BOM list will be updated.\%1 %2\%3 %4\¿Do you want to continue?',
            comment = 'ESP="Se van a actualizar los datos en la lista de materiales.\%1 %2\%3 %4\¿Desea continuar?"';
        lblConfirmChangesQtyper: Label 'Quantity per', comment = 'ESP="Cantidad por"';
        lblConfirmChangesQtyadd: Label 'Quantity add', comment = 'ESP="Cantidad añadir"';
        lblConfirmChangesUnit: Label 'Unit of measure', comment = 'ESP="Unidad de medida"';

    local procedure ChangeTask()
    begin
        notShowChangeDate := true;
        ShowChangeItem := false;
        case tasks of
            Tasks::Change:
                begin
                    notShowChangeDate := false;
                end;
            Tasks::Add:
                begin

                end;
            Tasks::Replace:
                begin
                    ShowChangeItem := true;
                end;
            Tasks::Delete:
                begin
                    ShowChangeItem := true;
                end;

        end;
    end;

    local procedure ValidateItemNo()
    begin
        ItemDescription := '';
        item.Reset();
        if Item.Get(Rec."Account No.") then begin
            ItemDescription := Item.Description;
            Rec."Document No." := Item."Base Unit of Measure";
        end;
    end;

    local procedure ValidateNewItemNo()
    begin
        NewItemDescription := '';
        item.Reset();
        if Item.Get(Rec."Bal. Account No.") then begin
            NewItemDescription := Item.Description;
            Rec."External Document No." := Item."Base Unit of Measure";
        end;

    end;

    local procedure CheckAction()
    begin
        // actualizamos la lista de materiales, cuales entran en filtro
        CurrPage.Lines.Page.UpdateBom(Rec."Account No.");
    end;

    local procedure RunAction()
    var
        myInt: Integer;
    begin
        case tasks of
            Tasks::Change:
                begin
                    UpdateBomDades();
                end;
            Tasks::Add:
                begin

                end;
            Tasks::Replace:
                begin
                    ShowChangeItem := true;
                end;
            Tasks::Delete:
                begin
                    ShowChangeItem := true;
                end;

        end;

    end;

    procedure UpdateBomDades()
    var
        ProductionBomLine: Record "Production BOM Line";
        Confirmparam: text;
        Qty: Decimal;
        LineNo: Integer;
    begin
        if Rec."Remaining Amount" <> 0 then begin
            Confirmparam := lblConfirmChangesQtyper;
            Qty := Rec."Remaining Amount"
        end else begin
            Confirmparam := lblConfirmChangesQtyadd;
            Qty := Rec."Remaining Amt. Incl. Discount";
        end;

        if not Confirm(lblConfirmChanges, false, Confirmparam, Qty, lblConfirmChangesUnit, Rec."Document No.") then
            exit;

        ProductionBomLine.Reset();
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        ProductionBomLine.SetRange("No.", Rec."Account No.");
        if ProductionBomLine.FindFirst() then
            repeat
                // actualizamos los datos con los cambios
                if Rec."Remaining Amount" <> 0 then
                    ProductionBomLine."Quantity per" := Rec."Remaining Amount";
                if Rec."Remaining Amt. Incl. Discount" <> 0 then
                    if (ProductionBomLine."Quantity per" + Rec."Remaining Amt. Incl. Discount") > 0 then
                        ProductionBomLine."Quantity per" += Rec."Remaining Amt. Incl. Discount";
                if Rec."Document No." <> '' then
                    ProductionBomLine."Unit of Measure Code" := Rec."Document No.";
                ProductionBomLine.Modify();

            Until ProductionBomLine.next() = 0;

        CurrPage.Lines.Page.UpdateBom(Rec."Account No.");

    end;

}