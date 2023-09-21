page 17415 "ZM PL Items temporary card"
{
    Caption = 'Items registration', Comment = 'ESP="Alta de productos"';
    PageType = card;
    SourceTable = "ZM PL Items temporary";
    SourceTableView = where("State Creation" = filter(" " | Requested | Released));
    UsageCategory = Tasks;


    layout
    {
        area(content)
        {

            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(EnglishDescription; Rec.EnglishDescription)
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("State Creation"; "State Creation")
                {
                    ApplicationArea = all;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = all;
                }
            }
            group(Applicant)
            {
                Caption = 'Applicant', comment = 'ESP="Solicitante"';
                field("Codigo Empleado"; "Codigo Empleado")
                {
                    ApplicationArea = all;
                }
                field(Department; Department)
                {
                    ApplicationArea = all;
                }
                field("Product manager"; "Product manager")
                {
                    ApplicationArea = all;
                }
                field(WorkDescription; WorkDescription)
                {
                    ApplicationArea = all;
                    Caption = 'Reason', comment = 'ESP="Motivo"';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        SetWorkDescription(WorkDescription);
                    end;
                }
                field(Activity; Activity)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Prototype; Prototype)
                {
                    ApplicationArea = all;
                }
            }
            group(Additional)
            {
                Caption = 'Additional', comment = 'ESP="Adicionales"';
                field(Color; Rec.Color)
                {
                    ApplicationArea = All;
                }
                field(Alto; Rec.Alto)
                {
                    ApplicationArea = All;
                }
                field(Ancho; Rec.Ancho)
                {
                    ApplicationArea = All;
                }
                field(Largo; Rec.Largo)
                {
                    ApplicationArea = All;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                }
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                }
                field(Packaging; Rec.Packaging)
                {
                    ApplicationArea = All;
                }
            }
            group("Costs & Posting")
            {
                Caption = 'Costs & Posting', comment = 'ESP="Costes y registro"';

                field("Costing Method"; "Costing Method")
                {
                    ApplicationArea = all;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = all;
                }
                group("Posting Details")
                {
                    field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                    {
                        ApplicationArea = all;
                    }
                    field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                    {
                        ApplicationArea = all;
                    }
                }
                group(ForeignTrade)
                {
                    field("Tariff No."; "Tariff No.")
                    {
                        ApplicationArea = all;
                    }
                }
            }
            group("Prices & Sales")
            {
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Item Disc. Group"; "Item Disc. Group")
                {
                    ApplicationArea = all;
                }
                field("Sales Unit of Measure"; "Sales Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Sales Blocked"; "Sales Blocked")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = all;
                }
            }
            group(Reposición)
            {
                field("Replenishment System"; "Replenishment System")
                {
                    ApplicationArea = all;
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    ApplicationArea = all;
                }
                group(Produccion)
                {
                    field("Manufacturing Policy"; "Manufacturing Policy")
                    {
                        ApplicationArea = all;
                    }
                    field("Routing No."; "Routing No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Production BOM No."; "Production BOM No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Rounding Precision"; "Rounding Precision")
                    {
                        ApplicationArea = all;
                    }
                    field("Flushing Method"; "Flushing Method")
                    {
                        ApplicationArea = all;
                    }
                }
                group(Ensamblado)
                {
                    field("Assembly Policy"; "Assembly Policy")
                    {
                        ApplicationArea = all;
                    }
                    field("Assembly BOM"; "Assembly BOM")
                    {
                        ApplicationArea = all;
                    }
                }
            }
            group(Planificacion)
            {
                field("Reordering Policy"; "Reordering Policy")
                {
                    ApplicationArea = all;
                }
                field(Reserve; Reserve)
                {
                    ApplicationArea = all;
                }
                field("Safety Lead Time"; "Safety Lead Time")
                {
                    ApplicationArea = all;
                }
                field("Safety Stock Quantity"; "Safety Stock Quantity")
                {
                    ApplicationArea = all;
                }
                group("Parámetros de lote a lote")
                {
                    field("Include Inventory"; "Include Inventory")
                    {
                        ApplicationArea = all;
                    }
                    field("Rescheduling Period"; "Rescheduling Period")
                    {
                        ApplicationArea = all;
                    }
                }
                group("Parámetros de punto de pedido")
                {
                    field("Reorder Point"; "Reorder Point")
                    {
                        ApplicationArea = all;
                    }
                    field("Reorder Quantity"; "Reorder Quantity")
                    {
                        ApplicationArea = all;
                    }
                    field("Maximum Inventory"; "Maximum Inventory")
                    {
                        ApplicationArea = all;
                    }
                }
                group("Modificadores de pedido")
                {
                    field("Minimum Order Quantity"; "Minimum Order Quantity")
                    {
                        ApplicationArea = all;
                    }
                    field("Maximum Order Quantity"; "Maximum Order Quantity")
                    {
                        ApplicationArea = all;
                    }
                    field("Order Multiple"; "Order Multiple")
                    {
                        ApplicationArea = all;
                    }
                }
                group("Seguim. prod.")
                {
                    field("Item Tracking Code"; "Item Tracking Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Serial Nos."; "Serial Nos.")
                    {
                        ApplicationArea = all;
                    }
                    field("Lot Nos."; "Lot Nos.")
                    {
                        ApplicationArea = all;
                    }
                    field("Expiration Calculation"; "Expiration Calculation")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release', comment = 'ESP="Lanzar"';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_Release();
                end;
            }
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open', comment = 'ESP="Abrir"';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_Open();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        WorkDescription := GetWorkDescription;
    end;

    var
        ItemsRegisterAprovals: Codeunit "ZM PL Items Regist. aprovals";
        WorkDescription: text;
        ShowField: array[100] of Integer;
        lblRelease: Label '¿Do you want to send the request for Item Registration %1 %2?', comment = 'ESP="¿Desea enviar la solicitud de Alta del producto %1 %2?"';

    local procedure OnAction_Release()
    begin
        Rec.TestField("State Creation", Rec."State Creation"::" ");
        if Confirm(lblRelease, true, Rec."No.", Rec.Description) then
            ItemsRegisterAprovals.ItemRegistrationChangeState(Rec);
    end;

    local procedure OnAction_Open()
    begin
        Rec.TestField("State Creation", Rec."State Creation"::Requested);
        if ItemsRegisterAprovals.ItemRegistratio_OpenRequested(Rec) then
            CurrPage.Update();
    end;
}
