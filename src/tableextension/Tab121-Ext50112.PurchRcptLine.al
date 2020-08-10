tableextension 50112 "PurchRcptLine" extends "Purch. Rcpt. Line"  //121
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

        field(50004; CodAlbProveedor_btc; Code[35])
        {
            Editable = false;
            Caption = 'Vendor Shipment No.', comment = 'ESP="Nº Albarán Proveedor"';
            FieldClass = FlowField;
            CalcFormula = lookup ("Purch. Rcpt. Header"."Vendor Shipment No." where("No." = field("Document No.")));
        }
        field(50003; "Nombre Proveedor"; Text[100])
        {
            Caption = 'Nombre Proveedor', Comment = 'ESP="Nombre Proveedor"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Purch. Rcpt. Header"."Buy-from Vendor Name" WHERE
            ("No." = FIELD("Document No.")
            ));
        }
        field(50099; "Fecha Vencimiento"; Date)
        {
            Caption = 'Fecha Vencimiento', Comment = 'ESP="Fecha Vencimiento"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Purch. Rcpt. Header"."Due Date" WHERE
            ("No." = FIELD("Document No.")
            ));
        }
    }
}