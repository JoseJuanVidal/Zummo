codeunit 50103 "STH Funciones IVA Recuperacion"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    // ================ Funciones para la importacion de excel de Recuperación de IVA  ======================
    // Tipo 
    // Nombre 
    // accion  
    //  29/09/2022
    //  
    // ==  Parametro  - 

    procedure CreateJnlIVARecuperacion(GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        ExcelBuffer: Record "Excel Buffer";
        SeriesMGt: codeunit NoSeriesManagement;
        NVInStream: InStream;
        DocNo: text;
        FileName: text;
        Sheetname: text;
        LastLine: Integer;
        i: Integer;
        Rows: Integer;
        UploadResult: Boolean;
        IDFra: text;
        txtFechaFra: text;
        FechaFra: date;
        IVA: text;
        CuentaContable: text;
        txtImporte: text;
        Importe: decimal;
        CIFProveedor: text;
        CuentaProveedor: text;
        NombreFiscal: text;
        Pais: text;
        Divisa: text;
        Direccion: text;
        Localidad: text;
        Provincia: text;
        CPProveeor: text;
        Id60dias: text;    //60 dias es el nombre de la empresa de recuperación de IVA
        Text000: label 'Cargar Fichero de Excel';
        Text001: Label 'Nominas %1 %2';
    begin

        ExcelBuffer.DeleteAll();
        UploadResult := UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream);
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 1);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";
        // primero miramos si existen líneas y obtenemos la ultima línea
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if GenJnlLine.FindLast() then
            LastLine := GenJnlLine."Line No." + 10000
        else
            LastLine := 10000;

        for i := 2 to Rows do begin

            InitValues(IDFra, txtFechaFra, FechaFra, IVA, CuentaContable, txtImporte, Importe, CIFProveedor, CuentaProveedor, NombreFiscal, Pais, Divisa, Direccion, Localidad, Provincia, CPProveeor, id60dias);

            ExcelBuffer.SetRange("Row No.", i);
            ExcelBuffer.SetRange("Column No.", 1);
            if ExcelBuffer.FindSet() then
                IDFra := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 2);
            if ExcelBuffer.FindSet() then
                txtFechaFra := ExcelBuffer."Cell Value as Text";
            Evaluate(FechaFra, txtFechaFra);
            ExcelBuffer.SetRange("Column No.", 3);
            if ExcelBuffer.FindSet() then
                IVA := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 4);
            if ExcelBuffer.FindSet() then
                CuentaContable := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 5);
            if ExcelBuffer.FindSet() then
                txtImporte := ExcelBuffer."Cell Value as Text";
            Evaluate(Importe, txtImporte);
            ExcelBuffer.SetRange("Column No.", 6);
            if ExcelBuffer.FindSet() then
                CIFProveedor := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 7);
            if ExcelBuffer.FindSet() then
                CuentaProveedor := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 8);
            if ExcelBuffer.FindSet() then
                NombreFiscal := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 9);
            if ExcelBuffer.FindSet() then
                Pais := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 10);
            if ExcelBuffer.FindSet() then
                Divisa := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 11);
            if ExcelBuffer.FindSet() then
                Direccion := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 12);
            if ExcelBuffer.FindSet() then
                Localidad := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 13);
            if ExcelBuffer.FindSet() then
                Provincia := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 14);
            if ExcelBuffer.FindSet() then
                CPProveeor := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 15);
            if ExcelBuffer.FindSet() then
                Id60dias := ExcelBuffer."Cell Value as Text";

            CrearJnlLine(GenJournalBatch, IDFra, txtFechaFra, FechaFra, IVA, CuentaContable, txtImporte, Importe, CIFProveedor, CuentaProveedor,
                    NombreFiscal, Pais, Divisa, Direccion, Localidad, Provincia, CPProveeor, id60dias, LastLine);

        end;

    end;


    local procedure CrearJnlLine(GenJournalBatch: Record "Gen. Journal Batch"; IDFra: text; txtFechaFra: Text; FechaFra: date; IVA: text; CuentaContable: text; txtImporte: Text; Importe: decimal; CIFProveedor: text; CuentaProveedor: text;
            NombreFiscal: text; Pais: text; Divisa: text; Direccion: text; Localidad: text; Provincia: text; CPProveeor: text; id60dias: text; var LastLine: Integer)
    var
        GLSetup: Record "General Ledger Setup";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GLSetup.get();
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := GenJournalBatch."Journal Template Name";
        GenJnlLine."Journal Batch Name" := GenJournalBatch.Name;
        GenJnlLine."Line No." := LastLine;
        GenJnlLine."Posting Date" := Workdate;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine.Insert();
        GenJnlLine."Document No." := IDFra;
        GenJnlLine."External Document No." := CopyStr(id60dias, 1, MaxStrLen(GenJnlLine."External Document No."));
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine.validate("Account No.", GetVendorNo(CuentaProveedor, CIFProveedor));
        GenJnlLine.Description := CopyStr(StrSubstNo('%1 %2', NombreFiscal, IDFra), 1, MaxStrLen(GenJnlLine.Description));
        GenJnlLine."VAT Registration No." := CIFProveedor;
        GenJnlLine.Validate(Amount, -Importe);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        if GLSetup."Cta. Contable IVA Recuperacion" = '' then
            GenJnlLine.Validate("Bal. Account No.", CuentaContable)
        else
            GenJnlLine.Validate("Bal. Account No.", GLSetup."Cta. Contable IVA Recuperacion");
        GenJnlLine.validate("Bal. VAT Prod. Posting Group", IVA);
        GenJnlLine.Modify();
        LastLine += 10000;

        // ahora hacemos el pago para que quede todo correcto
        GenJnlLine."Line No." := LastLine;
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::" ";
        GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        GenJnlLine."Bal. VAT Bus. Posting Group" := '';
        GenJnlLine."Bal. VAT Prod. Posting Group" := '';
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine.Validate(Amount, -GenJnlLine.Amount);
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := GenJnlLine."Document No.";

        GenJnlLine.Insert();
        LastLine += 10000;

    end;

    local procedure GetVendorNo(CuentaProveedor: text; CIFProveedor: Text): code[20]
    var
        GLSetup: Record "General Ledger Setup";
        Vendor: Record Vendor;
    begin
        GLSetup.Get();
        if Vendor.Get(CuentaProveedor) then
            exit(Vendor."No.");
        Vendor.Reset();
        Vendor.SetRange("VAT Registration No.", CIFProveedor);
        if Vendor.FindSet() then
            exit(Vendor."No.");

        exit(GLSetup."Proveedor IVA Recuperacion");

    end;

    local procedure InitValues(var IDFra: text; var txtFechaFra: Text; var FechaFra: date; IVA: text; var CuentaContable: text; var txtImporte: Text; var Importe: decimal; var CIFProveedor: text; var CuentaProveedor: text;
            var NombreFiscal: text; var Pais: text; var Divisa: text; var Direccion: text; var Localidad: text; var Provincia: text; var CPProveeor: text; var id60dias: text)
    var
        myInt: Integer;
    begin
        Clear(IDFra);
        clear(txtFechaFra);
        Clear(FechaFra);
        Clear(IVA);
        Clear(CuentaContable);
        Clear(txtImporte);
        Clear(Importe);
        Clear(CIFProveedor);
        Clear(CuentaProveedor);
        Clear(NombreFiscal);
        Clear(Pais);
        Clear(Divisa);
        Clear(Direccion);
        Clear(Localidad);
        clear(Provincia);
        Clear(CPProveeor);
        clear(id60dias);
    end;
}