page 17220 "ZM WS Service Item Line"
{
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Service Item Line";
    SourceTableView = where("Document Type" = const(Order), "Tipo Fallo localizado" = const(Manufacturing));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; "Document No.") { }
                field("Service Item No."; "Service Item No.") { }
                field("Item No."; "Item No.") { }
                field(Description; Description) { }
                field("Posting Date"; "Posting Date") { }
                field("Serial No."; "Serial No.") { }
                field(Fallo; Fallo) { }
                field("Fallo localizado"; "Fallo localizado") { }
                field(FalloLocalizadoDescripcion; FalloLocalizado."Descripción") { }
                field(CabDescripcion; ServiceHeader.Description) { }
                field("N. Empleado Fallo"; "N. Empleado Fallo") { }
                field("Nombre Empleado Fallo"; "Nombre Empleado Fallo") { }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not ServiceHeader.Get(Rec."Document Type", Rec."Document No.") then
            Clear(ServiceHeader);
        if not FalloLocalizado.Get(Rec.Fallo, Rec."Fallo localizado") then
            clear(FalloLocalizado);
    end;

    var
        ServiceHeader: Record "Service Header";
        FalloLocalizado: record "STH Fallo Localizado";
}