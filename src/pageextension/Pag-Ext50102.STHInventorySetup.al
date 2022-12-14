pageextension 50102 "STHInventorySetup" extends "Inventory Setup"
{
    layout
    {
        addafter("Copy Item Descr. to Entries")
        {
            field("Fecha Diario dentro periodo"; "Fecha Diario dentro periodo")
            {
                ApplicationArea = all;
            }
        }
        addafter(Numbering)
        {
            group(CalcNeed)
            {
                Caption = 'Calculate Balance Qty.', comment = 'ESP="Calcular Cantidad Balance"';

                field(Inventory; Inventory)
                {
                    ApplicationArea = all;
                }
                field("Qty. on Assembly Order"; "Qty. on Assembly Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Prod. Order"; "Qty. on Prod. Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                    ApplicationArea = all;
                }
                field("Trans. Ord. Receipt (Qty.)"; "Trans. Ord. Receipt (Qty.)")
                {
                    ApplicationArea = all;
                }

                field("Qty. on Asm. Component"; "Qty. on Asm. Component")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Component Lines"; "Qty. on Component Lines")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Job Order"; "Qty. on Job Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Service Order"; "Qty. on Service Order")
                {
                    ApplicationArea = all;
                }
                field("Trans. Ord. Shipment (Qty.)"; "Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Sales Quote"; "Qty. on Sales Quote")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Component Quote"; "Qty. on Component Quote")
                {
                    ApplicationArea = all;
                }
                field("Qty. on Planning MPS Component"; "Qty. on Planning MPS Component")
                {
                    ApplicationArea = all;
                }
                field("MRP Bitec Activo"; "MRP Bitec Activo")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}