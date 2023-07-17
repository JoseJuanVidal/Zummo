tableextension 50114 "PurchCrMemoLine" extends "Purch. Cr. Memo Line"  //125
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
            Caption = 'Rejected Text', Comment = 'ESP="Motivo Rechazo"';
            Description = 'Bitec';
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
        field(50101; "Contracts No."; code[20])
        {
            Caption = 'Contracts No.', comment = 'ESP="Nº Contrato"';
            DataClassification = CustomerContent;
            TableRelation = "ZM Contracts/Supplies Header";
            Editable = false;
        }
        field(50102; "Contracts Line No."; Integer)
        {
            Caption = 'Contracts Line No.', comment = 'ESP="Nº Línea Contrato"';
            DataClassification = CustomerContent;
            TableRelation = "ZM Contracts/Supplies Lines"."Line No." where("Document No." = field("Document No."));
            Editable = false;
        }
    }
}