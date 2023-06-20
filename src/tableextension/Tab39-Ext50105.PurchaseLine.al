tableextension 50105 "PurchaseLine" extends "Purchase Line"  //39
{
    fields
    {
        field(50000; FechaRechazo_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Rejected Date', Comment = 'ESP="Fecha Rechazo"';
            Description = 'Bitec';
        }

        field(50001; TextoRechazo; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Rejected Text', Comment = 'ESP="Comentario"';
            Description = 'Bitec';
        }
        field(50002; PermitirMatarResto; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Nombre Proveedor"; Text[100])
        {
            Caption = 'Nombre Proveedor', Comment = 'ESP="Nombre Proveedor"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Buy-from Vendor Name" WHERE
            ("Document Type" = FIELD("Document Type"),
             "No." = FIELD("Document No.")
            ));
        }
        field(50004; "Primera Fecha Recep."; date)
        {
            Caption = 'Primera fecha Recep.', comment = 'ESP="Primera fecha Recep."';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Line"."Posting Date" where("Order No." = field("Document No."), "Order Line No." = field("Line No."), Quantity = filter(<> 0)));
        }
        field(50005; StandarCost; decimal)
        {
            Caption = 'Coste Estandar', Comment = 'ESP="Coste Estandar"';
            Description = 'Bitec';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Standard Cost" where("No." = field("No.")));
            Editable = false;
        }
        field(50050; "IdCorp_Sol"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ID Corporativo Solicitante', comment = 'ESP="ID Corporativo Solicitante"';
            Editable = false;
        }
        field(50051; "Nombre Empleado"; code[250])
        {
            Caption = 'ID Corporativo Solicitante', comment = 'ESP="ID Corporativo Solicitante"';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field(IdCorp_Sol)));
            Editable = false;
        }
        field(50100; "Process No."; Code[20])
        {
            Caption = 'Process No.', Comment = 'ESP="Cód. proceso"';
            DataClassification = CustomerContent;
        }
    }
}