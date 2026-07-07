pageextension 50115 "StandardCustomerSalesCodes" extends "Standard Customer Sales Codes"
{
    layout
    {
        addafter("Customer No.")
        {
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Valid To date")
        {
            field(Active; Active)
            {
                ApplicationArea = all;
            }
            field(Periodicidad_btc; Periodicidad_btc)
            {
                ApplicationArea = All;
            }

            field(UltimaFechaFactura_btc; UltimaFechaFactura_btc)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(ProximaFechaFactura_btc; ProximaFechaFactura_btc)
            {
                ApplicationArea = All;
            }
            field("Amount Lines"; "Amount Lines")
            {
                ApplicationArea = all;
            }
            field("Contract Services"; "Contract Services")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(ExportExcel)
            {
                ApplicationArea = all;
                Caption = 'Export Excel', comment = 'ESP="Export Excel"';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    StandardCustomerSales: Record "Standard Customer Sales Code";
                    lblConfirm: Label '¿Desea exportar las %1 seleccionadas?', comment = 'ESP="¿Desea exportar las %1 seleccionadas?"';
                begin
                    if not Confirm(lblConfirm, false, Rec.TableCaption) then
                        exit;
                    StandardCustomerSales.CopyFilters(Rec);
                    Rec.ExportExcel(StandardCustomerSales);
                end;

            }
        }
    }
}