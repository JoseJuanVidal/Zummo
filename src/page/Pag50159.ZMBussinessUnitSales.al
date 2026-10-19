page 50159 "ZM Bussiness Unit Sales"
{
    Caption = 'Reporting SEB', comment = 'ESP="Reporting SEB"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "ZM Reporting SEB Sales";
    SourceTableView = sorting("Period Start", "Business Unit", MLA, "CMMF Code");

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
                    // Solo para la acción Cargar; no filtra las líneas (se filtran por Mes en el panel)
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
                field("Period Start"; "Period Start")
                {
                    ApplicationArea = all;
                    Caption = 'Month', comment = 'ESP="Mes"';
                }
                field("Business Unit"; "Business Unit") { ApplicationArea = all; }
                field(MLA; MLA) { ApplicationArea = all; }
                field("CMMF Code"; "CMMF Code") { ApplicationArea = all; }
                field(Fl1; Fl1) { ApplicationArea = all; }
                field(Fl2; Fl2) { ApplicationArea = all; }
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
                    FromDate: Date;
                    ToDate: Date;
                    lblConfirm: Label '¿Desea Cargar los datos de filtro %1?', comment = 'ESP="¿Desea Cargar los datos de filtro %1?"';
                begin
                    Rec.GetMonthRange(DateFilter, FromDate, ToDate);
                    if Confirm(lblConfirm, true, DateFilter) then begin
                        Rec.UploadItemLedgerEntry(DateFilter);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        Fechas: Record date;
        DateFilter: text;
}
