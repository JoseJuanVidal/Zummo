tableextension 50111 "StandardCustomerSalesCode" extends "Standard Customer Sales Code"  //172
{
    fields
    {

        field(50100; Periodicidad_btc; DateFormula)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Period', comment = 'ESP="Periodicidad"';

            trigger OnValidate()
            begin
                if format(Periodicidad_btc) = '' then
                    exit;

                CalculaProximaFechaFactura();
            end;
        }

        field(50101; ProximaFechaFactura_btc; Date)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Next invoice date', comment = 'ESP="Próxima fecha factura"';

            trigger OnValidate()
            var
                lbErrorFechaErr: Label 'The next invoice date cannot be less than the initial date', comment = 'ESP="La fecha de próxima factura no puede ser menor a la fecha inicial"';
                lbErrorFechaMayorErr: Label 'The next invoice date cannot be greater than the final date', Comment = 'ESP="La fecha de próxima factura no puede ser mayor a la fecha final"';
                lbErrorFechaMenorUltimaFechaErr: Label 'The next invoice date cannot be less than the last invoice date', comment = 'ESP="La fecha de próxima factura no puede ser menor a la fecha última factura"';
            begin
                if (ProximaFechaFactura_btc <> 0D) and (ProximaFechaFactura_btc < "Valid From Date") and ("Valid From Date" <> 0D) then
                    error(lbErrorFechaErr);


                if (ProximaFechaFactura_btc <> 0D) and (ProximaFechaFactura_btc > "Valid To date") and ("Valid To date" <> 0D) then
                    if not globalBoolDesdeReport then  // Si el cálculo viene desde el proceso que genera facturas no doy error, se deja la fecha fin como estaba
                        error(lbErrorFechaMayorErr)
                    else
                        ProximaFechaFactura_btc := xRec.ProximaFechaFactura_btc;

                if (ProximaFechaFactura_btc <> 0D) and (UltimaFechaFactura_btc <> 0D) and (ProximaFechaFactura_btc < UltimaFechaFactura_btc) then
                    error(lbErrorFechaMenorUltimaFechaErr);
            end;
        }

        field(50102; UltimaFechaFactura_btc; Date)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Last invoice date', comment = 'ESP="Última fecha factura"';
            Editable = false;

            trigger OnValidate()
            begin
                if (UltimaFechaFactura_btc <> 0D) and (UltimaFechaFactura_btc <> xRec.UltimaFechaFactura_btc) then
                    CalculaProximaFechaFactura();
            end;
        }
        field(50110; "Customer Name"; text[100])
        {
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup(customer.Name where("No." = field("Customer No.")));
            Editable = false;
        }
        field(50120; "Amount Lines"; Decimal)
        {
            Caption = 'Amount', comment = 'ESP="Importe Líneas"';
            FieldClass = FlowField;
            CalcFormula = sum("Standard Sales Line".Precio_btc where("Standard Sales Code" = field(Code)));
            Editable = false;
        }
    }

    procedure CalculaProximaFechaFactura()
    begin
        TestField(Periodicidad_btc);

        if UltimaFechaFactura_btc <> 0D then
            Validate(ProximaFechaFactura_btc, CalcDate(Periodicidad_btc, UltimaFechaFactura_btc))
        else
            if "Valid From Date" <> 0D then
                validate(ProximaFechaFactura_btc, CalcDate(Periodicidad_btc, "Valid From Date"))
            else
                validate(ProximaFechaFactura_btc, CalcDate(Periodicidad_btc, WorkDate()));
    end;

    procedure SetLlamadaDesdeReport(pBool: Boolean)
    begin
        globalBoolDesdeReport := pBool;
    end;

    var
        globalBoolDesdeReport: Boolean;
}