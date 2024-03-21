page 17386 "ZM API Visit log"
{
    APIGroup = 'zummoGroup';
    APIPublisher = 'zummo';
    APIVersion = 'v1.0';
    Caption = 'API Visit log';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'Visitlog';
    EntitySetName = 'Visitlogs';
    ODataKeyFields = "Entry No.";
    PageType = API;
    SourceTable = "ZM Visit log";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; "Entry No.")
                {
                    ApplicationArea = all;
                }
                field(Fechahoraentrada; "Fecha/hora entrada")
                {
                    ApplicationArea = all;
                }
                field(Fechahorasalida; "Fecha/hora salida")
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
                field(Autorizadopor; "Autorizado por")
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.InitLastNo();
    end;

    var
        txtFirma: text;
}