tableextension 50177 "ItemLedgerEntry" extends "Item Ledger Entry"  //32
{
    fields
    {
        field(50100; Desc2_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2', comment = 'ESP="Descripción 2"';
        }

        field(50101; CodCliente_btc; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.', comment = 'ESP="Cód. Cliente"';
        }

        field(50102; NombreCliente_btc; Text[100])
        {
            Editable = false;
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field(CodCliente_btc)));
        }

        field(50103; ItemType; Option)
        {
            Caption = 'Tipo producto', comment = 'ESP="Tipo producto"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Type where("No." = field("Item No.")));

            OptionMembers = Inventory,Service,"Non-Inventory";
            OptionCaption = 'Inventario,Servicio,Fuera de inventario', Comment = 'ESP="Inventario,Servicio,Fuera de inventario"';
        }
        field(50107; "Posted Service Item"; Boolean)
        {
            Caption = 'Posted  Item Service', comment = 'ESP="Hist. Productos de servicio"';
            FieldClass = FlowField;
            CalcFormula = exist("Service Item" where("Item No." = field("Item No."), CodSerieHistorico_btc = field("Serial No.")));
            Editable = false;
        }
    }
}