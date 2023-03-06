page 17401 "CRM Leads"
{
    PageType = List;
    SourceTable = "CRM Leads"; // "CRM FormasPago_btc";
    //Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                // add fields to display on the page
                field(LeadId; LeadId) { ApplicationArea = All; }
                field(companyname; companyname) { ApplicationArea = All; }
                field(firstname; firstname) { ApplicationArea = All; }
                field(lastname; lastname) { ApplicationArea = All; }
                field(zum_ac_enlacemail; zum_ac_enlacemail) { ApplicationArea = All; }
                field(zum_ac_areamanager; zum_ac_areamanager) { ApplicationArea = All; }
                field(zum_areamanager; zum_areamanager) { ApplicationArea = All; }
                field(OwnerId; OwnerId) { ApplicationArea = All; }
                field(CreatedBy; CreatedBy) { ApplicationArea = All; }
                field(ModifiedOn; ModifiedOn) { ApplicationArea = All; }
                field(ModifiedBy; ModifiedBy) { ApplicationArea = All; }
                field(CreatedOnBehalfBy; CreatedOnBehalfBy) { ApplicationArea = All; }
                field(ModifiedOnBehalfBy; ModifiedOnBehalfBy) { ApplicationArea = All; }
                field(campaignidname; campaignidname) { ApplicationArea = All; }

                // field(statecode; statecode) { ApplicationArea = All; }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action("Owner id")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AreaManager: Record TextosAuxiliares;
                    NwwGuide: Guid;
                begin
                    AreaManager.SetRange(TipoRegistro, AreaManager.TipoRegistro::Tabla);
                    AreaManager.SetRange(TipoTabla, AreaManager.TipoTabla::AreaManager);
                    AreaManager.SetRange(NumReg, Rec.zum_ac_areamanager);
                    if AreaManager.FindFirst() then begin
                        if IsNullGuid(AreaManager."CRM ID") then
                            exit;
                        Rec.OwnerId := AreaManager."CRM ID";
                        Rec.Modify();
                        Message('Fin');
                    end;
                end;
            }
        }
    }
    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

}