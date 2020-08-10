tableextension 50157 "PaymentOrder" extends "Payment Order"  //7000020
{
    fields
    {
        field(50100; DueDate_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date', comment = 'ESP="Fecha Pago"';
            trigger OnValidate()
            var
                CarteraDoc: Record "Cartera Doc.";
                Advertencia: Boolean;
                AdvertenciaLbl: Label '¿Desea Cambiar la fecha de vencimiento de las lineas?.', Comment = 'ESP="¿Desea Cambiar la fecha de vencimiento de las lineas?"';

            begin
                Clear(CarteraDoc);
                CarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", Rec."No.");
                Advertencia := Dialog.Confirm(AdvertenciaLbl, true);
                if Advertencia then
                    IF CarteraDoc.FindSet() then
                        repeat
                            CarteraDoc."Due Date" := Rec.DueDate_btc;
                            CarteraDoc.Modify();
                        until CarteraDoc.Next() = 0;
            end;
        }

    }
}