tableextension 50200 "CompanyInformationExt" extends "Company Information" //79
{
    fields
    {
        field(50000; "LogoCertificacion"; Blob)
        {
            Caption = 'LogoCertificacion';
            Subtype = Bitmap;
            DataClassification = CustomerContent;
        }
    }

}