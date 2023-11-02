tableextension 50150 "ServiceItemLine" extends "Service Item Line"  //5901
{
    //Clasificación pedido servicio

    fields
    {
        field(50100; CodProdFallo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. with fail', comment = 'ESP="Prod. con fallo"';
            TableRelation = Item."No.";
        }

        field(50110; NumCiclos_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Num Ciclos', comment = 'ESP="Num Ciclos"';
        }
        field(50120; CodAnterior_btc; Code[20])
        {
            Caption = 'Cod.Anterior', comment = 'ESP="Cod.Anterior"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Item".CodAnterior_btc where("No." = field("Service Item No.")));
        }
        field(50200; AmpliacionGarantia_sth; Boolean)
        {
            FieldClass = FlowField;
            Caption = 'Ampliacion Garantia', comment = 'ESP="Ampliación Garantía"';
            //.PeriodoAmplacionGarantica_sth
            CalcFormula = exist("Service Item" where("No." = field("Service Item No."), PeriodoAmplacionGarantica_sth = filter(<> '')));
            Editable = false;
        }
        field(50201; FechaFinGarantia_sth; Date)
        {
            Caption = 'Fecha final Garantia', comment = 'ESP="Fecha final Garantía"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Item"."Warranty Ending Date (Parts)" where("No." = field("Service Item No.")));

        }
        field(50202; "Fallo localizado"; text[80])
        {
            Caption = 'Fallo localizado', comment = 'ESP="Fallo localizado"';
            TableRelation = if (Fallo = const('')) "STH Fallo Localizado".FalloLocalizado else
            "STH Fallo Localizado".FalloLocalizado where(Fallo = field(Fallo));

            trigger OnValidate()
            begin
                FallolocalizadoValidate;
            end;
        }
        field(50203; Fallo; code[20])
        {
            Caption = 'Fallo', comment = 'ESP="Fallo"';
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(Tabla), TipoTabla = const(motivoCalibracion));

        }
        field(50204; "Informe Mejora"; text[100])
        {
            Caption = 'Informe Mejora', comment = 'ESP="Informe Mejora"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("STH Fallo Localizado".InformeMejora where(FalloLocalizado = field("Fallo localizado")));
        }
        field(50210; Fecharecepaviso_sth; DateTime)
        {
            Caption = 'Fecha Recepción aviso', comment = 'ESP="Fecha recepción aviso"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnValidate_Fecharecepaviso_sth();
            end;
        }
        field(50211; Fechaemtregamaterial_sth; DateTime)
        {
            Caption = 'Fecha entrega material', comment = 'ESP="Fecha resolución en cliente"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                OnValidate_Fecharresolucion();
            end;
        }
        field(50501; "Description Header"; text[100])
        {
            Caption = 'Description Header', comment = 'ESP="Cab. Descripción"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Header".Description where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
        field(50502; "Responsability Center"; code[20])
        {
            Caption = 'Responsability Center', comment = 'ESP="Centro de Responsabilidad"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Header"."Responsibility Center" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
        field(50503; "Ship-to Name"; text[100])
        {
            Caption = 'Ship-to Name', comment = 'ESP="Nombre dirección de envío"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Header"."Ship-to Name" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
        field(50504; "Ship-to City"; text[100])
        {
            Caption = 'Ship-to City', comment = 'ESP="Población dirección de envío"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Header"."Ship-to City" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
    }

    var
        ServiceHeader: Record "Service Header";
        lblErrorFechaMenor: Label 'La fecha %1: %2 no puede ser menor que %3: %4.\¿Desea continuar?', comment = 'ESP="La fecha %1: %2 no puede ser menor que %3: %4.\¿Desea continuar?"';
        lblErrorFechaMayor: Label 'La fecha %1: %2 no puede ser mayor que %3: %4.\¿Desea continuar?', comment = 'ESP="La fecha %1: %2 no puede ser mayor que %3: %4.\¿Desea continuar?"';
        lblError: Label 'Cancelado por usuario', comment = 'ESP="Cancelado por usuario"';

    local procedure FalloLocalizadoValidate()
    var
        FalloLoc: Record "STH Fallo Localizado";
    begin
        if Rec.Fallo = '' then begin
            FalloLoc.Reset();
            FalloLoc.SetRange(FalloLocalizado, Rec."Fallo localizado");
            if FalloLoc.FindFirst() then begin
                if FalloLoc.Count = 1 then begin
                    Rec.Fallo := FalloLoc.Fallo;
                end;
            end;
        end;
    end;

    local procedure OnValidate_Fecharresolucion()
    begin
        ServiceHeader.Reset();
        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
        if ServiceHeader."Order Date" > DT2Date(Rec.Fechaemtregamaterial_sth) then
            if not confirm(lblErrorFechaMenor, false, Rec.FieldCaption(Fechaemtregamaterial_sth), Rec.Fechaemtregamaterial_sth, ServiceHeader.FieldCaption("Order Date"), ServiceHeader."Order Date") then
                Error(lblError);
    end;

    local procedure OnValidate_Fecharecepaviso_sth()
    begin
        ServiceHeader.Reset();
        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
        if ServiceHeader."Order Date" > DT2Date(Rec.Fechaemtregamaterial_sth) then
            if not confirm(lblErrorFechaMayor, false, Rec.FieldCaption(Fecharecepaviso_sth), Rec.Fecharecepaviso_sth, ServiceHeader.FieldCaption("Order Date"), ServiceHeader."Order Date") then
                Error(lblError);
    end;
}