pageextension 50227 "ZM Email Dialog" extends "Email Dialog"
{
    layout
    {
        // addafter(MessageContents)
        // {
        //     field("Language Code"; "Language Code")
        //     {
        //         ApplicationArea = all;
        //         trigger OnValidate()
        //         begin
        //             OnAction_changeLanguage();
        //         end;
        //     }
        // }
        // modify(SendTo)
        // {
        //     trigger OnAssistEdit()
        //     begin
        //         OnAssistEdit_SendTo();
        //     end;
        // }
    }


    actions
    {
        addlast(Processing)
        {
            action(changeLanguage)
            {
                ApplicationArea = all;
                Caption = 'Select Estandar Text', comment = 'ESP="Texto Estandar"';
                Image = TextFieldConfirm;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_changeLanguage();
                end;
            }
        }
    }

    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        PurchaseHeader: Record "Purchase Header";
        ExtendedTextHeader: Record "Extended Text Header";
        ExtendedTextList: page "Extended Text List";
        Eventosbtc: Codeunit Eventos_btc;
        lblConfirmEstandarText: Label '¿Desea Añadir %1 como contacto del %3?', comment = 'ESP="¿Desea Añadir %1 como contacto del %3?"';



    local procedure OnAction_changeLanguage()
    var
        BodyText: text;
    begin

        if Rec."Language Code" = xRec."Language Code" then
            exit;
        PurchaseSetup.Get();
        PurchaseSetup.TestField("Standard Text Code");
        if not PurchaseHeader.get(PurchaseHeader."Document Type"::Order, Rec."Order No") then
            exit;
        ExtendedTextHeader.SetRange("No.", PurchaseSetup."Standard Text Code");
        ExtendedTextList.SetTableView(ExtendedTextHeader);
        ExtendedTextList.LookupMode := true;
        if ExtendedTextList.RunModal() = Action::LookupOK then begin
            ExtendedTextList.GetRecord(ExtendedTextHeader);
            PurchaseHeader."Language Code" := ExtendedTextHeader."Language Code";
            Eventosbtc.getTextoEmailCompra(PurchaseHeader, BodyText);
            // CurrPage.BodyHTMLMessage.SetContent(BodyText);
        end;
    end;
}

