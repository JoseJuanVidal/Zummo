page 50159 "ZM Bussiness Unit Sales"
{
    Caption = 'Reporting SEB', comment = 'ESP="Reporting SEB"';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "ZM Reporting SEB Sales";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = all;
                    Caption = 'Filtro Fecha', comment = 'ESP="Filtro Fecha"';
                    trigger OnValidate()
                    begin
                        Fechas.SetFilter("Period Start", DateFilter);
                        DateFilter := Fechas.GetFilter("Period Start");
                    end;
                }
            }
            repeater(Lines)
            {
                Editable = false;
                field("CMMF Code"; "CMMF Code") { ApplicationArea = all; }
                field(MLA; MLA) { ApplicationArea = all; }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        rec.DrillDrow();
                    end;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        rec.DrillDrow();
                    end;
                }
                field(Value1; Value1) { ApplicationArea = all; }
                field(Value2; Value2) { ApplicationArea = all; }
                field(Costs; Costs)
                {
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        rec.DrillDrow();
                    end;
                }
                field("Period Start"; "Period Start")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Period End"; "Period End")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(Trace)
            {
                ApplicationArea = all;
                Caption = 'Trace', comment = 'ESP="Cargar"';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea Cargar los datos de filtro %1?', comment = 'ESP="¿Desea Cargar los datos de filtro %1?"';
                begin
                    if Confirm(lblConfirm, true, DateFilter) then
                        Rec.UploadItemLedgerEntry(DateFilter);
                end;
            }
        }
    }

    var
        Fechas: Record date;
        DateFilter: text;
}