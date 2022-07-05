page 50128 "RegistrarEnvio"
{
    //Nº bultos

    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Weight control', comment = 'ESP="Control peso"';
    Permissions = tabledata "Sales Shipment Header" = rm, tabledata "Sales Invoice Header" = rm;


    layout
    {
        area(Content)
        {
            group(General)
            {
                field(vPeso; Peso)
                {
                    ApplicationArea = All;
                    Caption = 'Weight', comment = 'ESP="Peso"';
                }

                field(vNumPalets; numPalets)
                {
                    ApplicationArea = All;
                    Caption = 'Number of pallets', comment = 'ESP="Nº palets"';
                }

                field(vNumBultos; numBultos)
                {
                    ApplicationArea = All;
                    Caption = 'Number of packages', comment = 'ESP="Nº bultos"';
                }
            }
        }
    }

    procedure SetEnvioOrigen(pEnvioOrigen: Code[20]; pAlbaranOrigen: Code[20]; pFacturaRegOrigen: Code[20])
    begin
        envioOrigen := pEnvioOrigen;
        albaranOrigen := pAlbaranOrigen;
        facturaRegOrigen := pFacturaRegOrigen;
    end;

    procedure SetEnviosDatos(SalesShipmentHeader: record "Sales Shipment Header")
    begin
        peso := SalesShipmentHeader.Peso_btc;
        numPalets := SalesShipmentHeader.NumPalets_btc;
        numBultos := SalesShipmentHeader.NumBultos_btc;
    end;


    procedure GetDatos(var pPeso: Decimal; var pNumPalets: Integer; var pNumBultos: Integer)
    begin
        pPeso := peso;
        pNumPalets := numPalets;
        pNumBultos := numBultos;
    end;

    procedure SetDatos(var pPeso: Decimal; var pNumPalets: Integer; var pNumBultos: Integer)
    var
        recAlbaran: Record "Sales Shipment Header";
        recFacturaReg: Record "Sales Invoice Header";

    begin
        peso := pPeso;
        numPalets := pNumPalets;
        numBultos := pNumBultos;
        if albaranOrigen <> '' then begin
            recAlbaran.Reset();
            recAlbaran.SetRange("No.", albaranOrigen);

            if recAlbaran.FindFirst() then begin

                recAlbaran.Peso_btc := pPeso;
                recAlbaran.NumPalets_btc := pNumPalets;
                recAlbaran.NumBultos_btc := pNumBultos;
                recAlbaran.Modify();
            end
        end
        else
            if facturaRegOrigen <> '' then begin
                recFacturaReg.Reset();
                recFacturaReg.SetRange("No.", facturaRegOrigen);
                recFacturaReg.Peso_btc := pPeso;
                recFacturaReg.NumPalets_btc := pNumPalets;
                recFacturaReg.NumBultos_btc := pNumBultos;
                recFacturaReg.Modify();
            end;
    end;

    trigger OnOpenPage()
    var
        recWhseShptLine: Record "Warehouse Shipment Line";
        recLinAlbaran: Record "Sales Shipment Line";
        recLinFacturaReg: Record "Sales Invoice Line";
        recFacturaReg: Record "Sales Invoice Header";
        recItem: Record Item;
        Fc: Codeunit Funciones;

    begin
        //peso := 0;
        if facturaRegOrigen <> '' then begin
            recFacturaReg.Get(facturaRegOrigen);
            peso := recFacturaReg.Peso_btc;
            numPalets := recFacturaReg.NumPalets_btc;
            numBultos := recFacturaReg.NumBultos_btc;
            if ((peso = 0) and (numPalets = 0) and (numBultos = 0)) then
                fc.ObtenerPesosFactura(facturaRegOrigen, peso, numPalets, numBultos)
            else
                if Confirm('¿Desea volver a cargarlos de los albaranes?', false) then
                    fc.ObtenerPesosFactura(facturaRegOrigen, peso, numPalets, numBultos)

        end
        else
            if albaranOrigen <> '' then begin
                recLinAlbaran.Reset();
                recLinAlbaran.SetRange("Document No.", albaranOrigen);
                recLinAlbaran.SetFilter(recLinAlbaran.Quantity, '<>%1', 0);
                if recLinAlbaran.FindSet() then
                    repeat
                        if recItem.Get(recWhseShptLine."Item No.") and (recItem."Net Weight" <> 0) then
                            peso += recLinAlbaran.Quantity * recItem."Net Weight";
                    until recLinAlbaran.Next() = 0;
            end
            else begin
                recWhseShptLine.Reset();
                recWhseShptLine.SetRange("No.", envioOrigen);
                recWhseShptLine.SetFilter("Qty. to Ship", '<>%1', 0);
                if recWhseShptLine.FindSet() then
                    repeat
                        if recItem.Get(recWhseShptLine."Item No.") and (recItem."Net Weight" <> 0) then
                            peso += recWhseShptLine."Qty. to Ship" * recItem."Net Weight";
                    until recWhseShptLine.Next() = 0;
            end;
    end;

    var
        peso: Decimal;
        numPalets: Integer;
        numBultos: Integer;
        envioOrigen: Code[20];
        albaranOrigen: Code[20];
        facturaRegOrigen: Code[20];
}