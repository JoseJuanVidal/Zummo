pageextension 50005 "CustomerList" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
                ApplicationArea = All;
            }
            field("Payment Method Code"; "Payment Method Code") { }
            field("Net Change"; "Net Change")
            {
                ApplicationArea = All;
            }
            field(PermiteEnvioMail_btc; PermiteEnvioMail_btc)
            {
                ApplicationArea = all;
            }
            field(TipoFormarto_btc; TipoFormarto_btc)
            {
                ApplicationArea = all;
            }
            field("Net Change (LCY)"; "Net Change (LCY)")
            {
                ApplicationArea = all;
            }
            field(AreaManager_btc; AreaManager_btc)
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
            }
            field(Suplemento_aseguradora; Suplemento_aseguradora)
            {
                ApplicationArea = all;
            }
            field("Credito Maximo Interno_btc"; "Credito Maximo Interno_btc")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        modify("Co&mments")
        {
            Visible = false;
        }
        addbefore(ReportCustomerTrialBalance)
        {
            action("Imprimir Extracto")
            {
                ApplicationArea = All;
                Caption = 'Imprimir Extracto', comment = 'NLB="Imprimir Extracto"';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintForm;
                trigger OnAction()
                var
                    Cliente: Record Customer;
                begin
                    Cliente.SetRange("No.", Rec."No.");
                    if (Cliente.FindFirst()) then
                        Report.Run(Report::"Extracto Cliente", true, false, Cliente);
                end;
            }
        }
        addbefore("Co&mments")
        {
            action(Coment1)
            {
                ApplicationArea = All;
                Caption = 'Comments', comment = 'ESP="Comentarios"';
                ToolTip = 'View or add comments for the record', comment = 'ESP="Permite ver o agregar comentarios para el registro."';
                Image = ViewComments;
                PromotedCategory = Category7;
                Promoted = true;
                RunObject = page "Comentarios Cliente";
                RunPageLink = "Table Name" = CONST(Customer), "No." = FIELD("No.");
            }
        }
    }
}