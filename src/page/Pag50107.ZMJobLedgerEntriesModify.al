page 50107 "ZM Job Ledger Entries Modify"
{
    Caption = 'Job Ledger Entries', Comment = 'ESP="Movs. Proyectos"';
    DataCaptionFields = "Job No.";
    Editable = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Entry';
    SourceTable = "Job Ledger Entry";
    SourceTableView = SORTING("Job No.", "Posting Date") ORDER(Descending);
    UsageCategory = None;
    Permissions = tabledata "Job Ledger Entry" = rmid;


    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("No."; "No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Jobs;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Job Posting Group"; "Job Posting Group")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = Planning;
                    Visible = false;
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                    Editable = false;
                }
                field("Work Type Code"; "Work Type Code")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Direct Unit Cost (LCY)"; "Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Total Cost"; "Total Cost")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Total Cost (LCY)"; "Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Unit Price (LCY)"; "Unit Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Total Price"; "Total Price")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Visible = false;
                }
                field("Total Price (LCY)"; "Total Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Line Amount (LCY)"; "Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Amt. to Post to G/L"; "Amt. to Post to G/L")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Amt. Posted to G/L"; "Amt. Posted to G/L")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Original Unit Cost"; "Original Unit Cost")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Original Unit Cost (LCY)"; "Original Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Original Total Cost"; "Original Total Cost")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Original Total Cost (LCY)"; "Original Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("Original Total Cost (ACY)"; "Original Total Cost (ACY)")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Visible = false;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Visible = false;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Visible = false;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = ItemTracking;
                    Visible = false;
                    Editable = false;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Visible = false;
                }
                field("Ledger Entry Type"; "Ledger Entry Type")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Ledger Entry No."; "Ledger Entry No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field(Adjusted; Adjusted)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("DateTime Adjusted"; "DateTime Adjusted")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        xRec.ShowDimensions;
                    end;
                }
                action(SetDimensionFilter)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Set Dimension Filter';
                    Ellipsis = true;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Limit the entries according to the dimension filters that you specify. NOTE: If you use a high number of dimension combinations, this function may not work and can result in a message that the SQL server only supports a maximum of 2100 parameters.';

                    trigger OnAction()
                    begin
                        SETFILTER("Dimension Set ID", DimensionSetIDFilter.LookupFilter);
                    end;
                }
                action("<Action28>")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Show Linked Job Planning Lines';
                    Image = JobLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View the planning lines that are associated with job journal entries that have been posted to the job ledger. This requires that the Apply Usage Link check box has been selected for the job, or is the default setting for all jobs in your organization.';

                    trigger OnAction()
                    var
                        JobUsageLink: Record "Job Usage Link";
                        JobPlanningLine: Record "Job Planning Line";
                    begin
                        JobUsageLink.SETRANGE("Entry No.", "Entry No.");

                        IF JobUsageLink.FINDSET THEN
                            REPEAT
                                JobPlanningLine.GET(JobUsageLink."Job No.", JobUsageLink."Job Task No.", JobUsageLink."Line No.");
                                JobPlanningLine.MARK := TRUE;
                            UNTIL JobUsageLink.NEXT = 0;

                        JobPlanningLine.MARKEDONLY(TRUE);
                        PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Transfer To Planning Lines")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Transfer To Planning Lines';
                    Ellipsis = true;
                    Image = TransferToLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create planning lines from posted job ledger entries. This is useful if you forgot to specify the planning lines that should be created when you posted the job journal lines.';

                    trigger OnAction()
                    var
                        JobLedgEntry: Record "Job Ledger Entry";
                        JobTransferToPlanningLine: Report "Job Transfer To Planning Lines";
                    begin
                        JobLedgEntry.COPY(Rec);
                        CurrPage.SETSELECTIONFILTER(JobLedgEntry);
                        CLEAR(JobTransferToPlanningLine);
                        JobTransferToPlanningLine.GetJobLedgEntry(JobLedgEntry);
                        JobTransferToPlanningLine.RUNMODAL;
                        CLEAR(JobTransferToPlanningLine);
                    end;
                }
            }
            action("&Navigate")
            {
                ApplicationArea = Jobs;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
}


