page 17389 "ZM G/L Register Inventory"
{
    PageType = List;
    Caption = 'G/L Register Inventory"', comment = 'ESP="Registros Inventario Contable"';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ZM G/L Register Inventory";
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("G/L Entry No."; "G/L Entry No.")
                {
                    ApplicationArea = all;
                }
                field("G/L Register No."; "G/L Register No.")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("G/L Posting Date"; "G/L Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = all;
                }

                field("Clasification Entry"; "Clasification Entry")
                {
                    ApplicationArea = all;
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Amount Total G/L Entry"; "Amount Total G/L Entry")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                Field(PYL; PYL)
                {
                    ApplicationArea = all;
                    Visible = False;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Update)
            {
                Caption = 'Update', comment = 'ESP="Actualizar"';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea actualizar los movimientos de Costes?', comment = 'ESP="¿Desea actualizar los movimientos de Costes?"';
                begin
                    if Confirm(lblConfirm) then
                        Rec.UpdateEntries();
                end;
            }
        }
        area(Navigation)
        {
            action(ValueEntry)
            {
                Caption = 'Value entries', comment = 'ESP="Movs. Valor"';
                Image = ValueLedger;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    ShowValueEntries();
                end;
            }
        }
    }

    var
        myInt: Integer;

    local procedure ShowValueEntries()
    var
        myInt: Integer;
    begin
        Rec.ShowValueEntries();
    end;
}