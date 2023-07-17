table 17455 "ZM Contracts/Supplies Header"
{
    Caption = 'Contracts and Supplies Header', Comment = 'ESP="Contratos/Suministros Cabecera"';
    DataClassification = CustomerContent;
    // LookupPageId = "STH Contracts Suplies List";
    // DrillDownPageId = "STH Contracts Suplies List";

    Permissions = tabledata 121 = rmid, tabledata 6651 = rimd;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    TestNoSeries();
                    NoSeriesMgt.TestManual(PurchSetup."ZM Contracts Nos.");
                end;
            end;
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.', Comment = 'ESP="Compra a-Nº proveedor"';
            DataClassification = CustomerContent;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if xRec."Buy-from Vendor No." <> '' then
                    if xRec."Buy-from Vendor No." = rec."Buy-from Vendor No." then
                        exit;

                GetVend("Buy-from Vendor No.");
                Vend.CheckBlockedVendOnDocs(Vend, false);
                "Buy-from Vendor Name" := Vend.Name;
                "Buy-from Vendor Name 2" := Vend."Name 2";
                "Buy-from Address" := Vend.Address;
                "Buy-from Address 2" := Vend."Address 2";
                "Buy-from City" := Vend.City;
                "Buy-from Contact" := vend.Contact;
                "Buy-from County" := Vend.County;
                "Buy-from Country/Region Code" := Vend."Country/Region Code";
                "Buy-to Post Code" := Vend."Post Code";
                // "Payment Method Code" := Vend."Payment Method Code";
                // "Payment Terms Code" := Vend."Payment Terms Code";

            end;
        }
        field(3; "Buy-from Vendor Name"; Text[100])
        {
            Caption = 'Buy-from Vendor Name', Comment = 'ESP="Compra a-Nombre"';
            DataClassification = CustomerContent;
        }
        field(4; "Buy-from Vendor Name 2"; Text[50])
        {
            Caption = 'Buy-from Vendor Name 2', Comment = 'ESP="Compra a-Nombre 2"';
            DataClassification = CustomerContent;
        }
        field(5; "Buy-from Address"; Text[100])
        {
            Caption = 'Buy-from Address', Comment = 'ESP="Compra a-Dirección"';
            DataClassification = CustomerContent;
        }
        field(6; "Buy-from Address 2"; Text[50])
        {
            Caption = 'Buy-from Address 2', Comment = 'ESP="Compra a-Dirección 2"';
            DataClassification = CustomerContent;
        }
        field(7; "Buy-from City"; Text[30])
        {
            Caption = 'Buy-from City', Comment = 'ESP="Compra a-Población"';
            DataClassification = CustomerContent;
        }
        field(8; "Buy-from Contact"; Text[100])
        {
            Caption = 'Buy-from Contact', Comment = 'ESP="Compra a-Contacto"';
            DataClassification = CustomerContent;
        }
        field(9; "Buy-to Post Code"; Code[20])
        {
            Caption = 'Buy-to Post Code', Comment = 'ESP="Compra a-C.P."';
            DataClassification = CustomerContent;
        }
        field(10; "Buy-from County"; Text[30])
        {
            Caption = 'Buy-from County', Comment = 'ESP="Compra a-Provincia"';
            DataClassification = CustomerContent;
        }
        field(11; "Buy-from Country/Region Code"; Code[10])
        {
            Caption = 'Buy-from Country/Region Code', Comment = 'ESP="Compra a-Cód. país/región"';
            DataClassification = CustomerContent;
        }
        field(12; "Document Date"; Date)
        {
            Caption = 'Document Date', Comment = 'ESP="Fecha emisión documento"';
            DataClassification = CustomerContent;
        }
        field(15; Status; Enum "ZM Contracts Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', comment = 'ESP="Estado"';
            Editable = false;
        }

        field(17; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series', Comment = 'ESP="Nº Series"';
            Editable = false;
            TableRelation = "No. Series";
        }

        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha Registro"';
            DataClassification = CustomerContent;
        }

        field(50; "Contract No. Vendor"; Text[30])
        {
            Caption = 'Contract No. Vendor', Comment = 'ESP="Nº contrato proveedor"';
            DataClassification = CustomerContent;
        }
        field(51; "Date creation"; Date)
        {
            Caption = 'Date creation', Comment = 'ESP="Fecha Creación"';
            DataClassification = CustomerContent;
        }
        field(52; "Data Start Validity"; Date)
        {
            Caption = 'Data Start Validity', Comment = 'ESP="Fecha Inicio Vigencia"';
            DataClassification = CustomerContent;
        }
        field(53; "Date End Validity"; Date)
        {
            Caption = 'Date End Validity', Comment = 'ESP="Fecha Fin Vigencia"';
            DataClassification = CustomerContent;
        }
        // field(100; "Quantity Total"; Decimal)
        // {
        //     Caption = 'Quanity Total', comment = 'ESP="Cantidad Total"';
        //     FieldClass = FlowField;
        //     CalcFormula = sum("ZM Contracts/Supplies Lines"."Kilos totales" where("Document No." = field("No.")));
        //     Editable = false;
        // }
        field(102; "Expend Quantity"; Decimal)
        {
            Caption = 'Expend Quanity', comment = 'ESP="Cantidad Consumida"';
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line".Quantity where("Contracts No." = field("No.")));
            Editable = false;
        }
        field(103; "Return Quantity"; Decimal)
        {
            Caption = 'Return Quanity', comment = 'ESP="Cantidad Devolución"';
            FieldClass = FlowField;
            CalcFormula = sum("Return Shipment Line".Quantity where("Contracts No." = field("No.")));
            Editable = false;
        }
        field(104; "Quantity in Purch. Order"; Decimal)
        {
            Caption = 'Quantity in Purch. Order', comment = 'ESP="Cantidad pdte. Pedidos Compra"';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Contracts No." = field("No.")));
            Editable = false;
        }
        field(105; "No. of Purchase Line"; Integer)
        {
            Caption = 'No. of Purchase Order', comment = 'ESP="Nº de Pedidos de Compra"';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Line" where("Document Type" = const(Order), "Contracts No." = field("No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }


    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Buy-from Vendor Name")
        {
        }
    }

    trigger OnInsert()
    begin
        InitInsert();
    end;

    trigger OnDelete()
    begin
        DeleteLines;
    end;

    var
        Vend: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MsgConfirmClose: Label '¿Esta seguro de cerrar el contrato %1?', Comment = 'ESP="¿Esta seguro de cerrar el contrato %1?"';
        MsgConfirmRelease: Label '¿Esta seguro de lanzar el contrato %1?', Comment = 'ESP="¿Esta seguro de Lanzar el contrato %1?"';
        MsgConfirmReopen: Label '¿Esta seguro de Volver a Abrir el contrato %1?', Comment = 'ESP="¿Esta seguro de Volver a Abrir el contrato %1?"';
        MsgCheckchange: Label 'el Contrato %1 tiene ya registradas recepciones o devoluciones.', Comment = 'ESP="El Contrato %1 tiene ya registradas recepciones o devoluciones."';
        MsgChangeLocation: label 'Se van a actualizar el Cód. Almacén en las líneas del Contrato', Comment = 'ESP="Se van a actualizar el Cód. Almacén en las líneas del Contrato"';

    local procedure InitInsert()
    begin
        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(PurchSetup."ZM Contracts Nos.", xRec."No. Series", "Posting Date", "No.", "No. Series");
        END;

        InitRecord();
    end;

    local procedure InitRecord()
    begin
        GetPurchSetup();
        "Posting Date" := WorkDate();
        "Document Date" := WorkDate();
        "Date creation" := WorkDate();
    end;

    local procedure GetVend(VendNo: Code[20])
    begin
        if VendNo <> Vend."No." then
            Vend.Get(VendNo);
    end;

    local procedure GetPurchSetup()
    begin
        PurchSetup.Get();
    end;

    local procedure TestNoSeries()
    begin
        GetPurchSetup();
        PurchSetup.TestField("ZM Contracts Nos.");
    end;

    procedure Cerrar()
    begin
        if Confirm(MsgConfirmClose, true, "No.") then begin
            // Status := Status::Cerrado;
            Modify();
        end;
    end;

    procedure Release()
    begin
        // TestField(Status, Status::Abierto);
        if Confirm(MsgConfirmRelease, true, "No.") then begin
            // Status := Status::lanzado;
            Modify();
        end;

    end;

    procedure VolverAbrir()
    begin
        if Confirm(MsgConfirmReopen, true, "No.") then begin
            // Status := Status::Abierto;
            Modify();
        end;

    end;

    local procedure DeleteLines()
    var
        ContractLine: Record "ZM Contracts/Supplies Lines";
    begin
        ContractLine.SetRange("Document No.", "No.");
        ContractLine.DeleteAll(true);
    end;

}
