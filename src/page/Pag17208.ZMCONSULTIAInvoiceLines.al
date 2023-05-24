page 17208 "ZM CONSULTIA Invoice Lines"
{
    Caption = 'CONSULTIA Invoice Lines', Comment = 'ESP="CONSULTIA Líneas de facturas"';
    PageType = ListPart;
    SourceTable = "ZM CONSULTIA Invoice Line";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(N_Factura; Rec.N_Factura)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Numero; Rec.Numero)
                {
                    ApplicationArea = All;
                }
                field(Desc_servicio; Rec.Desc_servicio)
                {
                    ApplicationArea = All;
                }
                field(Proveedor; Rec.Proveedor)
                {
                    ApplicationArea = All;
                }
                field(F_Ini; Rec.F_Ini)
                {
                    ApplicationArea = All;
                }
                field(F_Fin; Rec.F_Fin)
                {
                    ApplicationArea = All;
                }
                field(IdCorp_Usuario; Rec.IdCorp_Usuario)
                {
                    ApplicationArea = All;
                }
                field(Usuario; Rec.Usuario)
                {
                    ApplicationArea = All;
                }
                field(Ref_Usuario; Rec.Ref_Usuario)
                {
                    ApplicationArea = All;
                }
                field(Ref_DPTO; Rec.Ref_DPTO)
                {
                    ApplicationArea = All;
                }
                field(CodigoProducto; Rec.CodigoProducto)
                {
                    ApplicationArea = All;
                }
                field(Producto; Rec.Producto)
                {
                    ApplicationArea = All;
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = All;
                }
                field(Porc_IVA; Rec.Porc_IVA)
                {
                    ApplicationArea = All;
                }
                field(Imp_IVA; Rec.Imp_IVA)
                {
                    ApplicationArea = All;
                }
                field(Tasas; Rec.Tasas)
                {
                    ApplicationArea = All;
                }
                field(PVP; Rec.PVP)
                {
                    ApplicationArea = All;
                }
                field(IdCorp_Sol; Rec.IdCorp_Sol)
                {
                    ApplicationArea = All;
                }
                field(IdServicio; Rec.IdServicio)
                {
                    ApplicationArea = All;
                }
                field(NumeroLineaServicio; Rec.NumeroLineaServicio)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}
