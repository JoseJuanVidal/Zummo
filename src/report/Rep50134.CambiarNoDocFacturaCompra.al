report 50134 "CambiarNoDocFacturaCompra"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/CambiarNoDocFacturaCompra.rdlc';
    Permissions = TableData "G/L Entry" = rm,
                  TableData "Cust. Ledger Entry" = rm,
                  tabledata "Vendor Ledger Entry" = rm,
                  TableData "G/L Register" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Invoice Line" = rm,
                  TableData "Purch. Inv. Header" = rm,
                  TableData "Purch. Inv. Line" = rm,
                  TableData "VAT Entry" = rm,
                  TableData "Detailed Cust. Ledg. Entry" = rm,
                  TableData "Detailed Vendor Ledg. Entry" = rm,
                  TableData "Cartera Doc." = rm,
                  tabledata "Cost Entry" = rm;

    dataset
    {
        dataitem(DataItem1000000000; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                RecCabFactura.GET(NoDoc);

                RecCabFactura2.INIT;
                RecCabFactura2.TRANSFERFIELDS(RecCabFactura);
                RecCabFactura2."No." := NuevoNumeroDoc;
                RecCabFactura2.INSERT;

                RecLinFactura.RESET;
                RecLinFactura.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecLinFactura.FINDSET THEN
                    REPEAT
                        RecLinFactura2.INIT;
                        RecLinFactura2.TRANSFERFIELDS(RecLinFactura);
                        RecLinFactura2."Document No." := RecCabFactura2."No.";
                        RecLinFactura2.INSERT;
                        RecLinFactura2.GET(RecLinFactura."Document No.", RecLinFactura."Line No.");
                        RecLinFactura2.DELETE;
                    UNTIL RecLinFactura.NEXT = 0;

                RecMovContabilidad.RESET;
                 RecMovContabilidad.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecMovContabilidad.FINDSET THEN BEGIN
                    REPEAT
                        RecMovContabilidad2.GET(RecMovContabilidad."Entry No.");
                        RecMovContabilidad2."Document No." := RecCabFactura2."No.";
                        RecMovContabilidad2.MODIFY;

                    UNTIL RecMovContabilidad.NEXT = 0;
                END;

                RecMovCliente.RESET;
                RecMovCliente.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                RecMovCliente.SETRANGE("Document No.", RecCabFactura."No.");
                 IF RecMovCliente.FINDSET THEN
                    REPEAT
                        RecMovCliente2.GET(RecMovCliente."Entry No.");
                        RecMovCliente2."Document No." := RecCabFactura2."No.";
                        RecMovCliente2.MODIFY;
                    UNTIL RecMovCliente.NEXT = 0;

                RecMovIVA.RESET;
                RecMovIVA.SETCURRENTKEY("Document No.", "Posting Date");
                RecMovIVA.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecMovIVA.FINDSET THEN
                    REPEAT
                        RecMovIVA2.GET(RecMovIVA."Entry No.");
                        RecMovIVA2."Document No." := RecCabFactura2."No.";
                        RecMovIVA2.MODIFY;
                    UNTIL RecMovIVA.NEXT = 0;

                RecMovClienteDet.RESET;
                RecMovClienteDet.SETCURRENTKEY("Document No.", "Document Type", "Posting Date");
                RecMovClienteDet.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecMovClienteDet.FINDSET THEN
                    REPEAT
                        RecMovClienteDet2.GET(RecMovClienteDet."Entry No.");
                        RecMovClienteDet2."Document No." := RecCabFactura2."No.";
                        RecMovClienteDet2.MODIFY;
                    UNTIL RecMovClienteDet.NEXT = 0;

                RecCarteraDoc.RESET;
                RecCarteraDoc.SETCURRENTKEY(Type, "Document No.");
                RecCarteraDoc.SETRANGE(Type, RecCarteraDoc.Type::Payable);
                RecCarteraDoc.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecCarteraDoc.FINDSET THEN
                    REPEAT
                        RecCarteraDoc2.GET(RecCarteraDoc.Type, RecCarteraDoc."Entry No.");
                        RecCarteraDoc2."Document No." := RecCabFactura2."No.";
                        RecCarteraDoc2.MODIFY;
                    UNTIL RecCarteraDoc.NEXT = 0;


                MovCoste.RESET;
                MovCoste.SETCURRENTKEY("Document No.", "Posting Date");
                MovCoste.SETRANGE("Document No.", RecCabFactura."No.");
                IF MovCoste.FINDSET THEN
                    REPEAT
                        MovCoste2.GET(MovCoste."Entry No.");
                        MovCoste2."Document No." := RecCabFactura2."No.";
                        MovCoste2.MODIFY;
                    UNTIL MovCoste.NEXT = 0;

                RecCabFactura.DELETE;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    Caption = 'Opciones';
                    field("No. Factura original"; NoDoc)
                    {
                        TableRelation = "Purch. Inv. Header"."No.";
                    }
                    field("Nuevo número "; NuevoNumeroDoc)
                    {
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        RecCabFactura: Record "Purch. Inv. Header";
        RecCabFactura2: Record "Purch. Inv. Header";
        RecLinFactura: Record "Purch. Inv. Line";
        RecLinFactura2: Record "Purch. Inv. Line";
        RecMovContabilidad: Record "G/L Entry";
        RecMovContabilidad2: Record "G/L Entry";
        RecRegistro: Record "G/L Register";
        RecMovCliente: Record "Vendor Ledger Entry";
        RecMovCliente2: Record "Vendor Ledger Entry";
        RecMovIVA: Record "VAT Entry";
        RecMovIVA2: Record "VAT Entry";
        RecMovClienteDet: Record "Detailed Vendor Ledg. Entry";
        RecMovClienteDet2: Record "Detailed Vendor Ledg. Entry";
        RecCarteraDoc: Record "Cartera Doc.";
        RecCarteraDoc2: Record "Cartera Doc.";
        Fecha: Date;
        MovCoste: Record "Cost Entry";
        MovCoste2: Record "Cost Entry";
        NoDoc: Code[20];
        NuevoNumeroDoc: Code[20];
}

