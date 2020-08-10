report 50107 "EtiquetaDeExpedicion"
{
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50107.EtiquetaDeExpedicion.rdl';
    Caption = 'Etiqueta De Expedicion', Comment = 'Etiqueta De Expedicion';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") where("Entry Type" = const(Sale));
            RequestFilterFields = "Document No.";


            column(RecSalesShipmentHeaderName; RecSalesShipmentHeader."Ship-to Name")
            {

            }
            column(RecSalesShipmentHeaderAddress; RecSalesShipmentHeader."Ship-to Address")
            {

            }
            column(RecSalesShipmentHeaderAddress2; RecSalesShipmentHeader."Ship-to Address 2")
            {

            }
            column(RecSalesShipmentHeaderPostCode; RecSalesShipmentHeader."Ship-to Post Code")
            {

            }
            column(RecSalesShipmentHeaderShipToCity; RecSalesShipmentHeader."Ship-to City")
            {

            }
            column(RecSalesShipmentHeaderShipToCounty; RecSalesShipmentHeader."Ship-to County")
            {

            }
            column(RecSalesShipmentHeaderShipToCountry; RecSalesShipmentHeader."Ship-to Country/Region Code")
            {

            }
            column(NumBultos_RecSalesShipmentHeader; RecSalesShipmentHeader.NumBultos_btc)
            {

            }
            column(Mercancias; Mercancias)
            {

            }
            //Numero de bultos
            column(NumBultos; RecSalesShipmentHeader.NumBultos_btc)
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
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(OutputNo; OutputNo)
                    {
                    }
                    dataitem(NumeroBultos; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(Number; Number) { }
                        column(RecTempBultos; RecTempBultos.Contador) { }
                        trigger OnPreDataItem()
                        begin
                            RecTempBultos.Reset();
                            RecTempBultos.SetRange(Noproducto, "Item Ledger Entry"."Document No.");
                            SetRange(Number, 1, RecTempBultos.Count());
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                RecTempBultos.FindSet()
                            else
                                RecTempBultos.Next();
                        end;
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
            trigger OnAfterGetRecord()
            begin

                if not RecSalesShipmentHeader.Get("Document No.") then
                    Clear(RecSalesShipmentHeader);
                //Rellenamos temporal para agrupar por bultos

                for i := 1 to RecSalesShipmentHeader.NumBultos_btc do begin
                    RecTempBultos.Init();
                    RecTempBultos.NoMov := ContadorBultos;
                    RecTempBultos.Contador := i;
                    RecTempBultos.Noproducto := "Document No.";
                    RecTempBultos.Insert();
                    ContadorBultos += 1;
                end;

            end;

            trigger OnPreDataItem()
            begin
                RecCompany.Get();
                RecCompany.CalcFields(Picture);
                clear(RecTempBultos);
                RecTempBultos.DeleteAll();
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
                    field(RPMercancias; Mercancias)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mercancias';
                        ToolTip = 'Especifique la mercancia';
                    }
                    field(NumBultos; NumBultos)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Nº de Bultos';
                        ToolTip = 'Especifique el número de Bultos';
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
        RecTempBultos: Record MemEstadistica_btc temporary;
        RecSalesShipmentHeader: Record "Sales Shipment Header";
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


}