page 17375 "OAuth 2.0 Applications"
{
    ApplicationArea = Basic, Suite, Service;
    Caption = 'OAuth 2.0 Applications', Comment = 'ESP="Aplicaciones OAuth 2.0"';
    CardPageID = "OAuth 2.0 Application";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "ZM OAuth 2.0 Application";
    UsageCategory = Administration;

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
        area(Navigation)
        {
            action(Folders)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Folders Setup', Comment = 'ESP="Config. Carpetas"';
                Image = SelectField;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Opem Folder', Comment = 'ESP="Abrir carpetas"';

                RunObject = page "ZM OAuth20Application Folders";
                RunPageLink = "Application Code" = field(Code);

            }
            action(GESTALIAVIAJEROS)
            {
                ApplicationArea = all;
                Promoted = true;

                trigger OnAction()
                var
                    GestaliaFunciones: Codeunit "Zummo Inn. IC Functions";
                begin
                    GestaliaFunciones.GetListaViajeros;
                end;

            }
            action(GESTALIFACTURAS)
            {
                ApplicationArea = all;
                Promoted = true;

                trigger OnAction()
                var
                    GestaliaFunciones: Codeunit "Zummo Inn. IC Functions";
                begin
                    GestaliaFunciones.GetInvoicebyDate(20230501D, 20230531D);

                end;

            }
        }
    }
}
