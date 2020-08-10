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
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        emailVisible := false;

        if (TipoTabla = TipoTabla::GrupoCliente) and (TipoRegistro = TipoRegistro::Tabla) then
            emailVisible := true;
    end;

    var
        emailVisible: Boolean;
}
