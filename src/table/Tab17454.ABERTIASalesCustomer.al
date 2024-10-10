table 17454 "ABERTIA SalesCustomer"
{
    Caption = 'ABERTIA Clientes';
    Description = 'ABERTIA - actualizacion datos Clientes';
    ExternalName = 'SalesCustomer';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {
        field(1; "No_"; code[50]) { ExternalName = 'No_'; }
        field(2; "Credito Maximo Interno_btc"; integer) { ExternalName = 'Credito Maximo Interno_btc'; }
        field(3; "Cred_ Max_ Int_ Autorizado Por_btc"; code[20]) { ExternalName = 'Cred_ Max_ Int_ Autorizado Por_btc'; }
        field(4; "Credito Maximo Aseguradora_btc"; Decimal) { ExternalName = 'Credito Maximo Aseguradora_btc'; }
        field(5; "Cred_ Max_ Aseg_ Autorizado Por_btc"; text[100]) { ExternalName = 'Cred_ Max_ Aseg_ Autorizado Por_btc'; }
        field(6; "Descuento1_btc"; Decimal) { ExternalName = 'Descuento1_btc'; }
        field(7; "Descuento2_btc"; Decimal) { ExternalName = 'Descuento2_btc'; }
        field(8; "CodMotivoBloqueo_btc"; code[20]) { ExternalName = 'CodMotivoBloqueo_btc'; }
        field(9; "Transaction Specification"; code[20]) { ExternalName = 'Transaction Specification'; }
        field(10; "Transaction Type"; code[20]) { ExternalName = 'Transaction Type'; }
        field(11; "Transport Method"; code[20]) { ExternalName = 'Transport Method'; }
        field(12; "Exit Point"; code[20]) { ExternalName = 'Exit Point'; }
        field(13; "Suplemento_aseguradora"; Integer) { ExternalName = 'Suplemento_aseguradora'; }
        field(14; "CentralCompras_btc"; code[20]) { ExternalName = 'CentralCompras_btc'; }
        field(15; "ClienteCorporativo_btc"; code[20]) { ExternalName = 'ClienteCorporativo_btc'; }
        field(16; "AreaManager_btc"; code[20]) { ExternalName = 'AreaManager_btc'; }
        field(17; "Delegado_btc"; code[20]) { ExternalName = 'Delegado_btc'; }
        field(18; "GrupoCliente"; code[20]) { ExternalName = 'GrupoCliente'; }
        field(19; "Perfil_btc"; code[20]) { ExternalName = 'Perfil_btc'; }
        field(20; "SubCliente_btc"; code[20]) { ExternalName = 'SubCliente_btc'; }
        field(21; "ClienteReporting_btc"; code[20]) { ExternalName = 'ClienteReporting_btc'; }
        field(22; "PermiteEnvioMail_btc"; Boolean) { ExternalName = 'PermiteEnvioMail_btc'; }
        field(23; "CorreoFactElec_btc"; text[80]) { ExternalName = 'CorreoFactElec_btc'; }
        field(24; "TipoFormarto_btc"; integer) { ExternalName = 'TipoFormarto_btc'; }
        field(25; "ClienteActividad_btc_"; code[20]) { ExternalName = 'ClienteActividad_btc_'; }
        field(26; "CondicionesEspeciales"; text[250]) { ExternalName = 'CondicionesEspeciales'; }
        field(27; "Rappel"; text[250]) { ExternalName = 'Rappel'; }
        field(28; "Formadepagosolicitada"; text[100]) { ExternalName = 'Formadepagosolicitada'; }
        field(29; "AlertaMaquina"; text[200]) { ExternalName = 'AlertaMaquina'; }
        field(30; "C4 CENTRAL DE COMPRAS"; code[20]) { ExternalName = 'C4 CENTRAL DE COMPRAS'; }
        field(31; "C4 CLIENTE REPORTING"; code[20]) { ExternalName = 'C4 CLIENTE REPORTING'; }
        field(32; "Name"; text[100]) { ExternalName = 'Name'; }
        field(33; "City"; text[30]) { ExternalName = 'City'; }
        field(34; "Country_Region Code"; text[100]) { ExternalName = 'Country_Region Code'; }
        field(35; "NOMBRE PAIS"; text[100]) { ExternalName = 'NOMBRE PAIS'; }
        field(36; "Post Code"; code[20]) { ExternalName = 'Post Code'; }
        field(37; "Name 2"; text[50]) { ExternalName = 'Name 2'; }
        field(38; "Expr1"; integer) { ExternalName = 'Expr1'; }
        field(39; "CodigoPais"; code[20]) { ExternalName = 'CodigoPais'; }
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

    procedure CreateSalesCustomer()
    var
        Customer: Record customer;
        Country: Record "Country/Region";
        ABERTIASalesCustomer: Record "ABERTIA SalesCustomer";
        Suplemento: Integer;
        Window: Dialog;
    begin
        Window.Open('Nº Cliente #1################');
        Customer.Reset();
        ABERTIASalesCustomer.Reset();
        // GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if Customer.FindFirst() then
            repeat
                Window.Update(1, Customer."No.");
                if not ABERTIASalesCustomer.Get(Customer."No.") then begin

                    ABERTIASalesCustomer.Init();
                    ABERTIASalesCustomer.ID := CreateGuid();
                end;
                ABERTIASalesCustomer."No_" := customer."No.";
                ABERTIASalesCustomer."Credito Maximo Interno_btc" := customer."Credito Maximo Interno_btc";
                ABERTIASalesCustomer."Cred_ Max_ Int_ Autorizado Por_btc" := customer."Cred_ Max_ Int_ Autorizado Por_btc";
                ABERTIASalesCustomer."Credito Maximo Aseguradora_btc" := customer."Credito Maximo Aseguradora_btc";
                ABERTIASalesCustomer."Cred_ Max_ Aseg_ Autorizado Por_btc" := customer."Cred_ Max_ Aseg. Autorizado Por_btc";
                ABERTIASalesCustomer."Descuento1_btc" := customer.Descuento1_btc;
                ABERTIASalesCustomer."Descuento2_btc" := customer.Descuento2_btc;
                ABERTIASalesCustomer."CodMotivoBloqueo_btc" := customer.CodMotivoBloqueo_btc;
                ABERTIASalesCustomer."Transaction Specification" := customer."Transaction Specification";
                ABERTIASalesCustomer."Transaction Type" := customer."Transaction Type";
                ABERTIASalesCustomer."Transport Method" := customer."Transport Method";
                ABERTIASalesCustomer."Exit Point" := customer."Exit Point";
                if Evaluate(Suplemento, customer.Suplemento_aseguradora) then
                    ABERTIASalesCustomer."Suplemento_aseguradora" := Suplemento;
                ABERTIASalesCustomer."CentralCompras_btc" := customer.CentralCompras_btc;
                ABERTIASalesCustomer."ClienteCorporativo_btc" := customer.ClienteCorporativo_btc;
                ABERTIASalesCustomer."AreaManager_btc" := customer.AreaManager_btc;
                ABERTIASalesCustomer."Delegado_btc" := customer.Delegado_btc;
                ABERTIASalesCustomer."GrupoCliente" := customer.GrupoCliente_btc;
                ABERTIASalesCustomer."Perfil_btc" := customer.Perfil_btc;
                ABERTIASalesCustomer."SubCliente_btc" := customer.SubCliente_btc;
                ABERTIASalesCustomer."ClienteReporting_btc" := customer.ClienteReporting_btc;
                ABERTIASalesCustomer."PermiteEnvioMail_btc" := customer.PermiteEnvioMail_btc;
                ABERTIASalesCustomer."CorreoFactElec_btc" := customer.CorreoFactElec_btc;
                ABERTIASalesCustomer."TipoFormarto_btc" := customer.TipoFormarto_btc;
                ABERTIASalesCustomer."ClienteActividad_btc_" := customer.ClienteActividad_btc;
                ABERTIASalesCustomer."CondicionesEspeciales" := customer.CondicionesEspeciales;
                ABERTIASalesCustomer."Rappel" := customer.Rappel;
                ABERTIASalesCustomer."Formadepagosolicitada" := customer.Formadepagosolicitada;
                ABERTIASalesCustomer."AlertaMaquina" := customer.AlertaMaquina;
                ABERTIASalesCustomer."C4 CENTRAL DE COMPRAS" := customer.CentralCompras_btc;
                ABERTIASalesCustomer."C4 CLIENTE REPORTING" := customer.ClienteReporting_btc;
                ABERTIASalesCustomer."Name" := customer.Name;
                ABERTIASalesCustomer."City" := customer.City;
                ABERTIASalesCustomer."Country_Region Code" := customer."Country/Region Code";
                if Country.Get(Customer."Country/Region Code") then;
                ABERTIASalesCustomer."NOMBRE PAIS" := Country.Name;
                ABERTIASalesCustomer."Post Code" := customer."Post Code";
                ABERTIASalesCustomer."Name 2" := customer."Name 2";
                // ABERTIASalesCustomer."Expr1" := customer.e
                ABERTIASalesCustomer."CodigoPais" := customer."Country/Region Code";
                if not ABERTIASalesCustomer.Insert() then
                    ABERTIASalesCustomer.Modify();
            Until Customer.next() = 0;
        Window.Close();
    end;
}