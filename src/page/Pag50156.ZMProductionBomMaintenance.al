page 50156 "ZM Production Bom Maintenance"
{
    Caption = 'Production BOM Maintenance', comment = 'ESP="Gestión de cambios - L. M. Productos"';
    DataCaptionFields = "Item Description";
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Item Changes L.M. production"; //"Ledger Entry Matching Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Options)
            {
                Caption = 'Exchange options', comment = 'ESP="Opciones de cambio"';
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select L.M. containing', comment = 'ESP="Seleccionar L.M. que contengan"';

                    trigger OnValidate()
                    begin
                        ValidateItemNo();
                    end;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = all;
                    Caption = 'Description', comment = 'ESP="Descripción"';
                    Editable = false;
                }
                field(Task; Task)
                {
                    ApplicationArea = all;
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

                field("Quantity per"; "Quantity per") // "Remaining Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Indicate the new "Quantity per" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Cantidad por" a actualizar en las listas de materiales"';
                    DecimalPlaces = 5 : 5;

                }
                field("Quantity add"; "Quantity add") // "VAT Amount") 
                {
                    ApplicationArea = all;

                    ToolTip = 'Indicate the add Quantity to be updated in the BOM', comment = 'ESP="Indicar la cantidad añadir para actualizar en las listas de materiales"';
                    DecimalPlaces = 5 : 5;
                }
                field("Unit of measure"; "Unit of measure") // "Insurance No.") 
                {
                    ApplicationArea = all;
                    ToolTip = 'Indicate the new "Unit of measure" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Unidad de medida" a actualizar en las listas de materiales"';
                    TableRelation = "Item Unit of Measure" where("Item No." = field("Item No."));
                }
                field("Routing Link Code"; "Routing Link Code")
                {
                    ApplicationArea = all;
                }
            }
            group(ItemRepalced)
            {
                Caption = 'Item to be replaced', comment = 'ESP="Producto a reemplazar"';
                Visible = ShowReplacedItem;
                field("Item No. to be replaced"; "Item No. to be replaced")
                {
                    ApplicationArea = all;
                    ToolTip = 'Indicate the new "Quantity per" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Cantidad por" a actualizar en las listas de materiales"';
                    Visible = ShowReplacedItem;

                    trigger OnValidate()
                    begin
                        ValidateReplaceItemNo();
                    end;
                }
                field("Replace Quantity per"; "Quantity per") // "Remaining Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Indicate the new "Quantity per" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Cantidad por" a actualizar en las listas de materiales"';
                    DecimalPlaces = 5 : 5;
                }
                field("Replaced Item Description"; "Replaced Item Description")
                {
                    ApplicationArea = all;
                    Caption = 'Description', comment = 'ESP="Descripción"';
                    Visible = ShowReplacedItem;
                    Editable = false;
                    //ShowCaption = false;
                }
            }

            group(LMChange)
            {
                Caption = 'Changes in Estructure', comment = 'ESP="Cambios en Estructura"';
                Visible = ShowChangeItem;


                field("New Item No."; "New Item No.") // "Budgeted FA No.") 
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        ValidateNewItemNo();
                    end;
                }

                field("New Quantity"; "New Quantity") // "Remaining Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Indicate the new "Quantity per" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Cantidad por" a actualizar en las listas de materiales"';
                    DecimalPlaces = 5 : 5;
                }
                field("New Item Description"; "New Item Description")
                {
                    ApplicationArea = all;
                    Editable = false;
                    //ShowCaption = false;
                }
                field("New Unit of measure"; "New Unit of measure") // "External Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Indicate the new "Unit of measure" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Unidad de medida" a actualizar en las listas de materiales"';
                }
            }
            group(DeleteItem)
            {
                Caption = 'Delete Item', comment = 'ESP="Eliminar Producto"';
                Visible = ShowDeleteItem;

                field("Del Item No. to be replaced"; "Item No. to be replaced") // "Budgeted FA No.") 
                {
                    ApplicationArea = all;
                    Caption = 'Item No.', comment = 'ESP="Cód. producto"';

                    trigger OnValidate()
                    begin
                        ValidateNewItemNo();
                    end;
                }
                field("Del Replaced Item Description"; "Replaced Item Description")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Description', comment = 'ESP="Descripción"';
                    //ShowCaption = false;
                }
                field("Delete Quantity per"; "Quantity per") // "Remaining Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Indicate the new "Quantity per" to be updated in the BOM', comment = 'ESP="Indicar la nueva "Cantidad por" a actualizar en las listas de materiales"';
                    DecimalPlaces = 5 : 5;
                }

            }
            part(Lines; "ZM Production Bom Check")
            {
                ApplicationArea = All;
                Caption = 'BOM list', comment = 'ESP="Lista de materiales"';
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
            action(translate)
            {
                ApplicationArea = all;

                trigger OnAction()
                var
                    translateCode: Codeunit "ZM Visual code utilities";
                begin
                    translateCode.CheckLanguageTranslation();
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
        rec.Modify();
    end;

    var
        Item: Record Item;
        Funciones: Codeunit Funciones;
        notShowChangeDate: Boolean;
        ShowChangeItem: Boolean;
        ShowReplacedItem: Boolean;
        ShowDeleteItem: Boolean;
        lblConfirmChanges: Label 'The data in the %1 BOM list will be updated.\%2 %3\%4 %5\¿Do you want to continue?',
            comment = 'ESP="Se van a actualizar %1 registros con los datos en la lista de materiales.\%2 %3\%4 %5\¿Desea continuar?"';
        lblConfirmAdd: Label 'We will add %1 records with \%2 %3\¿Do you want to continue?',
            comment = 'ESP="Se va a añadir %1 registros con \%2 %3 \¿Desea continuar?"';
        lblConfirmReplace: Label 'We will replace %1 records with \%2 %3\for %4 %5\¿Do you want to continue?',
            comment = 'ESP="Se va a reemplazar %1 registros con \%2 %3\por %4 %5\¿Desea continuar?"';
        lblConfirmDelete: Label 'We will delete Item %2 %3 of %1 records\¿Do you want to continue?',
            comment = 'ESP="Se va a eliminar el producto %2 %3 de %1 registros\¿Desea continuar?"';

        lblConfirmChangesQtyper: Label 'Quantity per', comment = 'ESP="Cantidad por"';
        lblConfirmChangesQtyadd: Label 'Quantity add', comment = 'ESP="Cantidad añadir"';
        lblConfirmChangesUnit: Label 'Unit of measure', comment = 'ESP="Unidad de medida"';

    local procedure ChangeTask()
    begin
        notShowChangeDate := true;
        ShowChangeItem := false;
        ShowReplacedItem := false;
        ShowDeleteItem := false;
        case Rec.Task of
            Task::Change:
                begin
                    notShowChangeDate := false;
                end;
            Task::Add:
                begin
                    ShowChangeItem := true;
                end;
            Task::Replace:
                begin
                    ShowChangeItem := true;
                    ShowReplacedItem := true;
                end;
            Task::Delete:
                begin
                    ShowDeleteItem := true;
                end;

        end;
    end;

    local procedure ValidateItemNo()
    begin
        CurrPage.Update();
    end;

    local procedure ValidateNewItemNo()
    begin
        CurrPage.Update();
    end;

    local procedure ValidateReplaceItemNo()
    begin
        CurrPage.Update();
    end;

    local procedure CheckAction()
    begin
        // actualizamos la lista de materiales, cuales entran en filtro
        CurrPage.Lines.Page.UpdateBom(Rec."Item No.");
    end;

    local procedure RunAction()
    var
        myInt: Integer;
    begin
        case task of
            Task::Change:
                begin
                    UpdateBomDades();
                end;
            Task::Add:
                begin
                    TaskItemLMProd();
                end;
            Task::Replace:
                begin
                    TaskItemLMProd();
                end;
            Task::Delete:
                begin
                    TaskItemLMProd();
                end;
        end;
    end;

    procedure UpdateBomDades()
    var
        ProductionBomLine: Record "Production BOM Line";
        ItemTracingBuffer: record "Item Tracing Buffer" temporary;
        Confirmparam: text;
        Qty: Decimal;
        LineNo: Integer;
    begin
        clear(Funciones);
        if Rec."Quantity per" <> 0 then begin
            Confirmparam := lblConfirmChangesQtyper;
            Qty := Rec."Quantity per"
        end else begin
            Confirmparam := lblConfirmChangesQtyadd;
            Qty := Rec."Quantity add";
        end;

        CurrPage.Lines.Page.GetSelectionRecord(ItemTracingBuffer);
        if not Confirm(lblConfirmChanges, false, ItemTracingBuffer.Count, Confirmparam, Qty, lblConfirmChangesUnit, Rec."Unit of measure") then
            exit;

        Funciones.UpdateBomDades(ItemTracingBuffer, Rec."Quantity per", Rec."Quantity add", Rec."Unit of measure", Rec."Routing Link Code");

        CurrPage.Lines.Page.UpdateBom(Rec."Item No.");

    end;

    local procedure TaskItemLMProd()
    var
        ItemTracingBuffer: record "Item Tracing Buffer" temporary;
    begin
        //   comment = 'ESP="Se van a reemplazar %1 registros con \%2 %3 por %4 %5\¿Desea continuar?"';
        //     comment = 'ESP="Se van a eliminar el producto %2 %3 de %1 registros\¿Desea continuar?"';

        clear(Funciones);
        CurrPage.Lines.Page.GetSelectionRecord(ItemTracingBuffer);
        case Rec.Task of
            Rec.Task::Add:
                begin
                    if not Confirm(lblConfirmAdd, false, ItemTracingBuffer.Count, Rec."New Item No.", Rec."New Item Description") then
                        exit;
                end;
            Rec.Task::Replace:
                begin
                    if not Confirm(lblConfirmReplace, false, ItemTracingBuffer.Count, Rec."Item No. to be replaced", Rec."Replaced Item Description",
                                    Rec."New Item No.", Rec."New Item Description") then
                        exit;
                end;
            Rec.Task::Delete:
                begin
                    if not Confirm(lblConfirmDelete, false, ItemTracingBuffer.Count, Rec."Item No. to be replaced", Rec."Replaced Item Description") then
                        exit;
                end;

        end;
        Funciones.TaskMProdItem(ItemTracingBuffer, Rec);
    end;
}