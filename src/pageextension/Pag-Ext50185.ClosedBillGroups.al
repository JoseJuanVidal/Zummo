pageextension 50185 "ClosedBillGroups" extends "Closed Bill Groups"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(Errors; "Payment Journal Errors Part")
            {
                ApplicationArea = All;
                Provider = Docs;
                Caption = 'File Export Errors', comment = 'ESP="Errores de exportación de archivo"';
                SubPageLink = "Journal Template Name" = FILTER(''),
                    "Journal Batch Name" = FILTER(7000007),
                    "Document No." = FIELD("Bill Gr./Pmt. Order No."),
                    "Journal Line No." = FIELD("Entry No.");
            }
        }
    }

    actions
    {
        addafter("&Navigate")
        {
            action(Export)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export to File', Comment = 'ESP="Exportar a archivo"';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Export a file with the payment information on the lines.', Comment = 'ESP="Exporta un archivo con la información de pago de las líneas."';

                trigger OnAction()
                var
                    DirectDebitCollection: Record "Direct Debit Collection";
                    DirectDebitCollectionEntry: Record "Direct Debit Collection Entry";
                    BankAccount: Record "Bank Account";
                begin
                    DirectDebitCollection.CreateNew("No.", "Bank Account No.", "Partner Type");
                    DirectDebitCollection."Source Table ID" := DATABASE::"Closed Bill Group";
                    DirectDebitCollection.MODIFY;
                    CheckSEPADirectDebitFormat(DirectDebitCollection);
                    BankAccount.GET("Bank Account No.");
                    COMMIT;
                    DirectDebitCollectionEntry.SETRANGE("Direct Debit Collection No.", DirectDebitCollection."No.");
                    RunFileExportCodeunit(50117, DirectDebitCollection."No.", DirectDebitCollectionEntry);

                    DeleteDirectDebitCollection(DirectDebitCollection."No.");
                end;
            }
        }
    }

    local procedure CheckSEPADirectDebitFormat(var DirectDebitCollection: Record "Direct Debit Collection")
    var
        BankAccount: Record "Bank Account";
        DirectDebitFormat: Option;
        Selection: Integer;
    begin
        BankAccount.GET("Bank Account No.");
        IF BankAccount.GetDDExportCodeunitID = CODEUNIT::"SEPA DD-Export File" THEN BEGIN
            IF NOT DirectDebitFormatSilentlySelected THEN BEGIN
                Selection := STRMENU(STRSUBSTNO('%1,%2', DirectDebitOptionTxt, InvoiceDiscountingOptionTxt), 1, InstructionTxt);

                IF Selection = 0 THEN
                    EXIT;

                CASE Selection OF
                    1:
                        DirectDebitFormat := DirectDebitCollection."Direct Debit Format"::Standard;
                    2:
                        DirectDebitFormat := DirectDebitCollection."Direct Debit Format"::N58;
                END;
            END ELSE
                DirectDebitFormat := SilentDirectDebitFormat;

            DirectDebitCollection."Direct Debit Format" := DirectDebitFormat;
            DirectDebitCollection.MODIFY;
        END;
    end;

    procedure RunFileExportCodeunit(CodeunitID: Integer; DirectDebitCollectionNo: Integer; var DirectDebitCollectionEntry: Record "Direct Debit Collection Entry")
    var
        LastError: Text;
    begin
        if not CODEUNIT.Run(CodeunitID, DirectDebitCollectionEntry) then begin
            LastError := GetLastErrorText;
            DeleteDirectDebitCollection(DirectDebitCollectionNo);
            Commit;
            Error(LastError);
        end;
    end;

    procedure DeleteDirectDebitCollection(DirectDebitCollectionNo: Integer)
    var
        DirectDebitCollection: Record "Direct Debit Collection";
    begin
        if DirectDebitCollection.Get(DirectDebitCollectionNo) then
            DirectDebitCollection.Delete(true);
    end;

    var
        DirectDebitFormatSilentlySelected: Boolean;
        DirectDebitOptionTxt: Label 'Direct Debit', Comment = 'ESP="Adeudo directo"';
        InvoiceDiscountingOptionTxt: Label 'Invoice Discounting', Comment = 'ESP="Operación de cesión de crédito"';
        InstructionTxt: Label 'Select which format to use.', Comment = 'ESP="Seleccione el formato que quiere usar."';
        SilentDirectDebitFormat: Option " ",Standard,N58;
        ExportToServerFile: Boolean;
}