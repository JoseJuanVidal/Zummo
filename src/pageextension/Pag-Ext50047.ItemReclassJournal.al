pageextension 50047 "ItemReclassJournal" extends "Item Reclass. Journal"
{
    actions
    {
        addafter("Bin Contents")
        {
            action(BinContentDestino)
            {
                ApplicationArea = All;
                Caption = 'Destination bin content', comment = 'ESP="Contenidos ubicación destino"';
                ToolTip = 'View items in the bin if the selected line contains a bin code.',
                    comment = 'ESP="Permite ver elementos en la ubicación si la línea seleccionada contiene un código de ubicación."';
                Image = BinContent;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "Bin Contents List";
                RunPageView = sorting("Location Code", "Bin Code", "Item No.", "Variant Code");
                RunPageLink = "Location Code" = field("New Location Code"), "Item No." = field("Item No."), "Variant Code" = field("Variant Code");
            }
        }
    }
}