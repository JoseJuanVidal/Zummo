page 50135 "Puesto Subform_zum"
{
    AutoSplitKey = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "MultiRRHH Lineas_zum";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(tabla; tabla)
                {
                    Visible = false;
                }
                field("Codigo Puesto"; "CodigoTipo")
                {

                    Visible = false;
                }
                field(Codigo; CodigoRRHH)
                {
                    Caption = 'Puesto';
                }
                field(Descripcion; Descripcion)
                {
                    Editable = false;

                    trigger OnDrillDown();
                    var
                        MultiRRHH: Record "MultiRRHH_zum";
                        listaPuestos: page "Puesto Trabajo List_zum";
                    begin
                        CLEAR(listaPuestos);
                        MultiRRHH.RESET;
                        MultiRRHH.SETRANGE(tabla, MultiRRHH.tabla::"Puesto Trabajo");
                        listaPuestos.EDITABLE := true;
                        listaPuestos.SETTABLEVIEW(MultiRRHH);
                        listaPuestos.Run();
                    end;
                }
                field("Fecha Alta"; "Fecha Alta")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Fecha Baja"; "Fecha Baja")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field(Motivo; Motivo)
                {

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

