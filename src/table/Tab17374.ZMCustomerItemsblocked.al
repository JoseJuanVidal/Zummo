table 17374 "ZM Customer Items blocked"
{
    Caption = 'Customer Items blocked', Comment = 'ESP="Bloqueos Productos por Clientes"';
    DataClassification = CustomerContent;
    LookupPageId = "Customer Items blockeds";
    DrillDownPageId = "Customer Items blockeds";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.', Comment = 'ESP="Cód. Cliente"';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(2; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name', Comment = 'ESP="Nombre Cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Editable = False;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(4; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = False;
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Customer No.", "Item No.")
        {
            Clustered = true;
        }
    }
}

// se utiliza en el evento de la tabla 37 al indicar 
// OnValidateNoOnBeforeInitRec
