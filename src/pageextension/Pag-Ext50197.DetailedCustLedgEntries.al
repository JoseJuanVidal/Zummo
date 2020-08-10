pageextension 50197 "DetailedCustLedgEntries" extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field(FacturaLiquidada; FacturaLiquidada)
            {
                ApplicationArea = all;
            }
        }
    }

    var
        FacturaLiquidada: Code[20];

    trigger OnAfterGetRecord()
    var
        Detailed: Record "Detailed Cust. Ledg. Entry";
    begin
        FacturaLiquidada := '';
        if Rec."Document Type" = Rec."Document Type"::Payment then begin
            Detailed.reset;
            Detailed.SetRange("Cust. Ledger Entry No.", rec."Cust. Ledger Entry No.");
            Detailed.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
            if Detailed.FindFirst() then
                FacturaLiquidada := Detailed."Document No.";
        end;
    END;
}