table 50152 "ZM Productión Tools"
{
    Caption = 'ZM Productión Tools', Comment = 'ESP="Utiles producción"';

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(3; Brand; Code[50])
        {
            Caption = 'Brand', Comment = 'ESP="Marca"';
            DataClassification = CustomerContent;
        }
        field(4; Model; Code[50])
        {
            Caption = 'Model', Comment = 'ESP="Modelo"';
            DataClassification = CustomerContent;
        }
        field(5; "Serial No."; Code[50])
        {
            Caption = 'Serial No.', Comment = 'ESP="Nº Serie"';
            DataClassification = CustomerContent;
        }
        field(6; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.', Comment = 'ESP="Cód. proveedor"';
            DataClassification = CustomerContent;
        }
        field(7; "Work Center"; Code[20])
        {
            Caption = 'Work Center', Comment = 'ESP="Centro trabajo"';
            DataClassification = CustomerContent;
            TableRelation = "Work Center";
        }
        field(8; "Machine Center"; Code[20])
        {
            Caption = 'Machine Center', Comment = 'ESP="Centro maquina"';
            DataClassification = CustomerContent;
            TableRelation = "Machine Center";
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
            DataClassification = CustomerContent;
        }
        field(10; "Purchase Date"; Date)
        {
            Caption = 'Purchase Date', Comment = 'ESP="Fecha compra"';
            DataClassification = CustomerContent;
        }
        field(11; Precision; Decimal)
        {
            Caption = 'Precision', Comment = 'ESP="Precisión"';
            DataClassification = CustomerContent;
        }
        field(12; "Value min."; Decimal)
        {
            Caption = 'Value min.', Comment = 'ESP="Valor min."';
            DataClassification = CustomerContent;
        }
        field(13; "Value max."; Decimal)
        {
            Caption = 'Value max.', Comment = 'ESP="Valor max."';
            DataClassification = CustomerContent;
        }
        field(14; Periodicity; DateFormula)
        {
            Caption = 'Periodicity', Comment = 'ESP="Periodicidad"';
            DataClassification = CustomerContent;
        }
        field(15; "Last date revision"; Date)
        {
            Caption = 'Last date revision', Comment = 'ESP="Ult. fecha revisión"';
            DataClassification = CustomerContent;
            // FieldClass = FlowField;
            // CalcFormula = max("ZM Prod. Tools Ledger Entry"."Last date revision" where("Prod. Tools code" = field(Code)));
            Editable = false;
        }
        field(16; "Next date revision"; Date)
        {
            Caption = 'Next date revision', Comment = 'ESP="Fecha siguiente revisión"';
            DataClassification = CustomerContent;
            // FieldClass = FlowField;
            // CalcFormula = max("ZM Prod. Tools Ledger Entry"."Next date revision" where("Prod. Tools code" = field(Code)));
            Editable = false;
        }
        field(17; Comments; Blob)
        {
            Caption = 'Commments', Comment = 'ESP="Comentarios"';
            DataClassification = CustomerContent;
        }
        field(18; "Last Vendor No."; code[20])
        {
            Caption = 'Last Vendor No.', Comment = 'ESP="Ult. Cód. proveedor"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; Status; Enum "ZM State production tools")
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
            DataClassification = CustomerContent;
        }

        field(21; Resolution; Enum "ZM Production tools resolution")
        {
            Caption = 'Resolution', Comment = 'ESP="Resolución"';
            DataClassification = CustomerContent;
        }
        field(30; "Direct unit cost."; Decimal)
        {
            Caption = 'Direct unit cost.', Comment = 'ESP="Coste Directo"';
            DataClassification = CustomerContent;
        }
        field(50; "Use"; text[100])
        {
            Caption = 'Use', comment = 'ESP="Uso"';
            DataClassification = CustomerContent;
        }
        field(51; "Bin"; text[100])
        {
            Caption = 'Bin', comment = 'ESP="Ubicación"';
            DataClassification = CustomerContent;
        }
        field(53; Type; Enum "ZM Prod. Tools Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(54; Units; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Units', comment = 'ESP="Unidades"';
        }

    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        DeleteProductionTools;
    end;

    var
        ProdToolsLdgEntry: Record "ZM Prod. Tools Ledger Entry";
        lblConfirmDelete: Label '¿Se van a eliminar todos los movimientos de revisión.\¿Esta seguro?', comment = 'ESP="¿Se van a eliminar todos los movimientos de revisión.\¿Esta seguro?"';
        lblErrorDelete: Label 'Cancelado por el usuario', Comment = 'ESP="Cancelado por el usuario"';

    procedure ShowProdToolLdgEntrys()
    var

        ProdToolsLedgerEntrys: page "ZM Prod. Tools Ledger Entry";
    begin
        ProdToolsLdgEntry.Reset();
        ProdToolsLdgEntry.SetRange("Prod. Tools code", Rec.Code);
        ProdToolsLedgerEntrys.SetTableView(ProdToolsLdgEntry);
        ProdToolsLedgerEntrys.Editable := false;
        ProdToolsLedgerEntrys.RunModal();
    end;

    procedure CreateRevisions()
    var
        ProdToolsLdgEntry: Record "ZM Prod. Tools Ledger Entry" temporary;
        ProdToolsLedgerEntrys: page "ZM Prod. Tools Ledger Entry";
    begin
        ProdToolsLdgEntry.Init();
        ProdToolsLdgEntry."Prod. Tools code" := Rec.Code;
        ProdToolsLdgEntry.Insert();
        if Page.RunModal(page::"ZM Prod. Tools Ldg. Entry Card", ProdToolsLdgEntry) = Action::LookupOK then begin
            // TODO crear el registro real y no en temporal, comprobar datos lookup de ficha
            ProdToolsLdgEntry.AddRevisionProdTools(ProdToolsLdgEntry);
        end;

    end;

    local procedure DeleteProductionTools()
    begin
        ProdToolsLdgEntry.Reset();
        ProdToolsLdgEntry.SetRange("Prod. Tools code", Rec.Code);
        if ProdToolsLdgEntry.Count > 0 then
            if not Confirm(lblConfirmDelete, false) then
                Error(lblErrorDelete);

        ProdToolsLdgEntry.DeleteAll();

    end;
}
