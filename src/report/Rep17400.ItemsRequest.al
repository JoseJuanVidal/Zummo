report 17400 "Items Request"
{
    Caption = 'Items Request', comment = 'ESP="Solicitud Alta productos"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep17400.ItemsRequest.rdl';

    dataset
    {
        dataitem(ZMPLItemsTemporary; "ZM PL Items Temporary")
        {
            RequestFilterFields = "No.", "Item No.";

            column(No; "No.") { }
            column(RequestType; "Request Type") { }
            column(ItemNo; "Item No.") { }
            column(Description; Description) { }
            column(Base_Unit_of_Measure; "Base Unit of Measure") { }
            column(Clasification_Type; "Clasification Type") { }
            column(ITBID_Create; "ITBID Create") { }
            column(ITBID_Status; "ITBID Status") { }
            column(Blocked; Blocked) { }
            column(Reason_Blocked; "Reason Blocked") { }
            column(User_ID; "User ID") { }
            column(Codigo_Empleado; "Codigo Empleado") { }
            column(Nombre_Empleado; "Nombre Empleado") { }
            column(Department; Department) { }
            column(Activity; Activity) { }
            column(Posting_Date; "Posting Date") { }
            column(Prototype; Prototype) { }
            column(Reason; Reason) { }
            column(Sujeto_a_Control_de_Calidad; "Sujeto a Control de Calidad") { }
            column(Control_Certificado_proveedor; "Control Certificado proveedor") { }

        }
    }
}
