page 17386 "ZM API Visit log"
{
    // APIGroup = 'zummoGroup';
    // APIPublisher = 'zummo';
    // APIVersion = 'v1.0';
    // Caption = 'API Visit log';    
    // ChangeTrackingAllowed = true;
    // DelayedInsert = true;
    // EntityName = 'Visitlog';
    // EntitySetName = 'Visitlog';
    // ODataKeyFields = "Entry No.";
    // PageType = API;
    SourceTable = "ZM Visit log";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(EntryNo; EntryNo)
                {
                    ApplicationArea = All;
                }
                field(Fechahora_entrada; "Fecha/hora entrada")
                {
                    ApplicationArea = all;
                }
                field(Fechahora_salida; "Fecha/hora salida")
                {
                    ApplicationArea = all;
                }
                field(Nombrecompleto; "Nombre completo")
                {
                    ApplicationArea = all;
                }
                field(Empresa; Empresa)
                {
                    ApplicationArea = all;
                }
                field(Trabajo; Trabajo)
                {
                    ApplicationArea = all;
                }
                field(Autorizado_por; "Autorizado por")
                {
                    ApplicationArea = all;
                }
                field(Estado; Estado)
                {
                    ApplicationArea = all;
                }
                field(Firma; txtFirma)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        EntryNo := Rec."Entry No.";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.InitLastNo();
    end;

    var
        txtFirma: text;
        EntryNo: Integer;
}