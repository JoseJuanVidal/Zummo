pageextension 50112 "SalesSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Dynamics 365 for Sales")
        {
            group(Bitec)
            {
                Caption = 'Bitec', comment = 'ESP="Bitec"';

                group(Repuestos)
                {
                    Caption = 'Replacements', comment = 'ESP="Repuestos"';

                    field(PmtTermsRepuesto_btc; PmtTermsRepuesto_btc)
                    {
                        ApplicationArea = All;
                    }

                    field(PmtMethodRepuesto_btc; PmtMethodRepuesto_btc)
                    {
                        ApplicationArea = All;
                    }

                    field(ClasificacionRepuesto_btc; OptClasificacionRepuesto_btc)
                    {
                        ApplicationArea = All;
                    }
                }

                field(NumDiasAvisoVencimiento_btc; NumDiasAvisoVencimiento_btc)
                {
                    ApplicationArea = All;
                }
                field(NumDiasAvisoVencido_btc; NumDiasAvisoVencido_btc)
                {
                    ApplicationArea = all;
                }

                field(RutaPdfPedidos_btc; RutaPdfPedidos_btc)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        FileManagement: Codeunit "File Management";
                        lbrutaLbl: Label 'Select Path', Comment = 'ESP="Seleccionar ruta"';
                    begin
                        Clear(FileManagement);
                        FileManagement.SelectFolderDialog(lbrutaLbl, RutaPdfPedidos_btc);
                    end;
                }
                field(CalendarioOfertas; CalendarioOfertas)
                {
                    ApplicationArea = all;
                }
                field(CodProvinciaDefecto_btc; CodProvinciaDefecto_btc)
                {
                    ApplicationArea = All;
                }
                field(DiasVtoAseguradora; DiasVtoAseguradora)
                {
                    ApplicationArea = all;
                }
                field(LanguageFilter; LanguageFilter)
                {
                    ApplicationArea = all;
                }
            }
            group("Zummo IC")
            {
                Caption = 'Zummo Intercompany', Comment = 'Zummo Intercompany';

                field("WS User Id"; Rec."WS User Id")
                {
                    ApplicationArea = All;
                }
                field("WS Key"; Rec."WS Key")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("Base URL IC Zummo Innc."; Rec."WS Base URL IC Zummo Innc.")
                {
                    ApplicationArea = All;
                }
                field("WS Name - Purch. Order Header"; Rec."WS Name - Purch. Order Header")
                {
                    ApplicationArea = All;
                }
                field("WS Name - Purch. Order Line"; Rec."WS Name - Purch. Order Line")
                {
                    ApplicationArea = All;
                }
                field("Send Mail Notifications"; Rec."Send Mail Notifications")
                {
                    ApplicationArea = All;
                }
                field("Rept. Mail Notifications"; Rec."Recipient Mail Notifications")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = EMail;
                }

            }
        }
    }

    actions
    {
        addafter("Customer Disc. Groups")
        {
            action(ComentariosPredefinidos)
            {
                Caption = 'Predefined Comments', comment = 'ESP="Comentarios predefinidos"';
                tooltip = 'Open a page where predefined comments can be inserted',
                    comment = 'ESP="Abre una página donde pueden insertarse los comentarios predefinidos"';
                ApplicationArea = All;
                promoted = True;
                promotedisbig = true;
                promotedcategory = Category4;
                image = ViewComments;
                RunObject = Page "Lista comentarios predefinidos";
            }
            action(ponerClienteReporting)
            {
                ApplicationArea = all;
                Image = Customer;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                begin
                    Funciones.ChangeSalesHeader;
                end;
            }
        }
    }
}
