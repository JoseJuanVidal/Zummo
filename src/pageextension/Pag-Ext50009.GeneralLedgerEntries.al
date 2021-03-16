pageextension 50009 "GeneralLedgerEntries" extends "General Ledger Entries"
{
    //Guardar Nº asiento y Nº documento

    layout
    {
        addafter("Entry No.")
        {
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = All;
            }

            field("IdFactAbno_btc"; IdFactAbno_btc)
            {
                ApplicationArea = All;
            }

            field("Source No."; "Source No.")
            {
                ApplicationArea = All;
            }
            field("NombreClienteProv"; NombreClienteProv)
            {
                ApplicationArea = ALL;
            }
            field("Detalle"; "Global Dimension 3 Code")
            {
                ApplicationArea = ALL;
            }
            field("Partida"; "Global Dimension 8 Code")
            {
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        addafter(Dimensions)
        {
            action("CambiarDimensiones")
            {
                ApplicationArea = All;
                Image = ChangeDimensions;
                Caption = 'Change Dimensions', comment = 'ESP="Cambiar Dimensiones"';
                ToolTip = 'Change the dimensions of the selected entry', comment = 'ESP="Permite cambiar las dimensiones del movimiento seleccionado"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    pageDim: Page CambioDimensionesMovConta;
                    recDimTemp: Record "Dimension Set Entry" temporary;
                    intDimSetId: Integer;
                    dimGlobal1: Code[20];
                    dimGlobal2: Code[20];
                begin
                    Clear(pageDim);
                    pageDim.SetDatos("Dimension Set ID", "Entry No.");
                    pageDim.LookupMode(true);

                    if pageDim.RunModal() = Action::LookupOK then
                        CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        NombreClienteProv := '';
        if Vendor.get("Source No.") then
            NombreClienteProv := Vendor.Name
        ELSE

            if Customer.get("Source No.") then
                NombreClienteProv := Customer.Name;
    end;


    var
        NombreClienteProv: code[100];
}