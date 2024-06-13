page 60030 "STH Itbid Configuration"
{
    ApplicationArea = All;
    Caption = 'Itbid Configuration';
    PageType = Card;
    SourceTable = "Sales & Receivables Setup";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(urlAccessToken; Rec.STHurlAccessToken)
                {
                    ToolTip = 'Specifies the value of the url field.';
                    ApplicationArea = All;
                }
                field(urlPut; Rec.STHurlPut)
                {
                    ToolTip = 'Specifies the value of the urlPut field';
                    ApplicationArea = All;
                }
                field("Requires Authentication"; Rec."STHRequires Authentication")
                {
                    ToolTip = 'Specifies the value of the Requires Authentication field';
                    ApplicationArea = All;
                }
                field("client_id"; Rec.STHclient_id)
                {
                    ToolTip = 'Specifies the value of the Requires Client_id field';
                    ApplicationArea = All;
                }
                field("client_secret"; Rec.STHclient_secret)
                {
                    ToolTip = 'Specifies the value of the Requires Client_secret field';
                    ApplicationArea = All;
                }
                field("grant_type"; Rec.STHgrant_type)
                {
                    ToolTip = 'Specifies the value of the Requires Grant_Type field';
                    ApplicationArea = All;
                }
                field("redirect_url"; Rec.STHredirect_url)
                {
                    ToolTip = 'Specifies the value of the Requires Redirect_URL field';
                    ApplicationArea = All;
                }
                field(username; Rec.STHusername)
                {
                    ToolTip = 'Specifies the value of the Requires Username field';
                    ApplicationArea = All;
                }
                field(password; Rec.STHpassword)
                {
                    ToolTip = 'Specifies the value of the Requires Password field';
                    ApplicationArea = All;
                }
                field(email; Rec.STHemail)
                {
                    ToolTip = 'Specifies the value of the Requires Email field';
                    ApplicationArea = All;
                }
            }
        }
    }


    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}