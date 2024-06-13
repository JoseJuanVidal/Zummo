page 60011 "STH API Contact"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Contact';
    // EntityCaption = 'STH API Contact';
    // EntitySetCaption = 'STH API Contact';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthContact';
    EntitySetName = 'sthContact';
    ODataKeyFields = "No.";
    PageType = API;
    SourceTable = Contact;

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
                field(companyNo; Rec."Company No.")
                {
                    Caption = 'Company No.';
                }
                field(companyName; Rec."Company Name")
                {
                    Caption = 'Company Name';
                }
                field(jobTitle; Rec."Job Title")
                {
                    Caption = 'Job Title';
                }
                field(Type; Type)
                {
                    Caption = 'Type';
                }
            }
        }
    }
}
