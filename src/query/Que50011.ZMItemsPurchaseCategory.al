query 50011 "ZM Items - Purchase Category"
{
    QueryCategory = 'Productos - Compras por categorias';

    elements
    {
        dataitem(Item; Item)
        {
            SqlJoinType = InnerJoin;
            //DataItemTableFilter = Type = const(Inventory);

            column(No_; "No.")
            { }
            column(Description; Description)
            { }
            column(Purch__Category; "Purch. Category")
            { }
            column(Desc__Purch__Category; "Desc. Purch. Category")
            { }
            column(Purch__SubCategory; "Purch. SubCategory")
            { }
            column(Group_Purch__SubCategory; "Group Purch. SubCategory")
            { }
            column(Net_Weight_Unitary; "Net Weight")
            { }
            column(Type; Type)
            { }
            column(Item_Category_Code; "Item Category Code")
            { }
            dataitem(Item_Ledger_Entry; "Item Ledger Entry")
            {
                DataItemTableFilter = "Entry Type" = const(Purchase), "Posting Date" = filter(>= 01012024);
                DataItemLink = "Item No." = Item."No.";
                SqlJoinType = InnerJoin;
                column(Year; Year)
                { }
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                column(Cost_Amount__Actual_; "Cost Amount (Actual)")
                {
                    Method = sum;
                }


            }
        }
    }

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Window: Dialog;
        lblWindow: Label 'Entry No.: #1#############\Posting Date: #2###############', comment = 'ESP="Nº Mov.: #1#############\Fecha: #2###############"';

    trigger OnBeforeOpen()
    begin

    end;

    local procedure UpdateItemLedgerPending()
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange(Year, 0);
        if ItemLedgerEntry.FindFirst() then
            repeat
                ItemLedgerEntry.Modify(true);
                ItemLedgerEntry.Modify();
            Until ItemLedgerEntry.next() = 0;
    end;
}