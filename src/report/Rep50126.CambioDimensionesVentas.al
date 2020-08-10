report 50126 "CambioDimensionesVentas"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Change Sales Dimensions', comment = 'ESP="Cambiar dimensiones ventas"';

    dataset
    {
        dataitem(Integer; Integer)
        {
            MaxIteration = 1;
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            begin
                Codeunit.Run(Codeunit::CambioDimensiones);
            end;
        }
    }

    trigger OnPreReport()
    var
        lbQst: Label 'This process will update the dimensions of all tables related to the client\Do you want to continue?', comment = 'ESP="Este proceso actualizará las dimensiones de todas las tablas relacionadas con el cliente\¿Desea continuar?"';
    begin
        if not Confirm(lbQst) then
            Error('');
    end;
}