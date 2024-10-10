table 17453 "ABERTIA SalesItem"
{
    Caption = 'ABERTIA Productos';
    Description = 'ABERTIA - actualizacion datos Productos';
    ExternalName = 'ItemCompleto';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {
        field(1; "No_"; code[20]) { ExternalName = 'No_'; }
        field(2; ClasVtas_btc; Integer) { ExternalName = 'ClasVtas_btc'; }
        field(3; Familia_btc; Integer) { ExternalName = 'Familia_btc'; }
        field(4; Gama_btc; Integer) { ExternalName = 'Gama_btc'; }
        field(5; Ordenacion_btc; Integer) { ExternalName = 'Ordenacion_btc'; }
        field(6; ValidadoContabiliad_btc; Boolean) { ExternalName = 'ValidadoContabiliad_btc'; }
        field(7; OptClasVtas_btc; Integer) { ExternalName = 'OptClasVtas_btc'; }
        field(8; OptFamilia_btc; Integer) { ExternalName = 'OptFamilia_btc'; }
        field(9; OptGama_btc; Integer) { ExternalName = 'OptGama_btc'; }
        field(10; ContraStock_BajoPedido; Integer) { ExternalName = 'ContraStock_BajoPedido'; }
        field(11; PedidoMaximo; Integer) { ExternalName = 'PedidoMaximo'; }
        field(12; selClasVtas_btc; code[20]) { ExternalName = 'selClasVtas_btc'; }
        field(13; selFamilia_btc; code[20]) { ExternalName = 'selFamilia_btc'; }
        field(14; selGama_btc; code[20]) { ExternalName = 'selGama_btc'; }
        field(15; selLineaEconomica_btc; code[20]) { ExternalName = 'selLineaEconomica_btc'; }
        field(16; ABC; Integer) { ExternalName = 'ABC'; }
        field(17; TasaRAEE; Decimal) { ExternalName = 'TasaRAEE'; }
        field(18; ClasifVentas; code[20]) { ExternalName = 'ClasifVentas'; }
        field(19; Familia; code[20]) { ExternalName = 'Familia'; }
        field(20; GAMA; code[20]) { ExternalName = 'GAMA'; }
        field(21; LineaEconomica; code[20]) { ExternalName = 'LineaEconomica'; }
        field(22; Canal; Integer) { ExternalName = 'Canal'; }

        field(50999; ID; Guid)
        {
            Caption = 'ID';
            ExternalName = 'ID';
            ExternalType = 'Uniqueidentifier';
        }
    }

    keys
    {
        key(pk; No_)
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

    procedure CreateSalesItem()
    var
        Item: record Item;
        ABERTIASalesItem: Record "ABERTIA SalesItem";
        Suplemento: Integer;
        Window: Dialog;
    begin
        Window.Open('Nº Producto #1################');
        Item.Reset();
        ABERTIASalesItem.Reset();
        // GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if Item.FindFirst() then
            repeat
                Window.Update(1, Item."No.");
                item.CalcFields(desClasVtas_btc, desFamilia_btc, desGama_btc, desLineaEconomica_btc);
                if not ABERTIASalesItem.Get(Item."No.") then begin

                    ABERTIASalesItem.Init();
                    ABERTIASalesItem.ID := CreateGuid();
                end;
                ABERTIASalesItem."No_" := Item."No.";
                ABERTIASalesItem.ClasVtas_btc := Item.optClasVtas_btc;
                ABERTIASalesItem.Familia_btc := Item.optFamilia_btc;
                ABERTIASalesItem.Gama_btc := Item.optGama_btc;
                ABERTIASalesItem.Ordenacion_btc := Item.Ordenacion_btc;
                ABERTIASalesItem.ValidadoContabiliad_btc := Item.ValidadoContabiliad_btc;
                ABERTIASalesItem.OptClasVtas_btc := Item.OptClasVtas_btc;
                ABERTIASalesItem.OptFamilia_btc := Item.OptFamilia_btc;
                ABERTIASalesItem.OptGama_btc := Item.OptGama_btc;
                ABERTIASalesItem.ContraStock_BajoPedido := Item."ContraStock/BajoPedido";
                ABERTIASalesItem.PedidoMaximo := Item.PedidoMaximo;
                ABERTIASalesItem.selClasVtas_btc := Item.selClasVtas_btc;
                ABERTIASalesItem.selFamilia_btc := Item.selFamilia_btc;
                ABERTIASalesItem.selGama_btc := Item.selGama_btc;
                ABERTIASalesItem.selLineaEconomica_btc := Item.selLineaEconomica_btc;
                ABERTIASalesItem.ABC := Item.ABC;
                ABERTIASalesItem.TasaRAEE := Item.TasaRAEE;
                ABERTIASalesItem.ClasifVentas := Item.desClasVtas_btc;
                ABERTIASalesItem.Familia := Item.desFamilia_btc;
                ABERTIASalesItem.GAMA := Item.desGama_btc;
                ABERTIASalesItem.LineaEconomica := Item.desLineaEconomica_btc;
                ABERTIASalesItem.Canal := Item.Canal;
                if not ABERTIASalesItem.Insert() then
                    ABERTIASalesItem.Modify();

            Until Item.next() = 0;
        Window.Close();
    end;
}