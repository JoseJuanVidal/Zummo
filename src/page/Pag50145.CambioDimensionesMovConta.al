page 50145 "CambioDimensionesMovConta"
{
    Permissions = tabledata "G/L Entry" = m;

    PageType = List;
    Caption = 'Change Dimensions', comment = 'ESP="Cambiar dimensiones"';
    SourceTable = "Dimension Set Entry";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Dimension Code"; "Dimension Code")
                {
                    ApplicationArea = All;
                }

                field("Dimension Value Code"; "Dimension Value Code")
                {
                    ApplicationArea = All;
                }

                field("Dimension Value Name"; "Dimension Value Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FindFirst() then;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        GLSetup: Record "General Ledger Setup";
        recGlEntry: Record "G/L Entry";
        cduDimMgt: Codeunit DimensionManagement;
        cduCambioDim: Codeunit CambioDimensiones;
    begin
        if CloseAction = CloseAction::LookupOK then begin
            recNewDimSetEntry.Reset();
            recNewDimSetEntry.DeleteAll();

            if FindSet() then
                repeat
                    recNewDimSetEntry.Init();
                    recNewDimSetEntry."Dimension Code" := "Dimension Code";
                    recNewDimSetEntry."Dimension Value Code" := "Dimension Value Code";
                    recNewDimSetEntry."Dimension Value ID" := "Dimension Value ID";
                    if recNewDimSetEntry.Insert() then;
                until Next() = 0;

            recNewDimSetEntry.Reset();
            if not recNewDimSetEntry.IsEmpty() then begin
                Clear(cduDimMgt);
                intDimSetId := cduDimMgt.GetDimensionSetID(recNewDimSetEntry);

                // Obtengo dimensiones globales
                GLSetup.get();
                clear(cduCambioDim);

                GlobalDim1 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 1 Code", intDimSetId);
                GlobalDim2 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 2 Code", intDimSetId);

                recGlEntry.Reset();
                recGlEntry.SetRange("Entry No.", intNumMovConta);
                if recGlEntry.FindFirst() then begin
                    recGlEntry."Dimension Set ID" := intDimSetId;
                    recGlEntry."Global Dimension 1 Code" := GlobalDim1;
                    recGlEntry."Global Dimension 2 Code" := GlobalDim2;
                    recGlEntry.Modify();
                end;
            end;
        end;
    end;

    procedure SetDatos(pIntDimension: Integer; pNumMovimiento: Integer)
    begin
        intNumMovConta := pNumMovimiento;

        recDimSetEntry.Reset();
        recDimSetEntry.SetRange("Dimension Set ID", pIntDimension);
        if recDimSetEntry.FindSet() then
            repeat
                Rec := recDimSetEntry;
                Insert();
            until recDimSetEntry.Next() = 0;
    end;

    var
        recDimSetEntry: Record "Dimension Set Entry";
        recNewDimSetEntry: record "Dimension Set Entry" temporary;
        intDimSetId: Integer;
        intNumMovConta: integer;
        GlobalDim1: code[20];
        GlobalDim2: code[20];
}