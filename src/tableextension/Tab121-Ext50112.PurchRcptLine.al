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
            CalcFormula = lookup("Purch. Rcpt. Header"."Vendor Shipment No." where("No." = field("Document No.")));
        }
        field(50003; "Nombre Proveedor"; Text[100])
        {
            Caption = 'Nombre Proveedor', Comment = 'ESP="Nombre Proveedor"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Buy-from Vendor Name" WHERE
            ("No." = FIELD("Document No.")
            ));
        }
        field(50099; "Fecha Vencimiento"; Date)
        {
            Caption = 'Fecha Vencimiento', Comment = 'ESP="Fecha Vencimiento"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Due Date" WHERE
            ("No." = FIELD("Document No.")
            ));
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
        field(50110; "Global Dimension 3 Code"; Code[20])
        {
            Editable = false;
            Caption = 'Detalle', comment = 'ESP="Detalle"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = filter('DETALLE')));
        }
        field(50111; "Global Dimension 8 Code"; Code[20])
        {
            Editable = false;
            Caption = 'Partida', comment = 'ESP="Partida"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = filter('PARTIDA')));
        }

        field(50157; BaseImponibleLinea; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base Amount Line', comment = 'ESP="Importe Base IVA"';
            editable = false;
        }
        field(50158; TotalImponibleLinea; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount Line', comment = 'ESP="Importe Total IVA"';
            editable = false;
        }
    }
}