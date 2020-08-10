report 50109 "EtiquetaProductoTerminado"
{
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50109.EtiquetaProductoTerminado.rdlc';
    Caption = 'Etiqueta Producto Terminado', Comment = 'Etiqueta Producto Terminado';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Document No.";

            column(CodBarra; CodBarra)
            {

            }
            column(Item_No_; "Item No.")
            {

            }
            column(RecItemDescripcion; RecItem.Description)
            {

            }
            column(Order_No_; "Order No.")
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
            begin

                if not RecCompany.Get() then
                    clear(RecCompany);

                if not RecItem.Get("Item No.") then
                    clear(RecItem);

                CodBarra := '*' + "Item No." + '*';
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


}