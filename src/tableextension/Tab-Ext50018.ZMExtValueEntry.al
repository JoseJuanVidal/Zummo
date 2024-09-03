tableextension 50018 "ZM Ext Value Entry" extends "Value Entry"
{
    fields
    {
        field(50000; "Prod. Order State"; Option)
        {
            Caption = 'Prod. Order State', comment = 'ESP="Estado Ord. Prod."';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished',
                  Comment = 'Simulada,Planificada,Planif. en firme,Lanzada,Terminada';
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order".Status where("No." = field("Document No.")));
        }
        field(50010; "Updated Cost Entry"; Boolean)
        {
            Caption = 'Updated Cost Entry', comment = 'ESP="Actualizado Mov. Coste"';
        }
        field(50100; "Posting Date Old"; Date)
        {
            Caption = 'Posting Date Old', comment = 'ESP="Fecha Registro Anterior"';
        }
        field(50101; ChangePostingDate; Boolean)
        {
            Caption = 'Cambiada Fecha Registro', comment = 'ESP="Cambiada Fecha Registro"';
        }
    }

    procedure ChangeValueEntryPostingDate(InitDate: Date; EndDate: Date; NewDate: date)
    var
        ValueEntry: Record "Value Entry";
        PostValueEntrytoGL: Record "Post Value Entry to G/L";
        Window: Dialog;
        lblWindows: Label 'Fecha Mov.: #1###############\Nº Mov.: #2###############', comment = 'ESP="Fecha Mov.: #1###############\Nº Mov.: #2###############"';
        lblConfirm: Label 'Se va a realizar el cambio de fechas de registros de los movimientos de valor desde %1 a %2, a fecha %3.\Nº Movimientos %4.\¿Desea continuar?',
            comment = 'ESP="Se va a realizar el cambio de fechas de registros de los movimientos de valor desde %1 a %2, a fecha %3.\Nº Movimientos %4.\¿Desea continuar?"';
    begin
        if InitDate = 0D then
            Error('Debe indicar una fecha inicial.');
        if EndDate = 0D then
            Error('Debe indicar una fecha final.');
        if NewDate = 0D then
            Error('Debe indicar una fecha registro.');
        PostValueEntrytoGL.SETRANGE("Posting Date", InitDate, EndDate);
        if not Confirm(lblConfirm, true, InitDate, EndDate, NewDate, PostValueEntrytoGL.Count) then
            exit;
        Window.Open(lblWindows);
        if PostValueEntrytoGL.FINDFIRST then
            repeat
                Window.UPDATE(1, PostValueEntrytoGL."Posting Date");
                ValueEntry.GET(PostValueEntrytoGL."Value Entry No.");
                ValueEntry."Posting Date Old" := ValueEntry."Posting Date";
                ValueEntry.ChangePostingDate := true;
                ValueEntry."Posting Date" := NewDate;
                ValueEntry.MODIFY;
                PostValueEntrytoGL."Posting Date" := NewDate;
                PostValueEntrytoGL.MODIFY;
            until PostValueEntrytoGL.NEXT = 0;
        Window.Close();
    end;

    procedure ResetValueEntryPostingDate()
    var
        ValueEntry: Record "Value Entry";
        PostValueEntrytoGL: Record "Post Value Entry to G/L";
        Window: Dialog;
        Contar: Integer;
        lblWindows: Label 'Fecha Mov.: #1###############\Nº Mov.: #2###############', comment = 'ESP="Fecha Mov.: #1###############\Nº Mov.: #2###############"';
        lblConfirm: Label 'Se van a retornar las fecha de los movimientos de valor %1.\¿Desea Continuar?', comment = 'ESP="Se van a retornar las fecha de los movimientos de valor %1.\¿Desea Continuar?"';
    begin
        Window.Open('Nº Mov.: #1###############');
        ValueEntry.SETRANGE(ChangePostingDate, true);
        IF ValueEntry.FINDFIRST THEN
            repeat

                Window.Update(1, ValueEntry."Entry No.");
                if ValueEntry."Posting Date Old" <> ValueEntry."Posting Date" then
                    Contar += 1;
            until ValueEntry.Next() = 0;
        Window.Close();

        if not Confirm(lblConfirm, true, Contar) then
            exit;
        Window.Open(lblWindows);
        IF ValueEntry.FINDFIRST THEN
            REPEAT
                if ValueEntry."Posting Date Old" <> ValueEntry."Posting Date" then begin
                    Window.UPDATE(1, ValueEntry."Posting Date");
                    Window.UPDATE(2, ValueEntry."Entry No.");
                    ValueEntry."Posting Date" := ValueEntry."Valuation Date";
                    ValueEntry.MODIFY;
                    PostValueEntrytoGL.SetRange("Value Entry No.", ValueEntry."Entry No.");
                    if PostValueEntrytoGL.FindFirst() then begin
                        PostValueEntrytoGL."Posting Date" := ValueEntry."Posting Date";
                        PostValueEntrytoGL.Modify();
                    end;
                end;
            UNTIL ValueEntry.NEXT = 0;
        Window.Close();
    end;
}
