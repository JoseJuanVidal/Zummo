tableextension 50188 "ZM FA Setup" extends "FA Setup"
{
    fields
    {
        Field(50101; "Path File Export"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Path File Export', comment = 'ESP="Directorio Exportar Ficheros"';

        }
    }

    procedure OnAssistEditPathFile()
    var
        FileManagement: Codeunit "File Management";
        RutaPdfPedidos_btc: Text;
        lbrutaLbl: Label 'Select Path', Comment = 'ESP="Seleccionar ruta"';
    begin
        Clear(FileManagement);
        if FileManagement.SelectFolderDialog(lbrutaLbl, RutaPdfPedidos_btc) then
            Rec."Path File Export" := RutaPdfPedidos_btc;
    end;
}