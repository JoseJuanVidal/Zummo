page 50140 "Opciones_btc"
{

    PageType = Card;
    Caption = 'Opciones';

    layout
    {
        area(content)
        {
            field(RoutingNo; RoutingNo)
            {
                Visible = BoolRuta;
                TableRelation = "Routing Header"."No.";
                trigger OnValidate()
                begin
                    RoutingNoVersion := '';
                END;
            }
            field(RoutingNoVersion; RoutingNoVersion)
            {
                Visible = BoolRuta;
                trigger OnDrillDown()
                var
                    RoutingVersion: Record "Routing Version";
                    RoutingVersionP: Page "Routing Version List";
                begin
                    if RoutingNo = '' then
                        Error('Selecciona Ruta');
                    RoutingVersion.reset;
                    RoutingVersion.SetRange("Routing No.", RoutingNo);
                    RoutingVersion.FindSet();
                    Clear(RoutingVersionP);
                    RoutingVersionP.SetTableView(RoutingVersion);
                    IF RoutingVersionP.RUNMODAL <> ACTION::LookupOK THEN
                        EXIT;

                    RoutingVersionP.GetRecord(RoutingVersion);
                    RoutingNoVersion := RoutingVersion."Version Code";
                end;
            }
            field(ProductionBom; ProductionBom)
            {
                Visible = BoolBom;
                TableRelation = "Production BOM Header"."No.";
                trigger OnValidate()
                begin
                    ProductionBomVersion := '';
                END;

            }
            field(ProductionBomVersion; ProductionBomVersion)
            {
                Visible = BoolBom;
                trigger OnDrillDown()
                var
                    RoutingVersion: Record "Production BOM Version";
                    RoutingVersionP: Page "Production BOM Version";
                begin
                    if ProductionBom = '' then
                        Error('Selecciona Ruta');
                    RoutingVersion.reset;
                    RoutingVersion.SetRange("Production BOM No.", ProductionBom);
                    RoutingVersion.FindSet();
                    Clear(RoutingVersionP);
                    RoutingVersionP.SetTableView(RoutingVersion);
                    IF RoutingVersionP.RUNMODAL <> ACTION::LookupOK THEN
                        EXIT;

                    RoutingVersionP.GetRecord(RoutingVersion);
                    RoutingNoVersion := RoutingVersion."Version Code";
                end;
            }
            field(Almacen; Almacen)
            {
                Visible = BoolAlmacen;
                ApplicationArea = All;
                Caption = 'Almacen', comment = 'ESP="Almacen"';
                TableRelation = Location;
            }
            field(fecha; fecha)
            {
                Visible = BoolFecha;
                ApplicationArea = All;
                Caption = 'fecha', comment = 'ESP="Fecha"';
                //TableRelation = Location;
            }
            field(Cantidad; Cantidad) { }
        }
    }

    var
        RoutingNo: Code[20];
        RoutingNoVersion: code[20];
        ProductionBom: Code[20];
        ProductionBomVersion: code[20];
        BoolRuta: Boolean;
        BoolBom: Boolean;
        BoolAlmacen: boolean;
        Almacen: Code[20];
        fecha: Date;
        BoolFecha: Boolean;
        Cantidad: Integer;
        BoolCantidad: Boolean;


    procedure SetRoutingNo(l_RoutingNo: Code[20]; l_RoutingNoVersion: code[20])
    begin
        RoutingNo := l_RoutingNo;
        RoutingNoVersion := l_RoutingNoVersion;
        BoolRuta := true;
        BoolBom := false;
        BoolAlmacen := false;
        BoolFecha := false;
        BoolCantidad := false;
    end;

    procedure SetProductionBomVersion(l_ProductionBom: code[20]; l_ProductionBomVersion: code[20])
    begin
        ProductionBom := l_ProductionBom;
        ProductionBomVersion := l_ProductionBomVersion;
        BoolBom := true;
        BoolRuta := false;
        BoolAlmacen := false;
        BoolFecha := false;
        BoolCantidad := false;
    end;

    procedure SetAlmacen(l_Almacen: Code[20])
    begin
        Almacen := l_Almacen;
        BoolRuta := false;
        BoolBom := false;
        BoolAlmacen := true;
        BoolFecha := false;
        BoolCantidad := false;
    end;

    procedure SetFecha(l_fecha: Date)
    begin
        fecha := l_fecha;
        BoolRuta := false;
        BoolBom := false;
        BoolAlmacen := false;
        BoolFecha := true;
        BoolCantidad := false;
    end;

    procedure SetCantidad(l_cantidad: Integer)
    begin
        Cantidad := l_cantidad;
        BoolRuta := false;
        BoolBom := false;
        BoolAlmacen := false;
        BoolFecha := false;
        BoolCantidad := true;
    end;

    procedure GetCantidad(var l_Cantidad: Integer)
    begin
        l_Cantidad := Cantidad;

    end;

    procedure GetRoutingNo(var l_RoutingNo: Code[20]; var l_RoutingNoVersion: code[20])
    begin
        l_RoutingNo := RoutingNo;
        l_RoutingNoVersion := RoutingNoVersion;

    end;

    procedure GetFecha(var l_fecha: date)
    begin
        l_fecha := fecha;

    end;

    procedure GetAlmacen(var l_almacen: Code[20])
    begin
        l_almacen := Almacen;
    end;

    procedure GetProductionBomVersion(var l_ProductionBom: code[20]; var l_ProductionBomVersion: code[20])
    begin
        l_ProductionBom := ProductionBom;
        l_ProductionBomVersion := ProductionBomVersion;

    end;

}



