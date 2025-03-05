tableextension 50002 "STH Sales prices Ext" extends "Sales price"  //7002
{
    fields
    {
        field(50000; "STH Vigente"; Boolean)
        {
            Caption = 'Vigente', comment = 'ESP="Vigente"';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Price" where("Item No." = field("Item No."), "Sales Type" = field("Sales Type"), "Sales Code" = field("Sales Code"),
            "Starting Date" = field("Starting Date"), "Currency Code" = field("Currency Code"), "Variant Code" = field("Variant Code"),
            "Unit of Measure Code" = field("Unit of Measure Code"), "Minimum Quantity" = field("Minimum Quantity")));
        }
        field(50002; "Date Filter"; date)
        {
            Caption = 'Date Filter', comment = 'ESP="Filtro Fecha"';
            FieldClass = FlowFilter;
        }
        field(50014; selClasVtas_btc; Code[20])
        {
            Description = 'Bitec';
            Caption = 'Sales Classification', comment = 'ESP="Clasificación Ventas"';
            FieldClass = FlowField;
            CalcFormula = lookup(item.selClasVtas_btc where("No." = field("Item No.")));
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClasificacionVentas"), TipoRegistro = const(Tabla));
        }

        field(50015; selFamilia_btc; Code[20])
        {
            Description = 'Bitec';
            Caption = 'Family', comment = 'ESP="Familia"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.selFamilia_btc where("No." = field("Item No.")));
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Familia"), TipoRegistro = const(Tabla));
        }

        field(50016; selGama_btc; Code[20])
        {
            Description = 'Bitec';
            Caption = 'Gamma', comment = 'ESP="Gama"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.selGama_btc where("No." = field("Item No.")));
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Gamma"), TipoRegistro = const(Tabla));
        }
        field(50017; selLineaEconomica_btc; Code[20])
        {
            Description = 'Bitec';
            Caption = 'Linea Economica', comment = 'ESP="Linea Economica"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.selLineaEconomica_btc where("No." = field("Item No.")));
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("LineaEconomica"), TipoRegistro = const(Tabla));
        }
        field(50020; desClasVtas_btc; text[100])
        {
            Caption = 'Desc. Sales Classification', comment = 'ESP="Desc. Clasificación Ventas"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(ClasificacionVentas), NumReg = field(selClasVtas_btc)));
        }
        field(50021; desFamilia_btc; text[100])
        {
            Caption = 'Desc. Familia', comment = 'ESP="Desc. Familia"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(Familia), NumReg = field(selFamilia_btc)));
        }
        field(50022; desGama_btc; text[100])
        {
            Caption = 'Desc. Gamma', comment = 'ESP="Desc. Gama"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(Gamma), NumReg = field(selGama_btc)));
        }
        field(50023; desLineaEconomica_btc; text[100])
        {
            Caption = 'Desc. Linea Economica', comment = 'ESP="Desc. Linea Economica"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(LineaEconomica), NumReg = field(selLineaEconomica_btc)));
        }
        field(50030; DescriptionLanguage; text[100])
        {
            Caption = 'Desc. Idioma', comment = 'ESP="Desc. Idiom"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item Translation".Description where("Item No." = field("Item No."), "Language Code" = field(FilterLanguage)));
        }
        field(50040; ItemDescription; text[100])
        {
            Caption = 'Desc. Producto', comment = 'ESP="Desc. Producto"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(50050; FilterLanguage; code[10])
        {
            Caption = 'Filtro Idioma', comment = 'ESP="Filtro. Idioma"';
            TableRelation = Language;
            FieldClass = FlowFilter;
        }
    }
}