page 17414 "ZM PL Items temporary list"
{
    ApplicationArea = All;
    Caption = 'Items temporary list', Comment = 'ESP="Lista Alta de productos"';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    SourceTable = "ZM PL Items temporary";
    Editable = false;
    UsageCategory = Lists;
    CardPageId = "ZM PL Items temporary card";

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
        area(Navigation)
        {
            action(ConfAltaProd)
            {
                ApplicationArea = all;
                Caption = 'Conf. Alta Productos', comment = 'ESP="Conf. Alta Productos"';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = page "ZM PL Setup Item registration";
            }
            action(ConfAprobAltaProd)
            {
                ApplicationArea = all;
                Caption = 'Conf. Departamentos Alta Productos', comment = 'ESP="Conf. Departamentos Alta Productos"';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = page "ZM PL Item Setup approvals";
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

    procedure SetShowPosted(Active: Boolean)
    begin
        ShowPosted := Active;
    end;

    local procedure OnAction_PostedItemList()
    var
        Itemstemporary: Record "ZM PL Items temporary";
        Itemstemporarylist: page "ZM PL Items temporary list";
    begin
        Itemstemporary.FilterGroup := 2;
        Itemstemporary.SetRange("State Creation", Itemstemporary."State Creation"::Finished);
        Itemstemporary.FilterGroup := 0;
        Itemstemporarylist.SetShowPosted(true);
        Itemstemporarylist.SetTableView(Itemstemporary);
        Itemstemporarylist.Run;
    end;

}
