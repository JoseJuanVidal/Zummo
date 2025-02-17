report 50119 "Service Mgt. Warranty"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Generar servicios garantia', comment = 'ESP="Generar servicios garantia"';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Item"; "Service Item")
        {
            DataItemTableView = where(PeriodoAmplacionGarantica_sth = filter(<> ''));
            RequestFilterFields = "No.", FechaMantGarantia_sth;

            trigger OnPreDataItem()
            begin
                // controlamos filtros fechas
                if GetFilter(FechaMantGarantia_sth) <> '' then
                    if mes in [mes::Enero, mes::Febrero, mes::Marzo, mes::Abril, mes::Mayo, mes::Junio, mes::Julio, mes::Agosto, mes::Septiembre,
                                mes::Octubre, mes::Noviembre, mes::Diciembre] then
                        error(Text000, GetFilter(FechaMantGarantia_sth), Mes);
                // si se elige un mes, ponemos el filtro del mes del año actual                
                case Mes of
                    Mes::Enero:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 01)), CALCDATE('<CM>', DMY2DATE(01, 01)));
                    Mes::Febrero:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 02)), CALCDATE('<CM>', DMY2DATE(01, 02)));
                    Mes::Marzo:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 03)), CALCDATE('<CM>', DMY2DATE(01, 03)));
                    Mes::Abril:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 04)), CALCDATE('<CM>', DMY2DATE(01, 04)));
                    Mes::Mayo:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 05)), CALCDATE('<CM>', DMY2DATE(01, 05)));
                    Mes::Junio:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 06)), CALCDATE('<CM>', DMY2DATE(01, 06)));
                    Mes::Julio:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 07)), CALCDATE('<CM>', DMY2DATE(01, 07)));
                    Mes::Agosto:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 08)), CALCDATE('<CM>', DMY2DATE(01, 08)));
                    Mes::Septiembre:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 09)), CALCDATE('<CM>', DMY2DATE(01, 09)));
                    Mes::Octubre:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 10)), CALCDATE('<CM>', DMY2DATE(01, 10)));
                    Mes::Noviembre:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 11)), CALCDATE('<CM>', DMY2DATE(01, 11)));
                    Mes::Diciembre:
                        SetRange(FechaMantGarantia_sth, CALCDATE('<-CM>', DMY2DATE(01, 12)), CALCDATE('<CM>', DMY2DATE(01, 12)));

                end
            end;

            trigger OnAfterGetRecord()
            begin
                CreateServiceOrder("Service Item");
            end;
        }
    }

    requestpage
    {
        SaveValues = false;
        layout
        {
            area(Content)
            {
                group(Opciones)
                {
                    field(Mes; Mes)
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
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        ServiceSetup.Get();
        ServiceSetup.TestField(PeriodoRevisionGarantia);
    end;

    trigger OnPostReport()
    begin
        Message(Text001, NoService, ServiceNo);
    end;

    var
        ServiceSetup: record "Service Mgt. Setup";
        ServiceOrdersCreate: Integer;
        NoService: Integer;
        ServiceNo: code[20];
        Mes: Option " ",Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        Text000: Label 'Es incompatible poner un filtro en la fecha %1 y seleccionar un mes %2';
        Text001: Label 'Creados %1 pedidos de servicios de garantias, desde %2';
        lblWarranty: Label 'Servicio Mantenimiento ampliacion garantia', comment = 'ESP="Servicio Mantenimiento ampliacion garantia"';

    local procedure CreateServiceOrder(var ServiceItem: Record "Service Item")
    var
        ServiceHeader: Record "Service Header";
        ServiceItemLine: Record "Service Item Line";
    begin
        ServiceHeader.Init();
        ServiceHeader."Document Type" := ServiceHeader."Document Type"::Order;
        ServiceHeader.Insert(true);
        ServiceHeader.Validate("Customer No.", ServiceItem."Customer No.");
        ServiceHeader.Description := lblWarranty;
        ServiceHeader."Operation Description" := lblWarranty;
        ServiceHeader.IsWarranty := true;
        ServiceHeader.Modify(true);
        UpdateExtensionField(ServiceHeader);
        ServiceItemLine.Init();
        ServiceItemLine."Document Type" := ServiceHeader."Document Type";
        ServiceItemLine."Document No." := ServiceHeader."No.";
        ServiceItemLine."Line No." := 10000;
        ServiceItemLine.Validate("Service Item No.", ServiceItem."No.");
        ServiceItemLine.Insert(true);
        ServiceItem.FechaMantGarantia_sth := CalcDate(ServiceSetup.PeriodoRevisionGarantia, ServiceItem.FechaMantGarantia_sth);
        ServiceItem.Modify();
        NoService += 1;
        if ServiceNo = '' then
            ServiceNo := ServiceHeader."No.";
    end;

    local procedure UpdateExtensionField(ServiceHeader: Record "Service Header")
    var
        RefRecord: RecordRef;
        RefField: FieldRef;
    begin
        RefRecord.GetTable(ServiceHeader);
        if RefRecord.FieldExist(50680) then begin
            RefField := RefRecord.field(50680); // Servicio proveedor
            RefField.Value := False;
            RefRecord.Modify();
        end;
    end;
}