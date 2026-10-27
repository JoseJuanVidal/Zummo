page 50117 "Lista Textos Auxiliares"
{

    PageType = List;
    SourceTable = TextosAuxiliares;
    Caption = 'Auxiliary', Comment = 'ESP="Valores"';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(NumReg; NumReg)
                {
                    ApplicationArea = All;
                }
                field(Origen; Origen)
                {
                    ApplicationArea = All;
                }
                field(Descripcion; Descripcion)
                {
                    ApplicationArea = All;
                }

                field(NoEnviarMailVencimientos; NoEnviarMailVencimientos)
                {
                    ApplicationArea = All;
                    Editable = emailVisible;
                    Visible = emailVisible;
                }
                field(Mercado; Mercado)
                {
                    ApplicationArea = all;
                    Editable = mercadoVisible;
                    Visible = mercadoVisible;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Visible = NotRegIVA;
                }
                field(AvisoProductoServicio; AvisoProductoServicio)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(WarrantyDate; WarrantyDate)
                {
                    ApplicationArea = All;
                    Visible = mostrarGarantia;
                }
                field("Discount Type"; "Discount Type")
                {
                    ApplicationArea = all;
                    Visible = mostrarGarantia;
                }
                field("CMMF Code Reporting"; "CMMF Code Reporting")
                {
                    ApplicationArea = all;
                    Visible = mostrarFamilia;
                }
                field("CMMF Nos."; "CMMF Nos.")
                {
                    ApplicationArea = all;
                    Visible = mostrarCMMF;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateCMMFReporting)
            {
                ApplicationArea = all;
                Caption = 'Actualizar CMMF Code (Reporting) productos', comment = 'ESP="Actualizar CMMF Code (Reporting) productos"';
                Image = UpdateDescription;
                Visible = mostrarFamilia;

                trigger OnAction()
                var
                    TextosAuxiliares: Record TextosAuxiliares;
                    Funciones: Codeunit FuncionesFabricacion;
                    lblConfirm: Label '¿Desea actualizar el CMMF Code (Reporting) de los productos sin informar de %1 familias seleccionadas?', comment = 'ESP="¿Desea actualizar el CMMF Code (Reporting) de los productos sin informar de %1 familias seleccionadas?"';
                begin
                    CurrPage.SetSelectionFilter(TextosAuxiliares);
                    if not Confirm(lblConfirm, false, TextosAuxiliares.Count) then
                        exit;
                    Funciones.UpdateCMMFReportingFromFamily(TextosAuxiliares);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UpperCase(GetFilter(TipoTabla)) = 'CANAL' then
            mercadoVisible := true;
        if UpperCase(GetFilter(TipoTabla)) = 'REGISTROIVA' then
            NotRegIVA := true;
        if GetFilter(TipoTabla) = FORMAT(Rec.TipoTabla::Familia) then begin
            mostrarGarantia := true;
            mostrarFamilia := true;
        end;
        if GetFilter(TipoTabla) = FORMAT(Rec.TipoTabla::ClasificacionVentas) then
            mostrarGarantia := true;
        if GetFilter(TipoTabla) = FORMAT(Rec.TipoTabla::CMMFType) then
            mostrarCMMF := true;
    end;

    trigger OnAfterGetRecord()
    begin
        emailVisible := false;

        if (TipoTabla = TipoTabla::GrupoCliente) and (TipoRegistro = TipoRegistro::Tabla) then
            emailVisible := true;
    end;

    var
        emailVisible: Boolean;
        mercadoVisible: Boolean;
        NotRegIVA: Boolean;
        mostrarGarantia: Boolean;
        mostrarCMMF: Boolean;
        mostrarFamilia: Boolean;
}
