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
        field(50001; "Vat Reg. GB"; code[20])
        {
            Caption = 'Vat Reg. GB', comment = 'ESP="CIF/NIF GB"';
        }
        field(50002; "EORI"; code[20])
        {
            Caption = 'EORI', comment = 'ESP="EORI"';
        }
    }

}