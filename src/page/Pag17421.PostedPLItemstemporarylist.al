page 17421 "Posted PL Items temporary list"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Posted Items temporary list', Comment = 'ESP="Histórico Alta de productos"';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    SourceTable = "Posted PL Items temporary";
    Editable = false;
    CardPageId = "Posted PL Items temporary card";

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
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(EnglishDescription; Rec.EnglishDescription)
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("State Creation"; "State Creation")
                {
                    ApplicationArea = all;
                }
                field("ITBID Status"; "ITBID Status")
                {
                    ApplicationArea = all;
                }
                field("Assembly BOM"; Rec."Assembly BOM")
                {
                    ApplicationArea = All;
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Color; Rec.Color)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Alto; Rec.Alto)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Ancho; Rec.Ancho)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Largo; Rec.Largo)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Packaging; Rec.Packaging)
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
            action(SendAltaproducto)
            {
                ApplicationArea = all;
                Caption = 'Confirmación Alta', comment = 'ESP="Confirmación Alta"';
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea Volver a enviar el email Confirmación Alta?', comment = 'ESP="¿Desea Volver a enviar el email Confirmación Alta?"';
                begin
                    if Confirm(lblConfirm) then
                        Rec.SendMailItemTemporaryFinalize();
                end;
            }
        }
        area(Navigation)
        {
            Group("Lista de materiales")
            {
                group(LMProducion)
                {
                    Caption = 'Producción', comment = 'ESP="Producción"';
                    action(ShowLMProduction)
                    {
                        ApplicationArea = all;
                        Caption = 'L. M. Producción', comment = 'ESP="L. M. Producción"';
                        Image = BOM;
                        Promoted = true;
                        PromotedCategory = Category4;
                        trigger OnAction()
                        begin
                            Navigate_ProductionML();
                        end;
                    }
                }
                action(PurchasePrices)
                {
                    ApplicationArea = all;
                    Caption = 'Purchases prices', comment = 'ESP="Precios Compra"';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    begin
                        Navigate_PurchasesPrices();
                    end;
                }
            }
            action(Translations)
            {
                ApplicationArea = all;
                Caption = 'Traducciones', comment = 'ESP="Traducciones"';
                Image = Translations;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = page "ZM Item Translation temporary";
                RunPageView = sorting("Item No.");
                RunPageLink = "Item No." = field("No.");
            }
            action(ItemApprovalsDept)
            {
                ApplicationArea = all;
                Caption = 'Approvals', comment = 'ESP="Aprobaciones"';
                Image = Translations;
                RunObject = page "Item Approval Departments";
                RunPageLink = "Request No." = field("No.");
            }
            action(ChangeLogEntries)
            {
                ApplicationArea = all;
                Caption = 'Change Log Entries', comment = 'ESP="Mov. registro cambios"';
                Image = ChangeLog;

                trigger OnAction()
                var
                    ChangeLogEntry: Record "Change Log Entry";
                    ChangeLogEntries: page "Change Log Entries";
                begin
                    ChangeLogEntry.SetRange("Record ID", Rec.RecordId);
                    ChangeLogEntries.SetTableView(ChangeLogEntry);
                    ChangeLogEntries.Run();
                end;

            }
        }
    }

    trigger OnOpenPage()
    begin
        // Rec.FilterGroup := 2;
        // If ShowPosted then
        //     SetRange("State Creation", "State Creation"::Finished)
        // else
        //     SetFilter("State Creation", '<>%1', Rec."State Creation"::Finished);
        // Rec.FilterGroup := 0;
    end;

    var
        ShowPosted: Boolean;
        lblConfirmUpdateITBID: Label '¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?', comment = 'ESP="¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?"';

    procedure SetShowPosted(Active: Boolean)
    begin
        ShowPosted := Active;
    end;
}

