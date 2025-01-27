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
        field(50105; SerialNoParent; code[50])
        {
            Caption = 'Nº Serie Consumo', comment = 'ESP="Nº Serie Consumo"';
            DataClassification = CustomerContent;

        }
        field(50107; "Posted Service Item"; Boolean)
        {
            Caption = 'Posted  Item Service', comment = 'ESP="Hist. Productos de servicio"';
            FieldClass = FlowField;
            CalcFormula = exist("Service Item" where("Item No." = field("Item No."), CodSerieHistorico_btc = field("Serial No.")));
            Editable = false;
        }
        field(50110; "Customer No. Item Service"; code[20])
        {
            Caption = 'Customer No. Item Service', comment = 'ESP="Cód. Cliente Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Item"."Customer No." where("Item No." = field("Item No."), "Serial No." = field("Serial No.")));
            Editable = false;
        }
        field(50111; "Customer Name Item Service"; text[100])
        {
            Caption = 'Customer Name Item Service', comment = 'ESP="Nombre Cliente Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD(CodCliente_btc)));
            Editable = false;
        }
        field(50112; "Cust. Ship-to Code Item Serv."; text[100])
        {
            Caption = 'Customer Ship-to Code Item service', comment = 'ESP="Cliente Cod. envío Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup("Service Item"."Ship-to Code" where("Item No." = field("Item No."), "Serial No." = field("Serial No.")));
            Editable = false;
        }
        field(50113; "Cust. Ship-to Name Item Serv."; text[100])
        {
            Caption = 'Customer Ship-toName Item service', comment = 'ESP="Nombre Cliente envío Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address".Name WHERE("Customer No." = FIELD("Customer No. Item Service"), Code = FIELD("Cust. Ship-to Code Item Serv.")));
            Editable = false;
        }
        field(50114; "Cust. Ship-to Address Item Serv."; text[100])
        {
            Caption = 'Customer Ship-to Address Item service', comment = 'ESP="Direccion Cliente envío Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address".Address WHERE("Customer No." = FIELD("Customer No. Item Service"), Code = FIELD("Cust. Ship-to Code Item Serv.")));
            Editable = false;
        }
        field(50115; "Cust. Ship-to Addres2 Item Serv."; text[50])
        {
            Caption = 'Customer Ship-to Address 2 Item service', comment = 'ESP="Direccion 2 Cliente envío Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address"."Address 2" WHERE("Customer No." = FIELD("Customer No. Item Service"), Code = FIELD("Cust. Ship-to Code Item Serv.")));
            Editable = false;
        }
        field(50116; "Cust. Ship-to PC Item Serv."; text[100])
        {
            Caption = 'Customer Ship-to P.C. Item service', comment = 'ESP="Cód. postal Cliente envío Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address"."Post Code" WHERE("Customer No." = FIELD("Customer No. Item Service"), Code = FIELD("Cust. Ship-to Code Item Serv.")));
            Editable = false;
        }
        field(50117; "Cust. Ship-to City Item Serv."; text[30])
        {
            Caption = 'Customer Ship-to Name Item service', comment = 'ESP="Población Cliente envío Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address".City WHERE("Customer No." = FIELD("Customer No. Item Service"), Code = FIELD("Cust. Ship-to Code Item Serv.")));
            Editable = false;
        }
        field(50118; "Cust. Ship-to County Item Serv."; text[30])
        {
            Caption = 'Customer Ship-to County Item service', comment = 'ESP="Provincia Cliente envío Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address".County WHERE("Customer No." = FIELD("Customer No. Item Service"), Code = FIELD("Cust. Ship-to Code Item Serv.")));
            Editable = false;
        }
        field(50119; "Cust. Ship-to Country Item Serv."; code[10])
        {
            Caption = 'Customer Ship-to Country Item service', comment = 'ESP="Páis Cliente envío Prod. servicio"';
            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address"."Country/Region Code" WHERE("Customer No." = FIELD("Customer No. Item Service"), Code = FIELD("Cust. Ship-to Code Item Serv.")));
            Editable = false;
        }
        field(50215; "Family Code"; code[20])
        {
            Caption = 'SubCategory Code', comment = 'ESP="Cód. Subcategoria"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Purch. Family" where("No." = field("Item No.")));
        }
        field(50216; "Category Code"; code[20])
        {
            Caption = 'Category Code', comment = 'ESP="Cód. Categoria"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Purch. Category" where("No." = field("Item No.")));
        }
        field(50217; "SubCategory Code"; code[20])
        {
            Caption = 'SubCategory Code', comment = 'ESP="Cód. Subcategoria"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Purch. SubCategory" where("No." = field("Item No.")));
        }

        field(50221; "Desc. Purch. Category"; Text[100])
        {
            Caption = 'Desc. Purch. Category', comment = 'ESP="Nombre Categoria compra"';
            FieldClass = FlowField;
            CalcFormula = lookup("STH Purchase SubCategory".Description where("Purch. Familiy code" = field("Family Code"),
                "Purch. Category code" = field("Category Code"), code = field("SubCategory Code")));
            Editable = false;
        }
        field(50222; "Desc. Purch. SubCategory"; Text[100])
        {
            Caption = 'Desc. Purch. SubCategory', comment = 'ESP="Nombre SubCategoria compra"';
            FieldClass = FlowField;
            CalcFormula = lookup("STH Purchase SubCategory".Description where("Purch. Familiy code" = field("Family Code"),
                "Purch. Category code" = field("Category Code"), code = field("SubCategory Code")));
            Editable = false;
        }
    }
}