pageextension 50204 "ZM IT Ext Jobs Setup" extends "Jobs Setup"
{
    layout
    {
        addlast(Content)
        {
            group(JIRA)
            {
                field("url Base"; "url Base")
                {
                    ApplicationArea = All;
                }
                field(user; user)
                {
                    ApplicationArea = all;
                }
                field(token; token)
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }
            }
        }
    }
}
