page 17214 "ZM Post Value Entry to G/L"
{
    Caption = 'Registrar mov. valor en C/G', comment = 'ESP="Registrar mov. valor en C/G"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Post Value Entry to G/L";

    layout
    {
        area(Content)
        {
            group(Options)
            {
                Caption = 'Options', comment = 'ESP="Opciones"';
                field(InitDate; InitDate)
                {
                    ApplicationArea = all;
                    Caption = 'Fecha Inicial', comment = 'ESP="Fecha Inicial"';
                    trigger OnValidate()
                    begin
                        UpdatePageForm();
                    end;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = all;
                    Caption = 'Fecha Final', comment = 'ESP="Fecha Final"';
                    trigger OnValidate()
                    begin
                        UpdatePageForm();
                    end;
                }
                field(NewDate; NewDate)
                {
                    ApplicationArea = all;
                    Caption = 'Fecha Registro', comment = 'ESP="Fecha Registro"';
                }
            }
            repeater(General)
            {
                Editable = false;
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Value Entry No."; "Value Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ValueEntryPostingDate; ValueEntry."Posting Date")
                {
                    ApplicationArea = all;
                    Caption = 'Fecha registro Mov.', comment = 'ESP="Fecha registro Mov."';
                }
                field(ValueItemNo; ValueEntry."Item No.")
                {
                    ApplicationArea = all;
                    Caption = 'Nº producto', comment = 'ESP="Nº producto"';
                }
                field(DocumentNo; ValueEntry."Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'Nº Documento', comment = 'ESP="Nº Documento"';
                }
                field(Description; ValueEntry.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Descripción', comment = 'ESP="Descripción"';
                }

                field(InvoicedQuantity; ValueEntry."Invoiced Quantity")
                {
                    ApplicationArea = all;
                    Caption = 'Cantidad facturada', comment = 'ESP="Cantidad facturada"';
                }
                field(ValuedQuantity; ValueEntry."Valued Quantity")
                {
                    ApplicationArea = all;
                    Caption = 'Cant. valorada', comment = 'ESP="Cant. valorada"';
                }
                field(Cantidadmovproducto; ValueEntry."Item Ledger Entry Quantity")
                {
                    ApplicationArea = all;
                    Caption = 'Cantidad mov. producto', comment = 'ESP="Cantidad mov. producto"';
                }
                field(CostperUnit; ValueEntry."Cost per Unit")
                {
                    ApplicationArea = all;
                    Caption = 'Coste por ud.', comment = 'ESP="Coste por ud."';
                }
                field(CostAmountExpected; ValueEntry."Cost Amount (Expected)")
                {
                    ApplicationArea = all;
                    Caption = 'Importe coste (Esperado)', comment = 'ESP="Importe coste (Esperado)"';
                }
                field(CostAmountActual; ValueEntry."Cost Amount (Actual)")
                {
                    ApplicationArea = all;
                    Caption = 'Importe coste (Real)', comment = 'ESP="Importe coste (Real)"';
                }
                field(CostAmountNonInvtbl; ValueEntry."Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = all;
                    Caption = 'Importe coste (No-invent.)', comment = 'ESP="Importe coste (No-invent.)"';
                }
                field(CostPostedtoGL; ValueEntry."Cost Posted to G/L")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PostingDate)
            {
                ApplicationArea = All;
                Caption = 'Procesar cambio fechas', comment = 'ESP="Procesar cambio fechas"';
                Image = ChangeDates;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ChangeValueEntryPostingDate();
                end;
            }
            action(ResetPostingDate)
            {
                ApplicationArea = All;
                Caption = 'Deshacer cambio fechas', comment = 'ESP="Deshacer cambio fechas"';
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ReverseValueEntryPostingDate();
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        if ValueEntry.Get(Rec."Value Entry No.") then;
    end;

    var
        ValueEntry: Record "Value Entry";
        InitDate: Date;
        EndDate: Date;
        NewDate: date;

    local procedure UpdatePageForm()
    var
        myInt: Integer;
    begin
        Rec.Reset();
        if (InitDate <> 0D) or (EndDate <> 0D) then
            Rec.SetRange("Posting Date", InitDate, EndDate);
        CurrPage.Update();
    end;

    local procedure ChangeValueEntryPostingDate()
    begin
        ValueEntry.ChangeValueEntryPostingDate(InitDate, EndDate, NewDate);
    end;

    local procedure ReverseValueEntryPostingDate()
    begin
        ValueEntry.ResetValueEntryPostingDate();
    end;
}