pageextension 50020 "CompanyInformationExt" extends "Company Information"
{
    layout
    {
        addafter("User Experience")
        {
            group("LeyendasFormularios")
            {
                Caption = 'Leyendas Formularios', comment = 'ESP = "Leyendas Formularios"';

                field(LogoCertificacion; LogoCertificacion)
                {
                    ApplicationArea = All;
                    Caption = 'Certification Logo', comment = 'ESP = "Logo Certificacion ISO"';

                }
            }
        }
    }

}