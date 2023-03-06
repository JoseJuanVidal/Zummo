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
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 01, Date2DMY(workdate, 3)), DMY2Date(31, 01, Date2DMY(workdate, 3)));
                    Mes::Febrero:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 02, Date2DMY(workdate, 3)), DMY2Date(30, 02, Date2DMY(workdate, 3)));
                    Mes::Marzo:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 03, Date2DMY(workdate, 3)), DMY2Date(31, 03, Date2DMY(workdate, 3)));
                    Mes::Abril:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 04, Date2DMY(workdate, 3)), DMY2Date(30, 04, Date2DMY(workdate, 3)));
                    Mes::Mayo:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 05, Date2DMY(workdate, 3)), DMY2Date(31, 05, Date2DMY(workdate, 3)));
                    Mes::Junio:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 06, Date2DMY(workdate, 3)), DMY2Date(30, 06, Date2DMY(workdate, 3)));
                    Mes::Julio:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 07, Date2DMY(workdate, 3)), DMY2Date(31, 07, Date2DMY(workdate, 3)));
                    Mes::Agosto:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 08, Date2DMY(workdate, 3)), DMY2Date(31, 08, Date2DMY(workdate, 3)));
                    Mes::Septiembre:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 09, Date2DMY(workdate, 3)), DMY2Date(30, 09, Date2DMY(workdate, 3)));
                    Mes::Octubre:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 10, Date2DMY(workdate, 3)), DMY2Date(31, 10, Date2DMY(workdate, 3)));
                    Mes::Noviembre:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 11, Date2DMY(workdate, 3)), DMY2Date(30, 11, Date2DMY(workdate, 3)));
                    Mes::Diciembre:
                        SetRange(FechaMantGarantia_sth, DMY2Date(01, 12, Date2DMY(workdate, 3)), DMY2Date(31, 12, Date2DMY(workdate, 3)));

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
        if NoService > 0 then
            Message(Text001, NoService, ServiceNo);
    end;

    var
        ServiceSetup: record "Service Mgt. Setup";
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
}