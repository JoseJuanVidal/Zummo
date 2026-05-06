pageextension 50229 "ZM BOM Cost Shares" extends "BOM Cost Shares"
{
    layout
    {
        addafter("Total Cost")
        {
            field("Standard Cost"; "Standard Cost")
            {
                ApplicationArea = all;
            }
            field("Total Standard Cost"; TotalStandardCost)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(CreateCostWorksheet)
            {
                ApplicationArea = all;
                Caption = 'Crear Hoja Coste', comment = 'ESP="Crear Hoja Coste"';
                Image = ItemWorksheet;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CreateCostWorksheet();
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        TotalStandardCost := Rec."Qty. per BOM Line" * Rec."Standard Cost";
    end;

    var
        StandardCostWorksheetName: record "Standard Cost Worksheet Name";
        StandardCostWorksheet: record "Standard Cost Worksheet";
        TotalStandardCost: Decimal;
        lblConfirmDelete: Label 'La seccion de Hoja de coste %1 tiene ya registros.\¿Desea Elimnarlos?', comment = 'ESP="La seccion de Hoja de coste %1 tiene ya registros.\¿Desea Elimnarlos?"';

    local procedure CreateCostWorksheet()
    var
        Window: Dialog;
        lblWindow: Label 'Nº Mov: #1############\Cód. producto #2################', comment = 'ESP="Nº Mov: #1############\Cód. producto #2################"';
        lblSeccion: Label 'REVISION';
    begin
        StandardCostWorksheetName.Get(lblSeccion);
        StandardCostWorksheet.Reset();
        StandardCostWorksheet.SetRange("Standard Cost Worksheet Name", lblSeccion);
        if StandardCostWorksheet.FindLast() then
            if confirm(lblConfirmDelete, false, StandardCostWorksheet."Standard Cost Worksheet Name") then
                StandardCostWorksheet.DeleteAll();
        Window.Open(lblWindow);
        if Rec.FindFirst() then
            repeat
                Window.Update(1, Rec."Entry No.");
                Window.Update(2, Rec."No.");
                if Rec.Type in [Rec.Type::Item] then begin
                    if not StandardCostWorksheet.Get(StandardCostWorksheetName.Name, StandardCostWorksheet.Type::Item, Rec."No.") then begin
                        StandardCostWorksheet.Init();
                        StandardCostWorksheet."Standard Cost Worksheet Name" := lblSeccion;
                        StandardCostWorksheet.Validate("No.", Rec."No.");
                        StandardCostWorksheet.Insert();
                    end;
                end;
            Until Rec.next() = 0;
        Rec.FindFirst();
        Window.Close();
        page.Run(page::"Standard Cost Worksheet");
    end;
}