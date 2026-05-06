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

    procedure GetClients()
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
        lblSQLDelete: Label 'SELECT *  FROM [CLIENTS$] WHERE Cliente is not null ORDER BY [Cliente]';
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

                if CheckCustomerSEBExist(CustomerNoSEB, Customer) then
                    UpdateCustomer := true
                else if CheckCustomerVatExist(CustomerNoSEB, VatNoSeb) then
                    UpdateCustomer := false
                else begin
                    Customer.Init();
                    Customer."No." := '';
                    // aplicar plantilla
                    UpdateCustomerFromTemplate(Customer);
                    windows.update(2, Customer."No.");
                    //Customer."No." := CopyStr(SQLRGetSTring(SQLReader, 0), 1, MaxStrLen(Customer."No."));     //   [Cliente]
                    // Customer."No." := NoSeriesMgt.GetNextNo(Customer."No. Series", WorkDate(), true);
                end;
                if UpdateCustomer then begin
                    GetFieldsCustomerSQLReader(tmpCustomer, SQLReader);
                    Windows.Update(1, tmpCustomer."No.");
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
        Page.Run(0, Customer);

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
        tmpCustomer.Modify();
    end;

    local procedure CheckCustomerSEBExist(CustomerNoSEB: code[20]; var Customer: Record Customer): Boolean

    begin
        Customer.SetRange("Codigo Anterior", CustomerNoSEB);
        if Customer.FindFirst() then
            exit(True);
    end;

    local procedure CheckCustomerVatExist(CustomerNoSEB: code[20]; VatNoSeb: code[50]): Boolean
    var
        Customer: Record Customer;
    begin
        if VatNoSeb = '' then
            exit;
        // primero filtramos por el nif del clientes, completo
        Customer.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        if Customer.FindSet() then begin
            Customer."Codigo Anterior" := CustomerNoSEB;
            Customer.Modify();
            UpdateSQLCodigNAV(CustomerNoSEB, Customer."No.", 'Encontrado CIF completo ZUMMO');
            exit(true);
        end;
        // ahora quitamos los dos primeros caracteres del pais.
        VatNoSeb := CopyStr(VatNoSeb, 3);
        Customer.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        if Customer.FindSet() then begin
            Customer."Codigo Anterior" := CustomerNoSEB;
            Customer.Modify();
            UpdateSQLCodigNAV(CustomerNoSEB, Customer."No.", 'Encontrado CIF sin pais ZUMMO');
            exit(true);
        end;
        // solo dejamos los numeros y comprobamos
        VatNoSeb := VATOnlyNumbers(VatNoSeb);
        Customer.SetFilter("VAT Registration No.", '%1', StrSubstNo('*%1*', VatNoSeb));
        if Customer.FindSet() then begin
            Customer."Codigo Anterior" := CustomerNoSEB;
            Customer.Modify();
            UpdateSQLCodigNAV(CustomerNoSEB, Customer."No.", 'Encontrado CIF sin pais ZUMMO');
            exit(true);
        end;
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
        lblSQLCount: Label 'UPDATE [ZUMMOREM].[dbo].[CLIENTS$] SET %1 WHERE [Cliente] =''%2''';
        lblSET: Label '[CodigoNAV]=''%1'',[Estado]=''%2''';
    begin
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
    end;

    local procedure CreateDefaultDimension(Customer: Record Customer)
    var
        DefaultDimension: Record "Default Dimension";
    begin
        DefaultDimension.SetRange("Table ID", Database::Customer);
        DefaultDimension.SetRange("No.", Customer."No.");
        DefaultDimension.SetRange("Dimension Code", 'LINEANEGOCIO');
        if not DefaultDimension.FindFirst() then begin
            DefaultDimension.Init();
            DefaultDimension."Table ID" := Database::Customer;
            DefaultDimension."No." := Customer."No.";
            DefaultDimension.Validate("Dimension Code", 'LINEANEGOCIO');
            DefaultDimension.Validate("Dimension Value Code", 'PCM');
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

}