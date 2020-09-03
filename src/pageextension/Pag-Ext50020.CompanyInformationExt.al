pageextension 50020 "CompanyInformationExt" extends "Company Information"
{
    layout
    {
        addafter("User Experience")
        {
            group("LeyendasFormularios")
            {
                Caption = 'Report Captions', comment = 'ESP = "Leyendas Formularios"';

                field(LogoCertificacion; LogoCertificacion)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}