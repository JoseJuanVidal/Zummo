report 50110 "EtiquetaEmbalaje"
{
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50110.EtiquetaEmbalaje.rdlc';
    Caption = 'Etiqueta Embalaje', Comment = 'Etiqueta Embalaje';
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
            column(Serial_No_; "Serial No.")
            {

            }
            column(Order_No_; "Order No.")
            {

            }
            column(Item_No_; "Item No.")
            {

            }

            column(RecItemDescripcion; RecItem.Description)
            {

            }

            column(Document_No_; "Document No.")
            {

            }
            column(RecCompany; RecCompany.Picture)
            {

            }
            //Captions

            column(NSerie_Lbl; NSerie_Lbl)
            {

            }
            column(Origen_Lbl; Origen_Lbl)
            {

            }
            column(Articulo_Lbl; Articulo_Lbl)
            {

            }
            column(Descripcion_Lbl; Descripcion_Lbl)
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

                CodBarra := '*' + "Serial No." + '*';
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

        trigger OnOpenPage()
        begin
            NoOfCopies := 0;
        end;
    }
    var
        RecItem: Record Item;
        RecCompany: Record "Company Information";
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        CodBarra: text;
        NSerie_Lbl: Label 'Serial No: ', Comment = 'ESP="Serial No:"';
        Origen_Lbl: Label 'Prod. Cod: ', Comment = 'ESP="Prod. Cod: "';
        Articulo_Lbl: Label 'Article: ', Comment = 'ESP="Article: "';
        Descripcion_Lbl: Label 'Description: ', Comment = 'ESP="Description: "';


}