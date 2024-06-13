page 60028 "STH API POST Contact"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API POST Contact';
    // EntityCaption = 'STH API Contact';
    // EntitySetCaption = 'STH API Contact';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostContact';
    EntitySetName = 'sthPostContact';
    ODataKeyFields = "No.";
    PageType = API;
    SourceTable = Contact;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(id; Rec.Id)
                // {
                //     Caption = 'Id';
                // }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(faxNo; Rec."Fax No.")
                {
                    Caption = 'Fax No.';
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'E-Mail';
                }
                field(companyContactNo; companyContactNo)
                {
                    Caption = 'Company No.';
                }
                // field(companyName; Rec."Company Name")
                // {
                //     Caption = 'Company Name';
                // }
                field(vendorNo; vendorNo)
                {
                    Caption = 'Vendor No.';

                    trigger OnValidate()
                    begin
                        validateVendorNo();
                    end;
                }
                field(jobTitle; Rec."Job Title")
                {
                    Caption = 'Job Title';
                }
                field(Type; auxTipo)
                {
                    Caption = 'Type';

                    trigger OnValidate()
                    begin
                        validateVendorNo();
                    end;
                }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }
    var
        contact: Record "Contact";
        actionHTTP: Text;
        result: Text;
        auxTipo: Text;
        companyContactNo: Code[20];
        vendorNo: Code[20];
        vendor: Record Vendor;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if contact.Get(Rec."No.") then begin
                        contact.Delete();
                    end;

                    deleteContBusRelation();

                    result := 'Success';
                end;
            'POST':
                begin
                    if contact.Get(Rec."No.") then
                        Error('El registro ya existe %1', Rec."No.");

                    contact.Init();
                    assignType();
                    contact.TransferFields(Rec);
                    createNoContact();

                    case auxTipo of
                        'Person':
                            begin
                                contact.Type := contact.Type::Person;
                            end;
                        'Company':
                            begin
                                contact.Type := contact.Type::Company;
                            end;
                    end;

                    updateCompanyNo();
                    validateVendorFieldPrimaryContact();

                    contact.Insert();
                end;
            'PATCH':
                begin
                    if contact.Get(Rec."No.") then begin
                        assignType();
                        contact.TransferFields(Rec);

                        case auxTipo of
                            'Person':
                                begin
                                    contact.Type := contact.Type::Person;
                                end;
                            'Company':
                                begin
                                    contact.Type := contact.Type::Company;
                                end;
                        end;

                        updateCompanyNo();
                        validateVendorFieldPrimaryContact();

                        contact.Modify();
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Person;
    end;

    local procedure validateVendorNo()
    var
        contBusRel: Record "Contact Business Relation";
    begin
        if (vendorNo = '') OR (auxTipo = '') then
            exit;

        assignType();
        Rec.TestField(Type, Rec.Type::Company);

        vendor.Reset();
        vendor.Get(vendorNo);
        if vendor."Primary Contact No." = Rec."No." then begin
            vendor.Validate("Primary Contact No.", "No.");
        end else begin
            if not contBusRel.FindByRelation(contBusRel."Link to Table"::Vendor, vendorNo) then begin
                contBusRel.CreateRelation("No.", vendorNo, contBusRel."Link to Table"::Vendor);
            end;
        end;
    end;

    local procedure validateVendorFieldPrimaryContact()
    var
        contBusRel: Record "Contact Business Relation";
    begin
        contBusRel.Reset();
        contBusRel.SetRange("Link to Table", contBusRel."Link to Table"::Vendor);
        contBusRel.SetRange("Contact No.", contact."Company No.");
        if contBusRel.FindSet() then begin
            vendor.Reset();
            vendor.Get(contBusRel."No.");
            if vendor."Primary Contact No." = Rec."No." then begin
                // vendor.Validate("Primary Contact No.", "No.");
                vendor."Primary Contact No." := "No.";
                vendor.Contact := Name;
                vendor.Modify();
            end;
        end;
    end;

    local procedure assignType()
    begin
        case auxTipo of
            'Person':
                begin
                    Rec.Type := Rec.Type::Person;
                end;
            'Company':
                begin
                    Rec.Type := Rec.Type::Company;
                end;
        end;
    end;

    local procedure deleteContBusRelation()
    var
        contBusRel: Record "Contact Business Relation";
    begin
        contBusRel.Reset();
        contBusRel.SetRange("Link to Table", contBusRel."Link to Table"::Vendor);
        contBusRel.SetRange("Contact No.", Rec."No.");
        if contBusRel.FindSet() then begin
            contBusRel.Delete();
        end;
    end;

    local procedure updateCompanyNo()
    var
        contacto: Record Contact;
    begin
        if companyContactNo <> '' then begin
            contact."Company No." := companyContactNo;
        end else begin
            contact."Company No." := Rec."No.";
            contact."Company Name" := Rec.Name;
        end;

        if contacto.Get(contact."Company No.") then
            contact."Company Name" := contacto.Name;
    end;

    local procedure createNoContact()

    var
        RMSetup: Record "Marketing Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            RMSetup.Get();
            RMSetup.TestField("Contact Nos.");
            // NoSeriesMgt.InitSeries(RMSetup."Contact Nos.", '', 0D, contact."No.", contact."No. Series");
            contact."No." := NoSeriesMgt.GetNextNo(RMSetup."Contact Nos.", 0D, true);
            Rec."No." := contact."No.";
        end;
    end;
}
