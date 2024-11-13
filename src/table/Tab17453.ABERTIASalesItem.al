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
        field(6; ValidadoContabiliad_btc; Integer) { ExternalName = 'ValidadoContabiliad_btc'; }
        field(7; OptClasVtas_btc; Integer) { ExternalName = 'OptClasVtas_btc'; }
        field(8; OptFamilia_btc; Integer) { ExternalName = 'OptFamilia_btc'; }
        field(9; OptGama_btc; Integer) { ExternalName = 'OptGama_btc'; }
        field(10; ContraStock_BajoPedido; Integer) { ExternalName = 'ContraStock_BajoPedido'; }
        field(11; PedidoMaximo; Decimal) { ExternalName = 'PedidoMaximo'; }
        field(12; selClasVtas_btc; Integer) { ExternalName = 'selClasVtas_btc'; }
        field(13; selFamilia_btc; Integer) { ExternalName = 'selFamilia_btc'; }
        field(14; selGama_btc; code[20]) { ExternalName = 'selGama_btc'; }
        field(15; selLineaEconomica_btc; Integer) { ExternalName = 'selLineaEconomica_btc'; }
        field(16; ABC; Integer) { ExternalName = 'ABC'; }
        field(17; TasaRAEE; Decimal) { ExternalName = 'TasaRAEE'; }
        field(18; ClasifVentas; code[20]) { ExternalName = 'ClasifVentas'; }
        field(19; Familia; code[20]) { ExternalName = 'Familia'; }
        field(20; GAMA; code[20]) { ExternalName = 'GAMA'; }
        field(21; LineaEconomica; code[20]) { ExternalName = 'LineaEconomica'; }
        field(22; Canal; code[20]) { ExternalName = 'Canal'; }
        field(50998; "00 - Origen"; code[10])
        {
            ExternalName = '00 - Origen';
        }
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
        CUCron: Codeunit CU_Cron;

    procedure CreateTableConnection()
    begin
        GenLedgerSetup.Get();
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI', GenLedgerSetup.AbertiaTABLECONNECTION());

        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;

    procedure CreateSalesItem() RecordNo: Integer;
    var
        Item: record Item;
        Window: Dialog;
    begin
        Window.Open('Nº Producto #1################');
        Item.Reset();
        // GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if Item.FindSet() then
            repeat
                Window.Update(1, Item."No.");
                item.CalcFields(desClasVtas_btc, desFamilia_btc, desGama_btc, desLineaEconomica_btc);
                if not ABERTIAItems(Item) then
                    CUCron.ABERTIALOGUPDATE('Item', GetLastErrorText());
                RecordNo += 1;
                Commit();
            Until Item.next() = 0;
        CUCron.ABERTIALOGUPDATE('Items', StrSubstNo('Record No: %1', RecordNo));
        Window.Close();
    end;

    [TryFunction]
    local procedure ABERTIAItems(Item: record Item)
    var
        ABERTIASalesItem: Record "ABERTIA SalesItem";
        Suplemento: Integer;
    begin
        ABERTIASalesItem.Reset();
        if not ABERTIASalesItem.Get(Item."No.") then begin
            ABERTIASalesItem.Init();
            ABERTIASalesItem.ID := CreateGuid();
        end;
        ABERTIASalesItem."No_" := Item."No.";
        ABERTIASalesItem.ClasVtas_btc := Item.optClasVtas_btc;
        ABERTIASalesItem.Familia_btc := Item.optFamilia_btc;
        ABERTIASalesItem.Gama_btc := Item.optGama_btc;
        ABERTIASalesItem.Ordenacion_btc := Item.Ordenacion_btc;
        // ABERTIASalesItem.ValidadoContabiliad_btc := Item.ValidadoContabiliad_btc;
        ABERTIASalesItem.OptClasVtas_btc := Item.OptClasVtas_btc;
        ABERTIASalesItem.OptFamilia_btc := Item.OptFamilia_btc;
        ABERTIASalesItem.OptGama_btc := Item.OptGama_btc;
        ABERTIASalesItem.ContraStock_BajoPedido := Item."ContraStock/BajoPedido";
        ABERTIASalesItem.PedidoMaximo := Item.PedidoMaximo;
        if Evaluate(Suplemento, Item.selClasVtas_btc) then
            ABERTIASalesItem.selClasVtas_btc := Suplemento;
        if Evaluate(Suplemento, Item.selFamilia_btc) then
            ABERTIASalesItem.selFamilia_btc := Suplemento;
        ABERTIASalesItem.selGama_btc := Item.selGama_btc;
        if Evaluate(Suplemento, Item.selLineaEconomica_btc) then
            ABERTIASalesItem.selLineaEconomica_btc := Suplemento;
        ABERTIASalesItem.ABC := Item.ABC;
        ABERTIASalesItem.TasaRAEE := Item.TasaRAEE;
        ABERTIASalesItem.ClasifVentas := Item.desClasVtas_btc;
        ABERTIASalesItem.Familia := Item.desFamilia_btc;
        ABERTIASalesItem.GAMA := Item.desGama_btc;
        ABERTIASalesItem.LineaEconomica := Item.desLineaEconomica_btc;
        ABERTIASalesItem.Canal := format(Item.Canal);
        Case CompanyName of
            'ZUMMO':
                ABERTIASalesItem."00 - Origen" := 'ZIM';
            'INVESTMENTS':
                ABERTIASalesItem."00 - Origen" := 'ZINV';
        end;
        if not ABERTIASalesItem.Insert() then
            ABERTIASalesItem.Modify();

    end;
}