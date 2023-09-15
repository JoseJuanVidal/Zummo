page 50055 "ZM CIM Items"
{
    ApplicationArea = All;
    Caption = 'ERPLINK Items Pending', comment = 'ESP="ERPLINK Productos pendientes"';
    PromotedActionCategories = 'Nuevo,Procesar,Informe,Mostrar,Navegar';
    PageType = List;
    SourceTable = "ZM CIM Items temporary";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(EnglishDescription; EnglishDescription)
                {
                    ApplicationArea = all;
                }
                field(Material; Material)
                {
                    ApplicationArea = all;
                }
                field("Assembly BOM"; "Assembly BOM")
                {
                    ApplicationArea = all;
                }
                field("Production BOM No."; "Production BOM No.")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpBomComponents();
                    end;
                }
                field("Routing No."; "Routing No.")
                {
                    ApplicationArea = all;
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field(Packaging; packaging)
                {
                    ApplicationArea = all;
                }
                field(Color; Color)
                {
                    ApplicationArea = all;
                }
                field(Inventory; Inventory)
                {
                    ApplicationArea = all;
                }
                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = all;
                }
                field("Unit Volume"; "Unit Volume")
                {
                    ApplicationArea = all;
                }
                field(largo; largo)
                {
                    ApplicationArea = all;
                }
                field(Ancho; Ancho)
                {
                    ApplicationArea = all;
                }
                field(Alto; Alto)
                {
                    ApplicationArea = all;
                }
                field(Principal; Principal)
                {
                    ApplicationArea = all;
                }
                field(CreationOn; CreationOn)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(UserERPLINK; UserERPLINK)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(ModifyOn; ModifyOn)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
            // part(Header; "ZM Production BOM List")
            // {
            //     ApplicationArea = all;
            //     SubPageLink = "No." = field("Production BOM No.");
            // }
            // part(BomLines; "ZM CIM Production BOM Lines")
            // {
            //     Caption = 'Components Lines', comment = 'ESP="Lista componentes"';
            //     ApplicationArea = all;
            //     SubPageLink = "Production BOM No." = field("Production BOM No.");
            //     UpdatePropagation = Both;
            // }
        }
        area(FactBoxes)
        {
            part(ItemPicture; "ZM ERPLINK Item Picture")
            {
                ApplicationArea = all;
                Caption = 'Imagen', comment = 'ESP="Imagen"';
                SubPageLink = "No." = field("No.");

            }
            part(Documents; "ZM Item Documents")
            {
                ApplicationArea = all;
                Caption = 'Documentos Producto', comment = 'ESP="Documentos Producto"';
                SubPageLink = CodComentario = field("No.");
            }
            // part(BomLineDocuments; "ZM Item Documents")
            // {
            //     ApplicationArea = all;
            //     Caption = 'Documentos Lista componentes', comment = 'ESP="Documentos Lista componentes"';
            //     SubPageLink = CodComentario = field("No.");
            //     Provider = BomLines;
            // }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(BOM)
            {
                Caption = 'BOM L.M.', comment = 'ESP="Estructura"';
                ApplicationArea = all;
                Image = BOM;
                Promoted = true;
                PromotedCategory = Category5;


                trigger OnAction()
                begin
                    LookUpBom();
                end;
            }
            action(BOMLedger)
            {
                ApplicationArea = all;
                Image = BOMLedger;
                Promoted = true;
                PromotedCategory = Category5;


                trigger OnAction()
                begin
                    LookUpBomComponents();
                end;
            }
            action(SharepointSetup)
            {
                ApplicationArea = all;
                Image = ValidateEmailLoggingSetup;
                RunObject = page "OAuth 2.0 Applications";
            }
        }
        area(Processing)
        {
            action(UpdatePicture)
            {
                ApplicationArea = all;
                Caption = 'Update picture', comment = 'ESP="Actualzizar imagen"';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    UpdateFileJpg();

                end;
            }
            action(MarkPrincipal)
            {
                ApplicationArea = all;
                Caption = 'Principal (S/N)', comment = 'ESP="Principal (S/N)"';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    Action_MarkPrincipal();

                end;
            }
            action(ShowAll)
            {
                ApplicationArea = all;
                Caption = 'Mostrar Todos', comment = 'ESP="Mostrar todos"';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Action_ShowAll();
                end;
            }
            action(ShowPrincipal)
            {
                ApplicationArea = all;
                Caption = 'Mostrar subidas', comment = 'ESP="Mostrar subidas"';
                Image = ShowSelected;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Action_ShowPrincipal();
                end;
            }

            // action(CopyItem)
            // {
            //     ApplicationArea = all;
            //     Caption = 'Copiar producto', comment = 'ESP="Copiar producto"';
            //     Image = CopyItem;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     PromotedCategory = Process;

            //     trigger OnAction()
            //     begin
            //         actionCopyItem;
            //     end;
            // }
            // action(Sharepoint)
            // {
            //     ApplicationArea = all;

            //     trigger OnAction()
            //     var
            //         Sites: Record File temporary;
            //         ZMOnlineDrive: Record "ZM Online Drive" temporary;
            //         Sharepoint: Codeunit "ZM Sharepoint Functions";
            //         statuscode: Integer;
            //         texto: Text;
            //     begin
            //         Commit();
            //         //Sharepoint.FetchSite(Sites);
            //         //Sharepoint.FetchDrives(ZMOnlineDrive);
            //         //Sharepoint.FetchDrivesItems()
            //         Sharepoint.UploadFileOne(ZMOnlineDrive);
            //         if ZMOnlineDrive.FindFirst() then
            //             repeat
            //                 message(ZMOnlineDrive.name + ': ' + ZMOnlineDrive.name + '\' + ZMOnlineDrive.id);
            //             until ZMOnlineDrive.Next() = 0;

            //     end;
            // }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange(Principal, true);
    end;

    var
        lblConfirmPrincipal: Label '¿Desea marcar/Desmarcar el producto %1 %2 como Subida principal?', comment = 'ESP="¿Desea marcar/Desmarcar el producto %1 %2 como Subida principal?"';

    local procedure ActionCopyItem()
    begin
        Rec.CopyItem;
    end;

    local procedure UpdateFileJpg()
    var
        CIMItemstemporary: Record "ZM CIM Items temporary";
        Docs: Record ComentariosPredefinidos;
        Sharepoint: Codeunit "Sharepoint OAuth App. Helper";
        Stream: InStream;
        lblConfirm: Label '¿Do you want to update the images of %1 selected records?', comment = 'ESP="¿Desea actualizar las imagenes de %1 registros seleccionados?"';
    begin
        CurrPage.SetSelectionFilter(CIMItemstemporary);
        if not Confirm(lblConfirm, false, CIMItemstemporary.Count) then
            exit;

        if CIMItemstemporary.FindFirst() then
            repeat

                Docs.Reset();
                Docs.SetRange(CodComentario, CIMItemstemporary."No.");
                Docs.SetRange(Extension, 'jpg');
                if Docs.FindFirst() then begin
                    if Sharepoint.DownloadFileName(Docs.Description, Stream, 'jpg') then begin
                        CIMItemstemporary.Picture.ImportStream(Stream, Docs.Description);
                        CIMItemstemporary.Modify();
                        //DownloadFromStream(Stream, '', '', '', Docs.Description);
                    end;
                end;
            Until CIMItemstemporary.next() = 0;
        Message('Fin');
        CurrPage.Update();
    end;

    local procedure LookUpBomComponents()
    var
        CIMProdBOMHeader: record "ZM CIM Prod. BOM Header";
        ProductionBOMList: page "ZM Production BOM List";
    begin
        CIMProdBOMHeader.Reset();
        CIMProdBOMHeader.SetRange("No.", Rec."Production BOM No.");
        ProductionBOMList.SetTableView(CIMProdBOMHeader);
        ProductionBOMList.RunModal();
    end;

    local procedure Action_MarkPrincipal()
    begin
        if Confirm(lblConfirmPrincipal, true, Rec."No.", Rec.Description) then begin
            Rec.Principal := not Rec.Principal;
            Rec.Modify();
            CurrPage.Update();
        end;
    end;

    local procedure Action_ShowAll()
    begin
        SetRange(Principal);
    end;

    local procedure Action_ShowPrincipal()
    begin
        SetRange(Principal, true);
    end;

    local procedure LookUpBom()
    var
        ItemsBOM: page "ZM CIM Items BOM";
    begin
        ItemsBOM.InitItem(Rec."No.");
        ItemsBOM.RunModal();
    end;

}