page 17375 "OAuth 2.0 Applications"
{
    ApplicationArea = Basic, Suite, Service;
    Caption = 'OAuth 2.0 Applications', Comment = 'ES==Aplicaciones OAuth 2.0';
    CardPageID = "OAuth 2.0 Application";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "ZM OAuth 2.0 Application";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }

                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}
