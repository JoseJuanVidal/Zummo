page 17209 "ZZM Customer List Edit"
{
    ApplicationArea = All;
    Caption = 'Customer List Edit', Comment = 'ESP="Lista editar clientes"';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {

            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Importe Facturas"; "Importe Facturas")
                {
                    ApplicationArea = all;
                }
                field(CodMotivoBloqueo_btc; Rec.CodMotivoBloqueo_btc)
                {
                    ApplicationArea = All;
                }
                field(CentralCompras_btc; Rec.CentralCompras_btc)
                {
                    ApplicationArea = All;
                }
                field(ClienteCorporativo_btc; Rec.ClienteCorporativo_btc)
                {
                    ApplicationArea = All;
                }
                field(Perfil_btc; Perfil_btc)
                {
                    ApplicationArea = all;
                }
                field(AreaManager_btc; AreaManager_btc)
                {
                    ApplicationArea = all;
                }
                field(InsideSales_btc; Rec.InsideSales_btc)
                {
                    ApplicationArea = All;
                }
                field(Canal_btc; Rec.Canal_btc)
                {
                    ApplicationArea = All;
                }
                field(Mercado_btc; Rec.Mercado_btc)
                {
                    ApplicationArea = All;
                }
                field(Delegado_btc; Rec.Delegado_btc)
                {
                    ApplicationArea = All;
                }
                field(GrupoCliente_btc; GrupoCliente_btc)
                {
                    ApplicationArea = all;
                }
                field(ClienteActividad_btc; ClienteActividad_btc)
                {
                    ApplicationArea = all;
                }
                field(SubCliente_btc; Rec.SubCliente_btc)
                {
                    ApplicationArea = All;
                }
                field(ClienteReporting_btc; Rec.ClienteReporting_btc)
                {
                    ApplicationArea = All;
                }
                field("ABC Cliente"; "ABC Cliente")
                {
                    ApplicationArea = all;
                }

                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Descuento1_btc; Rec.Descuento1_btc)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Descuento2_btc; Rec.Descuento2_btc)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dto. Exprimidores"; Rec."Dto. Exprimidores")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dto. Isla"; Rec."Dto. Isla")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dto. Repuestos"; Rec."Dto. Repuestos")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dto. Viva"; Rec."Dto. Viva")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(CorreoFactElec_btc; Rec.CorreoFactElec_btc)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ChangeClasification)
            {
                ApplicationArea = all;
                Caption = 'Change Clasification', comment = 'ESP="Cambiar datos clasificación"';
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActionChangeClasification();
                end;
            }
        }

    }
    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Edit Customer List" then
                exit;

        Error(lblError, UserId);
    end;

    var
        UserSetup: Record "User Setup";
        lblError: Label 'User %1 is not authorised for this page. Notify System Administration', comment = 'ESP="El usuario %1 no está autorizado para está pagina. Avise a Administración del sistema"';

    local procedure ActionChangeClasification()
    var
        Customer: Record Customer;
        Functions: Codeunit Funciones;
    begin
        // llamamos a función de cambiar datos, con la selección de clientes de la PAGE
        Customer.Reset();
        CurrPage.SetSelectionFilter(Customer);
        Functions.CustomerChangeClasification(Customer);

    end;
}
