tableextension 50008 "STH VAT Business Posting Group" extends "VAT Business Posting Group"
{
    fields
    {
        field(50000; "Cód. Texto Factura"; Code[20])
        {
            Caption = 'Cód. Texto Factura';
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(RegistroIVA), TipoRegistro = const(Tabla));
        }
    }
}
