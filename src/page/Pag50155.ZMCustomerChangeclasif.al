page 50155 "ZM Customer Change clasif."
{
    PageType = Card;
    Caption = 'Customer Change clasification', comment = 'ESP="Clientes cambiar datos clasificación"';
    //ApplicationArea = All;
    UsageCategory = None;
    //SourceTable = TableName;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(CentralCompras_btc; CentralCompras_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Central Compras"), TipoRegistro = const(Tabla));
                    Caption = 'Central Compras', comment = 'ESP="Central Compras"';
                }
                field(ClienteCorporativo_btc; ClienteCorporativo_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Cliente Corporativo"), TipoRegistro = const(Tabla));
                    Caption = 'Cliente Corporativo', comment = 'ESP="Cliente Corporativo"';

                }
                field(AreaManager_btc; AreaManager_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("AreaManager"), TipoRegistro = const(Tabla));
                    Caption = 'Area Manager', comment = 'ESP="Area Manager"';

                }
                field(Delegado_btc; Delegado_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Delegado"), TipoRegistro = const(Tabla));
                    Caption = 'Delegado', comment = 'ESP="Delegado"';

                }
                field(GrupoCliente_btc; GrupoCliente_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("GrupoCliente"), TipoRegistro = const(Tabla));
                    Caption = 'Cliente Tipo', comment = 'ESP="Cliente Tipo"';
                }
                field(Perfil_btc; Perfil_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Perfil"), TipoRegistro = const(Tabla));
                    Caption = 'Perfil', comment = 'ESP="Perfil"';
                }
                field(SubCliente_btc; SubCliente_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("SubCliente"), TipoRegistro = const(Tabla));
                    Caption = 'SubCliente', comment = 'ESP="SubCliente"';
                }
                field(ClienteReporting_btc; ClienteReporting_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClienteReporting"), TipoRegistro = const(Tabla));
                    Caption = 'Cliente Reporting', comment = 'ESP="Cliente Reporting"';
                }
                field(ClienteActividad_btc; ClienteActividad_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(ClienteActividad), TipoRegistro = const(Tabla));
                    Caption = 'Activity Customer', comment = 'ESP="Cliente Actividad"';
                }
                field(InsideSales_btc; InsideSales_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("InsideSales"), TipoRegistro = const(Tabla));
                    Caption = 'Inside Sales', comment = 'ESP="Inside Sales"';
                }
                field(Canal_btc; Canal_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Canal"), TipoRegistro = const(Tabla));
                    Caption = 'Canal', comment = 'ESP="Canal"';
                }
                field(Mercado_btc; Mercado_btc)
                {
                    ApplicationArea = All;
                    TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Mercados), TipoRegistro = const(Tabla));
                    Caption = 'Mercado', comment = 'ESP="Mercado"';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Caption := StrSubstNo(lblTitol, NumCustomer);
    end;

    var
        NumCustomer: Integer;
        CentralCompras_btc: Code[20];
        ClienteCorporativo_btc: Code[20];
        AreaManager_btc: Code[20];
        Delegado_btc: Code[20];
        GrupoCliente_btc: Code[20];
        Perfil_btc: Code[20];
        SubCliente_btc: Code[20];
        ClienteReporting_btc: Code[20];
        ClienteActividad_btc: Code[20];
        InsideSales_btc: Code[20];
        Canal_btc: Code[20];
        Mercado_btc: Code[20];
        lblTitol: Label '%1 customers have been selected', comment = 'ESP="Se han seleccionado %1 clientes"';



    procedure GetDatos(var vCentralCompras_btc: Code[20]; var vClienteCorporativo_btc: Code[20]; var vAreaManager_btc: Code[20]; var vDelegado_btc: Code[20]; var vGrupoCliente_btc: Code[20];
           var vPerfil_btc: Code[20]; var vSubCliente_btc: Code[20]; var vClienteReporting_btc: Code[20]; var vClienteActividad_btc: Code[20]; var vInsideSales_btc: Code[20];
           var vCanal_btc: Code[20]; var vMercado_btc: Code[20])
    var
    begin
        vCentralCompras_btc := CentralCompras_btc;
        vClienteCorporativo_btc := ClienteCorporativo_btc;
        vAreaManager_btc := AreaManager_btc;
        vDelegado_btc := Delegado_btc;
        vGrupoCliente_btc := GrupoCliente_btc;
        vPerfil_btc := Perfil_btc;
        vSubCliente_btc := SubCliente_btc;
        vClienteReporting_btc := ClienteReporting_btc;
        vClienteActividad_btc := ClienteActividad_btc;
        vInsideSales_btc := InsideSales_btc;
        vCanal_btc := Canal_btc;
        vMercado_btc := Mercado_btc;
    end;

    procedure SetNumCustomer(CountCustomer: Integer)
    begin
        NumCustomer := CountCustomer;
    end;

}