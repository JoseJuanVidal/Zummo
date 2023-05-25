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
            field(PaisClienteProv; PaisClienteProv)
            {
                ApplicationArea = all;
                Caption = 'País', comment = 'ESP="País"';
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
            action("CambiarDelectDimensiones")
            {
                ApplicationArea = All;
                Image = ChangeDimensions;
                Caption = 'Change Dimensions Multiple', comment = 'ESP="Cambiar Dimensiones Multiple"';
                ToolTip = 'Change the dimensions of the selected entries', comment = 'ESP="Permite cambiar la dimensione de los movimientos seleccionados"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    pageDim: Page "Change Dim CECO";
                    GLEntry: Record "G/L Entry";
                    recDimTemp: Record "Dimension Set Entry" temporary;
                    funciones: Codeunit Funciones;
                    intDimSetId: Integer;
                    dimGlobal1: Code[20];
                    dimGlobal2: Code[20];
                    Text000: Label '¿Desea cambiar lo/s %1 movimientos a CECO %2 y Proyecto %3?', comment = 'ESP="¿Desea cambiar lo/s %1 movimientos a CECO %2 y Proyecto %3?"';
                begin
                    CurrPage.SetSelectionFilter(GLEntry);
                    if GLEntry.Count = 0 then
                        exit;
                    Clear(pageDim);
                    pageDim.LookupMode(true);

                    if pageDim.RunModal() = Action::LookupOK then begin
                        dimGlobal1 := pageDim.GetCECOCOde();
                        dimGlobal2 := pageDim.GetDim2COde();
                        if Confirm(Text000, false, GLEntry.Count, dimGlobal1, dimGlobal2) then begin
                            Funciones.ChangeDimensionCECOGLEntries(GLEntry, dimGlobal1, dimGlobal2);
                            Message('Proceso finalizado');
                        end;
                    end;
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
        if Vendor.get("Source No.") then begin
            NombreClienteProv := Vendor.Name;
            PaisClienteProv := Vendor."Country/Region Code";
        end ELSE begin
            if Customer.get("Source No.") then begin
                NombreClienteProv := Customer.Name;
                PaisClienteProv := Customer."Country/Region Code";
            end;
        end;
    end;


    var
        NombreClienteProv: code[100];
        PaisClienteProv: code[10];
}