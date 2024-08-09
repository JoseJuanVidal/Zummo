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
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Customer Country/Region Code"; "Customer Country/Region Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Cust. Ledger Currency Factor"; "Cust. Ledger Currency Factor")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Amount (Currency)"; AmountCurrency)
            {
                Caption = 'Amount (Currency)', comment = 'ESP="Importe (Divisa)"';
                ApplicationArea = all;
                Visible = false;
            }
            field("Detalle"; "Global Dimension 3 Code")
            {
                ApplicationArea = ALL;
            }
            field("Partida"; "Global Dimension 8 Code")
            {
                ApplicationArea = ALL;
            }
            field("Purch. Request less 200"; "Purch. Request less 200")
            {
                ApplicationArea = all;
                Visible = false;
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
                    GLSetup.Get();
                    if CheckGLSetupPostingDate(Rec."Posting Date") then
                        Error(lblGLSetupTest, Rec."Posting Date");
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
                begin
                    ChangeMultiplesDimensiones();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        GLSetup.Get();
    end;

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        AmountCurrency := Rec.Amount * rec."Cust. Ledger Currency Factor";
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
        GLSetup: Record "General Ledger Setup";
        NombreClienteProv: code[100];
        PaisClienteProv: code[10];
        AmountCurrency: Decimal;
        lblGLSetupTest: Label '%1 no está dentro del intervalo de fechas de registro permitidas.', comment = 'ESP="%1 no está dentro del intervalo de fechas de registro permitidas."';

    local procedure ChangeMultiplesDimensiones()
    var
        pageDim: Page "Change Dim CECO";
        GLEntry: Record "G/L Entry";
        recDimTemp: Record "Dimension Set Entry" temporary;
        funciones: Codeunit Funciones;
        intDimSetId: Integer;
        dimGlobal1: Code[20];
        dimGlobal2: Code[20];
        Text000: Label '¿Desea cambiar lo/s %1 movimientos a CECO %2 y Proyecto %3?', comment = 'ESP="¿Desea cambiar lo/s %1 movimientos a CECO %2 y Proyecto %3?"';
        lblConfirm: Label 'Ha seleccionado %1 movimientos.\¿Esta seguro de continuar?', comment = 'ESP="Ha seleccionado %1 movimientos.\¿Esta seguro de continuar?"';
    begin
        CurrPage.SetSelectionFilter(GLEntry);
        if GLEntry.Count = 0 then
            exit;
        // comprobamos que se quieren cambiar movimientos fuera de periodo
        GLEntry.SetCurrentKey("Posting Date");
        if GLEntry.FindFirst() then
            if CheckGLSetupPostingDate(GLEntry."Posting Date") then
                Error(lblGLSetupTest, Rec."Posting Date");
        if GLEntry.FindLast() then
            if CheckGLSetupPostingDate(GLEntry."Posting Date") then
                Error(lblGLSetupTest, Rec."Posting Date");
        GLEntry.SetCurrentKey("Entry No.");

        Clear(pageDim);
        pageDim.LookupMode(true);
        if pageDim.RunModal() = Action::LookupOK then begin
            dimGlobal1 := pageDim.GetCECOCOde();
            dimGlobal2 := pageDim.GetDim2COde();
            if Confirm(Text000, false, GLEntry.Count, dimGlobal1, dimGlobal2) then begin
                if GLEntry.Count > 50 then
                    if not Confirm(lblConfirm, false, GLEntry.Count) then
                        exit;
                Funciones.ChangeDimensionCECOGLEntries(GLEntry, dimGlobal1, dimGlobal2);
                Message('Proceso finalizado');
            end;
        end;
    end;

    local procedure CheckGLSetupPostingDate(PostingDate: Date): Boolean
    var
        myInt: Integer;
    begin
        GLSetup.Get();
        if (PostingDate < GLSetup."Allow Posting From") OR (PostingDate > GLSetup."Allow Posting To") then
            exit(true);
    end;
}