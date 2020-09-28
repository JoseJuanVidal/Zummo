pageextension 50004 "PostedSalesInvoice" extends "Posted Sales Invoice"
{
    //Guardar Nº asiento y Nº documento


    layout
    {
        addafter("Salesperson Code")
        {
            field(Peso_btc; Peso_btc) { }
            field(NumPalets_btc; NumPalets_btc) { }
            field(NumBultos_btc; NumBultos_btc) { }
            field(CorreoEnviado_btc; CorreoEnviado_btc) { }
            field(FacturacionElec_btc; FacturacionElec_btc) { }
            field(AreaManager_btc; AreaManager_btc) { }


        }
        addafter("Pre-Assigned No.")
        {
            field(NumAsiento_btc; NumAsiento_btc)
            {
                ApplicationArea = All;
            }
        }

        modify("External Document No.")
        {
            Editable = true;
        }
        modify("Work Description")
        {
            Editable = true;
        }
    }
    actions
    {
        addfirst(Processing)
        {

            action("Cambiar Doc. Externo")
            {
                ApplicationArea = all;
                Caption = 'Cambiar Doc. Externo', comment = 'ESP="Cambiar Doc. Externo"';
                ToolTip = 'Cambiar Doc. Externo',
                    comment = 'ESP="Cambiar Doc. Externo"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Balance;

                trigger OnAction()
                var
                    PediDatos: Page "Posted Sales Invoice Change";
                    Funciones: Codeunit Funciones;
                    ExtDocNo: Text[35];
                    WorkDescription: text;
                    AreaManager: Code[20];
                begin
                    PediDatos.LookupMode := true;
                    PediDatos.SetDatos(rec);
                    if PediDatos.RunModal() = Action::LookupOK then begin
                        PediDatos.GetDatos(ExtDocNo, WorkDescription, AreaManager);
                        Funciones.ChangeExtDocNoPostedSalesInvoice("No.", ExtDocNo, WorkDescription, AreaManager);
                    end;
                end;

            }


            action("Pesos y Bultos")
            {
                ApplicationArea = all;
                Caption = 'Pesos y Bultos', comment = 'ESP="Pesos y Bultos"';
                ToolTip = 'Pesos y Bultos',
                    comment = 'ESP="Pesos y Bultos"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Balance;

                trigger OnAction()
                var
                    pageAbrir: Page RegistrarEnvio;
                    peso: Decimal;
                    numPalets: Integer;
                    numBultos: Integer;
                begin
                    Clear(pageAbrir);
                    pageAbrir.LookupMode(true);
                    pageAbrir.SetEnvioOrigen('', Rec."No.", '');

                    if pageAbrir.RunModal() = Action::LookupOK then begin
                        pageAbrir.GetDatos(peso, numPalets, numBultos);

                        NumBultos_btc := numBultos;
                        NumPalets_btc := numPalets;
                        Peso_btc := peso;
                        pageAbrir.SetDatos(Peso_btc, NumPalets_btc, NumBultos_btc);

                    end;
                end;
            }

        }

        addafter(DocAttach)
        {
            action(InsertarComentariosPredefinidos)
            {
                ApplicationArea = All;
                Image = NewProperties;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Insert predefined comments', comment = 'ESP="Insertar comentarios predefinidos"';
                ToolTip = 'Insert the comments in the table of predefined comments as order comments',
                    comment = 'ESP="Inserta como comentarios de pedido los comentarios que haya en la tabla de comentarios predefinidos"';

                trigger OnAction()
                var
                    recComentario: Record ComentariosPredefinidos;
                    pageComentarios: page "Lista comentarios predefinidos";
                begin
                    clear(pageComentarios);
                    pageComentarios.LookupMode(true);

                    if pageComentarios.RunModal() = Action::LookupOK then begin
                        pageComentarios.GetRecord(recComentario);
                        SetWorkDescription(recComentario.GetComentario());
                    end;
                end;
            }
        }

        addafter(Email)
        {
            action(Email_btc)
            {
                ApplicationArea = All;
                Image = Email;
                Promoted = true;
                PromotedCategory = Category6;
                Caption = '&Email', comment = 'ESP="&Correo electrónico"';
                trigger onAction()
                var
                    cduCron: Codeunit CU_Cron;
                begin
                    cduCron.EnvioPersonalizado(Rec);
                end;
            }

        }
        modify(Email)
        {
            Visible = false;
        }

        modify(SendCustom)
        {
            Visible = false;
        }
    }

    local procedure SetWorkDescription(NewWorkDescription: Text)
    var
        TempBlob: Record TempBlob temporary;
    begin
        CLEAR("Work Description");

        IF NewWorkDescription = '' THEN
            EXIT;

        TempBlob.Blob := "Work Description";
        TempBlob.WriteAsText(NewWorkDescription, TEXTENCODING::UTF8);
        "Work Description" := TempBlob.Blob;

        MODIFY;
    end;
}