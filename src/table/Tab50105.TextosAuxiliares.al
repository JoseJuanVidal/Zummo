table 50105 "TextosAuxiliares"
{
    DataClassification = CustomerContent;
    Caption = 'Auxiliary texts', comment = 'ESP="Textos Auxiliares"';
    DataCaptionFields = TipoTabla, NumReg, Origen, CodMotivo;
    LookupPageId = "Lista Textos Auxiliares";
    DrillDownPageId = "Lista Textos Auxiliares";

    fields
    {
        field(1; TipoTabla; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Record Type', comment = 'ESP="Tipo Registro"';
            OptionMembers = "Motivo Retraso","Central Compras","Cliente Corporativo",AreaManager,Delegado,GrupoCliente,Perfil,Subcliente,ClienteReporting,ClasificacionVentas,Familia,Gamma,MotivoBloqueo,LineaEconomica,ClienteActividad,Mercados,InsideSales,Aseguradora,Canal,ClasifAseguradora,FalloLocalizado,RegistroIVA,Almacen;
            OptionCaption = 'Motivo,CentralComras, ClienteCorporativo,AreaManager,Delegado,GrupoCliente,Perfil,Subcliente,ClienteReporting,ClasificacionVentas, Familia, Gamma, MotivoBloqueo,LineaEconomica,ClienteActividad,Mercados,InsideSales,Aseguradora,Canal,ClasifAseguradora,FalloLocalizado,RegistroIVA,Almacen',
                  Comment = 'ESP="Motivo,CentralComras, ClienteCorporativo,AreaManager,Delegado,GrupoCliente,Perfil,Subcliente,ClienteReporting, ClasificacionVentas, Familia, Gamma, MotivoBloqueo, LineaEconomica, ClienteActividad,Mercados,InsideSales,Aseguradora,Canal,ClasifAseguradora,FalloLocalizado,RegistroIVA,Almacen"';
        }


        field(5; TipoRegistro; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Type', comment = 'ESP="Tipo"';
            OptionMembers = "Tabla","Valores";
            OptionCaption = 'Table,Values', Comment = 'ESP="Tabla,Valores"';

        }

        field(2; NumReg; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.', comment = 'ESP="Nº"';
        }

        field(3; Origen; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Origin', comment = 'ESP="Origen"';
            OptionMembers = " ",Interno,Externo;
            OptionCaption = ' ,Internal,External', Comment = 'ESP=" ,Interno,Externo"';
        }

        field(4; CodMotivo; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Type motive', comment = 'ESP="Tipo Motivo"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = field(TipoTabla), TipoRegistro = const(Valores));
        }
        field(6; Descripcion; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripcion', comment = 'ESP="Descripcion"';
        }

        field(7; NoEnviarMailVencimientos; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Do not send emails invoices expired', comment = 'ESP="No enviar emails vtos."';
        }
        field(8; Mercado; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Market', comment = 'ESP="Mercado"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Mercados), TipoRegistro = const(Tabla));

        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripcion ENG', comment = 'ESP="Descripcion ENG"';
        }
    }

    keys
    {
        key(PK; TipoTabla, TipoRegistro, NumReg)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; /*TipoTabla,*/ NumReg, Descripcion, Origen/*, CodMotivo*/)
        {

        }
    }
}