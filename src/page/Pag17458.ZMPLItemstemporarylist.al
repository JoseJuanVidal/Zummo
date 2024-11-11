page 17458 "ZM PL Items temporary list"
{
    ApplicationArea = All;
    Caption = 'Items temporary list', Comment = 'ESP="Lista Alta de productos"';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    SourceTable = "ZM PL Items temporary";
    // Editable = false;
    UsageCategory = Lists;
    CardPageId = "ZM PL Items temporary card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                // field(EnglishDescription; Rec.EnglishDescription)
                // {
                //     ApplicationArea = All;
                // }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                field("State Creation"; "State Creation")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleText;
                }
                field("ITBID Status"; "ITBID Status")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleText;
                }
                field("Assembly BOM"; Rec."Assembly BOM")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleText;
                }
                field(Color; Rec.Color)
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleText;
                }
                field(Alto; Rec.Alto)
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleText;
                }
                field(Ancho; Rec.Ancho)
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleText;
                }
                field(Largo; Rec.Largo)
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleText;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleText;
                }
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleText;
                }
                field(Packaging; Rec.Packaging)
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleText;
                }
                field(StatusUser; StatusUser)
                {
                    ApplicationArea = all;
                    Caption = 'User Status', comment = 'ESP="Estado Usuario"';
                    StyleExpr = StyleText;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                }
                field(Department; Department)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConfAltaProd)
            {
                ApplicationArea = all;
                Caption = 'Conf. Alta Productos', comment = 'ESP="Conf. Alta Productos"';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "ZM PL Setup Item registration";
            }
            action(ConfAprobAltaProd)
            {
                ApplicationArea = all;
                Caption = 'Conf. Departamentos Alta Productos', comment = 'ESP="Conf. Departamentos Alta Productos"';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "ZM PL Item Setup approvals";
            }
            action(SolicitudAlta)
            {
                ApplicationArea = All;
                Caption = 'Solicitud Alta', Comment = 'ESP="Solicitud Alta/Actualización"';
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = StateBlank;

                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea Solicitar el alta/modificacion del producto %1 (%2)?', comment = 'ESP="¿Desea Solicitar el alta/modificacion del producto %1 (%2)?"';
                begin
                    if Confirm(lblConfirm, false, Rec."No.", Rec.Description) then
                        Rec.LaunchRegisterItemTemporary(false);
                end;
            }
            action(SolicitudDepartamento)
            {
                ApplicationArea = All;
                Caption = 'Revisión Departamentos', Comment = 'ESP="Revisión Departamentos"';
                Image = StaleCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = StateRequested;

                trigger OnAction()
                begin

                    Rec.LaunchRegisterItemTemporary(true);
                end;
            }
            action(UploadExcel)
            {
                ApplicationArea = All;
                Caption = 'Cargar Excel', comment = 'ESP="Cargar Excel"';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_UploadExcel();
                end;
            }
            // action(UpdateITBID)
            // {
            //     ApplicationArea = All;
            //     Caption = 'ITBID Update', Comment = 'ESP="Alta/Actualización ITBID"';
            //     Image = Purchasing;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         Itemstemporary: Record "ZM PL Items temporary";
            //         IsUpdate: Boolean;
            //         lblUpdate: Label 'Actualizada la plataforma ITBID', comment = 'ESP="Actualizada la plataforma ITBID"';
            //     begin
            //         if not Confirm(lblConfirmUpdateITBID) then
            //             exit;
            //         CurrPage.SetSelectionFilter(Itemstemporary);
            //         if Itemstemporary.FindFirst() then
            //             repeat
            //                 if Itemstemporary.ITBIDUpdate() then
            //                     IsUpdate := true;
            //             Until Itemstemporary.next() = 0;
            //         if IsUpdate then
            //             Message(lblUpdate);
            //     end;
            // }
        }
        area(Navigation)
        {
            Group("Lista de materiales")
            {
                Image = BOM;
                group(LMProducion)
                {
                    Caption = 'Producción', comment = 'ESP="Producción"';
                    Image = Production;
                    action(ShowLMProduction)
                    {
                        ApplicationArea = all;
                        Caption = 'L. M. Producción', comment = 'ESP="L. M. Producción"';
                        Image = BOM;
                        Promoted = true;
                        PromotedCategory = Category4;
                        trigger OnAction()
                        begin
                            Navigate_ProductionML();
                        end;
                    }
                }
                action(PurchasePrices)
                {
                    ApplicationArea = all;
                    Caption = 'Purchases prices', comment = 'ESP="Precios Compra"';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    begin
                        Navigate_PurchasesPrices();
                    end;
                }
                action(PostedItemList)
                {
                    ApplicationArea = all;
                    Caption = 'Hist. Alta Productos', comment = 'ESP="Hist. Alta Productos"';
                    Image = PostedDeposit;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        OnAction_PostedItemList();
                    end;
                }
            }
            action(Translations)
            {
                ApplicationArea = all;
                Caption = 'Traducciones', comment = 'ESP="Traducciones"';
                Image = Translations;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = page "ZM Item Translation temporary";
                RunPageView = sorting("Item No.");
                RunPageLink = "Item No." = field("No.");
            }
            action(ItemsReview)
            {
                ApplicationArea = all;
                Caption = 'Review Items temporary', comment = 'ESP="Revisión productos pendientes"';
                Image = ReviewWorksheet;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    OnAction_NavigateReview();
                end;

            }
            action(ItemApprovalsDept)
            {
                ApplicationArea = all;
                Caption = 'Approvals', comment = 'ESP="Aprobaciones"';
                Image = Translations;
                RunObject = page "Item Approval Departments";
                RunPageLink = "GUID Creation" = field("GUID Creation");
            }

        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        StateBlank := Rec."State Creation" = Rec."State Creation"::" ";
        StateRequested := Rec."State Creation" = Rec."State Creation"::Requested;
    end;

    trigger OnAfterGetRecord()
    begin
        CheckStatusUser();
    end;

    var
        StatusUser: Enum "Item Temporary User Status";
        StyleText: Text;
        ShowPosted: Boolean;
        StateBlank: Boolean;
        StateRequested: Boolean;
        lblConfirmUpdateITBID: Label '¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?', comment = 'ESP="¿Desea Crear/Actualizar los datos en le plataforma compra ITBID?"';

    procedure SetShowPosted(Active: Boolean)
    begin
        ShowPosted := Active;
    end;

    local procedure OnAction_PostedItemList()
    begin
        Navigate_PostedItemList();
    end;

    local procedure OnAction_NavigateReview()
    begin
        Rec.NavigateItemsReview();
    end;

    local procedure CheckStatusUser()
    var
        Dpto: code[20];
    begin
        StyleText := '';
        StatusUser := StatusUser::" ";
        case Rec."State Creation" of
            Rec."State Creation"::" ":
                exit;
            Rec."State Creation"::Finished:
                begin
                    StyleText := 'Favorable';
                    exit;
                end;
            Rec."State Creation"::Requested:
                begin
                    // comprobad si soy propietario
                    if CheckUserOwneerItem then
                        StyleText := 'StandardAccent';

                    exit;
                end;
            Rec."State Creation"::Released:
                case Rec.CheckItemsTemporary(Dpto) of
                    true:
                        begin
                            // Comprobar que si tiene todo aceptado, se ponga en Favorable (Verde)                    
                            if Rec.CheckUserReviewItem(Dpto) then
                                StatusUser := StatusUser::Pending
                            else
                                StatusUser := StatusUser::Comprobado;
                        end;
                    else
                        StatusUser := StatusUser::" ";
                end;
        end;
        case StatusUser of
            StatusUser::Pending:
                StyleText := 'Attention';
            StatusUser::Comprobado:
                StyleText := 'Favorable';
        end;
    end;

    local procedure OnAction_UploadExcel()
    var
        myInt: Integer;
    begin
        Rec.UploadExcel();
    end;
}
