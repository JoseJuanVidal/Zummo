page 17425 "ZM Items temporary Review list"
{
    ApplicationArea = All;
    Caption = 'Items temporary Review list', Comment = 'ESP="Lista revision Alta de productos"';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    SourceTable = "ZM PL Items temporary";
    Editable = false;
    UsageCategory = Lists;
    CardPageId = "ZM Items temporary Review card";

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                // field(EnglishDescription; Rec.EnglishDescription)
                // {
                //     ApplicationArea = All;
                // }
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
            action(UpdateITBID)
            {
                ApplicationArea = All;
                Caption = 'ITBID Update', Comment = 'ESP="Alta/Actualización ITBID"';
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Itemstemporary: Record "ZM PL Items temporary";
                    IsUpdate: Boolean;
                    lblUpdate: Label 'Actualizada la plataforma ITBID', comment = 'ESP="Actualizada la plataforma ITBID"';
                begin
                    if not Confirm(lblConfirmUpdateITBID) then
                        exit;
                    CurrPage.SetSelectionFilter(Itemstemporary);
                    if Itemstemporary.FindFirst() then
                        repeat
                            if Itemstemporary.ITBIDUpdate() then
                                IsUpdate := true;
                        Until Itemstemporary.next() = 0;
                    if IsUpdate then
                        Message(lblUpdate);
                end;
            }
        }
        area(Navigation)
        {
            Group("Lista de materiales")
            {
                // group(AssemblyML)
                // {
                // action(ShowLMAssembly)
                // {
                //     ApplicationArea = all;
                //     Caption = 'L. M. Ensamblado', comment = 'ESP="L. M. Ensamblado"';
                //     Image = BOM;
                //     Promoted = true;
                //     PromotedCategory = Category4;
                //     trigger OnAction()
                //     begin
                //         Navigate_AssemblyML();
                //     end;
                // }
                // }
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
                action(PostedItemList)
                {
                    ApplicationArea = all;
                    Caption = 'Hist. Alta Productos', comment = 'ESP="Hist. Alta Productos"';
                    Image = PostedDeposit;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        OnAction_PostedItemList();
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
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup := 2;
        If ShowPosted then
            SetRange("State Creation", "State Creation"::Finished)
        else
            SetFilter("State Creation", '<>%1', Rec."State Creation"::Finished);
        Rec.FilterGroup := 0;
    end;

    var
        ShowPosted: Boolean;
        lblConfirmUpdateITBID: Label '¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?', comment = 'ESP="¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?"';

    procedure SetShowPosted(Active: Boolean)
    begin
        ShowPosted := Active;
    end;

    local procedure OnAction_PostedItemList()
    begin
        Navigate_PostedItemList();
    end;

}
