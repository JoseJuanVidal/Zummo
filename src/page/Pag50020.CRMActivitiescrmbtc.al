page 50020 "CRM Activities_crm_btc"
{
    Caption = 'CRM Activities', comment = 'ESP="Actividades CRM"';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Cue";

    layout
    {
        area(content)
        {
            cuegroup("Outbound - Today")
            {
                field("CLientes CRM"; NumClientesCRM(false))
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Clientes CRM', comment = 'ESP="Clientes CRM"';
                    ToolTip = 'Clientes CRM', comment = 'ESP="Clientes procedentes de CRM"';
                    trigger OnDrillDown();
                    begin
                        NumClientesCRM(true);
                    end;
                }
            }
        }
    }

    actions
    {
    }


    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;
    end;




    local procedure NumClientesCRM(AbrirPage: Boolean): Integer;
    var
        Customer: Record Customer;

    begin


        Customer.Reset();
        Customer.SetFilter("No.", 'T*');

        if AbrirPage then begin

            Page.Run(Page::"Customer List", Customer);
        end
        else
            exit(Customer.Count);
    end;







}

