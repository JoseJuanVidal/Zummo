page 17216 "ZM Input Date"
{
    Caption = 'Introducir Fecha', comment = 'ESP="Introducir Fecha"';
    PageType = StandardDialog;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Fecha; Fecha)
                {
                    Caption = 'Fecha', comment = 'ESP="Fecha"';
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
        Fecha: Date;
        NotWorkdate: Boolean;

    procedure GetFecha(): Date
    var
    begin
        exit(Fecha);
    end;

    procedure SetNotWorkdate()
    var
        myInt: Integer;
    begin
        NotWorkdate := true;
    end;

}