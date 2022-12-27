page 50055 "ZM CIM Items"
{
    ApplicationArea = All;
    Caption = 'CIM Items Pending', comment = 'ESP="CIM Productos pendientes"';
    PageType = List;
    SourceTable = "ZM CIM Items temporary";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(EnglishDescription; EnglishDescription)
                {
                    ApplicationArea = all;
                }
                field(Material; Material)
                {
                    ApplicationArea = all;
                }
                field("Assembly BOM"; "Assembly BOM")
                {
                    ApplicationArea = all;
                }
                field("Production BOM No."; "Production BOM No.")
                {
                    ApplicationArea = all;
                }
                field("Routing No."; "Routing No.")
                {
                    ApplicationArea = all;
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field(Packaging; packaging)
                {
                    ApplicationArea = all;
                }
                field(Color; Color)
                {
                    ApplicationArea = all;
                }
                field(Inventory; Inventory)
                {
                    ApplicationArea = all;
                }
                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = all;
                }
                field("Unit Volume"; "Unit Volume")
                {
                    ApplicationArea = all;
                }
                field(largo; largo)
                {
                    ApplicationArea = all;
                }
                field(Ancho; Ancho)
                {
                    ApplicationArea = all;
                }
                field(Alto; Alto)
                {
                    ApplicationArea = all;
                }
            }
            part(Header; "ZM Production BOM List")
            {
                ApplicationArea = all;
                // SubPageLink = "No." = field("Production BOM No.");
            }
            part(BomLines; "ZM CIM Production BOM Lines")
            {
                Caption = 'Components Lines', comment = 'ESP="Lista componentes"';
                ApplicationArea = all;
                //  SubPageLink = "No." = field("Production BOM No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CopyItem)
            {
                ApplicationArea = all;
                Caption = 'Copiar producto', comment = 'ESP="Copiar producto"';
                Image = CopyItem;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    actionCopyItem;
                end;
            }
        }
    }

    local procedure actionCopyItem()
    begin
        Rec.CopyItem;
    end;
}
