page 17216 "ZM Input Date"
{
    Caption = 'Introducir Valor', comment = 'ESP="Introducir Valor"';
    PageType = StandardDialog;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(FieldCaption; FieldCaption)
                {
                    ApplicationArea = all;
                    Visible = ShowFieldName;
                    Editable = false;
                    ShowCaption = false;
                }
                field(Fecha; Fecha)
                {
                    Caption = 'Fecha', comment = 'ESP="Fecha"';
                    Visible = ShowFecha;
                }
                field(Texto; Texto)
                {
                    Caption = 'Texto', comment = 'ESP="Texto"';
                    Visible = ShowTexto;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not NotWorkdate then
            Fecha := WorkDate();
    end;

    var
        FieldCaption: text;
        Fecha: Date;
        Texto: Text;
        NotWorkdate: Boolean;
        ShowFecha: Boolean;
        ShowTexto: Boolean;
        ShowFieldName: Boolean;


    procedure GetFecha(): Date
    var
    begin
        exit(Fecha);
    end;

    procedure SetFecha(valor: Date)
    begin
        if valor <> 0D then
            Fecha := valor;
    end;

    procedure SetNotWorkdate()
    var
        myInt: Integer;
    begin
        HideAll();
        ShowFecha := true;
        NotWorkdate := true;
    end;

    procedure SetTexto(valor: text; Caption: text)
    begin
        HideAll();
        ShowTexto := true;
        if Caption <> '' then begin
            FieldCaption := Caption;
            ShowFieldName := true;
        end;
        if valor <> '' then
            Texto := valor;
    end;

    procedure GetTexto(): Text
    begin
        exit(Texto);
    end;

    local procedure HideAll()
    var
        myInt: Integer;
    begin
        ShowFecha := false;
        ShowTexto := false;
        ShowFieldName := false;
    end;

}