tableextension 50001 "AssemblyLine" extends "Assembly Line" //901
{//14
    // Ordenación almacenes

    fields
    {
        field(50001; "Document Type_btc"; Option)
        {
            OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            OptionCaption = '"Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order"', Comment = 'ESP="Oferta,Pedido,Factura,Abono,Pedido abierto,Devolución"';

            Editable = false;
            Caption = 'Tipo documento Ventas', comment = 'ESP="Tipo documento Ventas"';
            FieldClass = FlowField;
            CalcFormula = lookup("Assemble-to-Order Link"."Document Type" where
                (
                    "Assembly Document Type" = field("Document Type"),
                    "Assembly Document No." = field("Document No.")
                ));
            trigger OnLookup()
            var
                SalesHeader: Record "Sales Header";
                PSalesLine: Page "Sales List";
            begin
                SalesHeader.reset;
                SalesHeader.SetRange("Document Type", rec."Document Type_btc");
                SalesHeader.SetRange("No.", Rec."Document No_btc");
                PSalesLine.SetTableView(SalesHeader);
                PSalesLine.Run();
            end;
        }
        field(50002; "Document No_btc"; Code[20])
        {
            Editable = false;
            Caption = 'Documento Ventas', comment = 'ESP="Documento Ventas"';
            FieldClass = FlowField;
            CalcFormula = lookup("Assemble-to-Order Link"."Document No." where
                (
                    "Assembly Document Type" = field("Document Type"),
                    "Assembly Document No." = field("Document No.")
                ));
            trigger OnLookup()
            var
                SalesHeader: Record "Sales Header";
                PSalesLine: Page "Sales List";
            begin
                SalesHeader.reset;
                SalesHeader.SetRange("Document Type", rec."Document Type_btc");
                ;
                SalesHeader.SetRange("No.", Rec."Document No_btc");
                PSalesLine.SetTableView(SalesHeader);
                PSalesLine.Run();
            end;
        }
        field(50003; "Document Line No_btc"; Integer)
        {
            Editable = false;
            Caption = 'Linea Ventas', comment = 'ESP="Linea Ventas"';
            FieldClass = FlowField;
            CalcFormula = lookup("Assemble-to-Order Link"."Document Line No." where
                (
                    "Assembly Document Type" = field("Document Type"),
                    "Assembly Document No." = field("Document No.")
                ));
            trigger OnLookup()
            var
                SalesHeader: Record "Sales Header";
                PSalesLine: Page "Sales List";
            begin
                SalesHeader.reset;
                SalesHeader.SetRange("Document Type", rec."Document Type_btc");
                SalesHeader.SetRange("No.", Rec."Document No_btc");
                PSalesLine.SetTableView(SalesHeader);
                PSalesLine.Run();
            end;
        }
        field(50004; "Fecha Fin Oferta_btc"; Date)
        {
            Editable = false;
            Caption = 'Fecha Fin Oferta', comment = 'ESP="Fecha Fin Oferta"';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Quote Valid Until Date" where
                (
                    "Document Type" = field("Document Type_btc"),
                    "No." = field("Document No_btc")
                ));
        }
        field(50005; QuoteNoSalesOrder; code[20])
        {
            Caption = 'Quote No.', comment = 'ESP="Nº de oferta"';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Quote No." where("Document Type" = field("Document Type_btc"),
                    "No." = field("Document No_btc")));
            Editable = false;

        }
        field(50006; "No contemplar planificacion"; Boolean)
        {
            Caption = 'No contemplar planificacion';
            DataClassification = CustomerContent;
        }
        field(50020; ComentarioInterno_btc; text[250])
        {
            Caption = 'Internal Comment', comment = 'ESP="Comentario interno"';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header".ComentarioInterno_btc where("Document Type" = field("Document Type_btc"), "No." = field("Document No_btc")));
            editable = false;
        }
    }
}