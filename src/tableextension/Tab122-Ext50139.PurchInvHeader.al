tableextension 50139 "PurchInvHeader" extends "Purch. Inv. Header"  //122
{
    fields
    {
        field(50030; "Job No."; code[20])
        {
            Caption = 'Job No.', Comment = 'ESP="Nº Proyecto"';
            TableRelation = Job;
        }
        field(50032; "Job Task No."; code[20])
        {
            Caption = 'Job Task No', Comment = 'ESP="Nº Tarea Proyecto"';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(50033; "Job Preview Mode"; Boolean)
        {
            Caption = 'Job Preview Mode', Comment = 'ESP="Registro Preview mode"';
        }

        field(50035; "Job Category"; code[20])
        {
            Caption = 'Job Category', Comment = 'ESP="Categoría proyecto"';
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(tabla), TipoTabla = const("Job Clasification"));
        }
        //Guardar Nº asiento y Nº documento
        field(50100; NumAsiento_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction No.', comment = 'ESP="Nº asiento"';
        }
        field(50120; "Purch. Request less 200"; code[20])
        {
            Caption = 'Purch. Request less 200', Comment = 'ESP="Compra menor 200"';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Requests less 200";
        }
        //+  NORMATIVA MEDIO AMBIENTAL
        Field(50200; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic (kg)', comment = 'ESP="Plástico (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50201; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Recycled (kg)', comment = 'ESP="Plástico reciclado (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50202; "Plastic Date Declaration"; Date)
        {
            Caption = 'Plastic Date Declaration', comment = 'ESP="Fecha Declaración plástico"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //-  NORMATIVA MEDIO AMBIENTAL
        field(50400; "DIVISION"; Code[20])
        {
            Editable = false;
            Caption = 'DIVISION', comment = 'ESP="DIVISION"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = filter('DIVISION')));
        }
        field(50401; "Business Unit"; Code[20])
        {
            Editable = false;
            Caption = 'Business Unit', comment = 'ESP="Business Unit"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = filter('BUSUNIT')));
        }

    }
    keys
    {
        key(Less200; "Purch. Request less 200")
        { }
    }
}