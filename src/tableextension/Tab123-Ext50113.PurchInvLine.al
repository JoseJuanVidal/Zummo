tableextension 50113 "PurchInvLine" extends "Purch. Inv. Line"  //123
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
        field(50100; "Process No."; Code[20])
        {
            Caption = 'Process No.', Comment = 'ESP="Cód. proceso"';
            DataClassification = CustomerContent;
        }
    }
}