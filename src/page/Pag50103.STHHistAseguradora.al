page 50103 "STH Hist. Aseguradora"
{
    PageType = List;
    ApplicationArea = none;
    Caption = 'Hist. Aseguradora', comment = 'ESP="Hist. Aseguradora"';
    UsageCategory = Administration;
    SourceTable = "STH Hist. Aseguradora";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(CustomerNo; CustomerNo)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Name; Name)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(DateIni; DateIni)
                {
                    ApplicationArea = all;
                }
                field(Aseguradora; Aseguradora)
                {
                    ApplicationArea = all;
                }
                field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
                {
                    ApplicationArea = all;
                }
                field(DateFin; DateFin)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Revertir)
            {
                ApplicationArea = all;
                Caption = 'Revertir Historico', comment = 'ESP="Revertir Historico"';
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    HistAseguradora: Record "STH Hist. Aseguradora";
                    Funciones: Codeunit Funciones;
                    lblConfirm: Label '¿desea revertir la asegudara de %1 %2?', comment = '¿desea revertir la asegudara de %1 %2?';
                begin
                    CurrPage.SetSelectionFilter(HistAseguradora);
                    if not Confirm(lblConfirm, false, HistAseguradora.count, HistAseguradora.TableCaption) then
                        exit;
                    if rec.FindFirst() then
                        repeat
                            Funciones.RevertFinAseguradora(Rec);
                        until rec.Next() = 0;
                end;

            }
        }
    }

}

/*
page 50103 "ComentariosVarios"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = ComentariosVarios;
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Comentario_btc; Comentario_btc)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}*/
