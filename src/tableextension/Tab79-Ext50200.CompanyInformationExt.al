tableextension 50200 "CompanyInformationExt" extends "Company Information" //79
{
    fields
    {
        field(50000; "LogoCertificacion"; Blob)
        {
            Caption = 'Logo Certificacion ISO', Comment = 'ESP="Logo Certificacion ISO"';
            Subtype = Bitmap;
            DataClassification = CustomerContent;
        }
    }

}