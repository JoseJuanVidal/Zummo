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
}