page 17208 "ZM CONSULTIA Invoice Lines"
{
    Caption = 'CONSULTIA Invoice Lines', Comment = 'ESP="CONSULTIA Líneas de facturas"';
    PageType = ListPart;
    SourceTable = "ZM CONSULTIA Invoice Line";
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;

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
                    Editable = false;
                }
                field(N_Factura; Rec.N_Factura)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field(Numero; Rec.Numero)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Desc_servicio; Rec.Desc_servicio)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Proveedor; Rec.Proveedor)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(F_Ini; Rec.F_Ini)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(F_Fin; Rec.F_Fin)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(IdCorp_Usuario; Rec.IdCorp_Usuario)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Usuario; Rec.Usuario)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Ref_Usuario; Rec.Ref_Usuario)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Ref_DPTO; Rec.Ref_DPTO)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CodigoProducto; Rec.CodigoProducto)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Producto; Rec.Producto)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Proyecto Manual"; "Proyecto Manual")
                {
                    ApplicationArea = all;
                }
                field(Partida; Partida)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Detalle; Detalle)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Porc_IVA; Rec.Porc_IVA)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Imp_IVA; Rec.Imp_IVA)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Tasas; Rec.Tasas)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PVP; Rec.PVP)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(IdCorp_Sol; Rec.IdCorp_Sol)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(IdServicio; Rec.IdServicio)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(NumeroLineaServicio; Rec.NumeroLineaServicio)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(line)
            {
                Caption = 'Line', comment = 'ESP="Líneas"';
                action(AssingEmployee)
                {
                    ApplicationArea = all;
                    Caption = 'Assign Employee', comment = 'ESP="Asignar Empleado"';
                    Image = Employee;

                    trigger OnAction()
                    begin
                        AssingEmployeeIdCorp();
                    end;
                }
                action(AssingProyecto)
                {
                    ApplicationArea = all;
                    Caption = 'Assign Project', comment = 'ESP="Asignar Proyecto"';
                    Image = Employee;

                    trigger OnAction()
                    begin
                        AssingProject();
                    end;
                }
            }
        }
    }
    var
        CONSULTIAFunciones: Codeunit "Zummo Inn. IC Functions";

    local procedure AssingEmployeeIdCorp()
    var
    begin
        CONSULTIAFunciones.AssingEmployeeIdCorp(Rec);

        CurrPage.Update();
    end;

    local procedure AssingProject()
    begin
        CONSULTIAFunciones.AssingProject(Rec);
        CurrPage.Update();
    end;
}
