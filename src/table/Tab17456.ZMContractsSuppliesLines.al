table 17456 "ZM Contracts/Supplies Lines"
{
    Caption = 'Contracts/Supplies Lines', Comment = 'ESP="Contratos/Suministros Cabecera"';

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº Documento"';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Línea"';
            DataClassification = CustomerContent;
        }
        field(3; Type; enum "ZM Contracts Lines Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            DataClassification = CustomerContent;

            TableRelation = if (type = const(Item)) Item else
            if (type = const(Account)) "G/L Account" else
            if (type = const("Fixed Asset")) "Fixed Asset";

            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                Case Type of
                    Type::Item:
                        begin
                            if Item.Get("No.") then
                                Description := Item.Description;
                        end;
                    Type::Account:
                        begin
                            if GLAccount.Get("No.") then
                                Description := GLAccount.Name;
                        end;
                    Type::"Fixed Asset":
                        begin
                            if FixedAsset.Get("No.") then
                                Description := FixedAsset.Description;
                        end;
                end;

            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;

        }

        field(10; "Precio negociado"; Decimal)
        {
            Caption = 'Precio negociado', Comment = 'ESP="Precio negociado"';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(11; "Unidades"; Decimal)
        {
            Caption = 'Unidades', Comment = 'ESP="Unidades"';
            DataClassification = CustomerContent;
        }
        field(13; "Unidades compradas"; Decimal)
        {
            Caption = 'Unidades compradas', Comment = 'ESP="Unidades compradas"';
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line".Quantity where("Contracts No." = field("Document No."), "Contracts Line No." = field("Line No.")));
            Editable = false;
        }
        field(15; "Unidades Devolución"; Decimal)
        {
            Caption = 'Kilos Devolución', comment = 'ESP="Kilos Devolución"';
            FieldClass = FlowField;
            CalcFormula = sum("Return Shipment Line".Quantity where("Contracts No." = field("Document No."), "Contracts Line No." = field("Line No.")));
            Editable = false;
        }
        field(16; "Quantity in Purch. Order"; Decimal)
        {
            Caption = 'Quantity in Purch. Order', comment = 'ESP="Cantidad pdte. Pedidos Compra"';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const(Order), "Contracts No." = field("Document No."), "Contracts Line No." = field("Line No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestStatusOpen;
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
    end;

    trigger OnDelete()
    begin
        CheckDeleteLine;
    end;

    var
        ContractHeader: Record "ZM Contracts/supplies Header";
        GLAccount: Record "G/L Account";
        Item: Record Item;
        ItemCategory: Record "Item Category";
        FixedAsset: Record "Fixed Asset";
        MsgDuplicity: Label 'No se pueden insertar dos lineas con la misma categoria o Cód. Producto.', Comment = 'ESP="No se pueden insertar dos lineas con la misma categoria o Cód. Producto"';
        MsgErrorCategoryParent: Label 'La categoria elegida para el contrato, debe ser del último nivel', Comment = 'ESP="La categoria elegida para el contrato, debe ser del último nivel"';
        MsgDelete: Label 'No se puede eliminar la línea porque tiene Albaranes/Devoluciones en este contrato', Comment = 'ESP="No se puede eliminar la línea porque tiene Albaranes/Devoluciones en este contrato"';

    local procedure GetHeader()
    begin
        ContractHeader.Get("Document No.");
    end;

    local procedure TestStatusOpen()
    begin
        GetHeader();
        ContractHeader.TestField(Status, ContractHeader.Status::Abierto);
    end;

    local procedure CheckDeleteLine()
    begin
        CalcFields("Unidades compradas", "Unidades Devolución");
        if ("Unidades compradas" <> 0) or ("Unidades Devolución" <> 0) then
            Error(MsgDelete);
    end;
}
