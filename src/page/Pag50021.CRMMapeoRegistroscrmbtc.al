page 50021 "CRM Mapeo Registros_crm_btc"
{

    PageType = List;
    SourceTable = "CRM Integration Record";
    Caption = 'Mapeo Registros', Comment = 'ESP="Mapeo Registros"';
    ApplicationArea = All;
    UsageCategory = Lists;
    //DataCaptionFields = TipoTabla, NumReg, Origen, CodMotivo;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("CRM ID"; "CRM ID")
                {
                    ApplicationArea = All;
                }

                field("Integration ID"; "Integration ID")
                {
                    ApplicationArea = All;
                }
                field("Last Synch. Modified On"; "Last Synch. Modified On")
                {
                    ApplicationArea = All;
                }
                field("Last Synch. CRM Modified On"; "Last Synch. CRM Modified On")
                {
                    ApplicationArea = All;
                }
                field("Skipped"; "Skipped")
                {
                    ApplicationArea = All;
                }
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                }
                field("Last Synch. Result"; "Last Synch. Result")
                {
                    ApplicationArea = All;
                }
                field("Last Synch. CRM Result"; "Last Synch. CRM Result")
                {
                    ApplicationArea = All;
                }
                field("Last Synch. Job ID"; "Last Synch. Job ID")
                {
                    ApplicationArea = All;
                }
                field("Last Synch. CRM Job ID"; "Last Synch. CRM Job ID")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin


    end;


}
