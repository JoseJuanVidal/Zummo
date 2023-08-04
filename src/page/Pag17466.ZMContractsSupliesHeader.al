page 17466 "ZM Contracts Suplies Header"
{

    Caption = 'Contracts Suplies', Comment = 'ESP="Contratos/Suministros"';
    PageType = Document;
    SourceTable = "ZM Contracts/supplies Header";
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,Print/Send,Navigate',
        Comment = 'ESP="Nuevo,Proceso,Informe,Aprobar,Cambiar Estado,Registro,Preparar,Pedido,Solicitud Aprobación,Imprimir/Enviar,Navegar"';
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
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field(Currency; Currency)
                {
                    ApplicationArea = all;
                }
                field("Salesperson code"; "Salesperson code")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = all;
                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Total Amount"; "Total Amount")
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
                    field("VAT Registration No."; "VAT Registration No.")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        QuickEntry = false;
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
        }
        area(FactBoxes)
        {
            part("Attachment Document"; "ZM Document Attachment Factbox")
            {
                ApplicationArea = all;
                Caption = 'Attachment Document', comment = 'ESP="Documentos adjuntos"';
                SubPageLink = "Table ID" = const(17455), "No." = field("No.");
            }
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
            group(creation)
            {
                action(CreateOrder)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Purch. Order', comment = 'ESP="Crear Pedido Compra"';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    begin
                        ActionCreatePurchaseOrder();
                    end;

                }
            }
            group(Estado)
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

    trigger OnOpenPage()
    begin
        if UserSetup.get(UserId) then
            if UserSetup."Contrats/Suppliers" then
                exit;
        CurrPage.Editable := false;
    end;

    trigger OnAfterGetRecord()
    var
        RefRecord: recordRef;
    begin
        RefRecord.Get(Rec.RecordId);
        CurrPage."Attachment Document".Page.SetTableNo(17455, Rec."No.", 0, RefRecord);
    end;

    var
        UserSetup: Record "User Setup";

    local procedure ActionCreatePurchaseOrder()
    begin
        Rec.CreatePurchaseOrder();
    end;
}
