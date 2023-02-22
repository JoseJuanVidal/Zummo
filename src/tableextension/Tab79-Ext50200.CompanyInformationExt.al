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

        field(50003; "Initial Work Hour"; Time)
        {
            Caption = 'Initial Work Hour', Comment = 'ESP="Hora inicial de trabajo"';

            trigger OnValidate()
            begin
                if Rec."Initial Work Hour" > Rec."Final Work Hour" then
                    Error('Error. La hora inicial no puede superar a la hora final.');
            end;
        }
        field(50004; "Final Work Hour"; Time)
        {
            Caption = 'Final Work Hour', Comment = 'ESP="Hora final de trabajo"';
            trigger OnValidate()
            begin
                if Rec."Initial Work Hour" > Rec."Final Work Hour" then
                    Error('Error. La hora final no puede ser inferior a la hora inicial.');
            end;
        }
        field(50005; "Productor de producto"; code[50])
        {
            Caption = 'Product producer', comment = 'ESP="Productor de producto"';
        }
    }

}