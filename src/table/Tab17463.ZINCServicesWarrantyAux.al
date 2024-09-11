table 17463 "ZINC Services & Warranty Aux"
{
    Caption = 'ZINC Services & Warranty Aux';
    Description = 'ZUMMO INC - Tabla principal Services & Warranty';
    ExternalName = 'Zummo, Inc$LGX ZMO Service & Warranty Hdr$e3ec16ab-a69a-4d56-acad-9f2fd5ce519f';
    //Zummo, Inc$LGX ZMO Service & Warr_ Line$54d024e0-581a-40ad-9d77-0501b08a0e33
    //Zummo, Inc$LGX ZMO Service Warr_ Comment$54d024e0-581a-40ad-9d77-0501b08a0e33
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {
        field(1; "LGX ZMO Incident No_"; Code[20])
        {
            ExternalName = 'LGX ZMO Incident No_';
        }
        field(2; "Service & Warranty Type"; Code[20])
        {
            ExternalName = 'Service & Warranty Type';
        }
        field(3; "Fault"; Code[20])
        {
            ExternalName = 'Fault';
        }
        field(4; "Localized Fault"; Code[20])
        {
            ExternalName = 'Localized Fault';
        }
    }

    procedure CreateTableConnection()
    begin
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINC') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINC');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINC',
            'Data Source=10.8.1.16;Initial Catalog=ZummoBCDEV;User ID=BCSPAIN;Password=Bario5622!');  // ZummoLIVE
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINC');
    end;
}