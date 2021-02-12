pageextension 50057 "STH General JournalExt" extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            action(ImportNominas)
            {
                ApplicationArea = all;
                Caption = 'Importar Nominas', comment = 'ESP="Importar Nominas"';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                begin
                    Funciones.CargaFicheroNominas(rec."Journal Batch Name", rec."Journal Template Name");
                end;
            }
        }
    }

    var
        myInt: Integer;
}