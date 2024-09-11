table 17462 "ZINC Services & Warranty"
{
    Caption = 'ZINC Services & Warranty';
    Description = 'ZUMMO INC - Tabla principal Services & Warranty';
    ExternalName = 'Zummo, Inc$LGX ZMO Service & Warranty Hdr$54d024e0-581a-40ad-9d77-0501b08a0e33';
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
        field(2; "LGX ZMO Serial No_"; Code[20])
        {
            ExternalName = 'LGX ZMO Serial No_';
        }
        field(3; "LGX ZMO Sales Shipment No_"; Code[20])
        {
            ExternalName = 'LGX ZMO Sales Shipment No_';
        }
        field(4; "LGX ZMO Purchase Date"; datetime)
        {
            ExternalName = 'LGX ZMO Purchase Date';
        }
        field(5; "LGX ZMO Incident Date"; datetime)
        {
            ExternalName = 'LGX ZMO Incident Date';
        }
        field(6; "LGX ZMO Warranty"; Boolean)
        {
            ExternalName = 'LGX ZMO Warranty';
        }
        field(7; "LGX ZMO Action Taken"; Option)
        {
            ExternalName = 'LGX ZMO Action Taken';
            ExternalType = 'Picklist';
            InitValue = "No Action";
            OptionCaption = 'No Action,Repaired,Replaced';
            OptionMembers = "No Action",Repaired,Replaced;
        }
        field(8; "LGX ZMO New Serial No_"; Code[20])
        {
            ExternalName = 'LGX ZMO New Serial No_';
        }
        field(9; "LGX ZMO Sales Invoice No_"; Code[20])
        {
            ExternalName = 'LGX ZMO Sales Invoice No_';
        }
        field(10; "LGX ZMO Warranty Expiry Date"; datetime)
        {
            ExternalName = 'LGX ZMO Warranty Expiry Date';
        }
        field(11; "LGX ZMO Item No_"; Code[20])
        {
            ExternalName = 'LGX ZMO Item No_';
        }
        field(12; "LGX ZMO Item Description"; text[100])
        {
            ExternalName = 'LGX ZMO Item Description';
        }
        field(13; "LGX ZMO Item Description 2"; text[50])
        {
            ExternalName = 'LGX ZMO Item Description 2';
        }
        field(14; "LGX ZMO Sell-To Customer No_"; Code[20])
        {
            ExternalName = 'LGX ZMO Sell-To Customer No_';
        }
        field(15; "LGX ZMO Sell-to Customer Name"; text[100])
        {
            ExternalName = 'LGX ZMO Sell-to Customer Name';
        }
        field(16; "LGX ZMO Sell-to Cust_ Name 2"; text[500])
        {
            ExternalName = 'LGX ZMO Sell-to Cust_ Name 2';
        }
        field(17; "LGX ZMO Sell-to Address"; text[100])
        {
            ExternalName = 'LGX ZMO Sell-to Address';
        }
        field(18; "LGX ZMO Sell-to Address 2"; text[50])
        {
            ExternalName = 'LGX ZMO Sell-to Address 2';
        }
        field(19; "LGX ZMO Sell-to City"; text[30])
        {
            ExternalName = 'LGX ZMO Sell-to City';
        }
        field(20; "LGX ZMO Sell-to Post Code"; code[20])
        {
            ExternalName = 'LGX ZMO Sell-to Post Code';
        }
        field(21; "LGX ZMO Sell-to County"; text[30])
        {
            ExternalName = 'LGX ZMO Sell-to County';
        }
        field(22; "LGX ZMO Sell-to C__R_ Code"; code[10])
        {
            ExternalName = 'LGX ZMO Sell-to C__R_ Code';
        }
        field(23; "LGX ZMO Sell-to Contact"; text[100])
        {
            ExternalName = 'LGX ZMO Sell-to Contact';
        }
        field(24; "LGX ZMO Sell-to Phone No_"; text[30])
        {
            ExternalName = 'LGX ZMO Sell-to Phone No_';
        }
        field(25; "LGX ZMO Sell-to Fax No_"; text[30])
        {
            ExternalName = 'LGX ZMO Sell-to Fax No_';
        }
        field(26; "LGX ZMO Sell-to E-Mail"; text[80])
        {
            ExternalName = 'LGX ZMO Sell-to E-Mail';
        }
        field(27; "LGX ZMO No_ Series"; code[20])
        {
            ExternalName = 'LGX ZMO No_ Series';
        }
        field(28; "LGX ZMO Status"; Option)
        {
            ExternalName = 'LGX ZMO Status';
            ExternalType = 'Picklist';
            InitValue = Closed;
            OptionCaption = 'Closed,Delayed,Opened,Parts Shipped,Service Scheduled';
            OptionMembers = Closed,Delayed,Opened,"Parts Shipped","Service Scheduled";
        }

        field(29; "LGX ZMO Purchase Receipt No_"; code[20])
        {
            ExternalName = 'LGX ZMO Purchase Receipt No_';
        }
        field(30; "LGX ZMO Vendor No_"; code[20])
        {
            ExternalName = 'LGX ZMO Vendor No_';
        }
        field(31; "LGX ZMO Vendor Name"; text[100])
        {
            ExternalName = 'LGX ZMO Vendor Name';
        }
        field(32; "LGX ZMO Purchase Invoice No_"; code[20])
        {
            ExternalName = 'LGX ZMO Purchase Invoice No_';
        }
        field(33; "LGX ZMO Package Tracking No_"; text[30])
        {
            ExternalName = 'LGX ZMO Package Tracking No_';
        }
        field(34; "LGX ZMO Ship-to Code"; code[20])
        {
            ExternalName = 'LGX ZMO Ship-to Code';
        }
        field(35; "LGX ZMO Ship-to Name"; text[100])
        {
            ExternalName = 'LGX ZMO Ship-to Name';
        }
        field(36; "LGX ZMO Ship-to Name 2"; text[50])
        {
            ExternalName = 'LGX ZMO Ship-to Name 2';
        }
        field(37; "LGX ZMO Ship-to Address"; text[100])
        {
            ExternalName = 'LGX ZMO Ship-to Address';
        }
        field(38; "LGX ZMO Ship-to Address 2"; text[50])
        {
            ExternalName = 'LGX ZMO Ship-to Address 2';
        }
        field(39; "LGX ZMO Ship-to City"; text[30])
        {
            ExternalName = 'LGX ZMO Ship-to City';
        }
        field(40; "LGX ZMO Ship-to Contact"; text[100])
        {
            ExternalName = 'LGX ZMO Ship-to Contact';
        }
        field(41; "LGX ZMO Ship-to Post Code"; code[20])
        {
            ExternalName = 'LGX ZMO Ship-to Post Code';
        }
        field(42; "LGX ZMO Ship-to County"; text[30])
        {
            ExternalName = 'LGX ZMO Ship-to County';
        }
        field(43; "LGX ZMO Ship-to C__R_ Code"; code[10])
        {
            ExternalName = 'LGX ZMO Ship-to C__R_ Code';
        }
        field(44; "LGX ZMO Shipment Date"; datetime)
        {
            ExternalName = 'LGX ZMO Shipment Date';
        }
        field(45; "LGX ZMO Shipment Method Code"; code[20])
        {
            ExternalName = 'LGX ZMO Shipment Method Code';
        }
        field(46; "LGX ZMO Shipping Agent Code"; code[20])
        {
            ExternalName = 'LGX ZMO Shipping Agent Code';
        }
        field(47; "LGX ZMO Closed Date"; date)
        {
            ExternalName = 'LGX ZMO Closed Date';
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

    procedure CreateGLEntry(EntryNoIni: Integer)
    var
        GLEntry: Record "G/L Entry";
        ABGLEntry: Record "ABERTIA GL Entry";
        Window: Dialog;
    begin
        Window.Open('Nº Movimiento #1################\Fecha #2################');
        GLEntry.Reset();
        GLEntry.SetRange("Entry No.", EntryNoIni, 999999999);
        if GLEntry.FindFirst() then
            repeat
                Window.Update(1, GLEntry."Entry No.");
                Window.Update(2, GLEntry."Posting Date");
                ABGLEntry.Reset();
                case CompanyName of
                    'ZUMMO':
                        ABGLEntry.SetRange("00 - Origen", 'ZIM');
                    'INVESTMENTS':
                        ABGLEntry.SetRange("00 - Origen", 'ZINV');
                    else
                        ABGLEntry.SetRange("00 - Origen", '');
                end;
                ABGLEntry.SetRange("Entry No_", GLEntry."Entry No.");
            //if not ABGLEntry.FindFirst() then begin
            //UpdateABGLEntry(GLEntry, ABGLEntry);
            //end;
            Until GLEntry.next() = 0;
        Window.Close();

    end;


}