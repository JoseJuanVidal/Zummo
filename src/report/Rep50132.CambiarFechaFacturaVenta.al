report 50132 "CambiarFechaFacturaVenta"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/CambiarFechaFacturaVenta.rdlc';
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
                Fecha := FechaRegNueva;
                RecLinFactura.RESET;
                RecLinFactura.SETRANGE("Document No.", RecCabFactura."No.");
                RecLinFactura.SETFILTER(Type, '<>%1', RecLinFactura.Type::" ");
                IF RecLinFactura.FINDSET THEN
                    REPEAT
                        RecLinFactura."Posting Date" := Fecha;
                        RecLinFactura.MODIFY;
                    UNTIL RecLinFactura.NEXT = 0;

                RecMovContabilidad.RESET;
                RecMovContabilidad.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecMovContabilidad.FINDSET THEN BEGIN
                    REPEAT
                        RecRegistro.GET(RecMovContabilidad."Transaction No.");
                        RecRegistro."Posting Date" := Fecha;
                        RecRegistro.MODIFY;
                        RecMovContabilidad."Posting Date" := Fecha;
                        RecMovContabilidad."Document Date" := Fecha;
                        RecMovContabilidad.MODIFY;
                    UNTIL RecMovContabilidad.NEXT = 0;
                END;

                RecMovCliente.RESET;
                RecMovCliente.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                RecMovCliente.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecMovCliente.FINDSET THEN
                    REPEAT
                        RecMovCliente."Posting Date" := Fecha;
                        RecMovCliente."Document Date" := Fecha;
                        IF RecMovCliente."Document Type" = RecMovCliente."Document Type"::Invoice THEN BEGIN
                            RecMovCliente."Pmt. Discount Date" := Fecha;
                            RecMovCliente."Pmt. Disc. Tolerance Date" := Fecha;
                        END;
                        RecMovCliente.MODIFY;
                    UNTIL RecMovCliente.NEXT = 0;

                RecMovIVA.RESET;
                RecMovIVA.SETCURRENTKEY("Document No.", "Posting Date");
                RecMovIVA.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecMovIVA.FINDSET THEN
                    REPEAT
                        RecMovIVA."Posting Date" := Fecha;
                        RecMovIVA."Document Date" := Fecha;
                        RecMovIVA.MODIFY;
                    UNTIL RecMovIVA.NEXT = 0;

                RecMovClienteDet.RESET;
                RecMovClienteDet.SETCURRENTKEY("Document No.", "Document Type", "Posting Date");
                RecMovClienteDet.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecMovClienteDet.FINDSET THEN
                    REPEAT
                        RecMovClienteDet."Posting Date" := Fecha;
                        RecMovClienteDet.MODIFY;
                    UNTIL RecMovClienteDet.NEXT = 0;

                RecCarteraDoc.RESET;
                RecCarteraDoc.SETCURRENTKEY(Type, "Document No.");
                RecCarteraDoc.SETRANGE(Type, RecCarteraDoc.Type::Receivable);
                RecCarteraDoc.SETRANGE("Document No.", RecCabFactura."No.");
                IF RecCarteraDoc.FINDSET THEN
                    REPEAT
                        RecCarteraDoc."Posting Date" := Fecha;
                        RecCarteraDoc.MODIFY;
                    UNTIL RecCarteraDoc.NEXT = 0;

                RecCabFactura."Posting Date" := Fecha;
                RecCabFactura."Document Date" := Fecha;
                RecCabFactura.MODIFY;
            end;

            trigger OnPreDataItem()
            begin
                IF FechaRegNueva = 0D THEN
                    ERROR('Debe rellenar el campo "Fecha registro nueva"');
                IF NoDoc = '' THEN
                    ERROR('Debe seleccionar un número de factura.');
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
                    field("No. Factura"; NoDoc)
                    {
                        TableRelation = "Sales Invoice Header"."No.";
                    }
                    field("Nueva Fecha registro"; FechaRegNueva)
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
        RecCabFactura: Record "Sales Invoice header";
        RecLinFactura: Record "Sales Invoice Line";
        RecMovContabilidad: Record "G/L Entry";
        RecRegistro: Record "G/L Register";
        RecMovCliente: Record "Cust. Ledger Entry";
        RecMovIVA: Record "VAT Entry";
        RecMovClienteDet: Record "Detailed Cust. Ledg. Entry";
        RecCarteraDoc: Record "Cartera Doc.";
        Fecha: Date;
        NoDoc: Code[20];
        FechaRegNueva: Date;
}

