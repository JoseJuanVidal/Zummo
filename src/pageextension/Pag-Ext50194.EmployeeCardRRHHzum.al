pageextension 50194 "EmployeeCard_RRHH_zum" extends "Employee Card"
{
    layout
    {
        modify(Pager)
        {
            Caption = 'Skype Contact', comment = 'ESP="Contacto Skype"';
            ToolTip = 'Addres Contact Skype', Comment = 'Direccion de contacto Skype';
        }
        //Pestaña GENERAL
        addafter("Privacy Blocked")
        {

            field(Sucursal; Sucursal_zum)
            {

            }
            field(Departamento; Departamento_zum)
            {
            }
            field("Area"; "Area_zum")
            {
            }
            field("User Id"; "User Id")
            {
            }
            field("Approval User Id"; "Approval User Id")
            {
                ApplicationArea = all;
            }
            field("Approval Department User Id"; "Approval Department User Id")
            {
                ApplicationArea = all;
            }
        }
        //Pestaña ADMIN
        addafter("Salespers./Purch. Code")
        {
            field("Evaluacion Riesgos"; "Evaluacion Riesgos_zum")
            {
            }
            field("Proxima renovación"; "Proxima renovación_zum")
            {
            }
            field("Grupo profesional"; "Grupo profesional_zum")
            {
            }
            field("Grupo cotizacion"; "Grupo cotizacion_zum")
            {
            }
            field("Puesto contrato"; "Puesto contrato_zum")
            {
            }
            field("Jornada(%)"; "Jornada(%)_zum")
            {
            }
            field("Categoria organigrama"; "Categoria organigrama_zum")
            {
            }
        }
        //Pestaña PERSONAL
        addafter("Union Membership No.")
        {
            field("Pais Nacimiento"; PaisNacimiento_btc)
            {
            }
            field("Estado Civil"; "Estado Civil_zum")
            {
            }
            field("Nacionalidad"; "Nacionalidad_zum")
            {
            }
            field("NIF"; "NIF_zum")
            {
            }
            field("Fecha caducidad DNI"; "Fecha caducidad DNI_zum")
            {

            }
            field("Pasaporte"; "Pasaporte_zum")
            {

            }
            field("Fecha caducidad Pasaporte"; "Fecha caducidad Pasaporte_zum")
            {

            }
            field("Carnet conducir"; "Carnet conducir_zum")
            {

            }
            field("Fecha cad. carnet conducir"; "Fecha cad. carnet conducir_zum")
            {

            }

            field(Alergias; "Alergias_zum")
            {
            }
            field(Zapatos; "Zapatos_zum")
            {
            }
            field(Pantalon; Pantalon_zum)
            {
            }
            field(Camiseta; Camiseta_zum)
            {
            }

            field(Guantes1; "Guantes1_zum")
            {
            }
            field(Guantes2; "Guantes2_zum")
            {
            }

            field("Discapacidad(%)"; "Discapacidad(%)_zum")
            {
            }
            field("Seguro Medico"; "Seguro Medico_zum")
            {
            }
            field("Seguro Medico Infantil"; "Seguro Medico Infantil_zum")
            {
            }
        }
        addafter(General)
        {
            group("BITEC")
            {

                Caption = 'BITEC';
                field("Ubicacion Puesto"; "Ubicacion Puesto_zum")
                {
                }
                field("Nivel de estudios"; "Nivel de estudios_zum")
                {
                }
                field("Categoria bonificaciones"; "Categoria bonificaciones_zum")
                {
                }
            }
            // part("Histórico Contrato"; "Historico Contratos_zum")
            // {
            //     Caption = 'Histórico Contrato';
            //     SubPageLink = tabla = CONST("Historico Contratos"),
            //     tipo = const(Empleado),
            //      CodigoRRHH = FIELD("No.");
            // }
            // part("Histórico Categoría"; "Historico Categorias_zum")
            // {
            //     Caption = 'Histórico Categoría';
            //     SubPageLink = tabla = CONST("Historico Categoria"),
            //     tipo = const(Empleado),
            //      CodigoRRHH = FIELD("No.");
            // }
            // part("Puesto Subform"; "Puesto Subform_zum")
            // {
            //     Caption = 'Histórico de sucursal';
            //     SubPageLink = tabla = CONST("Historico Puestos"),
            //     tipo = const(Empleado),
            //      CodigoTipo = FIELD("No.");

            // }
        }
    }
}




