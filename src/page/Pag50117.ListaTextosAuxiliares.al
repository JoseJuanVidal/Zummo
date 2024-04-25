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
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UpperCase(GetFilter(TipoTabla)) = 'CANAL' then
            mercadoVisible := true;
        if UpperCase(GetFilter(TipoTabla)) = 'REGISTROIVA' then
            NotRegIVA := true;
        if GetFilter(TipoTabla) = FORMAT(Rec.TipoTabla::Familia) then
            mostrarGarantia := true;
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
}
