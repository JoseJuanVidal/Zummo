report 50138 "EtiquetasGenericas"
{
    RDLCLayout = './src/report/Rep50138.EtiquetasGenericas.rdl';
    Caption = 'Generic Labels', comment = 'ESP="Etiquetas genéricas"';
    PreviewMode = PrintLayout;
    EnableHyperlinks = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);

            column(CodBarra; CodBarra)
            {

            }
            column(Item_No_; recTemp.NumProducto)
            {

            }
            column(RecItemDescripcion; RecItem.Description)
            {

            }
            column(Order_No_; codPedido)
            {

            }

            column(Posting_Date; recTemp.FechaRegistro)
            {

            }
            column(Document_No_; recTemp.NumAlbaran)
            {

            }
            column(RecCompany; RecCompany.Picture)
            {

            }
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
                recTemp.RESET;
                if not recTemp.FindSet() then
                    CurrReport.BREAK;

                SETRANGE(Number, 1, recTemp.COUNT);
            end;

            trigger OnAfterGetRecord()
            var
                recPurchRcptHeader: Record "Purch. Rcpt. Header";
                Vendor: Record Vendor;
            begin


                IF Number = 1 THEN
                    recTemp.FindSet()
                ELSE
                    recTemp.Next();

                if not RecCompany.Get() then
                    clear(RecCompany);

                if not RecItem.Get(recTemp.NumProducto) then
                    clear(RecItem);

                if Vendor.Get(RecItem."Vendor No.") then
                    VendorName := Vendor.Name;

                CodBarra := '*' + recTemp.NumProducto + '*';

                codPedido := recTemp.NumPedido;
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

    procedure SetData(pRec: Record LinAlbCompraBuffer temporary)
    begin
        recTemp.Reset();
        recTemp.DeleteAll();

        recTemp := pRec;
        recTemp.Insert();
    end;

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
        recTemp: Record LinAlbCompraBuffer temporary;
        VendorName: Text;
}