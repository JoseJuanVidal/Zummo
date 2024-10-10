table 17449 "ABERTIA SalesPedidos"
{
    Caption = 'ABERTIA SalesPedidos';
    Description = 'ABERTIA - Actualizacion datos Pedidos';
    ExternalName = 'SalesPedidos';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {
        field(1; "G8. DOCUMENT TYPE"; Integer) { ExternalName = 'G8. DOCUMENT TYPE'; }
        field(2; "G3. PEDIDO NUM"; code[20]) { ExternalName = 'G3. PEDIDO NUM'; }
        field(3; "G4. PEDIDO LINEA"; integer) { ExternalName = 'G4. PEDIDO LINEA'; }
        field(4; "C6. CLIENTE COD"; code[20]) { ExternalName = 'C6. CLIENTE COD'; }
        field(5; "C6. CLIENTE NOMBRE"; text[100]) { ExternalName = 'C6. CLIENTE NOMBRE'; }
        field(6; "E6. ARTICULO COD"; code[20]) { ExternalName = 'E6. ARTICULO COD'; }
        field(7; "E6. ARTICULO DESC"; text[100]) { ExternalName = 'E6. ARTICULO DESC'; }
        field(8; "X1. CUSTOMER DISCOUNT GROUP"; code[20]) { ExternalName = 'X1. CUSTOMER DISCOUNT GROUP'; }
        field(9; "K1. UNIDAD MEDIDA"; code[20]) { ExternalName = 'K1. UNIDAD MEDIDA'; }
        field(10; "K1. CANTIDAD TOTAL PEDIDO"; Decimal) { ExternalName = 'K1. CANTIDAD TOTAL PEDIDO'; }
        field(11; "K1. CANTIDAD PENDIENTE"; Decimal) { ExternalName = 'K1. CANTIDAD PENDIENTE'; }
        field(12; "K1. CANTIDAD A FACTURAR"; Decimal) { ExternalName = 'K1. CANTIDAD A FACTURAR'; }
        field(13; "K1. CANTIDAD A ENVIAR"; Decimal) { ExternalName = 'K1. CANTIDAD A ENVIAR'; }
        field(14; "K1. CANTIDAD ENVIADA NO FACTURADA"; Decimal) { ExternalName = 'K1. CANTIDAD ENVIADA NO FACTURADA'; }
        field(15; "K1. CANTIDAD ENVIADA"; Decimal) { ExternalName = 'K1. CANTIDAD ENVIADA'; }
        field(16; "K1. CANTIDAD FACTURADA"; Decimal) { ExternalName = 'K1. CANTIDAD FACTURADA'; }
        field(17; "K2. PVP"; Decimal) { ExternalName = 'K2. PVP'; }
        field(18; "K6. COSTE"; Decimal) { ExternalName = 'K6. COSTE'; }
        field(19; "K4. DESC CLIENTE (D2)"; Decimal) { ExternalName = 'K4. DESC CLIENTE (D2)'; }
        field(20; "K4. DESC TOTAL OPERACION"; Decimal) { ExternalName = 'K4. DESC TOTAL OPERACION'; }
        field(21; "K5. VENTA NETA CLIENTES"; Decimal) { ExternalName = 'K5. VENTA NETA CLIENTES'; }
        field(22; "X1. CUSTOMER PRICE GROUP"; code[20]) { ExternalName = 'X1. CUSTOMER PRICE GROUP'; }
        field(23; "D3. AGENTE NOMBRE"; text[100]) { ExternalName = 'D3. AGENTE NOMBRE'; }
        field(24; "00. FECHA"; date) { ExternalName = '00. FECHA'; }
        field(25; "00. AÑO"; integer) { ExternalName = '00. AÑO'; }
        field(26; "00. MES"; integer) { ExternalName = '00. MES'; }
        field(27; "00. TRIMESTRE"; integer) { ExternalName = '00. TRIMESTRE'; }
        field(28; "00. AÑO MES"; code[20]) { ExternalName = '00. AÑO MES'; }
        field(29; "00. SEMANA"; integer) { ExternalName = '00. SEMANA'; }
        field(30; "00. FECHA PROMETIDA ENTREGA"; Date) { ExternalName = '00. FECHA PROMETIDA ENTREGA'; }
        field(31; "00. FECHA ALTA PEDIDO"; Date) { ExternalName = '00. FECHA ALTA PEDIDO'; }
        field(32; "00. FECHA REQUERIDA ENTREGA"; Date) { ExternalName = '00. FECHA REQUERIDA ENTREGA'; }

        field(50999; ID; Guid)
        {
            Caption = 'ID';
            ExternalName = 'ID';
            ExternalType = 'Uniqueidentifier';
        }
    }

    keys
    {
        key(pk; "G8. DOCUMENT TYPE", "G3. PEDIDO NUM", "G4. PEDIDO LINEA")
        {
        }
    }
    trigger OnInsert()
    begin
        if IsNullGuid(Rec.ID) then
            Rec.ID := CreateGuid();
    end;

    var
        GenLedgerSetup: Record "General Ledger Setup";

    procedure CreateTableConnection()
    begin
        GenLedgerSetup.Get();
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI', GenLedgerSetup.AbertiaTABLECONNECTION());

        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;

    procedure CreateSalesPedidos(TypeUpdate: Option Nuevo,Periodo,Todo)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CountryRegion: Record "Country/Region";
        SalesPerson: Record "Salesperson/Purchaser";
        ABERTIASalesPedidos: Record "ABERTIA SalesPedidos";
        Suplemento: Integer;
        tx: Text;
        Window: Dialog;
    begin
        Window.Open('Tipo: #1#############\Nº Documento #2################');
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        case TypeUpdate of
            TypeUpdate::Nuevo:
                begin
                    if SalesHeader.FindLast() then
                        SalesHeader.SetFilter("No.", '%1..', ABERTIASalesPedidos."G3. PEDIDO NUM");
                end;
            TypeUpdate::Periodo:
                begin
                    SalesHeader.SetRange("Posting Date", GenLedgerSetup."Allow Posting From", GenLedgerSetup."Allow Posting To");
                end;
        end;
        if SalesHeader.FindFirst() then
            repeat
                Window.Update(1, SalesHeader."Document Type");
                Window.Update(2, SalesHeader."No.");
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindFirst() then
                    repeat
                        if not ABERTIASalesPedidos.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") then begin
                            ABERTIASalesPedidos.Init();
                            ABERTIASalesPedidos.ID := CreateGuid();
                        end;
                        ABERTIASalesPedidos."G8. DOCUMENT TYPE" := SalesLine."Document Type";
                        ABERTIASalesPedidos."G3. PEDIDO NUM" := SalesLine."Document No.";
                        ABERTIASalesPedidos."G4. PEDIDO LINEA" := SalesLine."Line No.";
                        ABERTIASalesPedidos."C6. CLIENTE COD" := SalesLine."Sell-to Customer No.";
                        ABERTIASalesPedidos."C6. CLIENTE NOMBRE" := SalesHeader."Sell-to Customer Name";
                        ABERTIASalesPedidos."E6. ARTICULO COD" := SalesLine."No.";
                        ABERTIASalesPedidos."E6. ARTICULO DESC" := SalesLine.Description;
                        ABERTIASalesPedidos."X1. CUSTOMER DISCOUNT GROUP" := SalesLine."Customer Disc. Group";
                        ABERTIASalesPedidos."K1. UNIDAD MEDIDA" := SalesLine."Unit of Measure Code";
                        ABERTIASalesPedidos."K1. CANTIDAD TOTAL PEDIDO" := SalesLine.Quantity;
                        ABERTIASalesPedidos."K1. CANTIDAD PENDIENTE" := SalesLine."Outstanding Quantity";
                        ABERTIASalesPedidos."K1. CANTIDAD A FACTURAR" := SalesLine."Qty. to Invoice";
                        ABERTIASalesPedidos."K1. CANTIDAD A ENVIAR" := SalesLine."Qty. to Ship";
                        ABERTIASalesPedidos."K1. CANTIDAD ENVIADA NO FACTURADA" := SalesLine."Qty. Shipped Not Invoiced";
                        ABERTIASalesPedidos."K1. CANTIDAD ENVIADA" := SalesLine."Quantity Shipped";
                        ABERTIASalesPedidos."K1. CANTIDAD FACTURADA" := SalesLine."Quantity Invoiced";
                        ABERTIASalesPedidos."K2. PVP" := SalesLine."Unit Price";
                        ABERTIASalesPedidos."K6. COSTE" := SalesLine."Unit Cost";
                        ABERTIASalesPedidos."K4. DESC CLIENTE (D2)" := SalesLine."Line Discount %";
                        ABERTIASalesPedidos."K4. DESC TOTAL OPERACION" := SalesLine."Line Discount Amount";
                        ABERTIASalesPedidos."K5. VENTA NETA CLIENTES" := SalesLine."Line Amount";
                        ABERTIASalesPedidos."X1. CUSTOMER PRICE GROUP" := SalesLine."Customer Price Group";
                        if SalesPerson.Get(SalesHeader."Salesperson Code") then
                            ABERTIASalesPedidos."D3. AGENTE NOMBRE" := SalesPerson.Name;
                        ABERTIASalesPedidos."00. FECHA" := SalesHeader."Document Date";
                        ABERTIASalesPedidos."00. AÑO" := Date2DMY(SalesHeader."Document Date", 3);
                        ABERTIASalesPedidos."00. MES" := Date2DMY(SalesHeader."Document Date", 2);
                        ABERTIASalesPedidos."00. TRIMESTRE" := GetQuarterOfDate(SalesHeader."Document Date");
                        ABERTIASalesPedidos."00. AÑO MES" := format(ABERTIASalesPedidos."00. AÑO") +
                                            PadStr('', 2 - StrLen(format(ABERTIASalesPedidos."00. MES")), '0') + format(ABERTIASalesPedidos."00. MES");
                        ABERTIASalesPedidos."00. SEMANA" := Date2DWY(SalesHeader."Document Date", 2);
                        ABERTIASalesPedidos."00. FECHA PROMETIDA ENTREGA" := SalesLine."Promised Delivery Date";
                        ABERTIASalesPedidos."00. FECHA ALTA PEDIDO" := SalesHeader."Order Date";
                        ABERTIASalesPedidos."00. FECHA REQUERIDA ENTREGA" := SalesLine."Requested Delivery Date";

                        if not ABERTIASalesPedidos.Insert() then
                            ABERTIASalesPedidos.Modify();
                    Until SalesLine.next() = 0;
            Until SalesHeader.next() = 0;
        Window.Close();
    end;

    procedure GetQuarterOfDate(DateToCheck: Date) Quarter: Integer;
    begin
        case Date2DMY(DateToCheck, 2) of
            1 .. 3:
                Quarter := 1;
            4 .. 6:
                Quarter := 2;
            7 .. 9:
                Quarter := 3;
            10 .. 12:
                Quarter := 4;
        end;
        EXIT(Quarter);
    end;

}