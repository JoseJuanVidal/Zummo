report 50108 "EtiquetaMateriaPrima"
{
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50108.EtiquetaMateriaPrima.rdl';
    Caption = 'Etiqueta Materia Prima', Comment = 'Etiqueta Materia Prima';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Document No.";
            column(codDocumento; codDocumento) { }
            column(CodBarra; CodBarra)
            {

            }
            column(Item_No_; "Item No.")
            {

            }
            column(RecItemDescripcion; RecItem.Description)
            {

            }
            column(Order_No_; codPedido)
            {

            }

            column(Posting_Date; "Posting Date")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(RecCompany; RecCompany.Picture)
            {

            }
            //Captions
            column(Codigo_Lbl; Codigo_Lbl)
            {
            }

            column(NPedido_Lbl; NPedido_Lbl)
            {

            }
            column(Fecha_Lbl; Fecha_Lbl)
            {

            }
            column(VendorName; VendorName)
            {
            }

            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(OutputNo; OutputNo)
                    {
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    OutputNo := OutputNo + 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 0;

                end;
            }
            trigger OnPreDataItem()
            begin
            end;

            trigger OnAfterGetRecord()
            var
                recPurchRcptHeader: Record "Purch. Rcpt. Header";
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Item Ledger Entry"."Source No.") then
                    VendorName := Vendor.Name;

                if not RecCompany.Get() then
                    clear(RecCompany);

                if not RecItem.Get("Item No.") then
                    clear(RecItem);

                CodBarra := '*' + "Item No." + '*';

                codPedido := '';

                if codPedido = '' then
                    // si no imprimimos el numero de albaran porque es subcontratación
                    codPedido := GetPedidoPartida("Item Ledger Entry");
            end;

        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(RPNoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }

                }
            }
        }
    }
    var
        RecItem: Record Item;
        RecCompany: Record "Company Information";
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        CodBarra: text;
        Codigo_Lbl: Label 'CÓDIGO: ', Comment = 'ESP="´CÓDIGO: "';
        NPedido_Lbl: Label 'Nº PEDIDO:', Comment = 'ESP="Nº PEDIDO: "';
        Fecha_Lbl: Label 'FECHA: ', Comment = 'ESP="FECHA: "';
        codPedido: Code[20];
        codDocumento: Label 'FO.01_C7.03_V04';
        VendorName: Text;

    local procedure GetPedidoPartida(ItemLedgerEntry: Record "Item Ledger Entry"): code[20]  // 50604
    var
        RecRef: RecordRef;
        FRef: FieldRef;
    begin
        RecRef.GetTable(ItemLedgerEntry);
        if RecRef.FieldExist(50604) then begin  // partida
            FRef := RecRef.Field(50604);
            Exit(FRef.Value);
        end
    end;

}