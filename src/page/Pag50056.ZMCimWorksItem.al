page 50056 "ZM CimWorks Item"
{
    // pagina que se publica como Servicio WEB para CIMWORKS - Productos

    Caption = 'Cimworks Item list', comment = 'ESP="Cimworks Lista productos"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM CIM Items temporary";


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Lanzamiento; OrderNo)
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        SetOrderNo();
                    end;
                }
                field(No; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(EnglishDescription; EnglishDescription)
                {
                    ApplicationArea = all;
                }
                field(Material; Material)
                {
                    ApplicationArea = all;
                }
                field("Assembly BOM"; "Assembly BOM")
                {
                    ApplicationArea = all;
                }
                field("Production BOM No."; "Production BOM No.")
                {
                    ApplicationArea = all;
                }
                field("Routing No."; "Routing No.")
                {
                    ApplicationArea = all;
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field(Packaging; packaging)
                {
                    ApplicationArea = all;
                }
                field(Color; Color)
                {
                    ApplicationArea = all;
                }
                field(Inventory; Inventory)
                {
                    ApplicationArea = all;
                }
                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = all;
                }
                field("Unit Volume"; "Unit Volume")
                {
                    ApplicationArea = all;
                }
                field(largo; largo)
                {
                    ApplicationArea = all;
                }
                field(Ancho; Ancho)
                {
                    ApplicationArea = all;
                }
                field(Alto; Alto)
                {
                    ApplicationArea = all;
                }
                field(UserERPLINK; UserERPLINK)
                {
                    ApplicationArea = all;
                }
                part(Lines; "ZM Item Documents")
                {
                    ApplicationArea = All;
                    SubPageLink = CodComentario = field("No.");
                    UpdatePropagation = Both;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.CreationOn := CreateDateTime(WorkDate(), time());
        Rec.ModifyOn := CreateDateTime(WorkDate(), time());
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec.CreationOn = 0DT then
            Rec.CreationOn := CreateDateTime(WorkDate(), time());
        Rec.ModifyOn := CreateDateTime(WorkDate(), time());
    end;

    local procedure SetOrderNo()
    begin
        if OrderNo = 0 then
            Rec.Order := OrderNo
        else begin
            if (Rec.Order = 9999999) then
                Rec.Order := OrderNo;
        end;
        OrderNo := Rec.Order
    end;

    var
        OrderNo: Integer;

}