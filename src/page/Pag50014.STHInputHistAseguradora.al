page 50014 "STH Input Hist Aseguradora"
{
    PageType = StandardDialog;
    ApplicationArea = none;
    UsageCategory = Administration;
    Caption = '', comment = '';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(FechaIni; FechaIni)
                {
                    ApplicationArea = All;
                    Editable = ShowIni;
                }
                field(FechaFin; FechaFin)
                {
                    ApplicationArea = all;
                    Visible = ShowFin;
                }
                field(Aseguradora; Aseguradora)
                {
                    ApplicationArea = all;
                    Editable = ShowIni;
                    TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(Tabla), TipoTabla = const(Aseguradora));
                }
                field(Suplemento; Suplemento)
                {
                    ApplicationArea = all;
                    Editable = ShowIni;
                }
                field(Importe; Importe)
                {
                    ApplicationArea = all;
                    Editable = ShowIni;
                }
            }
        }
    }

    var
        HistAseguradora: Record "STH Hist. Aseguradora";
        FechaIni: Date;
        FechaFin: date;
        Aseguradora: code[20];
        Suplemento: code[20];
        Importe: Decimal;
        ShowIni: Boolean;
        ShowFin: Boolean;
        lblFin: Label 'Finalizar Credito', comment = 'ESP="Finalizar Credito"';

    procedure SetDatos(Customer: Record Customer)
    begin
        if ShowFin then begin
            HistAseguradora.SetRange(CustomerNo, Customer."No.");
            HistAseguradora.SetRange(Aseguradora, Customer."Cred_ Max_ Aseg. Autorizado Por_btc");
            if HistAseguradora.FindLast() then begin
                FechaIni := HistAseguradora.DateIni;
            end;
            Aseguradora := Customer."Cred_ Max_ Aseg. Autorizado Por_btc";
            Importe := Customer."Credito Maximo Aseguradora_btc";
            FechaFin := WorkDate();
        end;
    end;

    procedure SetShowIni()
    begin
        ShowIni := true;
    end;

    procedure SetShowFin()
    begin
        ShowFin := true;
        FechaFin := workdate;
        CurrPage.Caption := lblFin;
    end;

    procedure GetDateFin(): Date
    begin
        exit(FechaFin);
    end;

    procedure GetDatos(var Aseg: code[20]; var Imp: Decimal; var Ini: Date; Suple: code[20])
    begin
        Aseg := Aseguradora;
        Imp := Importe;
        ini := FechaIni;
        Suple := Suplemento;
    end;
}