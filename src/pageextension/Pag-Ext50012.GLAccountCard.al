pageextension 50012 "GLAccountCard" extends "G/L Account Card"
{

    layout
    {
        addafter("Account Type")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
        }
    }
    //181219 S19/01415 Duplicar cuenta contable
    actions
    {
        addafter("Where-Used List")
        {
            action(Copiar)
            {
                ApplicationArea = All;
                Image = Copy;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                Caption = 'Copy G/L Account', comment = 'ESP="Copiar Cuenta"';
                ToolTip = 'Generate a new account with the data of this', comment = 'ESP="Genera una nueva cuenta con los datos de esta"';

                trigger OnAction()
                var
                    recNewCuenta: Record "G/L Account";
                    recCuenta2: Record "G/L Account";
                    pageCopiar: Page CopiarCuent;
                    codCuenta: Code[20];
                    nombreCuenta: Text[100];
                    lbCuentaCreadaMsg: Label 'Account: %1 created successfully', comment = 'ESP="Cuenta: %1 creada correctamente"';
                begin
                    Clear(pageCopiar);
                    pageCopiar.LookupMode(true);
                    pageCopiar.SetProductoOrigen("No.");

                    if pageCopiar.RunModal() = Action::LookupOK then begin
                        pageCopiar.GetDatos(codCuenta, nombreCuenta);

                        recCuenta2.RESET();
                        recCuenta2 := Rec;
                        recCuenta2."No." := codCuenta;
                        recCuenta2.Validate(Name, nombreCuenta);
                        recCuenta2.Insert();

                        Commit();

                        Message(StrSubstNo(lbCuentaCreadaMsg, codCuenta));

                        recNewCuenta.reset();
                        recNewCuenta.SetRange("No.", codCuenta);

                        page.RunModal(page::"G/L Account Card", recNewCuenta);
                    end;
                end;
            }
            action(Translations)
            {
                //171241
                ApplicationArea = all;
                Caption = 'Translations', Comment = 'Traducciones';
                Image = Translations;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                RunObject = Page "Account Translations";
                RunPageLink = "G/L Account No." = FIELD("No.");
                ToolTip = 'View or edit translated G/L Account descriptions. Translated item descriptions are automatically inserted on documents according to the language code.'
                     , Comment = 'Permite ver o editar las descripciones de las cuentas traducidas. Tales descripciones se insertan automáticamente en los documentos según el código de idioma.';
            }
        }
    }
}