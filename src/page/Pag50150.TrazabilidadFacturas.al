page 50150 "Trazabilidad Facturas"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Invoice Line";
    SourceTableTemporary = true;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', comment = 'ESP="General"';
                field(FilterDocumentNo; FilterDocumentNo)
                {
                    Caption = 'Filtro Nº Documento', comment = 'ESP="Filtro Nº Documento"';
                    ApplicationArea = All;

                    TableRelation = "Sales Invoice Header";
                }
                field(FilterCustomer; FilterCustomer)
                {
                    ApplicationArea = all;
                    Caption = 'Filtro Cód. Clientes', comment = 'ESP="Filtro Cód. ClientesFiltro Cód. Clientes"';

                    TableRelation = Customer;
                }
                field(FilterFecha; FilterFecha)
                {
                    ApplicationArea = all;
                    Caption = 'Filtro Fecha', comment = 'ESP="Filtro Fecha"';
                }
                field(MostrarTodos; MostrarTodos)
                {
                    ApplicationArea = all;
                    Caption = 'Mostrar Todos', comment = 'ESP="Mostrar Todos"';
                }
            }
            repeater(Lines)
            {
                Caption = 'Líneas', comment = 'ESP="Líneas"';
                Editable = false;

                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = all;
                    Caption = 'Nombre Cliente', comment = 'ESP="Nombre Cliente"';
                    Editable = false;
                    StyleExpr = StyleExr;
                }

                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field("Posting Group"; "Posting Group")
                {
                    Caption = 'Nº Serie', comment = 'ESP="Nº Serie"';
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleExr;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Realizar)
            {
                ApplicationArea = All;
                Image = Trace;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActualizarLineas(Rec);
                    if rec.FindFirst() then;
                    CurrPage.Update();
                end;
            }
            action(ExportExcel)
            {
                ApplicationArea = All;
                Image = Excel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ExportTrazabilidadFacturas;
                end;
            }

        }
    }


    trigger OnAfterGetRecord()
    begin
        StyleExr := '';
        case Rec."Attached to Line No." of
            0, 1:
                StyleExr := 'Strong'
        end;

        // Buscar clientes y poner nombre        
        CustomerName := '';
        if SalesInvoiceHeader.Get(Rec."Document No.") then
            CustomerName := SalesInvoiceHeader."Sell-to Customer Name";
    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Customer: Record Customer;
        CustomerName: text;
        FilterDocumentNo: text;
        FilterCustomer: text;
        FilterFecha: Text;
        StyleExr: text;
        TextoFiltro: text;
        MostrarTodos: Boolean;


    local procedure ActualizarLineas(var tmpSalesInvoiceLine: Record "Sales Invoice Line")
    var
        Item: record item;
        SalesInvoiceLine: Record "Sales Invoice Line";
        Mostrar: Boolean;
    begin
        // if tmpSalesInvoiceLine.IsTemporary then
        //     error('La tabla %1 deber ser temporal', tmpSalesInvoiceLine.TableCaption);
        Rec.Reset();
        Rec.DeleteAll();
        TextoFiltro := '';
        SalesInvoiceHeader.Reset();
        if FilterDocumentNo <> '' then
            SalesInvoiceHeader.SetFilter("No.", FilterDocumentNo);
        if FilterFecha <> '' then
            SalesInvoiceHeader.SetFilter("Posting Date", FilterFecha);
        if FilterCustomer <> '' then
            SalesInvoiceHeader.SetFilter("Sell-to Customer No.", FilterCustomer);
        TextoFiltro := SalesInvoiceHeader.GetFilters();
        if SalesInvoiceHeader.findset() then
            repeat
                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
                if SalesInvoiceLine.findset() then
                    repeat
                        // comprobamos si tiene seguimiento de producto o es conjunto
                        Mostrar := false;
                        if item.get(SalesInvoiceLine."No.") then begin
                            if Item."Item Tracking Code" <> '' then
                                Mostrar := true;
                            Item.CalcFields("Assembly BOM");
                            if Item."Assembly BOM" then
                                Mostrar := true;
                        end;

                        if Mostrar or MostrarTodos then begin
                            tmpSalesInvoiceLine.Init();
                            tmpSalesInvoiceLine.TransferFields(SalesInvoiceLine);
                            tmpSalesInvoiceLine."Posting Group" := '';
                            tmpSalesInvoiceLine."Attached to Line No." := 1;
                            tmpSalesInvoiceLine.Insert();
                            ObtenerSerialNo(SalesInvoiceLine, tmpSalesInvoiceLine);
                        end
                    Until SalesInvoiceLine.next() = 0;

            Until SalesInvoiceHeader.next() = 0;

    end;

    local procedure ObtenerSerialNo(var SalesInvoiceLine: Record "Sales Invoice Line"; var tmpSalesInvoiceLine: Record "Sales Invoice Line"): Boolean
    var
        Item: Record Item;
        Funciones: Codeunit Funciones;
        RecMemLotes: Record MemEstadistica_btc temporary;
        lblCojunto: Label 'CONJUNTO', comment = 'ESP="CONJUNTO"';
        NumMov: Integer;
    begin
        NumMov := 1;
        // aqui obtenemos numeros de serie de la linea
        Funciones.RetrieveLotAndExpFromPostedInv(SalesInvoiceLine.RowID1(), RecMemLotes, NumMov);
        // aqui obtenemos numeros de serie de pedidos de ensamblado
        Funciones.SalesInvoiceLineAssemblyTracking(SalesInvoiceLine, RecMemLotes, NumMov);

        RecMemLotes.Reset();
        if RecMemLotes.Count <= 1 then begin
            tmpSalesInvoiceLine."Posting Group" := RecMemLotes.NoSerie;
            tmpSalesInvoiceLine.Modify();
            exit(true);
        end else
            if RecMemLotes.findset() then begin
                tmpSalesInvoiceLine."Posting Group" := lblCojunto;
                tmpSalesInvoiceLine.Modify();
                repeat
                    tmpSalesInvoiceLine."Line No." := tmpSalesInvoiceLine."Line No." + 1;
                    tmpSalesInvoiceLine."Posting Group" := RecMemLotes.NoSerie;
                    if tmpSalesInvoiceLine.Quantity <> 0 then begin
                        tmpSalesInvoiceLine."No." := RecMemLotes.Noproducto;
                        if Item.get(RecMemLotes.Noproducto) then
                            tmpSalesInvoiceLine.Description := Item.Description;
                        tmpSalesInvoiceLine."Line Amount" := tmpSalesInvoiceLine."Line Amount" / tmpSalesInvoiceLine.Quantity;
                        tmpSalesInvoiceLine.Quantity := 1;
                    end;
                    tmpSalesInvoiceLine."Attached to Line No." := 2;
                    tmpSalesInvoiceLine.Insert();

                Until RecMemLotes.next() = 0;
            end;
    end;

    local procedure ExportTrazabilidadFacturas()
    var
        Funciones: Codeunit Funciones;
    begin
        Funciones.ExportTrazabilidadFacturas(Rec, TextoFiltro);
        if Rec.FindFirst() then;
    end;
}