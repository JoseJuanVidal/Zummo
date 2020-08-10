table 50134 "MultiRRHH Lineas_zum"
{

    fields
    {
        field(10; tabla; Option)
        {

            OptionCaption = ' , , , ,Categorías, , , ,Historico Puestos,Historico Contratos,Historico Categoria';
            OptionMembers = "0","1","2","3","Categorías","5","6","7","Historico Puestos","Historico Contratos","Historico Categoria";



        }
        field(20; tipo; Option)
        {
            OptionCaption = ',Puesto,Empleado';
            OptionMembers = " ","Puesto","Empleado";

        }

        field(30; "CodigoTipo"; Code[20])
        {
            TableRelation =  Employee."No.";
        }
        field(40; Linea; integer)
        {


        }
        field(50; CodigoRRHH; Code[20])
        {
            TableRelation = IF (tabla = CONST("Historico Contratos")) MultiRRHH_zum.Codigo WHERE(tabla = CONST("Historico Contratos"))
            ELSE
            IF (tabla = CONST("Historico Categoria")) MultiRRHH_zum.Codigo WHERE(tabla = CONST(Categoria))
            ELSE
            IF (tabla = CONST("Historico Puestos")) MultiRRHH_zum.Codigo WHERE(tabla = CONST("Puesto Trabajo"));

            trigger OnValidate();
            var
                P_MultiRRHH: Record MultiRRHH_zum;
            begin

                P_MultiRRHH.RESET;
                P_MultiRRHH.SETRANGE(Codigo, CodigoRRHH);

                case tabla of
                    tabla::"Historico Contratos":
                        begin
                            P_MultiRRHH.SETRANGE(tabla, P_MultiRRHH.tabla::"Historico Contratos");
                        end;
                    tabla::"Historico Categoria":
                        begin
                            P_MultiRRHH.SETRANGE(tabla, P_MultiRRHH.tabla::"Historico Categoria");
                        end;
                    tabla::"Historico Puestos":
                        begin
                            P_MultiRRHH.SETRANGE(tabla, P_MultiRRHH.tabla::"Historico Puestos");
                        end;

                end;
                if P_MultiRRHH.FINDFIRST then begin
                    Descripcion := P_MultiRRHH.Descripcion;

                end;
            end;
        }
        field(60; Descripcion; Text[150])
        {
        }

        field(70; "Fecha Alta"; Date)
        {
        }
        field(80; "Fecha Baja"; Date)
        {
        }
        field(90; "Cod. motivo terminación"; Code[20])
        {
            TableRelation = "Grounds for Termination".Code;
        }
        field(100; "Cod. Contrato Laboral"; Code[20])
        {
            TableRelation = "Employment Contract".Code;
        }
        field(110; "Contrato Laboral"; Text[250])
        {
            CalcFormula = Lookup ("Employment Contract".Description WHERE(Code = FIELD("Cod. Contrato Laboral")));
            FieldClass = FlowField;
        }
        field(120; "Motivo terminación"; Text[100])
        {
            CalcFormula = Lookup ("Grounds for Termination".Description WHERE(Code = FIELD("Cod. motivo terminación")));
            FieldClass = FlowField;
        }
        field(130; Empresa; Text[30])
        {
        }
        field(140; "Cod. Categoria"; Code[20])
        {
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST(Categoria));
        }
        field(150; Motivo; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; tabla, tipo, CodigoTipo, Linea)
        {
        }
    }

}

