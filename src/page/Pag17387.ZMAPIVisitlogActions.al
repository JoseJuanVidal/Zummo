page 17387 "ZM API Visit log Actions"
{
    APIGroup = 'zummoGroup';
    APIPublisher = 'zummo';
    APIVersion = 'v1.0';
    Caption = 'API Visit log';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'VisitlogAction';
    EntitySetName = 'VisitlogsAction';
    ODataKeyFields = "Entry No.";
    PageType = API;
    SourceTable = "ZM Visit log";
    SourceTableTemporary = true;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(EntryNo; "Entry No.")
                {
                    ApplicationArea = all;
                }
                field(action; action)
                {
                    ApplicationArea = all;
                }
                field(result; result)
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
        GetResult();
    end;

    var
        Visitlog: Record "ZM Visit log";
        txtFirma: text;
        action: text;
        result: Text;
        lblSucces: Label 'Succes', comment = 'ESP="Realizado"';

    local procedure GetResult()
    var
        myInt: Integer;
    begin
        case action of
            'PATCH':
                begin
                    if ExistEntryno() then begin
                        // Visitlog.TransferFields(Rec);
                        Visitlog."Fecha/hora entrada" := Rec."Fecha/hora entrada";
                        Visitlog."Fecha/hora salida" := Rec."Fecha/hora salida";
                        Visitlog.Estado := Rec.Estado;
                        Visitlog."Nombre completo" := Rec."Nombre completo";
                        Visitlog.Empresa := Rec.Empresa;
                        Visitlog.Trabajo := Rec.Trabajo;
                        Visitlog."Autorizado por" := Rec."Autorizado por";
                        Visitlog.Modify();
                        Result := lblSucces;
                    end;
                end;
            'DELETE':
                begin
                    if ExistEntryno() then begin
                        Visitlog.Delete();
                        Result := lblSucces;
                    end;
                end;
            else
                Result := 'Error';
        end;
    end;

    local procedure ExistEntryno(): Boolean
    var
        myInt: Integer;
    begin
        Visitlog.Reset();
        if Visitlog.Get(Rec."Entry No.") then
            exit(true);
    end;
}