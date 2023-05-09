codeunit 50112 "Vigilantes colas"
{
    // clientes
    // ofertas aux
    // lineas ofertas aux
    // productos

    // Report	88205	GBS Resumen envios email SII
    // Report	88204	GBS Enviar documentos SII
    // Report	88201	GBS Procesar Movs. IVA SII
    // Codeunit	50503	Cron_AddonAUT	Cron_EnvioMailAprobacion	
    // Codeunit	50110	CU_Cron	Enviar facturación	
    // Codeunit	50110	CU_Cron	Aviso próximos vencimientos	
    // Codeunit	50110	CU_Cron	CargaMovsContaPresup
    // Codeunit	50110	CU_Cron	Limpia seguimientos    
    // Report	50101	Crear facturas periódicas (proceso)
    // Report	795	Valorar stock - movs. producto


    // ============== CRM 
    // Codeunit	5339	Integration Synch. Job Runner	CLIENTECORPORATIVO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	TERMINOS.PAGO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CURRENCY: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTAS-LIN: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTASSALESLIN: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CANAL: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	AREAMANAGER: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	PAISES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	FORMAS.PAGO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CLIENTES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	ACTIVIDADCLIENTE: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	PROVINCIAS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	TARIFAS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	DELEGADOS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	GRUPOCLIENTE: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTASSALES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	MERCADOS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTAS: trabajo de sincronización de Dynamics 365 for Sales.



    trigger OnRun()
    begin
        CheckJobQueueEntry;

        testCRMConnection;
    end;

    var
        myInt: Integer;

    local procedure CheckJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        isactive: Boolean;
    begin
        if JobQueueEntry.findset() then
            repeat
                isactive := false;
                // Limpiamos los trabajos de ERROR del CRM - customer - Contact link
                // id 5351 - CRM Customer-Contact Link - ERROR
                if (JobQueueEntry."Object ID to Run" = 5351) and (JobQueueEntry.Description = 'Enlace de contacto con el cliente.') and
                   (JobQueueEntry.Status in [JobQueueEntry.Status::Error]) then
                    JobQueueEntry.Delete();
                case JobQueueEntry."Object Type to Run" of
                    JobQueueEntry."Object Type to Run"::Codeunit:
                        begin
                            if JobQueueEntry."Object ID to Run" = 5339 then begin
                                case JobQueueEntry.Description of
                                    'CLIENTES: trabajo de sincronización de Dynamics 365 for Sales.',
                                    'OFERTASSALES: trabajo de sincronización de Dynamics 365 for Sales.',
                                    'OFERTASSALESLIN: trabajo de sincronización de Dynamics 365 for Sales.':
                                        begin
                                            if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                                JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                        end;
                                end;
                            end;

                            case JobQueueEntry."Object ID to Run" of
                                50503, 50110:
                                    begin
                                        if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                    end;
                            end;
                        end;
                    JobQueueEntry."Object Type to Run"::Report:
                        begin
                            case JobQueueEntry."Object ID to Run" of
                                88205, 88204, 88201, 50101, 795:
                                    begin
                                        if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                    end;
                            end;
                        end;
                end;

            Until JobQueueEntry.next() = 0;
    end;

    local procedure testCRMConnection()
    var
        CRMConnectionSetup: record "CRM Connection Setup";
    begin
        CRMConnectionSetup.get();
        if not CRMConnectionSetup.IsEnabled() then
            CRMConnectionSetup.Validate("Is Enabled", true);
    end;

    procedure TextToBase64String(Value: Text) ReturnValue: Text;
    var
        BinaryValue: text;
        Length: Integer;
    begin
        // Divide value into blocks of 3 bytes
        Length := StrLen(Value);
        BinaryValue := TextToBinary(Value, 8);
        ReturnValue := ConvertBinaryValueToBase64String(BinaryValue, Length);
    end;

    procedure StreamToBase64String(Value: InStream) ReturnValue: Text;
    var
        SingleByte: Byte;
        Length: Integer;
        BinaryValue: Text;
        adsfas: codeunit "CDC Convert Base 64";
    begin
        while not Value.EOS do begin
            Value.Read(SingleByte, 1);
            Length += 1;
            BinaryValue += ByteToBinary(SingleByte, 8);
        end;

        ReturnValue := ConvertBinaryValueToBase64String(BinaryValue, Length);
    end;

    procedure FromBase64StringToText(Value: Text) ReturnValue: Text;
    var
        BinaryValue: Text;
    begin
        BinaryValue := ConvertBase64StringToBinaryValue(Value);
        ReturnValue := BinaryToText(BinaryValue);
    end;

    procedure FromBase64StringToStream(Value: Text; var ReturnValue: OutStream);
    var
        BinaryValue: Text;
    begin
        BinaryValue := ConvertBase64StringToBinaryValue(Value);
        BinaryToStream(BinaryValue, ReturnValue);
    end;

    local procedure ConvertBinaryValueToBase64String(Value: Text; Length: Integer) ReturnValue: Text;
    var
        Length2: Integer;
        PaddingCount: Integer;
        BlockCount: Integer;
        Pos: Integer;
        CurrentByte: text;
        i: Integer;
    begin
        if Length MOD 3 = 0 then begin
            PaddingCount := 0;
            BlockCount := Length / 3;
        end else begin
            PaddingCount := 3 - (Length MOD 3);
            BlockCount := (Length + PaddingCount) / 3;
        end;

        Length2 := Length + PaddingCount;
        Value := PadStr(Value, Length2 * 8, '0');

        // Loop through bytes in groups of 6 bits
        Pos := 1;
        while Pos < Length2 * 8 do begin
            CurrentByte := CopyStr(Value, Pos, 6);
            ReturnValue += GetBase64Char(BinaryToInt(CurrentByte));
            pos += 6;
        end;

        // Replace last characters with '='
        for i := 1 to PaddingCount do begin
            Pos := StrLen(ReturnValue) - i + 1;
            ReturnValue[Pos] := '=';
        end;

    end;

    local procedure ConvertBase64StringToBinaryValue(Value: Text) ReturnValue: Text;
    var
        BinaryValue: Text;
        i: Integer;
        IntValue: Integer;
        PaddingCount: Integer;
    begin
        for i := 1 to StrLen(Value) do begin
            if Value[i] = '=' then
                PaddingCount += 1;

            IntValue := GetBase64Number(Value[i]);
            BinaryValue += IncreaseStringLength(IntToBinary(IntValue), 6);
        end;

        for i := 1 to PaddingCount do
            BinaryValue := CopyStr(BinaryValue, 1, StrLen(BinaryValue) - 8);

        ReturnValue := BinaryValue;
    end;

    local procedure TextToBinary(Value: text; ByteLength: Integer) ReturnValue: text;
    var
        IntValue: Integer;
        i: Integer;
        BinaryValue: text;
    begin
        for i := 1 to StrLen(value) do begin
            IntValue := value[i];
            BinaryValue := IntToBinary(IntValue);
            BinaryValue := IncreaseStringLength(BinaryValue, ByteLength);
            ReturnValue += BinaryValue;
        end;
    end;

    local procedure BinaryToText(Value: Text) ReturnValue: Text;
    var
        Buffer: BigText;
        Pos: Integer;
        SingleByte: Text;
        CharValue: Text;
    begin
        Buffer.AddText(Value);

        Pos := 1;
        while Pos < Buffer.Length do begin
            Buffer.GetSubText(SingleByte, Pos, 8);
            CharValue[1] := BinaryToInt(SingleByte);
            ReturnValue += CharValue;
            Pos += 8;
        end;
    end;

    local procedure BinaryToStream(Value: Text; var ReturnValue: OutStream);
    var
        Buffer: BigText;
        Pos: Integer;
        SingleByte: Text;
        ByteValue: Byte;
    begin
        Buffer.AddText(Value);

        Pos := 1;
        while Pos < Buffer.Length do begin
            Buffer.GetSubText(SingleByte, Pos, 8);
            ByteValue := BinaryToInt(SingleByte);
            ReturnValue.Write(ByteValue, 1);
            Pos += 8;
        end;
    end;

    local procedure ByteToBinary(Value: Byte; ByteLenght: Integer) ReturnValue: Text;
    var
        BinaryValue: Text;
    begin
        BinaryValue := IntToBinary(Value);
        BinaryValue := IncreaseStringLength(BinaryValue, ByteLenght);
        ReturnValue := BinaryValue;
    end;

    local procedure IntToBinary(Value: integer) ReturnValue: text;
    begin
        while Value >= 1 do begin
            ReturnValue := Format(Value MOD 2) + ReturnValue;
            Value := Value DIV 2;
        end;
    end;

    local procedure BinaryToInt(Value: Text) ReturnValue: Integer;
    var
        Multiplier: BigInteger;
        IntValue: Integer;
        i: Integer;
    begin
        Multiplier := 1;
        for i := StrLen(Value) downto 1 do begin
            Evaluate(IntValue, CopyStr(Value, i, 1));
            ReturnValue += IntValue * Multiplier;
            Multiplier *= 2;
        end;
    end;

    local procedure IncreaseStringLength(Value: Text; ToLength: Integer) ReturnValue: Text;
    var
        ExtraLength: Integer;
        ExtraText: Text;
    begin
        ExtraLength := ToLength - StrLen(Value);

        if ExtraLength < 0 then
            exit;

        ExtraText := PadStr(ExtraText, ExtraLength, '0');
        ReturnValue := ExtraText + Value;
    end;

    local procedure GetBase64Char(Value: Integer): text;
    var
        chars: text;
        i: Integer;
    begin
        chars := Base64Chars;
        exit(chars[Value + 1]);
    end;

    local procedure GetBase64Number(Value: text): Integer;
    var
        chars: text;
    begin
        if Value = '=' then
            exit(0);

        chars := Base64Chars;
        exit(StrPos(chars, Value) - 1);
    end;

    local procedure Base64Chars(): text;
    begin
        exit('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/');
    end;

    procedure ToBase64(InStream: InStream; InsertLineBreaks: Boolean): Text
    var
        Convert: DotNet Convert;
        MemoryStream: DotNet MemoryStream;
        InputArray: DotNet Array;
        // Base64FormattingOptions: DotNet Base64FormattingOptions;
        Base64String: Text;
    begin
        MemoryStream := MemoryStream.MemoryStream();
        CopyStream(MemoryStream, InStream);
        InputArray := MemoryStream.ToArray();

        Base64String := Convert.ToBase64String(InputArray);

        MemoryStream.Close();
        exit(Base64String);
    end;

}