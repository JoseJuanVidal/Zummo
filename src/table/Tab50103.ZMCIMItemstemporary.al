table 50103 "ZM CIM Items temporary"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(6; "Assembly BOM"; Boolean)
        {
            Caption = 'Assembly BOM', Comment = 'ESP="L.M. de Ensamblado"';
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure', Comment = 'ESP="Unidad medida base"';
        }
        field(42; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight', Comment = 'ESP="Peso Neto"';
        }
        field(44; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume', Comment = 'ESP="Volumen"';
        }
        field(68; Inventory; Decimal)
        {
            Caption = 'Inventory', Comment = 'ESP="Inventario"';
        }
        field(92; Picture; MediaSet)
        {
            Caption = 'Picture', Comment = 'ESP="Picture"';
        }
        Field(50125; Material; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Material', comment = 'ESP="Material"';
        }
        field(59001; Largo; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Largo', comment = 'ESP="Largo"';
        }
        field(59002; Ancho; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Ancho', comment = 'ESP="Ancho"';
        }
        field(59003; Alto; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Alto', comment = 'ESP="Alto"';
        }
        field(50805; EnglishDescription; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'English Description', comment = 'ESP="Descripción Ingles"';
        }
        field(50806; Packaging; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Packaging', comment = 'ESP="Embalaje"';
        }
        field(50807; Color; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Color', comment = 'ESP="Color"';
        }
        field(50808; Order; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Order', comment = 'ESP="Order"';
            InitValue = 9999999;
        }
        field(50809; CreationOn; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Creation On', comment = 'ESP="Fecha Creación"';
        }
        field(50810; UserERPLINK; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'USER ERPLINK', comment = 'ESP="Usuario ERPLINK"';
        }
        field(50811; ModifyOn; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Modify On', comment = 'ESP="Fecha Modificación"';
        }
        field(99000750; "Routing No."; Code[20])
        {
            Caption = 'Routing No.', Comment = 'ESP="Nº ruta"';
        }
        field(99000751; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.', Comment = 'ESP="Nº L.M. producción"';
            TableRelation = "ZM CIM Prod. BOM Header";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        Item: Record Item;
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
        ZMCIMProdBOMHeader: Record "ZM CIM Prod. BOM Header";
        ZMCIMProdBOMLine: Record "ZM CIM Prod. BOM Line";
        ZMCIMProdDocuments: Record "ComentariosPredefinidos";
        lblConfirmBOM: Label 'El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?', comment = 'ESP="El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?"';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        // eliminamos todos los dependientes
        ZMCIMProdBOMHeader.Reset();
        ZMCIMProdBOMHeader.SetRange("No.", Rec."Production BOM No.");
        ZMCIMProdBOMHeader.DeleteAll();
        ZMCIMProdBOMLine.Reset();
        ZMCIMProdBOMLine.SetRange("Production BOM No.", Rec."Production BOM No.");
        ZMCIMProdBOMLine.DeleteAll();
        ZMCIMProdDocuments.Reset();
        ZMCIMProdDocuments.SetRange(CodComentario, Rec."No.");
        ZMCIMProdDocuments.SetRange(Tipo, ZMCIMProdDocuments.Tipo::ERPLINKDocs);
        //ZMCIMProdDocuments.DeleteAll();
        if ZMCIMProdDocuments.FindFirst() then
            repeat
                ZMCIMProdDocuments.DeleteFileAttachment(false);
                ZMCIMProdDocuments.Delete();
            Until ZMCIMProdDocuments.next() = 0;
    end;


    trigger OnRename()
    begin

    end;

    procedure CopyItem()
    var
        ItemLookups: page "Item Lookup";
        InsertBOM: Boolean;
    begin
        ItemLookups.Caption := 'Seleccione el producto a copiar';
        ItemLookups.LookupMode := true;
        if ItemLookups.RunModal() = Action::LookupOK then begin
            ItemLookups.GetRecord(Item);
            if Item."Replenishment System" in [item."Replenishment System"::Assembly, item."Replenishment System"::"Prod. Order"] then begin
                InsertBOM := Confirm(lblConfirmBOM, false, item."No.", Item.Description);
            end;
            InsertItem(InsertBOM);
        end;
    end;

    local procedure InsertItem(InsertBom: Boolean)
    var
        OldItemNo: code[20];
    begin
        // actualizamos los datos 
        OldItemNo := Rec."No.";
        Rec.TransferFields(Item);
        Rec."No." := OldItemNo;
        Rec.Modify();

        if InsertBom then begin
            case Item."Replenishment System" of
                Item."Replenishment System"::Assembly:
                    begin

                    end;
                Item."Replenishment System"::"Prod. Order":
                    begin
                        ProdBOMHeader.get(Item."Production BOM No.");
                        ZMCIMProdBOMHeader.Init();
                        ZMCIMProdBOMHeader.TransferFields(ProdBOMHeader);
                        ZMCIMProdBOMHeader."No." := Rec."No.";
                        ZMCIMProdBOMHeader.Insert();
                        ProdBOMLine.Reset();
                        ProdBOMLine.SetRange("Production BOM No.", ProdBOMHeader."No.");
                        if ProdBOMLine.FindFirst() then
                            repeat
                                ZMCIMProdBOMLine.Init();
                                ZMCIMProdBOMLine.TransferFields(ProdBOMLine);
                                ZMCIMProdBOMLine."Production BOM No." := ZMCIMProdBOMHeader."No.";
                                ZMCIMProdBOMLine.Insert();
                            Until ProdBOMLine.next() = 0;
                    end;
            end;
        end;
    end;
}