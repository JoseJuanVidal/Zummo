tableextension 50126 "Employee" extends Employee  //5200
{

    fields
    {
        field(50101; PaisNacimiento_btc; code[2])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'PaisNacimiento', comment = 'ESP="Pais Nacimiento"';
            TableRelation = "Country/Region".Code;
        }

        field(50102; EstadoCivil_btc; code[2])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'EstadoCivil', comment = 'ESP="EstadoCivil"';
            ObsoleteState = Removed;
        }


        field(50103; "Nacionalidad_zum"; Text[40])
        {
            Caption = 'Nacionalidad', comment = 'ESP="Nacionalidad"';
        }
        field(50104; "NIF_zum"; Text[20])
        {
            Caption = 'NIF', comment = 'ESP="NIF"';
        }
        field(50105; "Fecha caducidad DNI_zum"; date)
        {
            Caption = 'Fecha caducidad DNI', comment = 'ESP="Fecha caducidad DNI"';
        }
        field(50106; "Pasaporte_zum"; Text[20])
        {
            Caption = 'Pasaporte', comment = 'ESP="Pasaporte"';
        }
        field(50107; "Fecha caducidad Pasaporte_zum"; date)
        {
            Caption = 'Fecha caducidad Pasaporte', comment = 'ESP="Fecha caducidad Pasaporte"';
        }
        field(50108; "Carnet conducir_zum"; Text[20])
        {
            Caption = 'Carnet conducir', comment = 'ESP="Carnet conducir"';
        }
        field(50109; "Fecha cad. carnet conducir_zum"; date)
        {
            Caption = 'Fecha cad. carnet conducir', comment = 'ESP="Fecha cad. carnet conducir"';
        }
        field(50110; "Discapacidad(%)_zum"; Decimal)
        {
            Caption = 'Discapacidad(%)', comment = 'ESP="Discapacidad(%)"';
        }
        field(50111; "Jornada(%)_zum"; Decimal)
        {
            Caption = 'Jornada(%)', comment = 'ESP="Jornada(%)"';
        }
        field(50112; "Area_zum"; Code[20])
        {
            Caption = 'Area', comment = 'ESP="Area"';
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST("Area"));
        }

        field(50113; Departamento_zum; Code[20])
        {
            Caption = 'Departamento', comment = 'ESP="Departamento"';
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST(Departamentos));
        }
        field(50114; "Nivel de estudios_zum"; Text[30])
        {
            Caption = 'Nivel de estudios', comment = 'ESP="Nivel de estudios"';
        }
        field(50115; "Proxima renovación_zum"; Date)
        {
            Caption = 'Proxima renovación', comment = 'ESP="Proxima renovación"';
        }
        field(50116; "Grupo profesional_zum"; Text[30])
        {
            Caption = 'Grupo profesional', comment = 'ESP="Grupo profesional"';
        }
        field(50117; "Grupo cotizacion_zum"; Integer)
        {
            Caption = 'Grupo cotizacion', comment = 'ESP="Grupo cotizacion"';
        }
        field(50118; "Puesto contrato_zum"; Text[50])
        {
            Caption = 'Puesto contrato', comment = 'ESP="Puesto contrato"';
        }
        field(50119; "Categoria organigrama_zum"; Integer)
        {
            Caption = 'Categoria organigrama', comment = 'ESP="Categoria organigrama"';
        }
        field(50121; "Alergias_zum"; Text[100])
        {
            Caption = 'Alergias', comment = 'ESP="Alergias"';
        }
        field(50122; "Zapatos_zum"; Text[50])
        {
            Caption = 'Zapatos', comment = 'ESP="Zapatos"';
        }
        field(50123; "Pantalon_zum"; Text[50])
        {
            Caption = 'Talla Pantalón', comment = 'ESP="Talla Pantalón"';
        }
        field(50124; "Camiseta_zum"; Text[50])
        {
            Caption = 'Talla Camiseta', comment = 'ESP="Talla Camiseta"';
        }
        field(50125; "Guantes1_zum"; Text[50])
        {
            Caption = 'Talla Guantes Piel', comment = 'ESP="Talla Guantes Piel"';
        }
        field(50126; "Guantes2_zum"; Text[50])
        {
            Caption = 'Talla Guantes Nylon', comment = 'ESP="Talla Guantes Nylon"';
        }
        field(50127; "Ubicacion Puesto_zum"; Code[20])
        {
            Caption = 'Ubicacion Puesto', comment = 'ESP="Ubicacion Puesto"';
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST("Ubicación Puesto"));
        }
        field(50128; "Evaluacion Riesgos_zum"; Code[20])
        {
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST("Evaluación Riesgos"));
        }
        field(50129; Sucursal_zum; Code[20])
        {
            Caption = 'Empresa', comment = 'ESP="Empresa"';
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST(Empresa));

        }
        field(50131; "Seguro Medico Infantil_zum"; Text[50])
        {
            Caption = 'Seguro Médico Infantil', comment = 'ESP="Seguro Médico Infantil"';
        }
        field(50132; "Categoria bonificaciones_zum"; Code[20])
        {
            Caption = 'Categoria bonificaciones', comment = 'ESP="Categoria bonificaciones"';
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST("Categoria Bonificaciones"));
        }
        field(50133; "Seguro Medico_zum"; Text[50])
        {
            Caption = 'Seguro Medico', comment = 'ESP="Seguro Medico"';
        }
        field(50134; "Estado Civil_zum"; Option)
        {
            OptionCaption = ',Soltero/a,Casado/a,Divorciado/a,Viudo/a,Pareja de hecho';
            OptionMembers = " ","Soltero/a","Casado/a","Divorciado/a","Viudo/a","Pareja de hecho";
        }
    }
}