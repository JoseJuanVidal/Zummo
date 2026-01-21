pageextension 50228 "ZM Extended Text" extends "Extended Text"
{
    layout
    {
        addlast(Content)
        {
            group(Signature)
            {
                Caption = 'Signature', comment = 'ESP="Firma"';
                field(Signaturetext; Signaturetext)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    MultiLine = true;
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        Rec.SetSignature(Signaturetext);
                    end;
                }
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(UploadFile)
            {
                ApplicationArea = all;
                Caption = 'Upload Signature', comment = 'ESP="Cargar Firma"';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Upload_Signature();
                end;
            }
            action(DeleteSignature)
            {
                ApplicationArea = all;
                Caption = 'Delete Signature', comment = 'ESP="Borrar Firma"';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm(lblConfirm) then
                        Clear_Signature();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Signaturetext := Rec.GetSignature();
    end;


    var
        Signaturetext: Text;
        FromFile: Text;
        InStr: InStream;
        OutStr: OutStream;
        FromFolder: text;
        DialogTitle: Label 'Seleccionar Fichero', comment = 'ESP="Seleccionar Fichero"';
        FromFilter: Label 'All Files (*.*)|*.*', comment = 'ESP="Todos Ficheros (*.*)|*.*"';
        lblConfirm: Label '¿Desea eliminar la Firma?', comment = 'ESP="¿Desea elimiinar la firma?="';


    local procedure Upload_Signature()
    var
    begin
        if UploadIntoStream(DialogTitle, FromFolder, FromFilter, FromFile, InStr) then begin
            Rec.Signature.CreateOutStream(OutStr);
            CopyStream(OutStr, InStr);
            Rec.Modify();
        end;
    end;

    local procedure Clear_Signature()
    var
        myInt: Integer;
    begin
        Rec.CalcFields(Signature);
        clear(Rec.Signature);
        Rec.Modify();
    end;
}