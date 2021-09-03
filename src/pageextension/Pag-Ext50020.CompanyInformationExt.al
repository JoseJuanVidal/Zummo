pageextension 50020 "CompanyInformationExt" extends "Company Information"
{
    layout
    {
        addafter("User Experience")
        {
            group("LeyendasFormularios")
            {
                Caption = 'Leyendas Formularios', comment = 'ESP="Leyendas Formularios"';

                field(LogoCertificacion; LogoCertificacion)
                {
                    ApplicationArea = All;
                    Caption = 'Certification Logo', comment = 'ESP="Logo Certificacion ISO"';
                }
            }
        }
        addafter("VAT Registration No.")
        {
            field("Vat Reg. GB"; "Vat Reg. GB")
            {
                ApplicationArea = all;
            }
            field(EORI; EORI)
            {
                ApplicationArea = all;
            }
            field("Initial Work Hours"; "Initial Work Hour")
            {
                ApplicationArea = all;
            }
            field("Final Work Hours"; "Final Work Hour")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        ConfigDays: Boolean;
        ConfigHours: Time;
}