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
        }
    }

    var
        LanguageFilter: code[10];
}
