pageextension 50011 "ItemLedgerEntries" extends "Item Ledger Entries"
{
    //Cantidad pendiente en mov producto

    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; "External Document No.") { }
        }
        addafter("Reserved Quantity")
        {
            field(CantDisp; cantidadDisponible)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Available Quantity', comment = 'ESP="Cantidad disponible"';
                DecimalPlaces = 0 : 5;
            }
            field("Item Category Code"; "Item Category Code")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field(Desc2_btc; Desc2_btc)
            {
                ApplicationArea = All;
            }

            field(CodCliente_btc; CodCliente_btc)
            {
                ApplicationArea = All;
            }

            field(NombreCliente_btc; NombreCliente_btc)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst(Reporting)
        {
            action("Imprimir Etiqueta")
            {
                ApplicationArea = all;
                Caption = 'Imprimir Etiqueta', comment = 'ESP="Imprimir Etiqueta"';
                ToolTip = 'Imprimir etiqueta',
                    comment = 'ESP="Imprimir etiqueta"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = PrintReport;

                trigger OnAction()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    Selection: Integer;
                begin
                    Selection := STRMENU('1.-Expedición,2.-Embalaje,3.-Materia Prima,4.-Prod.Terminado', 1);
                    // Message(Format(Selection));
                    ItemLedgerEntry.Reset();
                    IF Selection > 0 THEN begin

                        ItemLedgerEntry.SetRange("Entry No.", Rec."Entry No.");
                        if ItemLedgerEntry.FindFirst() then
                            case Selection of
                                1:
                                    Report.Run(Report::EtiquetaDeExpedicion, false, false, ItemLedgerEntry);
                                2:
                                    Report.Run(Report::EtiquetaEmbalaje, false, false, ItemLedgerEntry);
                                3:
                                    Report.Run(Report::EtiquetaMateriaPrima, false, false, ItemLedgerEntry);
                                4:
                                    Report.Run(Report::EtiquetaProductoTerminado, false, false, ItemLedgerEntry);

                            end;


                    end;
                end;

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Reserved Quantity");
        cantidadDisponible := "Remaining Quantity" - "Reserved Quantity";
    end;

    var
        cantidadDisponible: Decimal;
}