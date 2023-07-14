page 17470 "ABERTIA GL Entry"
{
    ApplicationArea = All;
    Caption = 'ABERTIA GL Entry';
    PageType = List;
    SourceTable = "ABERTIA GL Entry";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No_"; Rec."Entry No_")
                {
                    ApplicationArea = All;
                }
                field("G_L Account No_"; Rec."G_L Account No_")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No_"; Rec."Document No_")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Bal_ Account No_"; Rec."Bal_ Account No_")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    ApplicationArea = All;
                }
                field("Prior-Year Entry"; Rec."Prior-Year Entry")
                {
                    ApplicationArea = All;
                }
                field("Job No_"; Rec."Job No_")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Gen_ Posting Type"; Rec."Gen_ Posting Type")
                {
                    ApplicationArea = All;
                }
                field("Gen_ Bus_ Posting Group"; Rec."Gen_ Bus_ Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen_ Prod_ Posting Group"; Rec."Gen_ Prod_ Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Bal_ Account Type"; Rec."Bal_ Account Type")
                {
                    ApplicationArea = All;
                }
                field("Transaction No_"; Rec."Transaction No_")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No_"; Rec."External Document No_")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No_"; Rec."Source No_")
                {
                    ApplicationArea = All;
                }
                field("No_ Series"; Rec."No_ Series")
                {
                    ApplicationArea = All;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = All;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    ApplicationArea = All;
                }
                field("VAT Bus_ Posting Group"; Rec."VAT Bus_ Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod_ Posting Group"; Rec."VAT Prod_ Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    ApplicationArea = All;
                }
                field("Add_-Currency Debit Amount"; Rec."Add_-Currency Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Add_-Currency Credit Amount"; Rec."Add_-Currency Credit Amount")
                {
                    ApplicationArea = All;
                }
                field("Close Income Statement Dim_ ID"; Rec."Close Income Statement Dim_ ID")
                {
                    ApplicationArea = All;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                }
                field("Reversed by Entry No_"; Rec."Reversed by Entry No_")
                {
                    ApplicationArea = All;
                }
                field("Reversed Entry No_"; Rec."Reversed Entry No_")
                {
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("Prod_ Order No_"; Rec."Prod_ Order No_")
                {
                    ApplicationArea = All;
                }
                field("FA Entry Type"; Rec."FA Entry Type")
                {
                    ApplicationArea = All;
                }
                field("FA Entry No_"; Rec."FA Entry No_")
                {
                    ApplicationArea = All;
                }
                field("Last Modified DateTime"; Rec."Last Modified DateTime")
                {
                    ApplicationArea = All;
                }
                field("New G_L Account No_"; Rec."New G_L Account No_")
                {
                    ApplicationArea = All;
                }
                field("Old G_L Account No_"; Rec."Old G_L Account No_")
                {
                    ApplicationArea = All;
                }
                field(Updated; Rec.Updated)
                {
                    ApplicationArea = All;
                }
                field("Period Trans_ No_"; Rec."Period Trans_ No_")
                {
                    ApplicationArea = All;
                }
                field("Bill No_"; Rec."Bill No_")
                {
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Actualizar)
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Rec.CreateGLEntry(0D);
                end;

            }
        }
    }
    trigger OnInit()
    begin
        OpenTableConnection();
    end;

    procedure OpenTableConnection()
    begin
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI',
            'Data Source=zummo.ddns.net;Initial Catalog=ReportingZummo;User ID=jvidal;Password=Bario5622$');
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;


}
