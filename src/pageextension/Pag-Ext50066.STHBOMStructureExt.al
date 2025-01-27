pageextension 50066 "STH BOM StructureExt" extends "BOM Structure"
{
    layout
    {
        addafter(ItemFilter)
        {
            field(LanguageFilter; LanguageFilter)
            {
                Caption = 'Language Filter', comment = 'Filtro Idioma';
                TableRelation = Language;

                trigger OnValidate()
                begin
                    Rec.SetRange("Language Filter", LanguageFilter);
                    CurrPage.Update();
                end;
            }
        }
        addafter(Description)
        {
            field("Description Language"; "Description Language")
            {
                ApplicationArea = all;
            }
            field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Recycled plastic %"; "Recycled plastic %")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Packing Plastic Qty. (kg)"; "Packing Plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Packing Recycled plastic (kg)"; "Packing Recycled plastic (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Packing Recycled plastic %"; "Packing Recycled plastic %")
            {
                ApplicationArea = all;
                Visible = false;
            }

            field(Steel; Steel)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Carton; Carton)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Wood; Wood)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Costing Method"; "Costing Method")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Item Unit Cost"; "Item Unit Cost")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Standar Cost"; "Standar Cost")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Average cost last year"; "Average cost last year")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("SubCategory Code"; "SubCategory Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("Show Warnings")
        {
            action(CalculatePlastic)
            {
                ApplicationArea = all;
                Caption = 'Calculate Plastic BOM', comment = 'ESP="Calcular peso plastico L.M."';
                Image = CalculateHierarchy;
                // Promoted = true;
                // PromotedCategory = New;

                trigger OnAction()
                begin
                    CalculatePlastic;
                end;

            }
        }
    }
    var
        LanguageFilter: code[10];

    local procedure CalculatePlastic()
    var
        Item: Record Item;
        Funciones: Codeunit Funciones;
        lblConfirm: Label '¿Desea calcular la cantidad del plastico de la L.M. del producto %1?', comment = '¿Desea calcular la cantidad del plastico de la L.M. del producto %1?';
    begin
        if Rec.Type in [Rec.Type::Item] then
            if Item.Get(Rec."No.") then
                if Confirm(lblConfirm, false, Rec."No.") then
                    Funciones.PlasticCalculateItem(Item);
    end;
}
