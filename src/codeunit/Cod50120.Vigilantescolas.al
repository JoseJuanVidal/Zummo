codeunit 50120 "Vigilantes colas"
{
    // clientes
    // ofertas aux
    // lineas ofertas aux
    // productos

    // Report	88205	GBS Resumen envios email SII
    // Report	88204	GBS Enviar documentos SII
    // Report	88201	GBS Procesar Movs. IVA SII
    // Codeunit	50503	Cron_AddonAUT	Cron_EnvioMailAprobacion	
    // Codeunit	50110	CU_Cron	Enviar facturación	
    // Codeunit	50110	CU_Cron	Aviso próximos vencimientos	
    // Codeunit	50110	CU_Cron	CargaMovsContaPresup
    // Codeunit	50110	CU_Cron	Limpia seguimientos    
    // Report	50101	Crear facturas periódicas (proceso)
    // Report	795	Valorar stock - movs. producto


    // ============== CRM 
    // Codeunit	5339	Integration Synch. Job Runner	CLIENTECORPORATIVO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	TERMINOS.PAGO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CURRENCY: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTAS-LIN: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTASSALESLIN: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CANAL: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	AREAMANAGER: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	PAISES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	FORMAS.PAGO: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	CLIENTES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	ACTIVIDADCLIENTE: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	PROVINCIAS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	TARIFAS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	DELEGADOS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	GRUPOCLIENTE: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTASSALES: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	MERCADOS: trabajo de sincronización de Dynamics 365 for Sales.
    // Codeunit	5339	Integration Synch. Job Runner	OFERTAS: trabajo de sincronización de Dynamics 365 for Sales.



    trigger OnRun()
    begin
        CheckJobQueueEntry;
    end;

    var
        myInt: Integer;

    local procedure CheckJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        isactive: Boolean;
    begin
        if JobQueueEntry.findset() then
            repeat
                isactive := false;
                // Limpiamos los trabajos de ERROR del CRM - customer - Contact link
                // id 5351 - CRM Customer-Contact Link - ERROR
                if (JobQueueEntry."Object ID to Run" = 5351) and (JobQueueEntry.Description = 'Enlace de contacto con el cliente.') and
                   (JobQueueEntry.Status in [JobQueueEntry.Status::Error]) then
                    JobQueueEntry.Delete();
                case JobQueueEntry."Object Type to Run" of
                    JobQueueEntry."Object Type to Run"::Codeunit:
                        begin
                            if JobQueueEntry."Object ID to Run" = 5339 then begin
                                case JobQueueEntry.Description of
                                    'CLIENTES: trabajo de sincronización de Dynamics 365 for Sales.',
                                    'OFERTASSALES: trabajo de sincronización de Dynamics 365 for Sales.',
                                    'OFERTASSALESLIN: trabajo de sincronización de Dynamics 365 for Sales.':
                                        begin
                                            if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                                JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                        end;
                                end;
                            end;

                            case JobQueueEntry."Object ID to Run" of
                                50503, 50110:
                                    begin
                                        if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                    end;
                            end;
                        end;
                    JobQueueEntry."Object Type to Run"::Report:
                        begin
                            case JobQueueEntry."Object ID to Run" of
                                88205, 88204, 88201, 50101, 795:
                                    begin
                                        if JobQueueEntry.Status in [JobQueueEntry.Status::Error] then
                                            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                    end;
                            end;
                        end;
                end;

            Until JobQueueEntry.next() = 0;
    end;
}



