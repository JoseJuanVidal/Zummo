page 17466 "ZM Contracts Suplies Header"
{

    Caption = 'Contracts Suplies', Comment = 'ESP="Contratos/Suministros"';
    PageType = Document;
    SourceTable = "ZM Contracts/supplies Header";
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,Print/Send,Navigate',
        Comment = 'Nuevo,Proceso,Informe,Aprobar,Cambiar Estado,Registro,Preparar,Pedido,Solicitud Aprobación,Imprimir/Enviar,Navegar';
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Contract No. Vendor"; Rec."Contract No. Vendor")
                {
                    ApplicationArea = All;
                }
                field("Date creation"; Rec."Date creation")
                {
                    ApplicationArea = All;
                }
                field("Data Start Validity"; Rec."Data Start Validity")
                {
                    ApplicationArea = All;
                }

                field("Date End Validity"; Rec."Date End Validity")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("No. of Purchase Line"; Rec."No. of Purchase Line")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        PurchaseLine: record "Purchase Line";
                    begin
                        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SetRange("Contracts No.", Rec."No.");
                        page.RunModal(0, PurchaseLine);
                    end;

                }
                group(Address)
                {
                    Caption = 'Address', comment = 'Dirección';
                    field("Buy-from Vendor Name 2"; Rec."Buy-from Vendor Name 2")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
                        Visible = false;
                    }
                    field("Buy-from Address"; Rec."Buy-from Address")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
                    }
                    field("Buy-from Address 2"; Rec."Buy-from Address 2")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
                        Visible = false;
                    }
                    field("Buy-from City"; Rec."Buy-from City")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
                    }
                    field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
                    }
                    field("Buy-from County"; Rec."Buy-from County")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
                    }

                    field("Buy-to Post Code"; Rec."Buy-to Post Code")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
                    }
                    field("Buy-from Contact"; Rec."Buy-from Contact")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
                    }
                }
            }

            part(Lines; "ZM Contracts/supplies Lines")
            {
                Caption = 'Lines', comment = 'Líneas';
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group(totales)
            {
                field("Expend Quantity"; Rec."Expend Quantity")
                {
                    ApplicationArea = all;
                }
                field("Return Quantity"; Rec."Return Quantity")
                {
                    ApplicationArea = all;
                }
                field("Quantity in Purch. Order"; Rec."Quantity in Purch. Order")
                {
                    ApplicationArea = all;
                }
            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = Recordlinks;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Action13)
            {

                Caption = 'Cambiar Estado';
                Image = ReleaseDoc;
                action(Closed)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cerrar', Comment = 'Cerrar';
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.Release();
                    end;
                }
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = '&Lanzar', Comment = '&Lanzar';
                    // Enabled = Rec.Status = Rec.Status::Abierto;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.Release();
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = '&Volver a abrir', Comment = '&Volver a abrir';
                    // Enabled = (Rec.Status = Rec.Status::Lanzado);
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.VolverAbrir();
                    end;
                }
            }
        }
    }
}
