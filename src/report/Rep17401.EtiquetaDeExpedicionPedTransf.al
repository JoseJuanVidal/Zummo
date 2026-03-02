report 17401 "EtiquetaDeExpedicion PedTransf"
{
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep17401.EtiquetaDeExpedicionTransfer.rdl';
    Caption = 'Etiqueta De Expedicion (Ped. Transferencia)', Comment = 'Etiqueta De Expedicion (Ped. Transferencia)';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(CodDocumento; CodDocumento) { }
            column(RecSalesShipmentHeaderName; "Transfer Receipt Header"."Transfer-to Name")
            {

            }
            column(RecSalesShipmentHeaderAddress; "Transfer Receipt Header"."Transfer-to Address")
            {

            }
            column(RecSalesShipmentHeaderAddress2; "Transfer Receipt Header"."Transfer-to Address 2")
            {

            }
            column(RecSalesShipmentHeaderPostCode; "Transfer Receipt Header"."Transfer-to Post Code")
            {

            }
            column(RecSalesShipmentHeaderShipToCity; "Transfer Receipt Header"."Transfer-to City")
            {

            }
            column(RecSalesShipmentHeaderShipToCounty; "Transfer Receipt Header"."Transfer-to County")
            {

            }
            column(RecSalesShipmentHeaderShipToCountry; "Transfer Receipt Header"."Trsf.-to Country/Region Code")
            {

            }
            column(NumBultos_RecSalesShipmentHeader; NoOfCopies)
            {

            }
            column(Mercancias; Mercancias)
            {

            }
            //Numero de bultos
            column(NumBultos; NoOfCopies)
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Document_No_; "Transfer Receipt Header"."No.")
            {

            }
            column(RecCompany; RecCompany.Picture)
            {

            }
            //Captions
            column(Consignatario_Lbl; Consignatario_Lbl)
            {
            }
            column(Domicilio_Lbl; Domicilio_Lbl)
            {

            }
            column(Poblacion_Lbl; Poblacion_Lbl)
            {

            }
            column(Provincia_Lbl; Provincia_Lbl)
            {

            }
            column(Pais_Lbl; Pais_Lbl)
            {

            }
            column(Mercancias_Lbl; Mercancias_Lbl)
            {

            }
            column(NBultos_Lbl; NBultos_Lbl)
            {

            }
            column(Fecha_Lbl; Fecha_Lbl)
            {

            }
            column(Albaran_Lbl; Albaran_Lbl)
            {

            }
            column(de_Lbl; de_Lbl)
            {

            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(OutputNo; OutputNo) { }

                trigger OnAfterGetRecord()
                begin
                    OutputNo := OutputNo + 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies);
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;

            }
            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                RecCompany.Get();
                RecCompany.CalcFields(Picture);
                ContadorBultos := 1;
            end;

        }
    }
    requestpage
    {
        SaveValues = false;

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
                        Caption = 'Nº de Copias';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    // field(RPMercancias; Mercancias)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Mercancias';
                    //     ToolTip = 'Especifique la mercancia';
                    // }
                    // field(NumBultos; NumBultos)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Nº de Bultos';
                    //     ToolTip = 'Especifique el número de Bultos';
                    // }
                }
            }
        }

        trigger OnOpenPage()
        begin
            NoOfCopies := 1;
        end;
    }
    var
        RecCompany: Record "Company Information";
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        Mercancias: Text;
        NumBultos: Decimal;
        i: Integer;
        ContadorBultos: Decimal;
        Consignatario_Lbl: Label 'Consignatario / Consignee:', Comment = 'ESP="Consignatario / Consignee:"';
        Domicilio_Lbl: Label 'Domicilio / Address:', Comment = 'ESP="Domicilio / Address:"';
        Poblacion_Lbl: Label 'Población / City:', Comment = 'ESP="Población / City:"';
        Provincia_Lbl: Label 'Provincia / State:', Comment = 'ESP="Provincia / State:"';
        Pais_Lbl: Label 'País / Country:', Comment = 'ESP="País / Country:"';
        Mercancias_Lbl: Label 'Mercancias / Goods:', Comment = 'ESP="Mercancias / Goods:"';
        NBultos_Lbl: Label 'Nº Bultos / Bulks:', Comment = 'ESP="Nº Bultos / Bulks:"';
        de_Lbl: Label ' de ', Comment = 'ESP=" de "';
        Fecha_Lbl: Label 'Fecha / Date:', Comment = 'ESP="Fecha / Date:"';
        Albaran_Lbl: Label 'Albarán / Delivery note:', Comment = 'ESP="Albarán / Delivery note:"';
        CodDocumento: Label 'FO.04_C7.03_V04';

}