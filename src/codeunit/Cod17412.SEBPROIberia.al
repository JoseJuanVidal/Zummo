codeunit 17412 "SEB PRO Iberia"
{
    trigger OnRun()
    begin

    end;

    var
        DataSourceTok: label 'Data Source=%1;Initial Catalog=%2;User Id=%3;Password=%4;';

    local procedure SQLConnect(var SQLConnection: dotnet SQLConnection)
    var
        GLSetup: Record "General Ledger Setup";
        ConnStr: text;
    begin
        GLSetup.Get();
        GLSetup.TestField("Data Source");
        GLSetup.TestField("Initial Catalog");
        GLSetup.TestField("User Id");
        GLSetup.TestField("Password");
        // ConnStr := StrSubstNo(DataSourceTok, 'zummo.ddns.net', 'ReportingZummo', 'zummo', '@b3rti@');
        ConnStr := StrSubstNo(DataSourceTok, GLSetup."Data Source", 'ZUMMOREM', GLSetup."User Id", GLSetup."Password");
        SQLConnection := SQLConnection.SQLConnection(ConnStr);
        SQLConnection.Open();
    end;

    local procedure SQLRGetString(SQLReader: DotNet SqlDataReader; IndexField: Integer): Text
    begin
        if not SQLReader.IsDBNull(IndexField) then
            exit(SQLReader.GetString(IndexField));
    end;

    local procedure SQLRGetStringFieldName(SQLReader: DotNet SqlDataReader; IndexFieldName: Text): Text
    var
        IndexField: Integer;
    begin
        IndexField := SQLReader.GetOrdinal(IndexFieldName);
        if not SQLReader.IsDBNull(IndexField) then
            exit(SQLReader.GetString(IndexField));
    end;

    local procedure SQLRGetStringDate(SQLReader: DotNet SqlDataReader; IndexField: Integer): date
    var
        Fecha: text;
        Result: date;
    begin
        if not SQLReader.IsDBNull(IndexField) then begin
            Fecha := SQLReader.GetString(IndexField);
            Fecha := StrSubstNo('%1/%2/%3', copystr(Fecha, 1, 2), copystr(Fecha, 3, 2), copystr(Fecha, 7, 4));
            if Evaluate(Result, Fecha) then
                exit(Result);
        end;
    end;

    local procedure SQLRGetStringDateFieldName(SQLReader: DotNet SqlDataReader; IndexFieldName: Text): date
    var
        IndexField: Integer;
        Fecha: text;
        Result: date;
    begin
        IndexField := SQLReader.GetOrdinal(IndexFieldName);
        if not SQLReader.IsDBNull(IndexField) then begin
            Fecha := SQLReader.GetString(IndexField);
            Fecha := StrSubstNo('%1/%2/%3', copystr(Fecha, 1, 2), copystr(Fecha, 3, 2), copystr(Fecha, 7, 4));
            if Evaluate(Result, Fecha) then
                exit(Result);
        end;
    end;

    local procedure SQLRGetDate(SQLReader: DotNet SqlDataReader; IndexField: Integer): date
    begin
        if not SQLReader.IsDBNull(IndexField) then
            exit(DT2Date(SQLReader.GetDateTime((IndexField))));
    end;

    local procedure SQLRGetDateTime(SQLReader: DotNet SqlDataReader; IndexField: Integer): DateTime
    begin
        if not SQLReader.IsDBNull(IndexField) then
            exit(SQLReader.GetDateTime((IndexField)));
    end;

    local procedure SQLRGetDecimal(SQLReader: DotNet SqlDataReader; IndexField: Integer): Decimal
    begin
        if not SQLReader.IsDBNull(IndexField) then
            exit(SQLReader.GetDouble((IndexField)));
    end;

    local procedure SQLRGetDecimalFieldName(SQLReader: DotNet SqlDataReader; IndexFieldName: text): Decimal
    var
        IndexField: Integer;
        txtValue: text;
        Value: decimal;
    begin
        IndexField := SQLReader.GetOrdinal(IndexFieldName);
        if not SQLReader.IsDBNull(IndexField) then begin
            txtValue := SQLReader.GetString(IndexField);
            if Evaluate(Value, txtValue) then
                exit(Value);
        end;
    end;

    procedure GetItemTextos()
    var
        Item: Record Item;
        ItemTranslation: record "Item Translation";
        SQLConnection: DotNet SqlConnection;
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        texto: text;
        CustomerNoSEB: code[20];
        VatNoSeb: code[50];
        UpdateCustomer: Boolean;
        cont: Integer;
        Windows: Dialog;
        lblSQLSelect: Label 'SELECT TOP (1000) [material] ,[idioma] ,[texto_breve_de_material] ,[texto_breve_de_material_2]  FROM [ZUMMOREM].[dbo].[materialestextos_stg] where idioma = ''E''  and material = ''%1''';
        lblWindow: Label 'Nº #1##########\Registro #2#########\#3####### de #4########', comment = 'ESP="Nº #1##########\Registro #2#########\#3####### de #4########"';
    begin
        windows.Open(lblWindow);
        if IsNull(SQLConnection) then
            SQLConnect(SQLConnection);
        Item.SetFilter("No. 2", '<>%1', '');
        windows.update(4, Item.Count);
        if Item.FindFirst() then
            repeat
                cont += 1;
                Windows.Update(1, Item."No. 2");
                Windows.Update(3, cont);
                Clear(SQLCommand);
                SQLCommand := SQLConnection.CreateCommand();
                // SQLCommand.CommandText := 'select * From ItemCompleto';
                SQLCommand.CommandText := StrSubstNo(lblSQLSelect, ClearItemNo(Item."No. 2"));
                // ** EXEC READER **
                SQLReader := SQLCommand.ExecuteReader;
                IF SQLReader.HasRows then
                    while SQLReader.Read() do begin
                        windows.update(2, SQLRGetSTring(SQLReader, 0));
                        CustomerNoSEB := SQLRGetSTring(SQLReader, 0);
                        if not ItemTranslation.Get(Item."No.", '', 'ESP') then begin
                            ItemTranslation.Init();
                            ItemTranslation."Item No." := Item."No.";
                            ItemTranslation."Variant Code" := '';
                            ItemTranslation."Language Code" := 'ESP';
                            ItemTranslation.Insert();
                        end;
                        ItemTranslation.Description := UpperCase(SQLRGetSTring(SQLReader, 2));
                        ItemTranslation.Modify();

                    end;
                SQLReader.Close();
            //     exit(false);
            Until Item.next() = 0;
        windows.close;
        // exit(true);
        //Page.Run(0, Customer);
    end;


    procedure GetClients(ClientNo: Code[20])
    var
        Customer: Record Customer;
        tmpCustomer: Record Customer temporary;
        SQLConnection: DotNet SqlConnection;
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        texto: text;
        CustomerNoSEB: code[20];
        VatNoSeb: code[50];
        UpdateCustomer: Boolean;
        Windows: Dialog;
        lblSQLSelect: Label 'SELECT *  FROM [CLIENTS$] WHERE cliente is not null and cliente =''%1'' ORDER BY [Cliente]';
        lblWindow: Label 'Nº Cliente #1##########\Registro #2#########\#3####### de #4########', comment = 'ESP="Nº Cliente #1##########\Registro #2#########\#3####### de #4########"';
    begin
        windows.Open(lblWindow);
        if IsNull(SQLConnection) then
            SQLConnect(SQLConnection);
        Clear(SQLCommand);
        SQLCommand := SQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        SQLCommand.CommandText := StrSubstNo(lblSQLSelect, ClientNo);
        // ** EXEC READER **
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            while SQLReader.Read() do begin
                windows.update(1, SQLRGetSTring(SQLReader, 0));
                CustomerNoSEB := SQLRGetSTring(SQLReader, 0);
                VatNoSeb := SQLRGetSTring(SQLReader, 62);
                if VatNoSeb = '' then
                    VatNoSeb := SQLRGetSTring(SQLReader, 51);

                if CheckCustomerSEBExist(CustomerNoSEB, Customer) then
                    UpdateCustomer := true
                else if CheckCustomerVatExist(CustomerNoSEB, VatNoSeb, Customer) then
                    UpdateCustomer := false
                else begin
                    Customer.Init();
                    Customer."No." := '';
                    // aplicar plantilla
                    UpdateCustomerFromTemplate(Customer);

                    windows.update(2, Customer."No.");
                    UpdateCustomer := true
                    //Customer."No." := CopyStr(SQLRGetSTring(SQLReader, 0), 1, MaxStrLen(Customer."No."));     //   [Cliente]
                    // Customer."No." := NoSeriesMgt.GetNextNo(Customer."No. Series", WorkDate(), true);
                end;
                if UpdateCustomer then begin
                    GetFieldsCustomerSQLReader(tmpCustomer, SQLReader);
                    //actualizamos datos si es cliente de SEB y no de Zummo
                    Customer."Codigo Anterior" := tmpCustomer."Codigo Anterior";
                    Customer."Country/Region Code" := tmpCustomer."Country/Region Code";
                    Customer.validate(Name, tmpCustomer.Name);
                    Customer."Name 2" := tmpCustomer."Name 2";
                    Customer.validate("Post Code", tmpCustomer."Post Code");
                    Customer.City := tmpCustomer.City;
                    Customer.Address := tmpCustomer.Address;
                    Customer."Phone No." := tmpCustomer."Phone No.";
                    Customer."Fax No." := tmpCustomer."Fax No.";
                    Customer.Address := tmpCustomer.Address;
                    Customer."Phone No." := tmpCustomer."Phone No.";
                    Customer."Fax No." := tmpCustomer."Fax No.";
                    Customer.FechaAlta := tmpCustomer.FechaAlta;
                    Customer."VAT Registration No." := tmpCustomer."VAT Registration No.";

                    UpdateCustomerAuxiliares(Customer);

                    Customer.Modify();
                    UpdateSQLCodigNAV(Customer."Codigo Anterior", Customer."No.", 'ALTA NUEVA');
                end;
            end;
        //     exit(false);
        windows.close;
        // exit(true);
        //Page.Run(0, Customer);
    end;

    local procedure GetFieldsCustomerSQLReader(var tmpCustomer: Record Customer; var SQLReader: DotNet SqlDataReader)
    var
        myInt: Integer;
    begin
        if not tmpCustomer.IsTemporary then
            Error('%1 debe ser temporal', tmpCustomer.Name);
        tmpCustomer.DeleteAll();
        tmpCustomer.Init();
        tmpCustomer."Codigo Anterior" := CopyStr(SQLRGetSTring(SQLReader, 0), 1, MaxStrLen(tmpCustomer."No."));     //   [Cliente]
        tmpCustomer."Country/Region Code" := CopyStr(SQLRGetSTring(SQLReader, 1), 1, MaxStrLen(tmpCustomer."Country/Region Code")); //   ,[Ps]
        tmpCustomer.validate(Name, CopyStr(SQLRGetSTring(SQLReader, 2), 1, MaxStrLen(tmpCustomer.Name)));  //   ,[Nombre 1]
        tmpCustomer."Name 2" := CopyStr(SQLRGetSTring(SQLReader, 3), 1, MaxStrLen(tmpCustomer."Name 2"));  //   ,[Nombre 2]
        tmpCustomer.City := CopyStr(SQLRGetSTring(SQLReader, 4), 1, MaxStrLen(tmpCustomer.City));  //   ,[Poblaci]
        tmpCustomer."Post Code" := CopyStr(SQLRGetSTring(SQLReader, 5), 1, MaxStrLen(tmpCustomer."Post Code"));
        //   ,[CP]
        // Customer."Post Code" := CopyStr(SQLRGetSTring(SQLReader,6),1,MaxStrLen(Customer."Post Code"));  //   ,[Rg] 
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,7),1,MaxStrLen(Customer.)); //   ,[Conc#b俍q#] TODO
        tmpCustomer.Address := CopyStr(SQLRGetSTring(SQLReader, 8), 1, MaxStrLen(tmpCustomer.Address));  //   ,[Calle]
        tmpCustomer."Phone No." := CopyStr(format(SQLRGetDecimal(SQLReader, 9)), 1, MaxStrLen(tmpCustomer."Phone No."));  //   ,[Tel馭ono 1]        
        tmpCustomer."Fax No." := CopyStr(format(SQLRGetDecimal(SQLReader, 10)), 1, MaxStrLen(tmpCustomer."Fax No."));
        //      ,[Nｺ telefax]      
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,11), 1, MaxStrLen(Customer.)); ,[Cuenta CPD]      
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,12), 1, MaxStrLen(Customer.)); //  ,[Direcci]      0050005458
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,13), 1, MaxStrLen(Customer.)); //  ,[Nombre 11]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,14), 1, MaxStrLen(Customer.)); //        ,[Nombre 21]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,15), 1, MaxStrLen(Customer.)); //        ,[Poblaci1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,16), 1, MaxStrLen(Customer.)); //        ,[Tratamiento]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,17), 1, MaxStrLen(Customer.)); //     ,[BqPed]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,18), 1, MaxStrLen(Customer.)); //        ,[Estac#ferrocarril expreso]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,19), 1, MaxStrLen(Customer.)); //        ,[Estaci de tren]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,20), 1, MaxStrLen(Customer.)); //        ,[NUI 1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,21), 1, MaxStrLen(Customer.)); //        ,[NUI 2]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,22), 1, MaxStrLen(Customer.)); //        ,[GrA]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,23), 1, MaxStrLen(Customer.)); //        ,[Ramo]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,24), 1, MaxStrLen(Customer.)); //        ,[D刕#ctrl#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,25), 1, MaxStrLen(Customer.)); //        ,[L匤TransmDatos]
        tmpCustomer.FechaAlta := SQLRGetStringDate(SQLReader, 26);
        //        ,[Fecha]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,27), 1, MaxStrLen(Customer.)); //        ,[Autor]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,28), 1, MaxStrLen(Customer.)); //        ,[PsDes]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,29), 1, MaxStrLen(Customer.)); //        ,[BlqFa]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,30), 1, MaxStrLen(Customer.)); //        ,[Dom#fisc#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,31), 1, MaxStrLen(Customer.)); //        ,[Calendario horario trabajo]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,32), 1, MaxStrLen(Customer.)); //     ,[Pag#alt#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,33), 1, MaxStrLen(Customer.)); //        ,[Grupo]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,34), 1, MaxStrLen(Customer.)); //        ,[Grupo1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,35), 1, MaxStrLen(Customer.)); //   ,[Cl]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,36), 1, MaxStrLen(Customer.)); //   ,[Acreedor]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,37), 1, MaxStrLen(Customer.)); //   ,[BqEnt]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,38), 1, MaxStrLen(Customer.)); //   ,[C#loc#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,39), 1, MaxStrLen(Customer.)); //   ,[PBor]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,40), 1, MaxStrLen(Customer.)); //   ,[Nombre 3]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,41), 1, MaxStrLen(Customer.)); //   ,[Nombre 4]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,42), 1, MaxStrLen(Customer.)); //   ,[CN]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,43), 1, MaxStrLen(Customer.)); //   ,[Distrito]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,44), 1, MaxStrLen(Customer.)); //   ,[Apartado]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,45), 1, MaxStrLen(Customer.)); //   ,[CP apdo#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,46), 1, MaxStrLen(Customer.)); //   ,[CCD]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,47), 1, MaxStrLen(Customer.)); //   ,[Mun#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,48), 1, MaxStrLen(Customer.)); //   ,[MerRg]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,49), 1, MaxStrLen(Customer.)); //   ,[B]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,50), 1, MaxStrLen(Customer.)); //   ,[Idioma]
        // Customer.Validate("VAT Registration No.", CopyStr(SQLRGetSTring(SQLReader, 51), 1, MaxStrLen(Customer."VAT Registration No."))); //   ,[Nｺ ident#fis#1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,52), 1, MaxStrLen(Customer.)); //   ,[Nｺ ident#fis#2]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,53), 1, MaxStrLen(Customer.)); //   ,[Rec#equiv#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,54), 1, MaxStrLen(Customer.)); //   ,[Sujeto a IVA]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,55), 1, MaxStrLen(Customer.)); //   ,[Telebox]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,56), 1, MaxStrLen(Customer.)); //   ,[Tel馭ono 2]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,57), 1, MaxStrLen(Customer.)); //   ,[N伹ero de teletex]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,58), 1, MaxStrLen(Customer.)); //   ,[N伹ero de t駘ex]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,59), 1, MaxStrLen(Customer.)); //   ,[ZonaTransp]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,60), 1, MaxStrLen(Customer.)); //   ,[Pag#doc#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,61), 1, MaxStrLen(Customer.)); //   ,[SocGLA]
        tmpCustomer."VAT Registration No." := CopyStr(SQLRGetSTring(SQLReader, 62), 1, MaxStrLen(tmpCustomer."VAT Registration No."));
        //   ,[N#I#F# comunitario]  TODO Nif con ES delante
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,63), 1, MaxStrLen(Customer.)); //   ,[M]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,64), 1, MaxStrLen(Customer.)); //   ,[I]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,65), 1, MaxStrLen(Customer.)); //   ,[I1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,66), 1, MaxStrLen(Customer.)); //   ,[S]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,67), 1, MaxStrLen(Customer.)); //   ,[SpD]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,68), 1, MaxStrLen(Customer.)); //   ,[SJ]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,69), 1, MaxStrLen(Customer.)); //   ,[C#ramo 1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,70), 1, MaxStrLen(Customer.)); //   ,[C#ramo 2]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,71), 1, MaxStrLen(Customer.)); //   ,[C#ramo 3]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,72), 1, MaxStrLen(Customer.)); //   ,[C#ramo 4]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,73), 1, MaxStrLen(Customer.)); //   ,[C#ramo 5]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,74), 1, MaxStrLen(Customer.)); //   ,[PrimerCont]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,75), 1, MaxStrLen(Customer.)); //   ,[Vol#neg#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,76), 1, MaxStrLen(Customer.)); //   ,[Mon#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,77), 1, MaxStrLen(Customer.)); //   ,[en]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,78), 1, MaxStrLen(Customer.)); //   ,[Mon#1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,79), 1, MaxStrLen(Customer.)); //   ,[Empleados]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,80), 1, MaxStrLen(Customer.)); //   ,[en1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,81), 1, MaxStrLen(Customer.)); //   ,[A1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,82), 1, MaxStrLen(Customer.)); //   ,[A2]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,83), 1, MaxStrLen(Customer.)); //   ,[A3]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,84), 1, MaxStrLen(Customer.)); //   ,[A4]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,85), 1, MaxStrLen(Customer.)); //   ,[A5]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,86), 1, MaxStrLen(Customer.)); //   ,[A6]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,87), 1, MaxStrLen(Customer.)); //   ,[A7]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,88), 1, MaxStrLen(Customer.)); //   ,[A8]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,89), 1, MaxStrLen(Customer.)); //   ,[A9]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,90), 1, MaxStrLen(Customer.)); //   ,[A10]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,91), 1, MaxStrLen(Customer.)); //   ,[Pers#f﨎#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,92), 1, MaxStrLen(Customer.)); //   ,[Vol#neg#anual]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,93), 1, MaxStrLen(Customer.)); //   ,[Mon#2]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,94), 1, MaxStrLen(Customer.)); //   ,[Domicil#fiscal]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,95), 1, MaxStrLen(Customer.)); //   ,[VE]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,96), 1, MaxStrLen(Customer.)); //   ,[Util#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,97), 1, MaxStrLen(Customer.)); //   ,[PorPartClt]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,98), 1, MaxStrLen(Customer.)); //   ,[Tras entr#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,99), 1, MaxStrLen(Customer.)); //   ,[GrRef#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,100), 1, MaxStrLen(Customer.)); //   ,[Pob#apdo#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,101), 1, MaxStrLen(Customer.)); //   ,[Ce#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,102), 1, MaxStrLen(Customer.)); //   ,[N]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,103), 1, MaxStrLen(Customer.)); //   ,[CI]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,104), 1, MaxStrLen(Customer.)); //   ,[Status trans#datos a release s]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,105), 1, MaxStrLen(Customer.)); //   ,[AJ]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,106), 1, MaxStrLen(Customer.)); //   ,[Blq#pago]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,107), 1, MaxStrLen(Customer.)); //   ,[EtiqGrClie]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,108), 1, MaxStrLen(Customer.)); //   ,[UtilCivil]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,109), 1, MaxStrLen(Customer.)); //   ,[UtilizMil]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,110), 1, MaxStrLen(Customer.)); //   ,[GrC1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,111), 1, MaxStrLen(Customer.)); //   ,[GrC2]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,112), 1, MaxStrLen(Customer.)); //   ,[GrC3]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,113), 1, MaxStrLen(Customer.)); //   ,[GrC4]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,114), 1, MaxStrLen(Customer.)); //   ,[GrC5]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,115), 1, MaxStrLen(Customer.)); //   ,[PagAltCta]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,116), 1, MaxStrLen(Customer.)); //   ,[Cl#impto#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,117), 1, MaxStrLen(Customer.)); //   ,[Tipo NIF]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,118), 1, MaxStrLen(Customer.)); //   ,[NIF 3]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,119), 1, MaxStrLen(Customer.)); //   ,[NIF 4]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,120), 1, MaxStrLen(Customer.)); //   ,[Steuernummer 5]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,121), 1, MaxStrLen(Customer.)); //   ,[Sin ICMS]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,122), 1, MaxStrLen(Customer.)); //   ,[Sin IPI]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,123), 1, MaxStrLen(Customer.)); //   ,[Grupo Subt]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,124), 1, MaxStrLen(Customer.)); //   ,[CFOP]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,125), 1, MaxStrLen(Customer.)); //   ,[Txt]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,126), 1, MaxStrLen(Customer.)); //   ,[Txt1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,127), 1, MaxStrLen(Customer.)); //   ,[Guerra c/armas qu匇icas/biol]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,128), 1, MaxStrLen(Customer.)); //   ,[No proliferaci tecnolog僘 nu]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,129), 1, MaxStrLen(Customer.)); //   ,[Seg#nac#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,130), 1, MaxStrLen(Customer.)); //   ,[Tecn#mis#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,131), 1, MaxStrLen(Customer.)); //   ,[BlCon]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,132), 1, MaxStrLen(Customer.)); //   ,[URL]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,133), 1, MaxStrLen(Customer.)); //   ,[Nombre del representante]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,134), 1, MaxStrLen(Customer.)); //   ,[Tipo de operaci]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,135), 1, MaxStrLen(Customer.)); //   ,[Tipo de industria]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,136), 1, MaxStrLen(Customer.)); //   ,[Stat#conf#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,137), 1, MaxStrLen(Customer.)); //   ,[Fe#conf#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,138), 1, MaxStrLen(Customer.)); //   ,[H#confirm#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,139), 1, MaxStrLen(Customer.)); //   ,[BlBo]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,140), 1, MaxStrLen(Customer.)); //   ,[Consumidor]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,141), 1, MaxStrLen(Customer.)); //   ,[Altura m痊ima]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,142), 1, MaxStrLen(Customer.)); //   ,[UL]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,143), 1, MaxStrLen(Customer.)); //   ,[UL1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,144), 1, MaxStrLen(Customer.)); //   ,[EmbCl]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,145), 1, MaxStrLen(Customer.)); //   ,[ME cliente]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,146), 1, MaxStrLen(Customer.)); //   ,[CtdPalInt]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,147), 1, MaxStrLen(Customer.)); //   ,[EMﾚn]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,148), 1, MaxStrLen(Customer.)); //   ,[EmTpBto]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,149), 1, MaxStrLen(Customer.)); //   ,[PrefL]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,150), 1, MaxStrLen(Customer.)); //   ,[A/P]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,151), 1, MaxStrLen(Customer.)); //   ,[PtoDescCol]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,152), 1, MaxStrLen(Customer.)); //   ,[Agency Location Code]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,153), 1, MaxStrLen(Customer.)); //   ,[Payment Office]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,154), 1, MaxStrLen(Customer.)); //   ,[Eq#respons#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,155), 1, MaxStrLen(Customer.)); //   ,[Proc#previo cta#ter#]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,156), 1, MaxStrLen(Customer.)); //   ,[Nombre 12]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,157), 1, MaxStrLen(Customer.)); //   ,[Nombre 22]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,158), 1, MaxStrLen(Customer.)); //   ,[Nombre 31]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,159), 1, MaxStrLen(Customer.)); //   ,[Nombre]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,160), 1, MaxStrLen(Customer.)); //   ,[T咜ulos]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,161), 1, MaxStrLen(Customer.)); //   ,[Nｺ (edif#)]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,162), 1, MaxStrLen(Customer.)); //   ,[Calle1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,163), 1, MaxStrLen(Customer.)); //   ,[Descripci]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,164), 1, MaxStrLen(Customer.)); //   ,[Descripci1]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,165), 1, MaxStrLen(Customer.)); //   ,[Descripci2]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,166), 1, MaxStrLen(Customer.)); //   ,[Descripci3]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,167), 1, MaxStrLen(Customer.)); //   ,[Descripci4]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,168), 1, MaxStrLen(Customer.)); //   ,[Estado]
        // Customer. := CopyStr(SQLRGetSTring(SQLReader,169), 1, MaxStrLen(Customer.)); //   ,[CodigoNAV]

        // Customer. := CopyStr(SQLRGetSTring(SQLReader,), 1, MaxStrLen(Customer.)); //   
        tmpCustomer.Insert();
    end;

    local procedure CheckCustomerSEBExist(CustomerNoSEB: code[20]; var Customer: Record Customer): Boolean

    begin
        Customer.Reset();
        Customer.SetRange("Codigo Anterior", CustomerNoSEB);
        if Customer.FindFirst() then
            exit(True);
    end;

    local procedure CheckCustomerVatExist(CustomerNoSEB: code[20]; VatNoSeb: code[50]; var Customer: Record Customer): Boolean
    var
        SearchCustomer: Record Customer;
    begin
        Customer.Reset();
        if VatNoSeb = '' then
            exit;
        // primero filtramos por el nif del clientes, completo
        Customer.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        if Customer.FindSet() then begin
            if Customer."Codigo Anterior" = '' then begin
                Customer."Codigo Anterior" := CustomerNoSEB;
                Customer.Modify();
            end;
            //UpdateSQLCodigNAV(CustomerNoSEB, Customer."No.", 'Encontrado CIF completo ZUMMO');
            exit(true);
        end;
        // ahora quitamos los dos primeros caracteres del pais.
        VatNoSeb := CopyStr(VatNoSeb, 3);
        Customer.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        if Customer.FindSet() then begin
            if Customer."Codigo Anterior" = '' then begin
                Customer."Codigo Anterior" := CustomerNoSEB;
                Customer.Modify();
            end;
            //UpdateSQLCodigNAV(CustomerNoSEB, Customer."No.", 'Encontrado CIF sin pais ZUMMO');
            exit(true);
        end;
        // // solo dejamos los numeros y comprobamos
        // VatNoSeb := VATOnlyNumbers(VatNoSeb);
        // Customer.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        // if Customer.FindSet() then begin
        //     Customer."Codigo Anterior" := CustomerNoSEB;
        //     Customer.Modify();
        //     UpdateSQLCodigNAV(CustomerNoSEB, Customer."No.", 'Encontrado CIF sin pais ZUMMO');
        //     exit(true);
        // end;
    end;

    local procedure VATOnlyNumbers(VatRegistration: text) NewVAT: text;
    var
        Caracter: Char;
        I: Integer;
    begin
        for i := 1 to StrLen(VatRegistration) do begin
            Caracter := VatRegistration[i];
            case Caracter of
                '1', '2', '3', '4', '5', '6', '7', '8', '9', '0':
                    NewVAT += Caracter;
            end;
        end;
    end;

    procedure UpdateSQLCodigNAV(CustomerNoSEB: code[20];
        CodigoNAv: code[20];
        Estado: Text): Boolean
    var
        SQLConnection: DotNet SqlConnection;
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtCommand: text;
        txtSET: text;
        lblSQLCount: Label 'UPDATE [ZUMMOREM].[dbo].[clientes_stg] SET %1 WHERE [Cliente] =''%2''';
        lblSET: Label '[CodigoNAV]=''%1'',[Estado]=''%2''';
    begin
        exit; // TODO
        if IsNull(SQLConnection) then
            SQLConnect(SQLConnection);
        Clear(SQLCommand);
        SQLCommand := SQLConnection.CreateCommand();
        txtSET := StrSubstNo(lblSET, CodigoNAv, Estado);
        txtCommand := StrSubstNo(lblSQLCount, txtSET, CustomerNoSEB);
        SQLCommand.CommandText := txtCommand;
        // ** EXEC READER **
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            exit(true);
    end;

    local procedure UpdateCustomerFromTemplate(var Customer: Record Customer)
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        MiniCustomerTemplate: Record "Mini Customer Template" temporary;
        CustomerRecRef: RecordRef;
    begin
        ConfigTemplateHeader.SetRange("Table ID", Database::Customer);
        ConfigTemplateHeader.SetRange(Description, 'CUSTSEBPRO');
        if not ConfigTemplateHeader.FindFirst() then
            exit;
        MiniCustomerTemplate.InitializeTempRecordFromConfigTemplate(MiniCustomerTemplate, ConfigTemplateHeader);
        MiniCustomerTemplate.InsertCustomerFromTemplate(ConfigTemplateHeader, Customer);

        //NewCustomerFromTemplate(Customer);
    end;

    local procedure UpdateCustomerAuxiliares(var Customer: Record Customer)
    var
        myInt: Integer;
    begin
        // dimension por defecto, aunque se crean al aplicar la plantilla
        CreateDefaultDimension(Customer);

        // miramos por el pais, el grupo registro clientes
        UpdateCustomerPostingSetup(Customer);

        CreateClienteReporting(Customer);
    end;

    local procedure CreateClienteReporting(var Customer: Record Customer)
    var
        ClienteRep: Record TextosAuxiliares;
    begin
        ClienteRep.SetRange(TipoRegistro, ClienteRep.TipoRegistro::Tabla);
        ClienteRep.SetRange(TipoTabla, ClienteRep.TipoTabla::ClienteReporting);
        ClienteRep.SetRange(NumReg, Customer."No.");
        if not ClienteRep.FindFirst() then begin
            ClienteRep.Init();
            ClienteRep.TipoRegistro := ClienteRep.TipoRegistro::Tabla;
            ClienteRep.TipoTabla := ClienteRep.TipoTabla::ClienteReporting;
            ClienteRep.NumReg := Customer."No.";
            ClienteRep.Insert();
        end;
        Customer.validate(ClienteReporting_btc, Customer."No.");
    end;

    local procedure CreateDefaultDimension(Customer: Record Customer)
    var
        DefaultDimension: Record "Default Dimension";
    begin
        DefaultDimension.SetRange("Table ID", Database::Customer);
        DefaultDimension.SetRange("No.", Customer."No.");
        DefaultDimension.SetRange("Dimension Code", 'DIVISION');
        if not DefaultDimension.FindFirst() then begin
            DefaultDimension.Init();
            DefaultDimension."Table ID" := Database::Customer;
            DefaultDimension."No." := Customer."No.";
            DefaultDimension.Validate("Dimension Code", 'DIVISION');
            DefaultDimension.Validate("Dimension Value Code", 'PCM');
            DefaultDimension.Insert();
        end;
        // codigo proyecto
        DefaultDimension.SetRange("Dimension Code", 'PROYECTO');
        if not DefaultDimension.FindFirst() then begin
            DefaultDimension.Init();
            DefaultDimension."Table ID" := Database::Customer;
            DefaultDimension."No." := Customer."No.";
            DefaultDimension.Validate("Dimension Code", 'PROYECTO');
            DefaultDimension.Validate("Dimension Value Code", Customer."No.");
            DefaultDimension.Insert();
        end;
    end;

    local procedure UpdateCustomerPostingSetup(var Customer: Record Customer)
    var
        CountryRegion: record "Country/Region";
    begin
        if CountryRegion.Get(Customer."Country/Region Code") then begin
            Customer."Gen. Bus. Posting Group" := CountryRegion."Gen. Bus. Posting Group";
            Customer."VAT Bus. Posting Group" := CountryRegion."VAT Bus. Posting Group";
            Customer."Customer Posting Group" := CountryRegion."Customer Posting Group";
        end else begin
            CountryRegion.Init();
            CountryRegion.Validate(Code, Customer."Country/Region Code");
            CountryRegion.Insert();
        end;
    end;

    procedure GerProveedores()
    var
        Item: Record Item;
        tmpItem: Record Item temporary;
        SQLConnection: DotNet SqlConnection;
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        texto: text;
        CustomerNoSEB: code[20];
        VatNoSeb: code[50];
        UpdateCustomer: Boolean;
        Windows: Dialog;
        lblSQLDelete: Label 'SELECT *  FROM [CLIENTS$] WHERE clientes_stg is not null ORDER BY [Cliente]';
        lblWindow: Label 'Nº Cliente #1##########\Registro #2#########', comment = 'ESP="Nº Cliente #1##########\Registro #2#########"';
    begin
        windows.Open(lblWindow);
        if IsNull(SQLConnection) then
            SQLConnect(SQLConnection);
        Clear(SQLCommand);
        SQLCommand := SQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        SQLCommand.CommandText := StrSubstNo(lblSQLDelete);
        // ** EXEC READER **
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            while SQLReader.Read() do begin
                windows.update(1, SQLRGetSTring(SQLReader, 0));
                CustomerNoSEB := SQLRGetSTring(SQLReader, 0);
                VatNoSeb := SQLRGetSTring(SQLReader, 62);
                if VatNoSeb = '' then
                    VatNoSeb := SQLRGetSTring(SQLReader, 51);

                // if CheckCustomerSEBExist(CustomerNoSEB, Customer) then
                //     UpdateCustomer := true
                // else if CheckCustomerVatExist(CustomerNoSEB, VatNoSeb) then
                //     UpdateCustomer := false
                // else begin
                //     Customer.Init();
                //     Customer."No." := '';
                //     // aplicar plantilla
                //     UpdateCustomerFromTemplate(Customer);
                //     windows.update(2, Customer."No.");
                //     //Customer."No." := CopyStr(SQLRGetSTring(SQLReader, 0), 1, MaxStrLen(Customer."No."));     //   [Cliente]
                //     // Customer."No." := NoSeriesMgt.GetNextNo(Customer."No. Series", WorkDate(), true);
                // end;
                // if UpdateCustomer then begin
                //     GetFieldsCustomerSQLReader(tmpCustomer, SQLReader);
                //     Windows.Update(1, tmpCustomer."No.");
                //     //actualizamos datos si es cliente de SEB y no de Zummo
                //     Customer."Codigo Anterior" := tmpCustomer."Codigo Anterior";
                //     Customer."Country/Region Code" := tmpCustomer."Country/Region Code";
                //     Customer.validate(Name, tmpCustomer.Name);
                //     Customer."Name 2" := tmpCustomer."Name 2";
                //     Customer.validate("Post Code", tmpCustomer."Post Code");
                //     Customer.City := tmpCustomer.City;
                //     Customer.Address := tmpCustomer.Address;
                //     Customer."Phone No." := tmpCustomer."Phone No.";
                //     Customer."Fax No." := tmpCustomer."Fax No.";
                //     Customer.Address := tmpCustomer.Address;
                //     Customer."Phone No." := tmpCustomer."Phone No.";
                //     Customer."Fax No." := tmpCustomer."Fax No.";
                //     Customer.FechaAlta := tmpCustomer.FechaAlta;
                //     Customer."VAT Registration No." := tmpCustomer."VAT Registration No.";

                //     UpdateCustomerAuxiliares(Customer);

                //     Customer.Modify();
                //     UpdateSQLCodigNAV(Customer."Codigo Anterior", Customer."No.", 'ALTA NUEVA');
                // end;
            end;
        //     exit(false);
        windows.close;
        // exit(true);
        //Page.Run(0, Customer);
    end;

    procedure GeTItems(WhereItemNo: text)
    var
        Item: Record Item;
        tmpItem: Record Item temporary;
        SQLConnection: DotNet SqlConnection;
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemNo: Code[20];
        txtJoin: text;
        txtWhere: text;
        Windows: Dialog;
        lblSQLSelect: Label 'SELECT [materiales_stg].*,materialestextos_stg.*  FROM [MATERIALES_STG] %1 WHERE %2 and idioma = ''S'' ORDER BY [materiales_stg].Material';
        lblWindow: Label 'Nº Producto #1##########\Registro #2#########', comment = 'ESP="Nº Cliente #1##########\Registro #2#########"';
    begin
        tmpItem.DeleteAll();
        windows.Open(lblWindow);
        if IsNull(SQLConnection) then
            SQLConnect(SQLConnection);
        Clear(SQLCommand);
        SQLCommand := SQLConnection.CreateCommand();
        txtWhere := StrSubstNo('([Grupo_art] = ''%1'' or [Grupo_art] = ''%2'' or [Grupo_art] = ''%3'' or [Grupo_art] = ''%4'' or [Grupo_art] = ''%5'' or [Grupo_art] = ''%6'')',
                '033', '043', '313', '333', '503', '991');
        if WhereItemNo <> '' then
            txtWhere := StrSubstNo(' [MATERIALES_STG].material=''%1''', ClearItemNo(WhereItemNo));
        txtJoin := 'left join materialestextos_stg on [materiales_stg].material = materialestextos_stg.material';
        SQLCommand.CommandText := StrSubstNo(lblSQLSelect, txtJoin, txtWhere);
        // ** EXEC READER **
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            while SQLReader.Read() do begin
                // ItemNo := CheckItemNoSEB(SQLRGetStringFieldName(SQLReader, 'Material'));
                windows.update(1, WhereItemNo);
                GetFieldsItemSQLReader(tmpItem, SQLReader, WhereItemNo);
                if not Item.Get(tmpItem."No.") then begin
                    Item.Init();
                    Item.TransferFields(tmpItem);
                    Item.Insert()
                end;
                Item."Last Date Modified" := tmpItem."Last Date Modified";
                Item.selClasVtas_btc := tmpItem.selClasVtas_btc;
                Item."material antiguo code" := tmpItem."material antiguo code";
                Item."Gross Weight" := tmpItem."Gross Weight";
                Item."Net Weight" := tmpItem."Net Weight";
                Item."Unit Volume" := tmpItem."Unit Volume";
                Item.GTIN := tmpItem.GTIN;
                Item.Modify();
            end;
        //     exit(false);
        windows.close;
        // exit(true);
    end;

    local procedure ClearItemNo(ItemNo: text) NewItemNo: Text
    var
        i: Integer;
        NumChar: Integer;
    begin
        NewItemNo := DelChr(ItemNo, '=', '.');
        for i := 1 to StrLen(ItemNo) do begin
            if copystr(NewItemNo, 1, 1) = '0' then
                NewItemNo := copystr(NewItemNo, 2);
        end;
    end;

    local procedure CheckItemNoSEB(ItemNo: text) NewItemNo: Text
    var
        i: Integer;
        NumChar: Integer;
    begin
        if StrLen(ItemNo) < 10 then
            ItemNo := PadStr('', 10 - StrLen(ItemNo), '0') + ItemNo;
        for i := StrLen(ItemNo) downto 1 do begin
            NumChar += 1;
            NewItemNo := ItemNo[i] + NewItemNo;
            case NumChar of
                4, 8:
                    NewItemNo := '.' + NewItemNo;
            end;
        end;
    end;

    local procedure GetFieldsItemSQLReader(var tmpItem: Record Item; var SQLReader: DotNet SqlDataReader; ItemNo: code[20])
    var
        SEBITemNo: code[20];
        ValorCampo: text;
        Longitud: Decimal;
        unLongitud: text;
        Ancho: Decimal;
        unAncho: Text;
        Altura: Decimal;
        unAltura: text;
    begin
        if not tmpItem.IsTemporary then
            Error('%1 debe ser temporal', tmpItem.TableName);

        tmpItem.DeleteAll();
        SEBITemNo := SQLRGetSTring(SQLReader, 0);

        tmpItem.Init();
        tmpItem."No." := ItemNo;
        tmpItem.Description := CopyStr(SQLRGetStringFieldName(SQLReader, 'texto_breve_de_material'), 1, MaxStrLen(tmpItem.Description));
        // tmpItem. := CopyStr(SQLRGetSTring(SQLReader, 0), 1, MaxStrLen(tmpItem.       ); // [Material]
        // tmpItem. := CopyStr(SQLRGetSTring(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Creado]
        // tmpItem. := CopyStr(SQLRGetSTring(SQLReader, 2), 1, MaxStrLen(tmpItem.       ); //,[Creado_por]
        tmpItem."Last Date Modified" := SQLRGetStringDateFieldName(SQLReader, 'lt_mod');
        //  tmpItem."Last Time Modified" := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[lt_mod]
        //  tmpItem."Last DateTime Modified" := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[lt_mod]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Modif_por]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Stat_act_comp]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Stat_actual]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Mat]
        ValorCampo := SQLRGetStringFieldName(SQLReader, 'TpMt'); //,[TpMt]
        case ValorCampo of
            'NLAG':
                tmpItem.Type := tmpItem.Type::Service;
            else
                tmpItem.Type := tmpItem.Type::Inventory;
        end;

        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[R]

        tmpItem.selClasVtas_btc := GetClasificacionVentas(SQLRGetStringFieldName(SQLReader, 'Grupo_art'), SQLRGetStringFieldName(SQLReader, 'Grupo_art'));
        tmpItem."material antiguo code" := CopyStr(SQLRGetStringFieldName(SQLReader, 'N_Material_antiguo'), 1, MaxStrLen(tmpItem."material antiguo code")); //,[N_Material_antiguo]
        ValorCampo := SQLRGetStringFieldName(SQLReader, 'UMB');   //,[UMB] ST - M unidad de medida
        case ValorCampo of
            'M':
                tmpItem.Validate("Base Unit of Measure", 'METRO');
            else
                tmpItem.Validate("Base Unit of Measure", 'UDS');
        end;
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[UMP]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Documento]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[CDoc]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Vers]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[DIN1]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[N_ModD]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[N_H]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Ctd]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Info_fabr_insp]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[DIN]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Tama_Dimens]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Materia]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Denom_est_dar]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[L_O]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[CvValCp]
        tmpItem."Gross Weight" := SQLRGetDecimalFieldName(SQLReader, 'Peso_bruto');
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Un] todos son kilos, parece unidad de medida del peso bruto y neto
        tmpItem."Net Weight" := SQLRGetDecimalFieldName(SQLReader, 'Peso_neto'); //,[Peso_neto]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Un_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Un_3]
        tmpItem."Unit Volume" := SQLRGetDecimalFieldName(SQLReader, 'Volumen');
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[UV]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[UV_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[PE]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[CA]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Temp]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[NvP]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[GrTran]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[N_sust_peligrosa]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Se]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Competenc]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[N_ero_EAN]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Cant_para_el_n_ero_de_vales]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[UMB_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[N]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[F]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Temp_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[CE]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[FE]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Cpo_desactiv]
        tmpItem.GTIN := CopyStr(SQLRGetStringFieldName(SQLReader, 'C_igo_EAN_UPC'), 1, MaxStrLen(tmpItem.GTIN)); //,[C_igo_EAN_UPC] 
                                                                                                                 // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Tp]
        Longitud := SQLRGetDecimalFieldName(SQLReader, 'Longitud'); //,[Longitud]
        unLongitud := SQLRGetStringFieldName(SQLReader, 'Unidad_dimensi'); //,[Unidad_dimensi]
        Ancho := SQLRGetDecimalFieldName(SQLReader, 'Ancho'); //,[Ancho]
        unAncho := SQLRGetStringFieldName(SQLReader, 'Unidad_dimensi_2'); //,[Unidad_dimensi_2]
        Altura := SQLRGetDecimalFieldName(SQLReader, 'Altura'); //,[Altura]
        unAltura := SQLRGetStringFieldName(SQLReader, 'Unidad_dimensi_3'); //,[Unidad_dimensi_3]
        CreateItemUnitOfMeasure(tmpItem, Longitud, unLongitud, Ancho, unAncho, Altura, unAltura);
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Unidad_dimensi_4]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Jqu_productos]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Traslado_c_culo_del_coste_Net]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[CAD]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[QM]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Peso_perm_emb]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Un_4]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Un_5]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Volum_perm]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[UnV]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[UnV_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[TSP]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[TEV]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[V]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[R_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Conf]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[SjL]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[ClMAE]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[CLl]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[FApil]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[GrME]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[GrpA]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[V_ido_de]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Validez_a]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[A_E]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[TpP]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[LS]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Grupo_art_ext]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Mat_gral_conf]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Tp_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Co]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[R_3]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[Material_precio]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[SM]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       ); //,[St]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[V_ido_de_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[V_ido_de_3]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[ClFis]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[PerfCat]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[DurRe]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Cnsrv]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[PrcAl]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[UMC]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Conten_neto]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[UMC_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[por]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Gr_mat_etiquetado]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Conten_bruto]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //      ,[UMC_3]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[MCC]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[N_objeto]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[R_4]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[EsquemaContingente]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[PP]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[SuBonEs]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[N_Fb]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Fabricante]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Mat_gestion_stock]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[PerfPF]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[U]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Colecci]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Perf]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[ViscosElev]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[A_granel_l_uido]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[NS]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[C]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[LA]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[ValVal]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[NF]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Ind_per]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Regla_red]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Comp_prod]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[MTPOS]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Var_log]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[El_material_est_fijado]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Indicador_para_relevancia_en_C]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[C_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Fecha_de_caducidad_Fecha_de_ex]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Variante_EAN]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Material_gen_ico]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Material_refer]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Relevante_para_GDS]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[AP]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Tp_un_manip_std]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Con_riesgo_de_robo]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[CondAlm]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[GrMatAlm]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Ind_man]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Rel_sust_peligrosa]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Tp_unidad_manip]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[V_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Capacidad_m_ima]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[TSC]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Long_permitida]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Un_medida]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Ancho_perm_embalaje]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Un_medida_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Altura_perm]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Un_medida_3]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Un_medida_4]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Orig]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[GrpPortM]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[PerC]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Unidad_tiempo_cuarentena]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Unidad_tiempo_cuarentena_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Grupo_control_calidad]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Perfil_n_ero_serie]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Nombre]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Unidad_medida_log_tica]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Material_es_un_material_CW]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Perfil_CW_para_cantidad_de_val]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Grupo_tolerancia_catch_weight]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Un_carga]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Gr_unidad_carga]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[C_3]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[AgrDSD]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Volcar]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[NoApil]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Inf]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Sup]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[FApil_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Sin_ME]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Exceso_profund]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Unidad_dimensi_5]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Exceso_ancho]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Unidad_dimensi_6]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Altura_m_ima]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Unidad_dimensi_7]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Altura_m_ima_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Unidad_dimensi_8]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Exceso_alt_emb]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Unidad_dimensi_9]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Mat_MEm]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[UM_OAC]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[ME_cerrado]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Gesti_estado_material]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[C_Ret]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[ANivLog]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[ID_OTAN]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Clase_FFF]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[N_ero_cadena_reemplazo]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[SC]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[CaractInt]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[CaractInt_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[CaractInt_3]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Color]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Tam_1]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Tam_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Valor]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[C_cuid]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Marca]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Componente_1]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Col_1]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Componente_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Col_2]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Componente_3]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Col_3]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Componente_4]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Col_4]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Componente_5]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[Col_5]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[GrMo]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[KWG]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[CMMF_code]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[idioma]
        // tmpItem. := CopyStr(SQLRGetStringFieldName(SQLReader, 1), 1, MaxStrLen(tmpItem.       );  //,[texto_breve_de_material]
        tmpItem.Insert();
    end;

    local procedure GetClasificacionVentas(CodClasif: code[20]; Name: Text): code[20]
    var
        TextosAuxiliares: Record TextosAuxiliares;
        lblPCM: Label 'PCM %1';
    begin
        CodClasif := StrSubstNo(lblPCM, CodClasif);
        //TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClasificacionVentas"), TipoRegistro = const(Tabla));
        // 033	MAQUINAS CAFE 043	RENTING  313	#N/A 333	REP. MAQUINAS CAFE
        // 503	S.A.T  991	Seguro/Portes/Desc.
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::ClasificacionVentas);
        TextosAuxiliares.SetRange(NumReg, CodClasif);
        if not TextosAuxiliares.FindFirst() then begin
            TextosAuxiliares.Init();
            TextosAuxiliares.TipoRegistro := TextosAuxiliares.TipoRegistro::Tabla;
            TextosAuxiliares.TipoTabla := TextosAuxiliares.TipoTabla::ClasificacionVentas;
            TextosAuxiliares.NumReg := CodClasif;
            TextosAuxiliares.Descripcion := copystr(Name, 1, MaxStrLen(TextosAuxiliares.Descripcion));
            TextosAuxiliares.Insert()
        end;
        exit(CodClasif);
    end;

    local procedure CreateItemUnitOfMeasure(Item: Record Item; Longitud: Decimal; unLongitud: text; Ancho: Decimal; unAncho: Text; Altura: Decimal; unAltura: text)
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        Multiplicador: Decimal;
    begin
        case unLongitud of
            'MM':
                Multiplicador := 1000;
            'CM':
                Multiplicador := 100;
            else
                Multiplicador := 1;
        end;
        Longitud := Longitud * Multiplicador;
        case unAncho of
            'MM':
                Multiplicador := 1000;
            'CM':
                Multiplicador := 100;
            else
                Multiplicador := 1;
        end;
        Ancho := Ancho * Multiplicador;
        case unAltura of
            'MM':
                Multiplicador := 1000;
            'CM':
                Multiplicador := 100;
            else
                Multiplicador := 1;
        end;
        Altura := Altura * Multiplicador;
        if not ItemUnitOfMeasure.Get(Item."No.", Item."Base Unit of Measure") then begin
            ItemUnitOfMeasure.Init();
            ItemUnitOfMeasure."Item No." := Item."No.";
            ItemUnitOfMeasure.Code := Item."Base Unit of Measure";
            ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
            ItemUnitOfMeasure.Insert();
        end;
        ItemUnitOfMeasure.Cubage := Item."Unit Volume";
        ItemUnitOfMeasure.Height := Altura;
        ItemUnitOfMeasure.Weight := Ancho;
        ItemUnitOfMeasure.Length := Longitud;
        ItemUnitOfMeasure.Modify();
    end;

    procedure UpdateCustomerExcel()
    var
        Customer: record Customer;
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        CustomerNoSEB: text;
        VATCustomerNo: text;
        Borrado: text;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        UpdateCustomer: Boolean;
        Text000: label 'Cargar Fichero de Excel';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');
        ;
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Window.Open('Customer SEB: #1###############\Cliente: #2###############\#3####### de #4########');
        Window.Update(4, Rows);
        for linea := 2 to Rows do begin
            Window.Update(3, linea);
            CustomerNoSEB := '';
            VATCustomerNo := '';
            Borrado := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 2);  // cliente
            if ExcelBuffer.FindSet() then
                CustomerNoSEB := ExcelBuffer."Cell Value as Text";
            if CustomerNoSEB <> '' then begin
                Customer.SetRange("Codigo Anterior", CustomerNoSEB);
                if Customer.FindFirst() then begin
                    ExcelBuffer.SetRange("Column No.", 3);  // Nombre
                    if ExcelBuffer.FindSet() then
                        Customer.Name := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Customer.Name));
                    ExcelBuffer.SetRange("Column No.", 4);  // Alias
                    if ExcelBuffer.FindSet() then
                        Customer."Search Name" := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Customer."Search Name"));
                    ExcelBuffer.SetRange("Column No.", 5);  // Dirección
                    if ExcelBuffer.FindSet() then
                        Customer.Address := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 6);  // Población
                    if ExcelBuffer.FindSet() then
                        Customer.City := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 7);  // Nº teléfono
                    if ExcelBuffer.FindSet() then
                        Customer."Phone No." := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 8);  // Cód.términos pago
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Payment Terms Code", ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 9);  // Cód.país / región
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Country/Region Code", ExcelBuffer."Cell Value as Text");
                    // ExcelBuffer.SetRange("Column No.", 10);  // Bloqueado
                    // if ExcelBuffer.FindSet() then
                    //     Customer. := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 11);  // Cód.forma pago
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Payment Method Code", ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 13);  // Código postal
                    if ExcelBuffer.FindSet() then
                        Customer."Post Code" := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 14);  // Correo electrónico
                    if ExcelBuffer.FindSet() then
                        Customer."E-Mail" := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 15);  // Area Manager
                    if ExcelBuffer.FindSet() then
                        Customer.validate(AreaManager_btc, ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 16);  // Delegado
                    if ExcelBuffer.FindSet() then
                        Customer.validate(Delegado_btc, ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 17);  // Cliente Tipo
                    if ExcelBuffer.FindSet() then
                        Customer.validate(GrupoCliente_btc, ExcelBuffer."Cell Value as Text")
                    else
                        Customer.GrupoCliente_btc := '';
                    ExcelBuffer.SetRange("Column No.", 18);  // Cliente Corporativo
                    if ExcelBuffer.FindSet() then begin
                        Customer.validate(ClienteCorporativo_btc, AddClienteCorporativo_btc(ExcelBuffer."Cell Value as Text", ExcelBuffer."Cell Value as Text"));
                    end else
                        Customer.ClienteCorporativo_btc := '';
                    ExcelBuffer.SetRange("Column No.", 19);  // Grupo dto.cliente
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Customer Disc. Group", ExcelBuffer."Cell Value as Text")
                    else
                        Customer."Customer Disc. Group" := '';
                    ExcelBuffer.SetRange("Column No.", 20);  // Grupo precio cliente
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Customer Price Group", ExcelBuffer."Cell Value as Text")
                    else
                        Customer.GrupoCliente_btc := 'PVP';
                    ExcelBuffer.SetRange("Column No.", 21);  //  Perfil
                    if ExcelBuffer.FindSet() then
                        Customer.validate(Perfil_btc, ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 22);  // Cliente Reporting
                    if ExcelBuffer.FindSet() then begin
                        Customer.validate(ClienteReporting_btc, AddClienteReporting_btc(ExcelBuffer."Cell Value as Text", ExcelBuffer."Cell Value as Text"));
                    end;
                    ExcelBuffer.SetRange("Column No.", 23);  // Cliente Actividad
                    if ExcelBuffer.FindSet() then begin
                        Customer.validate(ClienteActividad_btc, AddClienteActividad_btc(ExcelBuffer."Cell Value as Text", ExcelBuffer."Cell Value as Text"));
                    end;
                    ExcelBuffer.SetRange("Column No.", 24);  // Canal
                    if ExcelBuffer.FindSet() then
                        Customer.validate(Canal_btc, ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 25);  // Mercado
                    if ExcelBuffer.FindSet() then
                        Customer.validate(Mercado_btc, ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 26);  // Cód.almacén
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Location Code", ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 27);  // Código(Condiciones envío)
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Shipment Method Code", ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 28);  // Especificación transacción
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Transaction Specification", ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 29);  // Naturaleza transacción
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Transaction Type", ExcelBuffer."Cell Value as Text");
                    ExcelBuffer.SetRange("Column No.", 30);  // Modo transporte
                    if ExcelBuffer.FindSet() then
                        Customer.validate("Transport Method", ExcelBuffer."Cell Value as Text");
                    Customer.Modify()
                end;
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    procedure CreateTableFromtxt()
    var
        Customer: record Customer;
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        CustomerNoSEB: text;
        VATCustomerNo: text;
        Borrado: text;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        UpdateCustomer: Boolean;
        Text000: label 'Cargar Fichero de Excel';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');
        ;
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Window.Open('Customer SEB: #1###############\Cliente: #2###############\#3####### de #4########');
        Window.Update(4, Rows);
        for linea := 7 to Rows do begin
            Window.Update(3, linea);
            CustomerNoSEB := '';
            VATCustomerNo := '';
            Borrado := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 2);  // cliente
            if ExcelBuffer.FindSet() then
                CustomerNoSEB := ExcelBuffer."Cell Value as Text";
            // ExcelBuffer.SetRange("Column No.", 40);  // pBor borrado
            // if ExcelBuffer.FindSet() then
            //     Borrado := ExcelBuffer."Cell Value as Text";
            // if Borrado = '' then begin
            ExcelBuffer.SetRange("Column No.", 20);  // N.I.F. 
            if ExcelBuffer.FindSet() then
                VATCustomerNo := ExcelBuffer."Cell Value as Text";
            window.update(1, CustomerNoSEB);
            if CustomerNoSEB <> '' then begin
                if CheckCustomerSEBExist(CustomerNoSEB, Customer) then begin
                    if customer.NuevoSEB then
                        UpdateCustomer := true
                    else
                        UpdateCustomer := false;
                end else if CheckCustomerVatExist(CustomerNoSEB, VATCustomerNo, Customer) then begin
                    UpdateCustomer := false;
                end else begin
                    Customer.Init();
                    Customer."No." := '';
                    // aplicar plantilla
                    UpdateCustomerFromTemplate(Customer);
                    Customer."Codigo Anterior" := CustomerNoSEB;
                    Customer.NuevoSEB := true;
                    window.update(2, Customer."No.");
                    UpdateCustomer := true
                    //Customer."No." := CopyStr(SQLRGetSTring(SQLReader, 0), 1, MaxStrLen(Customer."No."));     //   [Cliente]
                    // Customer."No." := NoSeriesMgt.GetNextNo(Customer."No. Series", WorkDate(), true);
                end;
                if UpdateCustomer then begin
                    GetFieldsCustomerExcel(ExcelBuffer, Customer);

                    UpdateCustomerAuxiliares(Customer);

                    Customer.Modify();
                end;
                CustomerShipAddress(ExcelBuffer, Customer, CustomerNoSEB);
                // end;
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    local procedure GetFieldsCustomerExcel(var ExcelBuffer: Record "Excel Buffer" temporary; var Customer: Record Customer)
    var
        DatoExcel: text;
        DatoExceldesc: text;
        DatoFecha: date;
    begin
        ExcelBuffer.SetRange("Column No.", 2);  // cliente 1
        if ExcelBuffer.FindSet() then
            Customer."Codigo Anterior" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 5);  // PS  Pais
        if ExcelBuffer.FindSet() then
            Customer."Country/Region Code" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 6);  // Nombre 1
        if ExcelBuffer.FindSet() then
            Customer.validate(Name, ExcelBuffer."Cell Value as Text");
        ExcelBuffer.SetRange("Column No.", 7);  // Nombre 2
        if ExcelBuffer.FindSet() then
            Customer."Name 2" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 9);  // Poblaci
        if ExcelBuffer.FindSet() then
            Customer.City := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Customer.City));
        ExcelBuffer.SetRange("Column No.", 10);  // CP
        if ExcelBuffer.FindSet() then
            Customer."Post Code" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 11);  // Calle
        if ExcelBuffer.FindSet() then
            Customer.Address := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 12);  // Tel馭ono 1
        if ExcelBuffer.FindSet() then
            Customer."Phone No." := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 13);  // Nｺ telefax
        if ExcelBuffer.FindSet() then
            Customer."Fax No." := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 22);  // Telefono 2
        if ExcelBuffer.FindSet() then
            Customer."Telex No." := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 24);  // Email
        if ExcelBuffer.FindSet() then
            Customer."E-Mail" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 28);  // Responsable-Area Manager PDTE RELACION TABLA AUXILIAR
        if ExcelBuffer.FindSet() then
            Customer.AreaManager_btc := ExcelBuffer."Cell Value as Text";
        DatoExcel := '';
        ExcelBuffer.SetRange("Column No.", 31);  //  MLA Code
        if ExcelBuffer.FindSet() then
            DatoExcel := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 32);  // MLA Name - Cliente corporativo
        if ExcelBuffer.FindSet() then
            Customer.ClienteCorporativo_btc := AddClienteCorporativo_btc(ExcelBuffer."Cell Value as Text", DatoExcel);
        DatoExcel := '';
        ExcelBuffer.SetRange("Column No.", 35);  //  Precio Cliente
        if ExcelBuffer.FindSet() then
            DatoExcel := ExcelBuffer."Cell Value as Text";
        DatoExceldesc := '';
        ExcelBuffer.SetRange("Column No.", 36);  //  Nombre Tarifa
        if ExcelBuffer.FindSet() then
            DatoExceldesc := ExcelBuffer."Cell Value as Text";
        addCustomerGroupPrice(Customer, DatoExcel, DatoExceldesc);
        ExcelBuffer.SetRange("Column No.", 37);  //  Termino de pago
        if ExcelBuffer.FindSet() then
            DatoExcel := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 39);  //  Forma de pago
        if ExcelBuffer.FindSet() then
            DatoExceldesc := ExcelBuffer."Cell Value as Text";
        AddCustomerPayments(Customer, DatoExcel, DatoExceldesc);

        // ExcelBuffer.SetRange("Column No.", 27);  // Fecha
        // if ExcelBuffer.FindSet() then
        //     DatoExcel := ExcelBuffer."Cell Value as Text";
        // DatoExcel := StrSubstNo('%1/%2/%3', copystr(DatoExcel, 1, 2), copystr(DatoExcel, 3, 2), copystr(DatoExcel, 7, 4));        //            19.09.2000
        // if Evaluate(DatoFecha, DatoExcel) then
        //     Customer.FechaAlta := DatoFecha;        
        ExcelBuffer.SetRange("Column No.", 20);  // N.I.F. comunitario
        if ExcelBuffer.FindSet() then
            Customer."VAT Registration No." := ExcelBuffer."Cell Value as Text";

        ExcelBuffer.SetRange("Column No.", 51);  // Idioma
        if ExcelBuffer.FindSet() then
            DatoExcel := ExcelBuffer."Cell Value as Text";
        case DatoExcel of
            'F':
                Customer."Language Code" := 'FRA';
            'P':
                Customer."Language Code" := 'PTG';
            'D', 'N', 'I':
                Customer."Language Code" := 'ENG';
            else
                Customer."Language Code" := 'ESP';
        end;
    end;

    local procedure AddClienteCorporativo_btc(Value: text; Code: Text): Text
    var
        TextoAuxiliares: record TextosAuxiliares;
        ValueCode: code[20];
    begin
        ValueCode := CopyStr(Value, 1, MaxStrLen(TextoAuxiliares.NumReg));
        TextoAuxiliares.SetRange(TipoRegistro, TextoAuxiliares.TipoRegistro::Tabla);
        TextoAuxiliares.SetRange(TipoTabla, TextoAuxiliares.TipoTabla::"Cliente Corporativo");
        TextoAuxiliares.setrange(NumReg, Code);
        if not TextoAuxiliares.FindFirst() then begin
            TextoAuxiliares.Init();
            TextoAuxiliares.TipoRegistro := TextoAuxiliares.TipoRegistro::Tabla;
            TextoAuxiliares.TipoTabla := TextoAuxiliares.TipoTabla::"Cliente Corporativo";
            TextoAuxiliares.NumReg := ValueCode;
            TextoAuxiliares.Descripcion := Value;
            TextoAuxiliares.Insert();
        end;
        exit(TextoAuxiliares.NumReg);
    end;

    local procedure AddClienteReporting_btc(Value: text; Code: Text): Text
    var
        TextoAuxiliares: record TextosAuxiliares;
        ValueCode: code[20];
    begin
        ValueCode := CopyStr(Value, 1, MaxStrLen(TextoAuxiliares.NumReg));
        TextoAuxiliares.SetRange(TipoRegistro, TextoAuxiliares.TipoRegistro::Tabla);
        TextoAuxiliares.SetRange(TipoTabla, TextoAuxiliares.TipoTabla::ClienteReporting);
        TextoAuxiliares.setrange(NumReg, Code);
        if not TextoAuxiliares.FindFirst() then begin
            TextoAuxiliares.Init();
            TextoAuxiliares.TipoRegistro := TextoAuxiliares.TipoRegistro::Tabla;
            TextoAuxiliares.TipoTabla := TextoAuxiliares.TipoTabla::ClienteReporting;
            TextoAuxiliares.NumReg := ValueCode;
            TextoAuxiliares.Descripcion := Value;
            TextoAuxiliares.Insert();
        end;
        exit(TextoAuxiliares.NumReg);
    end;

    local procedure AddClienteActividad_btc(Value: text; Code: Text): Text
    var
        TextoAuxiliares: record TextosAuxiliares;
        ValueCode: code[20];
    begin
        ValueCode := CopyStr(Value, 1, MaxStrLen(TextoAuxiliares.NumReg));
        TextoAuxiliares.SetRange(TipoRegistro, TextoAuxiliares.TipoRegistro::Tabla);
        TextoAuxiliares.SetRange(TipoTabla, TextoAuxiliares.TipoTabla::ClienteActividad);
        TextoAuxiliares.setrange(NumReg, ValueCode);
        if not TextoAuxiliares.FindFirst() then begin
            TextoAuxiliares.Init();
            TextoAuxiliares.TipoRegistro := TextoAuxiliares.TipoRegistro::Tabla;
            TextoAuxiliares.TipoTabla := TextoAuxiliares.TipoTabla::ClienteActividad;
            TextoAuxiliares.NumReg := ValueCode;
            TextoAuxiliares.Descripcion := Value;
            TextoAuxiliares.Insert();
        end;
        exit(TextoAuxiliares.NumReg);
    end;

    local procedure addCustomerGroupPrice(var Customer: Record Customer; DatoExcel: text; DatoExceldesc: text);
    var
        CustPriceGroup: Record "Customer Price Group";
        CustDiscountGroup: Record "Customer Discount Group";
        Code: code[20];
    begin
        Code := copystr(DatoExceldesc, 1, MaxStrLen(CustPriceGroup.Code));
        CustPriceGroup.Reset();
        if not CustPriceGroup.Get(Code) then begin
            CustPriceGroup.Init();
            CustPriceGroup.Code := code;
            CustPriceGroup.Description := DatoExceldesc;
            CustPriceGroup."Allow Invoice Disc." := true;
            CustPriceGroup."Allow Line Disc." := true;
            CustPriceGroup.Insert();
        end else if CustPriceGroup.Description <> DatoExceldesc then begin
            if not CustPriceGroup.Get(DatoExcel) then begin
                CustPriceGroup.Init();
                CustPriceGroup.Code := DatoExcel;
                CustPriceGroup.Description := DatoExceldesc;
                CustPriceGroup."Allow Invoice Disc." := true;
                CustPriceGroup."Allow Line Disc." := true;
                CustPriceGroup.Insert();
            end;
        end;
        Customer."Customer Price Group" := CustPriceGroup.Code;
        Code := copystr(DatoExceldesc, 1, MaxStrLen(CustDiscountGroup.Code));
        CustDiscountGroup.Reset();
        if not CustDiscountGroup.Get(Code) then begin
            CustDiscountGroup.Init();
            CustDiscountGroup.Code := Code;
            CustDiscountGroup.Description := DatoExceldesc;
            CustDiscountGroup.Insert();
        end else if CustDiscountGroup.Description <> DatoExceldesc then begin
            if not CustDiscountGroup.Get(DatoExcel) then begin
                CustDiscountGroup.Init();
                CustDiscountGroup.Code := DatoExcel;
                CustDiscountGroup.Description := DatoExceldesc;
                CustDiscountGroup.Insert();
            end;
        end;
        Customer."Customer Disc. Group" := CustDiscountGroup.Code;
    end;

    local procedure AddCustomerPayments(var Customer: record Customer; Termino: Text; Metodo: text)
    var
        myInt: Integer;
    begin
        case Metodo of
            'B', 'IT', 'T':
                Customer."Payment Method Code" := 'TRANSF';
            'I':
                Customer."Payment Method Code" := 'GIRO';
            'S':
                Customer."Payment Method Code" := 'PAGARE';
            else
                Customer."Payment Method Code" := 'EFECTIVO';
        end;
        case Termino of
            '01':    //	Pagadero inmediatamente
                Customer."Payment Terms Code" := 'CONTADO';
            '02':    //	Contra reembolso
                begin
                    Customer."Payment Terms Code" := 'CONTADO';
                    Customer."Payment Method Code" := 'REEMBOLSO;'
                end;
            '03':    //	Pago Anticipado
                Customer."Payment Terms Code" := '';
            '05':    //	dentro de los 45 días sin DPP
                Customer."Payment Terms Code" := '45 DÍAS';
            '10':    //	dentro de los 30 días sin DPP
                Customer."Payment Terms Code" := '30 DÍAS';
            '11':    //	para facturación hasta 05 del mes al 5 del mes siguiente sin DPP Fecha base a 5. del mes
                Customer."Payment Terms Code" := '';
            '12':    //	para facturación hasta 10 del mes al 10 del mes siguiente sin DPP Fecha base a 10. del mes
                Customer."Payment Terms Code" := '';
            '13':    //	para facturación hasta 25 del mes al 25 del mes siguiente sin DPP Fecha base a 25. del mes
                Customer."Payment Terms Code" := '';
            '14':    //	para facturación hasta 28 del mes al 28 del mes siguiente sin DPP Fecha base a 28. del mes
                Customer."Payment Terms Code" := '';
            '15':    //	dentro de los 30 días sin DPP Fecha base a 30. del mes
                Customer."Payment Terms Code" := '';
            '16':    //	para facturación hasta 15 del mes al 15 del mes siguiente sin DPP Fecha base a 15. del mes
                Customer."Payment Terms Code" := '';
            '17':    //	para facturación hasta 20 del mes al 20 del mes siguiente sin DPP Fecha base a 20. del mes
                Customer."Payment Terms Code" := '';
            '20':    //	dentro de los 60 días sin DPP
                Customer."Payment Terms Code" := '60 DÍAS';
            '21':    //	para facturación hasta 15 del mes hasta el 15. en el mes 2 sin DPP Fecha base a 15. del mes
                Customer."Payment Terms Code" := '';
            '22':    //	para facturación hasta 20 del mes hasta el 20. en el mes 2 sin DPP Fecha base a 20. del mes
                Customer."Payment Terms Code" := '';
            '23':    //	para facturación hasta 25 del mes hasta el 25. en el mes 2 sin DPP Fecha base a 25. del mes
                Customer."Payment Terms Code" := '';
            '24':    //	hasta el 30. en el mes 2 sin DPP Fecha base a 30. del mes
                Customer."Payment Terms Code" := '';
            '25':    //	para facturación hasta 10 del mes hasta el 10. en el mes 2 sin DPP Fecha base a 10. del mes
                Customer."Payment Terms Code" := '';
            '30':    //	dentro de los 90 días sin DPP
                Customer."Payment Terms Code" := '90 DIAS';
            '31':    //	para facturación hasta 05 del mes hasta el 5. en el mes 3 sin DPP Fecha base a 5. del mes
                Customer."Payment Terms Code" := '';
            '32':    //	para facturación hasta 10 del mes
                Customer."Payment Terms Code" := '';
            '33':    //	para facturación hasta 15 del mes hasta el 15. en el mes 3 sin DPP Fecha base a 15. del mes
                Customer."Payment Terms Code" := '';
            '36':    //	para facturación hasta 20 del mes hasta el 20. en el mes 3 sin DPP Fecha base a 20. del mes
                Customer."Payment Terms Code" := '';
            '37':    //	para facturación hasta 25 del mes hasta el 25. en el mes 3 sin DPP Fecha base a 25. del mes
                Customer."Payment Terms Code" := '';
            '39':    //	dentro de los 90 días sin DPP
                Customer."Payment Terms Code" := '90 DIAS';
            '40':    //	pagable en 2 importes parciales
                Customer."Payment Terms Code" := '30-60';
            '50':    //	pagable en 2 importes parciales
                Customer."Payment Terms Code" := '30-60';
            '51':    //	pagable en 2 importes parciales
                Customer."Payment Terms Code" := '30-60';
            '53':    //	pagable en 2 importes parciales
                Customer."Payment Terms Code" := '30-60';
            '60':    //	pagable en 3 importes parciales
                Customer."Payment Terms Code" := '30-60-90';
            '70':    //	pagable en 3 importes parciales
                Customer."Payment Terms Code" := '30-60-90';
            '90':    //	pagable en 4 importes parciales
                Customer."Payment Terms Code" := '30-60-90';
        end;
    end;

    local procedure CustomerShipAddress(var ExcelBuffer: Record "Excel Buffer" temporary; Customer: Record Customer; CustSEBNo: code[20])
    var
        tmpCustomer: Record Customer temporary;
        ShiptoAddress: record "Ship-to Address";
    begin
        tmpCustomer := Customer;
        if Customer."Codigo Anterior" <> CustSEBNo then
            GetFieldsCustomerExcel(ExcelBuffer, tmpCustomer);
        ShiptoAddress.Reset();
        ShiptoAddress.SetRange("Customer No.", Customer."No.");
        ShiptoAddress.SetRange("Codigo Anterior", CustSEBNo);
        if not ShiptoAddress.FindFirst() then begin
            ShiptoAddress.Init();
            ShiptoAddress."Customer No." := tmpCustomer."No.";
            ShiptoAddress.Code := CustSEBNo;
            ShiptoAddress.Insert();
        end;
        ShiptoAddress.Name := tmpCustomer.Name;
        ShiptoAddress."Name 2" := tmpCustomer."Name 2";
        ShiptoAddress.Address := tmpCustomer.Address;
        ShiptoAddress."Address 2" := tmpCustomer."Address 2";
        ShiptoAddress.City := tmpCustomer.City;
        ShiptoAddress."Post Code" := tmpCustomer."Post Code";
        ShiptoAddress."Phone No." := tmpCustomer."Phone No.";
        ShiptoAddress."Telex No." := tmpCustomer."Telex No.";
        ShiptoAddress."Fax No." := tmpCustomer."Fax No.";
        ShiptoAddress."Country/Region Code" := tmpCustomer."Country/Region Code";
        ShiptoAddress."E-Mail" := tmpCustomer."E-Mail";
        ShiptoAddress."Codigo Anterior" := CustSEBNo;
        ShiptoAddress.Modify();
    end;

    // =============     PRODUCTOS SEB          ====================
    // ==  
    // ==  Importar excel de productos 
    // ==  
    // ======================================================================================================
    procedure UploadSEBItemRepuestosExcel()
    var
        Item: record Item;
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        ItemNoSEB: text;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        Text000: label 'Cargar Fichero de Excel';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');
        ;
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Window.Open('Linea #3####### de #4#######\Producto SEB: #1###############\Producto NAV: #2################');

        for linea := 2 to Rows do begin
            ItemNoSEB := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 1);  // codigo new cmmf
            if ExcelBuffer.FindSet() then
                ItemNoSEB := ExcelBuffer."Cell Value as Text";
            Window.Update(1, ItemNoSEB);
            if ItemNoSEB <> '' then begin
                window.update(3, linea);
                window.update(4, Rows);
                Window.Update(2, ItemNoSEB);
                if not Item.Get(ItemNoSEB) then begin
                    Item.Init();
                    Item."No." := ItemNoSEB;
                    item.Insert();
                    // aplicar plantilla
                    UpdateItemFromTemplate(Item, 'SAGE plantilla productos');
                end;

                GetFieldsItemRepuestoExcel(ExcelBuffer, Item);

                UpdateItemAux(item);

                Item.Modify();
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    procedure UploadSEBItemExcel()
    var
        Item: record Item;
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        ItemNoSEB: text;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        Text000: label 'Cargar Fichero de Excel';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');
        ;
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Window.Open('Linea #3####### de #4#######\Producto SEB: #1###############\Producto NAV: #2################');

        for linea := 2 to Rows do begin
            ItemNoSEB := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 3);  // codigo new cmmf
            if ExcelBuffer.FindSet() then
                ItemNoSEB := ExcelBuffer."Cell Value as Text";
            Window.Update(1, ItemNoSEB);
            if ItemNoSEB <> '' then begin
                window.update(3, linea);
                window.update(4, Rows);
                Window.Update(2, ItemNoSEB);
                if not Item.Get(ItemNoSEB) then begin
                    Item.Init();
                    Item."No." := ItemNoSEB;
                    item.Insert();
                    // aplicar plantilla
                    UpdateItemFromTemplate(Item, 'SAGE Plantillas Maquinas');
                end;

                GetFieldsItemExcel(ExcelBuffer, Item);

                UpdateItemAux(item);

                Item.Modify();
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    local procedure UpdateItemAux(var Item: record Item)
    var
        ItemTranslation: record "Item Translation";
    begin
        if not ItemTranslation.Get(Item."No.", '', 'ENU') then begin
            ItemTranslation.Init();
            ItemTranslation."Item No." := Item."No.";
            ItemTranslation."Variant Code" := '';
            ItemTranslation."Language Code" := 'ENU';
            ItemTranslation.Insert();
        end;
        ItemTranslation.Description := Item."Description 2";
        ItemTranslation.Modify();
        if not ItemTranslation.Get(Item."No.", '', 'ENG') then begin
            ItemTranslation.Init();
            ItemTranslation."Item No." := Item."No.";
            ItemTranslation."Variant Code" := '';
            ItemTranslation."Language Code" := 'ENG';
            ItemTranslation.Insert();
        end;
        ItemTranslation.Description := Item."Description 2";
        ItemTranslation.Modify();
    end;

    local procedure UpdateItemFromTemplate(var Item: Record Item; Plantilla: text);
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        ItemTemplate: Record "Item Template";
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        DimensionsTemplate: Record "Dimensions Template";
        ItemRecRef: RecordRef;
    begin
        ItemRecRef.GetTable(Item);
        ConfigTemplateHeader.SetRange("Table ID", Database::Item);
        ConfigTemplateHeader.SetRange(Description, Plantilla);
        if not ConfigTemplateHeader.FindFirst() then
            exit;
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
        DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Item."No.", DATABASE::Item);

        //NewCustomerFromTemplate(Customer);
    end;

    local procedure GetFieldsItemRepuestoExcel(var ExcelBuffer: Record "Excel Buffer" temporary; var Item: Record Item)
    var
        DatoExcel: text;
        DatoExceldesc: text;
        DatoFecha: date;
    begin

        Item.Blocked := false;
        //Item."Item Category Code" := DatoExcel;

        ExcelBuffer.SetRange("Column No.", 1);  // Material
        if ExcelBuffer.FindSet() then
            Item."No." := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 2);  // codigo anterior
        if ExcelBuffer.FindSet() then
            Item."No. 2" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 3);  // Nombre 
        if ExcelBuffer.FindSet() then
            Item.validate(Description, UpperCase(ExcelBuffer."Cell Value as Text"));
        DatoExcel := '333';
        // Item.selClasVtas_btc := GetClasificacionVentas(DatoExcel, DatoExceldesc);
        // GRUPO ART para grupo Registro de Ventas
        case DatoExcel of
            '033': //MAQUINAS CAFE  -> Producto Terminados SEB (mercaderias) 7002005  Ventas Productos Terminados, SEB
                begin
                    Item.Type := Item.Type::Inventory;
                    item.Validate("Gen. Prod. Posting Group", 'TERMINADOS SEB');
                    item.Validate("Inventory Posting Group", 'SEB MAQUINAS');
                end;
            '043': //RENTING
                begin
                    Item.Type := Item.Type::Service;
                    item.Validate("Gen. Prod. Posting Group", 'ALQUILERPRODUCTO');
                end;
            '313',  // REPUESTOS  -> Repuestos SEB  7001005
            '333':  //REP. MAQUINAS CAFE  -> Repuestos SEB  7001005
                begin
                    Item.Type := Item.Type::Inventory;
                    item.Validate("Gen. Prod. Posting Group", 'REPUESTOS SEB');
                    item.Validate("Inventory Posting Group", 'SEB RESPUESTOS');
                end;
            '503':  //S.A.T  ->  7050000  Prestación servicios Nacional
                begin
                    Item.Type := Item.Type::Service;
                    item.Validate("Gen. Prod. Posting Group", 'SERVICIOS SEB');
                end;
            '991':  //Seguro/Portes/Desc.       DESPLAZAMIENTO 7592000 Prestación servicios Nacional
                begin
                    Item.Type := Item.Type::Service;
                    item.Validate("Gen. Prod. Posting Group", 'SERVICIOS SEB');
                end;
        end;
        Item."material antiguo code" := Item."No. 2";
        ExcelBuffer.SetRange("Column No.", 8);  //  Código EAN/UPC
        if ExcelBuffer.FindSet() then
            Item.GTIN := CopyStr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Item.GTIN));
        ExcelBuffer.SetRange("Column No.", 3);  //  CMMF Code
        if ExcelBuffer.FindSet() then
            Item."CMMF Code" := CopyStr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Item."CMMF Code"));
        Item."Safety Stock Quantity" := 0;
        // ExcelBuffer.SetRange("Column No.", 24);  //  Nª Codigo
        // if ExcelBuffer.FindSet() then
        //     item."Vendor Item No." := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(item."material antiguo code"));
        ExcelBuffer.SetRange("Column No.", 5);  //  Base nit
        if ExcelBuffer.FindSet() then
            DatoExcel := ExcelBuffer."Cell Value as Text";
        case datoexcel of
            'ST':
                Item.validate("Base Unit of Measure", 'UDS');
            'KG':
                Item.validate("Base Unit of Measure", 'UDS');
            'M':
                Item.validate("Base Unit of Measure", 'METRO');
            else
                Item.validate("Base Unit of Measure", 'UDS');
        end;
        ExcelBuffer.SetRange("Column No.", 6);  //  Model Code
        if ExcelBuffer.FindSet() then
            item."Shelf No." := ExcelBuffer."Cell Value as Text";
    end;

    local procedure GetFieldsItemExcel(var ExcelBuffer: Record "Excel Buffer" temporary; var Item: Record Item)
    var
        DatoExcel: text;
        DatoExceldesc: text;
        DatoFecha: date;
    begin

        Item.Blocked := false;
        //Item."Item Category Code" := DatoExcel;

        ExcelBuffer.SetRange("Column No.", 3);  // Material
        if ExcelBuffer.FindSet() then
            Item."No." := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 1);  // codigo anterior
        if ExcelBuffer.FindSet() then
            Item."No. 2" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 5);  // Nombre 1
        if ExcelBuffer.FindSet() then
            Item.validate(Description, UpperCase(ExcelBuffer."Cell Value as Text"));
        ExcelBuffer.SetRange("Column No.", 2);  // Nombre anterior
        if ExcelBuffer.FindSet() then
            Item.validate("Description 2", ExcelBuffer."Cell Value as Text");
        DatoExcel := '033';
        // Item.selClasVtas_btc := GetClasificacionVentas(DatoExcel, DatoExceldesc);
        // GRUPO ART para grupo Registro de Ventas
        case DatoExcel of
            '033': //MAQUINAS CAFE  -> Producto Terminados SEB (mercaderias) 7002005  Ventas Productos Terminados, SEB
                begin
                    Item.Type := Item.Type::Inventory;
                    item.Validate("Gen. Prod. Posting Group", 'TERMINADOS SEB');
                    item.Validate("Inventory Posting Group", 'SEB MAQUINAS');
                end;
            '043': //RENTING
                begin
                    Item.Type := Item.Type::Service;
                    item.Validate("Gen. Prod. Posting Group", 'ALQUILERPRODUCTO');
                end;
            '313',  // REPUESTOS  -> Repuestos SEB  7001005
            '333':  //REP. MAQUINAS CAFE  -> Repuestos SEB  7001005
                begin
                    Item.Type := Item.Type::Inventory;
                    item.Validate("Gen. Prod. Posting Group", 'REPUESTOS SEB');
                    item.Validate("Inventory Posting Group", 'SEB RESPUESTOS');
                end;
            '503':  //S.A.T  ->  7050000  Prestación servicios Nacional
                begin
                    Item.Type := Item.Type::Service;
                    item.Validate("Gen. Prod. Posting Group", 'SERVICIOS SEB');
                end;
            '991':  //Seguro/Portes/Desc.       DESPLAZAMIENTO 7592000 Prestación servicios Nacional
                begin
                    Item.Type := Item.Type::Service;
                    item.Validate("Gen. Prod. Posting Group", 'SERVICIOS SEB');
                end;
        end;
        Item."material antiguo code" := Item."No. 2";
        ExcelBuffer.SetRange("Column No.", 9);  //  Código EAN/UPC
        if ExcelBuffer.FindSet() then
            Item.GTIN := CopyStr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Item.GTIN));
        ExcelBuffer.SetRange("Column No.", 3);  //  CMMF Code
        if ExcelBuffer.FindSet() then
            Item."CMMF Code" := CopyStr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Item."CMMF Code"));
        Item."Safety Stock Quantity" := 0;
        // ExcelBuffer.SetRange("Column No.", 24);  //  Nª Codigo
        // if ExcelBuffer.FindSet() then
        //     item."Vendor Item No." := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(item."material antiguo code"));
        ExcelBuffer.SetRange("Column No.", 6);  //  Base nit
        if ExcelBuffer.FindSet() then
            DatoExcel := ExcelBuffer."Cell Value as Text";
        case datoexcel of
            'ST':
                Item.validate("Base Unit of Measure", 'UDS');
            'KG':
                Item.validate("Base Unit of Measure", 'UDS');
            'M':
                Item.validate("Base Unit of Measure", 'METRO');
            else
                Item.validate("Base Unit of Measure", 'UDS');
        end;
        ExcelBuffer.SetRange("Column No.", 7);  //  Model Code
        if ExcelBuffer.FindSet() then
            item."Shelf No." := ExcelBuffer."Cell Value as Text";
        item."Item Tracking Code" := 'SEGNS';
        Item."Serial Nos." := 'SERIE';
    end;


    // =============     TARIFAS PRECIOS XLS          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    procedure UploadSEBItemPriceExcel()
    var
        Item: record Item;
        SalesPrice: record "Sales Price";
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        ItemNoSEB: text;
        Precio: Decimal;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        Text000: label 'Cargar Fichero de Excel';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');
        ;
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Window.Open('Linea #3####### de #4#######\Producto SEB: #1###############\Precio: #2################');

        for linea := 3 to Rows do begin
            ItemNoSEB := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 2);  // Codigo producto
            if ExcelBuffer.FindSet() then
                ItemNoSEB := ExcelBuffer."Cell Value as Text";
            Window.Update(1, ItemNoSEB);
            if ItemNoSEB <> '' then begin

                ExcelBuffer.SetRange("Column No.", 3);  //  precio
                if ExcelBuffer.FindSet() then
                    if Evaluate(Precio, ExcelBuffer."Cell Value as Text") then;
                window.update(3, linea);
                window.update(4, Rows);
                Window.Update(2, ItemNoSEB);
                if not Item.Get(ItemNoSEB) then begin
                    GeTItems(ItemNoSEB);
                end;
                SalesPrice.Reset();
                SalesPrice.SetRange("Item No.", ItemNoSEB);
                SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
                SalesPrice.SetRange("Sales Code", 'PCM');
                if not SalesPrice.FindFirst() then begin
                    SalesPrice.Init();
                    SalesPrice.validate("Item No.", ItemNoSEB);
                    SalesPrice."Sales Type" := SalesPrice."Sales Type"::"Customer Price Group";
                    SalesPrice.validate("Sales Code", 'PCM');
                    SalesPrice."Starting Date" := 20260101D;
                    SalesPrice.Validate("Currency Code", 'EUR');
                    //SalesPrice.validate("Unit of Measure Code", 'UDS');
                    SalesPrice.Insert();
                end;
                SalesPrice."Unit Price" := Precio;
                SalesPrice.Modify();
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    // =============     PROVEEDORES          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    procedure CargaVendorfromExcel()
    var
        Vendor: record Vendor;
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        CustomerNoSEB: text;
        VATCustomerNo: text;
        Borrado: text;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        UpdateCustomer: Boolean;
        Text000: label 'Cargar Fichero de Excel';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');

        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Window.Open('Vendor SEB: #1###############\Proveedor: #2###############\#3##### de #4#####');
        Window.Update(4, Rows);
        for linea := 6 to Rows do begin
            Window.Update(3, linea);
            CustomerNoSEB := '';
            VATCustomerNo := '';
            Borrado := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 2);  // codigo
            if ExcelBuffer.FindSet() then
                CustomerNoSEB := ExcelBuffer."Cell Value as Text";
            // ExcelBuffer.SetRange("Column No.", 40);  // pBor borrado
            // if ExcelBuffer.FindSet() then
            //     Borrado := ExcelBuffer."Cell Value as Text";
            // if Borrado = '' then begin
            ExcelBuffer.SetRange("Column No.", 18);  // N.I.F. 
            if ExcelBuffer.FindSet() then
                VATCustomerNo := ExcelBuffer."Cell Value as Text";
            window.update(1, CustomerNoSEB);
            if CustomerNoSEB <> '' then begin
                if CheckVendorSEBExist(CustomerNoSEB, Vendor) then begin
                    if Vendor.NuevoSEB then
                        UpdateCustomer := true
                    else
                        UpdateCustomer := false;
                end else if CheckVendorVatExist(CustomerNoSEB, VATCustomerNo) then begin
                    UpdateCustomer := false;
                    if Vendor."Codigo Anterior" = '' then begin
                        Vendor."Codigo Anterior" := CustomerNoSEB;
                        Vendor.NuevoSEB := true;
                        Vendor.Modify();
                    end;
                end else begin
                    Vendor.Init();
                    Vendor."No." := '';

                    // aplicar plantilla
                    UpdateVendorFromTemplate(Vendor);
                    Vendor."Codigo Anterior" := CustomerNoSEB;
                    Vendor.NuevoSEB := true;
                    window.update(2, Vendor."No.");
                    UpdateCustomer := true
                    //Customer."No." := CopyStr(SQLRGetSTring(SQLReader, 0), 1, MaxStrLen(Customer."No."));     //   [Cliente]
                    // Customer."No." := NoSeriesMgt.GetNextNo(Customer."No. Series", WorkDate(), true);
                end;
                if UpdateCustomer then begin
                    GetFieldsVendorExcel(ExcelBuffer, Vendor);
                    UpdateVendorPostingSetup(Vendor);
                    Vendor.Modify();
                end;
                // end;
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    local procedure GetFieldsVendorExcel(var ExcelBuffer: Record "Excel Buffer" temporary; var Vendor: Record Vendor)
    var
        DatoExcel: text;
        DatoExceldesc: text;
        DatoFecha: date;
    begin
        ExcelBuffer.SetRange("Column No.", 2);  // codig
        if ExcelBuffer.FindSet() then
            Vendor."Codigo Anterior" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 11);  // NOMBRFE PAIS
        if ExcelBuffer.FindSet() then
            DatoExcel := ExcelBuffer."Cell Value as Text";
        Vendor."Country/Region Code" := GetPAISVendor(DatoExcel);

        ExcelBuffer.SetRange("Column No.", 4);  // Nombre 1
        if ExcelBuffer.FindSet() then
            Vendor.validate(Name, ExcelBuffer."Cell Value as Text");
        ExcelBuffer.SetRange("Column No.", 5);  // Nombre 2
        if ExcelBuffer.FindSet() then
            Vendor."Name 2" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 7);  // Poblaci
        if ExcelBuffer.FindSet() then
            Vendor.City := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Vendor.City));
        ExcelBuffer.SetRange("Column No.", 10);  // CP
        if ExcelBuffer.FindSet() then
            Vendor."Post Code" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 12);  // Calle
        if ExcelBuffer.FindSet() then
            Vendor.Address := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 18);  // N.I.F. 
        if ExcelBuffer.FindSet() then
            Vendor."VAT Registration No." := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 20);  // Tel馭ono 1
        if ExcelBuffer.FindSet() then
            Vendor."Phone No." := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 21);  // Telefono 2
        if ExcelBuffer.FindSet() then
            Vendor."Fax No." := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 22);  // Nｺ telefax
        if ExcelBuffer.FindSet() then
            Vendor."Telex No." := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(Vendor."Telex No."));

        Vendor."Payment Terms Code" := 'CONTADO';
        vendor."Payment Method Code" := 'TRANSF';

    end;

    local procedure GetPAISVendor(Pais: text): text
    var
        myInt: Integer;
    begin
        case Pais of
            'Alemania':
                exit('DE');
            'Andorra':
                exit('AD');
            'Bélgica':
                exit('BE');
            'China':
                exit('CN');
            'Corea del Sur':
                exit('KR');
            'Dinamarca':
                exit('DK');
            'EEUU':
                exit('US');
            'Eslovenia':
                exit('SI');
            'España':
                exit('ES');
            'Estonia':
                exit('EE');
            'Francia':
                exit('FR');
            'Gibraltar':
                exit('GI');
            'Hong Kong':
                exit('GB');
            'Hungría':
                exit('HU');
            'Indonesia':
                exit('ID');
            'Irlanda':
                exit('IE');
            'Italia':
                exit('IT');
            'Luxemburgo':
                exit('LU');
            'Portugal':
                exit('PT');
            'Reino Unido':
                exit('GB');
            'República Checa':
                exit('CZ');
            'Singapur':
                exit('SG');
            'Suecia':
                exit('SE');
            'Suiza':
                exit('CH');
            'Vietnam':
                exit('VN');
            else
                exit(Pais);
        end;
    end;

    local procedure CheckVendorSEBExist(CustomerNoSEB: code[20]; var Vendor: Record Vendor): Boolean
    begin
        Vendor.SetRange("Codigo Anterior", CustomerNoSEB);
        if Vendor.FindFirst() then
            if Vendor.NuevoSEB then
                exit(True);
    end;

    local procedure CheckVendorVatExist(CustomerNoSEB: code[20]; VatNoSeb: code[50]): Boolean
    var
        Vendor: Record Vendor;
    begin
        if VatNoSeb = '' then
            exit;
        // primero filtramos por el nif del clientes, completo
        Vendor.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        if Vendor.FindSet() then begin
            Vendor."Codigo Anterior" := CustomerNoSEB;
            Vendor.Modify();
            exit(true);
        end;
        // ahora quitamos los dos primeros caracteres del pais.
        VatNoSeb := CopyStr(VatNoSeb, 3);
        Vendor.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        if Vendor.FindSet() then begin
            Vendor."Codigo Anterior" := CustomerNoSEB;
            Vendor.Modify();
            exit(true);
        end;
        // // solo dejamos los numeros y comprobamos
        // VatNoSeb := VATOnlyNumbers(VatNoSeb);
        // Customer.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        // if Customer.FindSet() then begin
        //     Customer."Codigo Anterior" := CustomerNoSEB;
        //     Customer.Modify();
        //     UpdateSQLCodigNAV(CustomerNoSEB, Customer."No.", 'Encontrado CIF sin pais ZUMMO');
        //     exit(true);
        // end;
    end;

    local procedure UpdateVendorFromTemplate(var Vendor: Record Vendor)
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        MiniVendorTemplate: Record "Mini Vendor Template" temporary;
        CustomerRecRef: RecordRef;
    begin
        ConfigTemplateHeader.SetRange("Table ID", Database::Vendor);
        ConfigTemplateHeader.SetRange(Description, 'VENDSEBPRO');
        if not ConfigTemplateHeader.FindFirst() then
            exit;
        MiniVendorTemplate.InitializeTempRecordFromConfigTemplate(MiniVendorTemplate, ConfigTemplateHeader);
        MiniVendorTemplate.InsertVendorFromTemplate(ConfigTemplateHeader, Vendor);

    end;

    local procedure UpdateVendorPostingSetup(var Vendor: Record Vendor)
    var
        CountryRegion: record "Country/Region";
    begin
        if CountryRegion.Get(Vendor."Country/Region Code") then begin
            Vendor."Gen. Bus. Posting Group" := CountryRegion."Gen. Bus. Posting Group";
            Vendor."VAT Bus. Posting Group" := CountryRegion."VAT Bus. Posting Group";
            Vendor."Vendor Posting Group" := CountryRegion."Vendor Posting Group";
        end else begin
            CountryRegion.Init();
            CountryRegion.Validate(Code, Vendor."Country/Region Code");
            CountryRegion.Insert();
        end;
    end;

    procedure CargaVendorBankfromExcel()
    var
        Vendor: record Vendor;
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        VendorNoSEB: text;
        Borrado: text;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        UpdateCustomer: Boolean;
        Text000: label 'Cargar Fichero de Excel banco proveedores';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');

        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Window.Open('Vendor SEB: #1###############\Proveedor: #2###############\#3##### de #4#####');
        Window.Update(4, Rows);
        for linea := 6 to Rows do begin
            Window.Update(3, linea);
            VendorNoSEB := '';
            Borrado := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 1);  // codigo proveedor
            if ExcelBuffer.FindSet() then
                VendorNoSEB := ExcelBuffer."Cell Value as Text";
            VendorNoSEB := KillLeftCERO(VendorNoSEB);
            window.update(1, VendorNoSEB);
            if VendorNoSEB <> '' then begin
                Vendor.SetRange("Codigo Anterior", VendorNoSEB);
                if Vendor.FindFirst() then begin
                    AddVendorBank(ExcelBuffer, Vendor, VendorNoSEB);
                    Vendor.Modify();
                end;
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    local procedure AddVendorBank(var ExcelBuffer: Record "Excel Buffer" temporary; var Vendor: Record Vendor; VendorSebNo: text)
    var
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        VendorBankAccount.Reset();
        VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
        if VendorBankAccount.findset() then
            exit;
        VendorBankAccount.Reset();
        clear(VendorBankAccount);
        VendorBankAccount.Init();
        VendorBankAccount."Vendor No." := vendor."No.";
        VendorBankAccount.Code := VendorSebNo;
        ExcelBuffer.SetRange("Column No.", 2);  // IBAN
        if ExcelBuffer.FindSet() then
            VendorBankAccount.IBAN := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 12);  // codigo bancario
        if ExcelBuffer.FindSet() then begin
            VendorBankAccount."CCC Bank No." := copystr(ExcelBuffer."Cell Value as Text", 1, 4);
            VendorBankAccount."CCC Bank Branch No." := copystr(ExcelBuffer."Cell Value as Text", 5, 4);
        end;
        ExcelBuffer.SetRange("Column No.", 4);  // cuenta bancaria
        if ExcelBuffer.FindSet() then
            VendorBankAccount."CCC Bank Account No." := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(VendorBankAccount."CCC Bank Account No."));
        ExcelBuffer.SetRange("Column No.", 5);  // Nombre
        if ExcelBuffer.FindSet() then
            VendorBankAccount.Name := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(VendorBankAccount.Name));
        ExcelBuffer.SetRange("Column No.", 9);  // SWIFT
        if ExcelBuffer.FindSet() then
            VendorBankAccount."SWIFT Code" := ExcelBuffer."Cell Value as Text";
        VendorBankAccount.Insert();
        Vendor."Preferred Bank Account Code" := VendorBankAccount.Code;
    end;

    local procedure KillLeftCERO(VendorNoSEB: text): text
    begin
        repeat
            if COPYSTR(VendorNoSEB, 1, 1) = '0' then
                VendorNoSEB := COPYSTR(VendorNoSEB, 2);
        until COPYSTR(VendorNoSEB, 1, 1) <> '0';
        exit(VendorNoSEB);
    end;

    procedure CargaCustomerBankfromExcel()
    var
        ShiptoAddress: record "Ship-to Address";
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        CustNoSEB: text;
        IBAN: text;
        Borrado: text;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        UpdateCustomer: Boolean;
        Text000: label 'Cargar Fichero de Excel banco clientes';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');

        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Window.Open('Vendor SEB: #1###############\Proveedor: #2###############\#3##### de #4#####');
        Window.Update(4, Rows);
        for linea := 6 to Rows do begin
            Window.Update(3, linea);
            CustNoSEB := '';
            IBAN := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 1);  // codigo proveedor
            if ExcelBuffer.FindSet() then
                CustNoSEB := ExcelBuffer."Cell Value as Text";
            CustNoSEB := KillLeftCERO(CustNoSEB);
            window.update(1, CustNoSEB);
            if CustNoSEB <> '' then begin
                ShiptoAddress.SetRange("Codigo Anterior", CustNoSEB);
                if ShiptoAddress.FindFirst() then begin
                    ExcelBuffer.SetRange("Column No.", 4);  // IBAN
                    if ExcelBuffer.FindSet() then
                        IBAN := ExcelBuffer."Cell Value as Text";
                    if IBAN <> '' then begin
                        AddCustBank(ExcelBuffer, ShiptoAddress, CustNoSEB);
                        window.update(2, CustNoSEB);
                    end;
                end;
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    local procedure AddCustBank(var ExcelBuffer: Record "Excel Buffer" temporary; ShiptoAddress: record "Ship-to Address"; CustSebNo: text)
    var
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        CustomerBankAccount.Reset();
        if CustomerBankAccount.Get(ShiptoAddress."Customer No.", CustSebNo) then
            exit;
        clear(CustomerBankAccount);
        CustomerBankAccount.Init();
        CustomerBankAccount.validate("Customer No.", ShiptoAddress."Customer No.");
        CustomerBankAccount.Code := CustSebNo;
        ExcelBuffer.SetRange("Column No.", 2);  // Nombre clientes
        if ExcelBuffer.FindSet() then
            CustomerBankAccount."Name 2" := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(CustomerBankAccount."Name 2"));
        ExcelBuffer.SetRange("Column No.", 3);  // Nombre
        if ExcelBuffer.FindSet() then
            CustomerBankAccount.Name := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(CustomerBankAccount.Name));
        ExcelBuffer.SetRange("Column No.", 4);  // IBAN
        if ExcelBuffer.FindSet() then
            CustomerBankAccount.IBAN := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 5);  // SWIFT
        if ExcelBuffer.FindSet() then
            CustomerBankAccount."SWIFT Code" := ExcelBuffer."Cell Value as Text";
        ExcelBuffer.SetRange("Column No.", 7);  // codigo bancario
        if ExcelBuffer.FindSet() then begin
            CustomerBankAccount."CCC Bank No." := copystr(ExcelBuffer."Cell Value as Text", 1, 4);
            CustomerBankAccount."CCC Bank Branch No." := copystr(ExcelBuffer."Cell Value as Text", 5, 4);
        end;
        ExcelBuffer.SetRange("Column No.", 6);  // cuenta bancaria
        if ExcelBuffer.FindSet() then
            CustomerBankAccount."CCC Bank Account No." := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(CustomerBankAccount."CCC Bank Account No."));
        ExcelBuffer.SetRange("Column No.", 10);  // DC
        if ExcelBuffer.FindSet() then
            CustomerBankAccount."CCC Control Digits" := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(CustomerBankAccount."CCC Control Digits"));
        CustomerBankAccount.Insert();
        if Customer.Get(CustomerBankAccount."Customer No.") then
            if Customer."Preferred Bank Account Code" = '' then begin
                Customer."Preferred Bank Account Code" := CustomerBankAccount.Code;
                Customer.Modify();
            end;

    end;

    procedure CargaSaldosProveedorfromExcel()
    var
        GLJnlLine: record "Gen. Journal Line";
        Vendor: record Vendor;
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        VendNoSEB: text;
        IBAN: text;
        Dato: text;
        Fecha: date;
        Importe: Decimal;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        LineNo: Integer;
        UpdateCustomer: Boolean;
        Text000: label 'Cargar Fichero de Excel saldos Proveedores';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');

        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 3);
        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        GLJnlLine.SetRange("Journal Template Name", 'APERTURA');
        GLJnlLine.SetRange("Journal Batch Name", 'APERTURA');
        GLJnlLine.DeleteAll();

        Window.Open('Proveedor SEB: #1###############\Fecha: #2###############\#3##### de #4#####');
        Window.Update(4, Rows);
        LineNo := 10000;
        for linea := 8 to Rows do begin
            Window.Update(3, linea);
            VendNoSEB := '';
            IBAN := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 3);  // codigo Proveedor
            if ExcelBuffer.FindSet() then
                VendNoSEB := ExcelBuffer."Cell Value as Text";
            window.update(1, VendNoSEB);
            if VendNoSEB <> '' then begin
                Vendor.SetRange("Codigo Anterior", VendNoSEB);
                if Vendor.FindFirst() then
                    if Vendor.Blocked in [Vendor.Blocked::All, Vendor.Blocked::Payment] then begin
                        Vendor.Blocked := Vendor.Blocked::" ";
                        Vendor."Purchaser Code" := 'SEB';
                        Vendor.Modify();
                    end;
                GLJnlLine.Init();
                clear(GLJnlLine);
                GLJnlLine."Journal Template Name" := 'APERTURA';
                GLJnlLine."Journal Batch Name" := 'APERTURA';
                GLJnlLine."Line No." := LineNo;
                GLJnlLine.Validate("Posting Date", WorkDate());
                fecha := 0D;
                ExcelBuffer.SetRange("Column No.", 6);  // Fecha
                if ExcelBuffer.FindSet() then
                    if Evaluate(fecha, ExcelBuffer."Cell Value as Text") then
                        GLJnlLine.validate("Document Date", Fecha);
                GLJnlLine.validate("Document Type");
                dato := '';
                ExcelBuffer.SetRange("Column No.", 4);  // Documento
                if ExcelBuffer.FindSet() then
                    Dato := ExcelBuffer."Cell Value as Text";
                if dato <> '' then begin
                    ExcelBuffer.SetRange("Column No.", 5);  // Tipo Documento
                    if ExcelBuffer.FindSet() then begin
                        GLJnlLine.validate("Document No.", StrSubstNo('%1 %2', ExcelBuffer."Cell Value as Text", dato));
                        GLJnlLine.validate(Description, ExcelBuffer."Cell Value as Text");
                    end;
                    GLJnlLine.validate("Account Type", GLJnlLine."Source Type"::Vendor);
                    GLJnlLine.validate("Account No.", Vendor."No.");

                    ExcelBuffer.SetRange("Column No.", 9);  // Importe
                    if ExcelBuffer.FindSet() then
                        if Evaluate(Importe, ExcelBuffer."Cell Value as Text") then
                            GLJnlLine.validate(Amount, Importe);
                    // GLJnlLine."Payment Method Code" := 'CONTADO';
                    // GLJnlLine."Payment Terms Code" := 'CONTADO';
                    GLJnlLine.validate("Bal. Account Type", GLJnlLine."Bal. Account Type"::"G/L Account");
                    GLJnlLine.validate("Bal. Account No.", '4000998');
                    GLJnlLine.Insert();
                    LineNo += 10000;
                end;
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

    procedure CargaSaldosClientesfromExcel()
    var
        GLJnlLine: record "Gen. Journal Line";
        Customer: record Customer;
        ShiptoAddres: Record "Ship-to Address";
        ExcelBuffer: Record "Excel Buffer" temporary;
        NVInStream: InStream;
        FileName: text;
        Sheetname: text;
        CustNoSEB: text;
        IBAN: text;
        Dato: text;
        Fecha: date;
        Importe: Decimal;
        Window: Dialog;
        Rows: Integer;
        linea: Integer;
        UpdateCustomer: Boolean;
        Text000: label 'Cargar Fichero de Excel saldos clientes';
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error('No ser ha podido abrir el fichero');

        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 1);
        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        GLJnlLine.SetRange("Journal Template Name", 'APERTURA');
        GLJnlLine.SetRange("Journal Batch Name", 'APERTURA');
        GLJnlLine.DeleteAll();

        Window.Open('Cliente SEB: #1###############\Fecha: #2###############\#3##### de #4#####');
        Window.Update(4, Rows);
        for linea := 2 to Rows do begin
            Window.Update(3, linea);
            CustNoSEB := '';
            IBAN := '';
            ExcelBuffer.SetRange("Row No.", linea);
            ExcelBuffer.SetRange("Column No.", 1);  // codigo Cliente
            if ExcelBuffer.FindSet() then
                CustNoSEB := ExcelBuffer."Cell Value as Text";
            CustNoSEB := copystr(CustNoSEB, 9);  //Account 
            window.update(1, CustNoSEB);
            if CustNoSEB <> '' then begin
                ShiptoAddres.SetRange("Codigo Anterior", CustNoSEB);
                if ShiptoAddres.FindFirst() then;
                if Customer.Get(ShiptoAddres."Customer No.") then
                    if not (Customer.Blocked in [Customer.Blocked::" "]) then
                        Customer.Blocked := Customer.Blocked::" ";
                if Customer."Payment Terms Code" = '' then
                    Customer."Payment Terms Code" := 'CONTADO';
                Customer.Modify();

                GLJnlLine.Init();
                clear(GLJnlLine);
                GLJnlLine."Journal Template Name" := 'APERTURA';
                GLJnlLine."Journal Batch Name" := 'APERTURA';
                GLJnlLine."Line No." := 10000 * linea;
                GLJnlLine.Validate("Posting Date", WorkDate());
                fecha := 0D;
                ExcelBuffer.SetRange("Column No.", 6);  // Fecha
                if ExcelBuffer.FindSet() then
                    if Evaluate(fecha, ExcelBuffer."Cell Value as Text") then
                        GLJnlLine.validate("Document Date", Fecha);
                GLJnlLine.validate("Document Type");
                dato := '';
                ExcelBuffer.SetRange("Column No.", 5);  // Tipo Documento
                if ExcelBuffer.FindSet() then
                    Dato := ExcelBuffer."Cell Value as Text";
                ExcelBuffer.SetRange("Column No.", 4);  // Documento
                if ExcelBuffer.FindSet() then
                    GLJnlLine.validate("Document No.", StrSubstNo('%1 %2', dato, ExcelBuffer."Cell Value as Text"));
                GLJnlLine.validate("Account Type", GLJnlLine."Source Type"::Customer);
                GLJnlLine.validate("Account No.", Customer."No.");
                ExcelBuffer.SetRange("Column No.", 11);  // descripcion
                if ExcelBuffer.FindSet() then
                    GLJnlLine.validate(Description, ExcelBuffer."Cell Value as Text");
                fecha := 0D;
                ExcelBuffer.SetRange("Column No.", 10);  // Fecha
                if ExcelBuffer.FindSet() then
                    if Evaluate(fecha, ExcelBuffer."Cell Value as Text") then
                        GLJnlLine.validate("Due Date", Fecha);
                ExcelBuffer.SetRange("Column No.", 8);  // importe
                if ExcelBuffer.FindSet() then
                    if Evaluate(Importe, ExcelBuffer."Cell Value as Text") then
                        GLJnlLine.validate(Amount, Importe);
                GLJnlLine."Payment Method Code" := 'CONTADO';
                GLJnlLine."Payment Terms Code" := 'CONTADO';
                GLJnlLine.validate("Bal. Account Type", GLJnlLine."Bal. Account Type"::"G/L Account");
                GLJnlLine.validate("Bal. Account No.", '4300998');
                GLJnlLine.Insert();
            end;
        end;
        Window.Close();
        Message('File %1 uploaded successfully. Content: %2', FileName, linea);
    end;

}