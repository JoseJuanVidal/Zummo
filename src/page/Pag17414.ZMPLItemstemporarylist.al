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
        }
    }
}
