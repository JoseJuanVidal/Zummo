tableextension 50197 "ZM Serial No. Information" extends "Serial No. Information"
{
    fields
    {
        field(50100; "Serial No. Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No. Cost', comment = 'ESP="Coste Nº de serie"';

            trigger OnValidate()
            begin
                OnValidate_SerialNoCost();
            end;
        }
        field(50101; "Last Date Update Cost"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Update Cost', comment = 'ESP="Fecha act. Coste"';
        }
        field(50102; "Update Cost"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Update Cost', comment = 'ESP="Costes Actualizados"';
        }
        field(50105; "Last Item ldg Entry"; Integer)
        {
            Caption = 'Last Item ledger Entry', comment = 'ESP="Ultimo Mov. producto"';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Entry No." where("Entry Type" = const(Output), "Item No." = field("Item No."), "Serial No." = field("Serial No.")));
        }
        field(50106; "Last Cost"; Decimal)
        {
            Caption = 'Last Cost', comment = 'ESP="Ultimo Coste"';
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item Ledger Entry No." = FIELD("Last Item ldg Entry")));
        }
        field(50110; Open; Boolean)
        {
            Caption = 'Open', comment = 'ESP="Pendiente"';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry".Open where("Entry No." = field("Last Item ldg Entry")));
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    local procedure OnValidate_SerialNoCost()
    var
        lblConfirm: Label 'Se a cambiar el coste del numero de serie a partir de la fecha indicada.\¿Desea continuar?', comment = 'ESP="Se a cambiar el coste del numero de serie a partir de la fecha indicada.\¿Desea continuar?"';
    begin
        if Rec."Serial No. Cost" <> xRec."Serial No. Cost" then begin
            if not Confirm(lblConfirm) then
                exit;
            Rec."Last Date Update Cost" := WorkDate();
        end;
    end;

    procedure UpdateItemLedgerEntry()
    var
        EventosBTC: Codeunit Eventos_btc;
        textoEmail: text;
        lblConfirm: Label '¿Desea actualizar el coste %1 al numero de serie %2?', comment = 'ESP="¿Desea actualizar el coste %1 al numero de serie %2?"';
    begin
        Rec.TestField("Serial No. Cost");
        if Confirm(lblConfirm, false, rec."Serial No.", Rec."Serial No. Cost") then
            EventosBTC.AdjustCostItemEntries(Rec, textoEmail);

    end;
}