pageextension 50229 "ZM BOM Cost Shares" extends "BOM Cost Shares"
{
    layout
    {
        // Add changes to page layout here
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

    var
        StandardCostWorksheetName: record "Standard Cost Worksheet Name";
        StandardCostWorksheet: record "Standard Cost Worksheet";
        lblConfirmDelete: Label 'La seccion de Hoja de coste %1 tiene ya registros.\¿Desea Elimnarlos?', comment = 'ESP="La seccion de Hoja de coste %1 tiene ya registros.\¿Desea Elimnarlos?"';

    local procedure CreateCostWorksheet()
    var
        lblSeccion: Label 'REVISION';
    begin
        StandardCostWorksheetName.Get(lblSeccion);
        StandardCostWorksheet.Reset();
        StandardCostWorksheet.SetRange("Standard Cost Worksheet Name", lblSeccion);
        if StandardCostWorksheet.FindLast() then
            if confirm(lblConfirmDelete, false, StandardCostWorksheet."Standard Cost Worksheet Name") then
                StandardCostWorksheet.DeleteAll();

        if Rec.FindFirst() then
            repeat
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
        // page.Run(0, StandardCostWorksheet);
    end;
}