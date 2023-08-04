table 17455 "ZM Contracts/Supplies Header"
{
    Caption = 'Contracts and Supplies Header', Comment = 'ESP="Contratos/Suministros Cabecera"';
    DataClassification = CustomerContent;
    LookupPageId = "ZM Contracts Suplies List";
    DrillDownPageId = "ZM Contracts Suplies List";

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
                OnValidate_BuyFromVendorNo();

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
        field(13; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code', Comment = 'ESP="Cód. Formas pago"';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method";
        }
        field(14; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code', Comment = 'ESP="Cód. términos pago"';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms";
        }
        field(15; Status; Enum "ZM Contracts Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', comment = 'ESP="Estado"';
            Editable = false;
        }
        field(16; "Salesperson/Purchaser"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson/Purchaser', comment = 'ESP="Cód. Comprador"';
            TableRelation = "Salesperson/Purchaser";
        }
        field(17; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series', Comment = 'ESP="Nº Series"';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18; "ITBID Solicitud No."; Code[50])
        {
            Caption = 'ITBID Solicitud No.', Comment = 'ESP="Nº de solicitud ITBID"';
            DataClassification = CustomerContent;
        }
        field(19; "ITBID Negotiation No."; Code[50])
        {
            Caption = 'ITBID Negotiation No.', Comment = 'ESP="Nº de negociación ITBID"';
            DataClassification = CustomerContent;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha Registro"';
            DataClassification = CustomerContent;
        }
        field(21; "VAT Registration No."; text[20])
        {
            Caption = 'VAT Registration No.', Comment = 'ESP="CIF/NIF"';
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
        field(55; "User Id"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User Id', comment = 'ESP="Nº usuario"';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(56; "Employee No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.', comment = 'ESP="Cód. empleado"';
            TableRelation = Employee;
        }
        field(57; "Shipment Method Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Method Code', comment = 'ESP="Cód. condiciones envío"';
            TableRelation = "Shipment Method";
        }
        field(58; "Currency"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency', comment = 'ESP="Cód. Divisa"';
            TableRelation = Currency;
        }
        field(60; "Salesperson code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson code', comment = 'ESP="Cód. Vendedor"';
            TableRelation = "Salesperson/Purchaser";
        }
        field(61; "Blocked"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Blocked', comment = 'ESP="Bloqueado"';
            TableRelation = "Salesperson/Purchaser";
        }
        field(100; "Quantity Total"; Decimal)
        {
            Caption = 'Quanity Total', comment = 'ESP="Cantidad Total"';
            FieldClass = FlowField;
            CalcFormula = sum("ZM Contracts/Supplies Lines".Unidades where("Document No." = field("No.")));
            Editable = false;
        }
        field(101; "Total Amount"; Decimal)
        {
            Caption = ' Total Amount', comment = 'ESP="Importe"';
            FieldClass = FlowField;
            CalcFormula = sum("ZM Contracts/Supplies Lines"."Line Amount" where("Document No." = field("No.")));
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

    trigger OnModify()
    begin
        TestOpen();
    end;

    trigger OnDelete()
    begin
        DeleteLines;
    end;

    var
        Vend: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Funciones: Codeunit Funciones;
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
        Rec."Posting Date" := WorkDate();
        Rec."Document Date" := WorkDate();
        Rec."Date creation" := WorkDate();
        Rec."User Id" := UserId;
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
        TestField(Status, Status::Abierto);
        TestField("Data Start Validity");
        TestField("Date End Validity");
        if Confirm(MsgConfirmRelease, true, "No.") then begin
            Status := Status::lanzado;
            Modify();
        end;

    end;

    procedure VolverAbrir()
    begin
        if Confirm(MsgConfirmReopen, true, "No.") then begin
            Status := Status::Abierto;
            Modify();
        end;
    end;

    procedure TestOpen()
    begin
        Rec.TestField(Status, Rec.Status::Abierto);
    end;

    local procedure DeleteLines()
    var
        ContractLine: Record "ZM Contracts/Supplies Lines";
    begin
        ContractLine.SetRange("Document No.", "No.");
        ContractLine.DeleteAll(true);
    end;

    local procedure OnValidate_BuyFromVendorNo()
    var
        myInt: Integer;
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
        "VAT Registration No." := Vend."VAT Registration No.";
        "Payment Method Code" := Vend."Payment Method Code";
        "Payment Terms Code" := Vend."Payment Terms Code";
    end;

    procedure CreatePurchaseOrder()
    var

    begin
        Funciones.ContractsCreatePurchaseOrder(Rec);
    end;
}