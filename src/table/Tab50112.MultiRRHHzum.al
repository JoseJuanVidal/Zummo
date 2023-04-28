table 50112 "MultiRRHH_zum"
{
    DataPerCompany = false;
    LookupPageID = "Lista RRHH_zum";

    fields
    {
        field(10; tabla; Option)
        {
            OptionCaption = 'Puesto Trabajo, , , , , ,Historico Puestos,Historico Contratos,Historico Categoria,Categoria, , ,Departamentos,Sección,Empresa ,Area,CategoriaBonificaciones,Ubicación Puesto,Evaluación Riesgos,Sucursal,IT Departamentos';
            OptionMembers = "Puesto Trabajo","1","2","3","4","5","Historico Puestos","Historico Contratos","Historico Categoria",Categoria,"10","11",Departamentos,"Sección",Empresa,Area,"Categoria Bonificaciones","Ubicación Puesto","Evaluación Riesgos","Sucursal","IT Departamentos";
        }
        field(20; Descripcion; Text[150])
        {

        }
        field(25; Descripcion2; Text[150])
        {

        }
        field(30; Codigo; Code[20])
        {
        }

        field(170; "Cod. Contrato Laboral"; Code[20])
        {
            TableRelation = "Employment Contract".Code;
        }


    }

    keys
    {
        key(Key1; tabla, Codigo)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }


}

