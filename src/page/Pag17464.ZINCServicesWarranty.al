page 17464 "ZINC Services & Warranty"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ZINC Services & Warranty";
    SourceTableView = where("LGX ZMO Warranty" = const(true));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("LGX ZMO Incident No_"; "LGX ZMO Incident No_") { ApplicationArea = All; }
                field("LGX ZMO Serial No_"; "LGX ZMO Serial No_") { ApplicationArea = All; }
                field("LGX ZMO Sales Shipment No_"; "LGX ZMO Sales Shipment No_") { ApplicationArea = All; }
                field("LGX ZMO Purchase Date"; "LGX ZMO Purchase Date") { ApplicationArea = All; }
                field("LGX ZMO Incident Date"; "LGX ZMO Incident Date") { ApplicationArea = All; }
                field("LGX ZMO Warranty"; "LGX ZMO Warranty") { ApplicationArea = All; }
                field("LGX ZMO Action Taken"; "LGX ZMO Action Taken") { ApplicationArea = All; }
                field("LGX ZMO New Serial No_"; "LGX ZMO New Serial No_") { ApplicationArea = All; }
                field("LGX ZMO Sales Invoice No_"; "LGX ZMO Sales Invoice No_") { ApplicationArea = All; }
                field("LGX ZMO Warranty Expiry Date"; "LGX ZMO Warranty Expiry Date") { ApplicationArea = All; }
                field("LGX ZMO Item No_"; "LGX ZMO Item No_") { ApplicationArea = All; }
                field("LGX ZMO Item Description"; "LGX ZMO Item Description") { ApplicationArea = All; }
                field("LGX ZMO Item Description 2"; "LGX ZMO Item Description 2") { ApplicationArea = All; }
                field("LGX ZMO Sell-To Customer No_"; "LGX ZMO Sell-To Customer No_") { ApplicationArea = All; }
                field("LGX ZMO Sell-to Customer Name"; "LGX ZMO Sell-to Customer Name") { ApplicationArea = All; }
                field("LGX ZMO Sell-to Cust_ Name 2"; "LGX ZMO Sell-to Cust_ Name 2") { ApplicationArea = All; }
                field("LGX ZMO Sell-to Address"; "LGX ZMO Sell-to Address") { ApplicationArea = All; }
                field("LGX ZMO Sell-to Address 2"; "LGX ZMO Sell-to Address 2") { ApplicationArea = All; }
                field("LGX ZMO Sell-to City"; "LGX ZMO Sell-to City") { ApplicationArea = All; }
                field("LGX ZMO Sell-to Post Code"; "LGX ZMO Sell-to Post Code") { ApplicationArea = All; }
                field("LGX ZMO Sell-to County"; "LGX ZMO Sell-to County") { ApplicationArea = All; }
                field("LGX ZMO Sell-to C__R_ Code"; "LGX ZMO Sell-to C__R_ Code") { ApplicationArea = All; }
                field("LGX ZMO Sell-to Contact"; "LGX ZMO Sell-to Contact") { ApplicationArea = All; }
                field("LGX ZMO Sell-to Phone No_"; "LGX ZMO Sell-to Phone No_") { ApplicationArea = All; }
                field("LGX ZMO Sell-to Fax No_"; "LGX ZMO Sell-to Fax No_") { ApplicationArea = All; }
                field("LGX ZMO Sell-to E-Mail"; "LGX ZMO Sell-to E-Mail") { ApplicationArea = All; }
                field("LGX ZMO No_ Series"; "LGX ZMO No_ Series") { ApplicationArea = All; }
                field("LGX ZMO Status"; "LGX ZMO Status") { ApplicationArea = All; }
                field("LGX ZMO Purchase Receipt No_"; "LGX ZMO Purchase Receipt No_") { ApplicationArea = All; }
                field("LGX ZMO Vendor No_"; "LGX ZMO Vendor No_") { ApplicationArea = All; }
                field("LGX ZMO Vendor Name"; "LGX ZMO Vendor Name") { ApplicationArea = All; }
                field("LGX ZMO Purchase Invoice No_"; "LGX ZMO Purchase Invoice No_") { ApplicationArea = All; }
                field("LGX ZMO Package Tracking No_"; "LGX ZMO Package Tracking No_") { ApplicationArea = All; }
                field("LGX ZMO Ship-to Code"; "LGX ZMO Ship-to Code") { ApplicationArea = All; }
                field("LGX ZMO Ship-to Name"; "LGX ZMO Ship-to Name") { ApplicationArea = All; }
                field("LGX ZMO Ship-to Name 2"; "LGX ZMO Ship-to Name 2") { ApplicationArea = All; }
                field("LGX ZMO Ship-to Address"; "LGX ZMO Ship-to Address") { ApplicationArea = All; }
                field("LGX ZMO Ship-to Address 2"; "LGX ZMO Ship-to Address 2") { ApplicationArea = All; }
                field("LGX ZMO Ship-to City"; "LGX ZMO Ship-to City") { ApplicationArea = All; }
                field("LGX ZMO Ship-to Contact"; "LGX ZMO Ship-to Contact") { ApplicationArea = All; }
                field("LGX ZMO Ship-to Post Code"; "LGX ZMO Ship-to Post Code") { ApplicationArea = All; }
                field("LGX ZMO Ship-to County"; "LGX ZMO Ship-to County") { ApplicationArea = All; }
                field("LGX ZMO Ship-to C__R_ Code"; "LGX ZMO Ship-to C__R_ Code") { ApplicationArea = All; }
                field("LGX ZMO Shipment Date"; "LGX ZMO Shipment Date") { ApplicationArea = All; }
                field("LGX ZMO Shipment Method Code"; "LGX ZMO Shipment Method Code") { ApplicationArea = All; }
                field("LGX ZMO Shipping Agent Code"; "LGX ZMO Shipping Agent Code") { ApplicationArea = All; }
                field("LGX ZMO Closed Date"; "LGX ZMO Closed Date") { ApplicationArea = All; }

                field(ServiceType; ServiceType)
                {
                    ApplicationArea = All;
                    Caption = 'Service Type';
                }
                field(Fault; Fault)
                {
                    ApplicationArea = All;
                    Caption = 'Fault';
                }
                field(LocalizedFault; LocalizedFault)
                {
                    ApplicationArea = All;
                    Caption = 'Localized Fault';
                }

            }
        }
    }
    trigger OnInit()
    begin
        OpenTableConnection();
    end;

    trigger OnAfterGetRecord()
    begin
        // ServiceType := '';
        // Fault := '';
        // LocalizedFault := '';
        // if Services_WarrantyAux.Get(Rec."LGX ZMO Incident No_") then begin
        //     ServiceType := Services_WarrantyAux."Service & Warranty Type";
        //     Fault := Services_WarrantyAux.Fault;
        //     LocalizedFault := Services_WarrantyAux."Localized Fault";
        // end;
    end;

    var
        Services_WarrantyAux: Record "ZINC Services & Warranty Aux";
        ServiceType: Text;
        Fault: text;
        LocalizedFault: text;

    procedure OpenTableConnection()
    begin
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINC') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINC');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINC',
            'Data Source=10.8.1.16;Initial Catalog=ZummoBCDEV;User ID=BCSPAIN;Password=Bario5622!');  // ZummoLIVE
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ZUMMOINC');
    end;

}