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
        }
    }

    var
        LanguageFilter: code[10];
}
